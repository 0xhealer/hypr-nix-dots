{ pkgs, config, lib, ... }:

{
  # -------------------------------------------------------------------------
  # Hyprland is enabled here purely for package/xwayland/systemd/portal
  # wiring. The actual config is hand-written Lua below (xdg.configFile),
  # NOT home-manager's `settings` attrset — home-manager's settings→lua
  # translator has an open, unresolved bug specifically with `$`-prefixed
  # variables (nix-community/home-manager#9468), which is exactly the kind
  # of thing this config leans on (keybind mod keys, wallust-sourced
  # colors). Writing the .lua by hand sidesteps that bug entirely.
  # -------------------------------------------------------------------------
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.configFile."hypr/hyprland.lua".text = ''
    -- Hand-written Hyprland 0.55+ Lua config.
    -- A few dispatcher names below (workspace switch, move-to-workspace,
    -- mouse move/resize) aren't independently confirmed against the exact
    -- API surface — if a bind silently doesn't fire, diff it against the
    -- canonical example shipped at /usr/share/hypr/hyprland.lua.

    local mainMod = "SUPER"

    -- wallust writes this after every wallpaper pick in Waypaper; seeded
    -- once by the activation script in style/wallust.nix before that.
    local colors = dofile(os.getenv("HOME") .. "/.config/hypr/colors.lua")

    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

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
        ["col.active_border"] = colors.active_border .. " " .. colors.inactive_border .. " 45deg",
        ["col.inactive_border"] = colors.inactive_border,
        layout = "dwindle",
        resize_on_border = true,
      },

      decoration = {
        rounding = 10,
        active_opacity = 0.92,
        inactive_opacity = 0.85,
        blur = {
          enabled = true,
          size = 8,
          passes = 4,
          new_optimizations = true,
          ignore_opacity = true,
          xray = false,
        },
        shadow = {
          enabled = true,
          range = 12,
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
      hl.exec_cmd("waybar")
      hl.exec_cmd("swww-daemon")
      hl.exec_cmd("waypaper --restore")
      hl.exec_cmd("dunst")
      hl.exec_cmd("wl-paste --watch cliphist store")
      -- hypridle runs as its own systemd user service (see hypridle.nix)
      hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    end)

    -- Window rules — windowrulev2 was deprecated; hl.window_rule replaces it.
    -- NOTE: the `opacity` field's exact shape (string vs table) isn't
    -- independently confirmed — verify against your Hyprland version if it
    -- doesn't apply.
    hl.window_rule({ match = { class = "^(kitty)$" }, opacity = "0.90 0.85" })
    hl.window_rule({ match = { class = "^(thunar)$" }, opacity = "0.95 0.90" })

    -- Keybinds
    hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty > /tmp/kitty-debug.log 2>&1"))
    hl.bind(mainMod .. " + Q", hl.dsp.window.close())
    hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
    hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("rofi -show drun"))
    hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
    hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
    hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("wlogout -b 5"))
    hl.bind("PRINT", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))

    -- Workspaces — TODO: verify hl.dsp.workspace / hl.dsp.window.move_to_workspace
    -- against /usr/share/hypr/hyprland.lua; not independently confirmed.
    for i = 1, 4 do
      hl.bind(mainMod .. " + " .. tostring(i), hl.dsp.workspace(i))
      hl.bind(mainMod .. " + SHIFT + " .. tostring(i), hl.dsp.window.move_to_workspace(i))
    end

    -- Mouse move/resize — TODO: verify against /usr/share/hypr/hyprland.lua,
    -- the exact mouse-bind dispatcher call isn't independently confirmed.
    -- hl.bind(mainMod, "mouse:272", hl.dsp.window.move(), { mouse = true })
    -- hl.bind(mainMod, "mouse:273", hl.dsp.window.resize(), { mouse = true })

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
