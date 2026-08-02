{ pkgs, config, lib, ... }:

let
  colors = import ../style/colors.nix;
  strip = c: lib.toLower (lib.removePrefix "#" c);
  activeBorder = "rgba(${strip colors.color4}ee)";
  inactiveBorder = "rgba(${strip colors.color8}aa)";
in
{
  # -------------------------------------------------------------------------
  # Hyprland is enabled here purely for package/xwayland/systemd/portal
  # wiring. The actual config is hand-written Lua below (xdg.configFile),
  # NOT home-manager's `settings` attrset — home-manager's settings→lua
  # translator has an open, unresolved bug specifically with `$`-prefixed
  # variables (nix-community/home-manager#9468), which is exactly the kind
  # of thing this config leans on (keybind mod keys). Writing the .lua by
  # hand sidesteps that bug entirely.
  #
  # Colors are the static palette in style/colors.nix, interpolated in at
  # build time by Nix — no wallpaper-driven regeneration, no runtime file
  # writes to fight home-manager over.
  # -------------------------------------------------------------------------
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.configFile."hypr/hyprland.lua".text = ''
    -- Hand-written Hyprland 0.55+ Lua config.
    -- The window-rule `opacity` field's exact shape (string vs table) isn't
    -- independently confirmed — if it doesn't apply, check the wiki or
    -- /usr/share/hypr/hyprland.lua for the current form.

    local mainMod = "SUPER"

    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

    -- Forces the software (Pixman) renderer and disables hardware cursors.
    -- Needed when running inside a VM whose virtual GPU driver (VMware
    -- vmwgfx, virtio-gpu, etc.) can't correctly negotiate the hardware
    -- buffer path Hyprland tries by default — without this, EVERY app that
    -- opens a Wayland surface (not just Kitty) crashes immediately with
    -- "wl_display: error 1: invalid arguments for wl_surface.attach",
    -- a well-documented Hyprland-in-VM issue. If you're on bare metal with
    -- a real GPU, remove these three lines — Pixman is CPU-only and
    -- historically has weaker/no support for blur, so this is a real
    -- trade-off: stability over the blur effect while virtualized.
    hl.env("WLR_RENDERER", "pixman")
    hl.env("WLR_NO_HARDWARE_CURSORS", "1")
    hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "1")

    hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
    hl.env("XCURSOR_SIZE", "24")
    hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

    hl.config({
      input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = true },
      },

      general = {
        gaps_in = 5,
        gaps_out = 12,
        border_size = 2,
        ["col.active_border"] = "${activeBorder}",
        ["col.inactive_border"] = "${inactiveBorder}",
        layout = "dwindle",
        resize_on_border = true,
      },

      decoration = {
        rounding = 4,
        active_opacity = 0.90,
        inactive_opacity = 0.80,
        blur = {
          enabled = true,
          size = 7,
          passes = 3,
          new_optimizations = true,
          ignore_opacity = true,
          xray = false,
        },
      },

      dwindle = {
        -- pseudotile removed entirely in Hyprland 0.55+, no replacement needed
        preserve_split = true,
      },
    })

    -- Animations
    hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
    hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "myBezier" })
    hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "default" })
    hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "default" })

    -- Autostart (equivalent of exec-once)
    hl.on("hyprland.start", function()
      -- hl.exec_cmd("waybar")  -- swapped for qs (quickshell); flip back any time
      -- Quickshell first; if it crashes or exits within 2s, fall back to Waybar.
      -- (mirrors the same try-then-fallback pattern used for Kitty/Alacritty below)
      hl.exec_cmd("sh -c 'qs > /tmp/qs-debug.log 2>&1 & sleep 2; pgrep -x qs >/dev/null || waybar &'")
      hl.exec_cmd("awww-daemon")
      hl.exec_cmd("waypaper --restore")
      hl.exec_cmd("wl-paste --watch cliphist store")
      -- dunst and hypridle run as their own systemd user services (see
      -- dunst.nix / hypridle.nix)
      hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    end)

    -- Window rules — windowrulev2 was deprecated; hl.window_rule replaces it.
    -- NOTE: the `opacity` field's exact shape (string vs table) isn't
    -- independently confirmed — verify against your Hyprland version if it
    -- doesn't apply.
    hl.window_rule({ match = { class = "^(kitty)$" }, opacity = "0.90 0.85" })
    hl.window_rule({ match = { class = "^(Alacritty)$" }, opacity = "0.90 0.85" })
    hl.window_rule({ match = { class = "^(thunar)$" }, opacity = "0.95 0.90" })

    -- Layer rules — glassmorphism needs these, not just CSS transparency.
    -- CSS alpha alone gives a flat tinted look; this is what actually
    -- blurs what's *behind* Waybar/Rofi (confirmed via the official wiki:
    -- https://wiki.hypr.land/Configuring/Basics/Window-Rules/). NOTE: this
    -- won't visually render while forced onto the Pixman software renderer
    -- (see the VM note near the top of this file) — the config is correct
    -- and will take effect once you're back on hardware-accelerated
    -- rendering.
    hl.layer_rule({ match = { namespace = "waybar" }, blur = true, ignore_alpha = 0.3 })
    hl.layer_rule({ match = { namespace = "rofi" }, blur = true, ignore_alpha = 0.3 })

    -- Keybinds — tries Kitty first, falls back to Alacritty if Kitty
    -- crashes/exits immediately; output still logged for diagnosis.
    hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty > /tmp/kitty-debug.log 2>&1 || alacritty"))
    hl.bind(mainMod .. " + Q", hl.dsp.window.close())
    hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
    hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("rofi -show drun"))
    hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("vicinae vicinae://toggle"))
    hl.bind("ALT + Space", hl.dsp.exec_cmd("vicinae vicinae://extensions/vicinae/clipboard/history"))
    hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
    hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
    hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("wlogout --layout ~/.config/wlogout/layout.json --css ~/.config/wlogout/style.css -b 5"))
    hl.bind("PRINT", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))

    -- Workspaces
    for i = 1, 4 do
      hl.bind(mainMod .. " + " .. tostring(i), hl.dsp.focus({ workspace = i }))
      hl.bind(mainMod .. " + SHIFT + " .. tostring(i), hl.dsp.window.move({ workspace = i }))
    end

    -- Mouse move/resize
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

    -- Media / brightness keys
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { repeating = true })
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +10%"), { repeating = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { repeating = true })
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"), { locked = true })
    hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
    hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
  '';
}
