{ pkgs, lib, ... }:

let
  colors = import ../style/colors.nix;
  strip = c: lib.removePrefix "#" c;
in
{
  # -------------------------------------------------------------------------
  # i3/X11 — permanent second session for guests used to i3 rather than
  # Hyprland. Deliberately kept in this one file rather than split out,
  # since it's a self-contained unit (i3 + its own compositor + bar + lock).
  #
  # picom provides the blur/transparency here, since i3 (unlike Hyprland)
  # has no compositor of its own. Polybar is the status bar (themed to
  # match Waybar's Nord palette). i3lock-color is the screen locker
  # (Hyprland's equivalent is hyprlock). All three are launched ONLY from
  # i3's own startup list below — not via systemd services tied to the
  # generic graphical-session target — specifically so none of them can
  # try to start under Hyprland's Wayland session too. picom/i3lock-color
  # are X11-only and would fail immediately under Wayland regardless, but
  # launching this way means they never even try.
  # -------------------------------------------------------------------------

  xsession.enable = true;

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      terminal = "kitty";
      modifier = "Mod4"; # Super key

      # mkOptionDefault merges these with i3's own sensible built-in
      # defaults (workspace switching, window navigation, etc.) instead of
      # replacing them outright — only overriding/adding what's needed.
      keybindings = lib.mkOptionDefault {
        "Mod4+Return" = "exec kitty";
        "Mod4+d" = "exec rofi -show drun";
        "Mod4+Shift+w" = "exec nitrogen ~/.local/share/hypr-nix-dots/assets/wallpapers";
        "Mod4+Shift+q" = "kill";
        "Mod4+Shift+e" = "exec i3-msg exit";
        "Mod4+l" = ''exec --no-startup-id i3lock-color \
          --insidecolor=${strip colors.background}dd \
          --ringcolor=${strip colors.color4}ff \
          --line-uses-ring \
          --keyhlcolor=${strip colors.color6}ff \
          --bshlcolor=${strip colors.color1}ff \
          --separatorcolor=${strip colors.color8}ff \
          --insidevercolor=${strip colors.background}dd \
          --ringvercolor=${strip colors.color6}ff \
          --insidewrongcolor=${strip colors.background}dd \
          --ringwrongcolor=${strip colors.color1}ff \
          --verifcolor=${strip colors.foreground}ff \
          --wrongcolor=${strip colors.color1}ff \
          --timecolor=${strip colors.foreground}ff \
          --datecolor=${strip colors.foreground}ff \
          --layoutcolor=${strip colors.foreground}ff \
          --clock --indicator --radius 120 --ring-width 6'';
      };

      startup = [
        {
          command = "picom --config ~/.config/picom/picom.conf";
          always = true;
          notification = false;
        }
        {
          command = "nitrogen --restore";
          always = true;
          notification = false;
        }
        {
          command = "sh -c 'sleep 1.5 && polybar mainbar'";
          always = true;
          notification = false;
        }
      ];

      # Explicitly empty — home-manager's i3 module has its own default
      # bar (classic i3bar + i3status) that stays active otherwise, which
      # is what was showing up as a second bar alongside Polybar.
      bars = [ ];

      colors = {
        focused = {
          border = colors.color4;
          background = colors.color4;
          text = colors.background;
          indicator = colors.color4;
          childBorder = colors.color4;
        };
      };

      gaps = {
        inner = 8;
        outer = 4;
      };

      window = {
        titlebar = false;
        border = 0;
      };

      floating = {
        titlebar = false;
        border = 0;
      };
    };
  };

  home.packages = [ pkgs.polybar pkgs.i3lock-color pkgs.nitrogen pkgs.picom ];

  # -------------------------------------------------------------------------
  # nitrogen — the X11 equivalent of Waypaper: a GUI wallpaper browser
  # (Super+Shift+W opens it, pointed at assets/wallpapers/). Seeded with a
  # default wallpaper the same way Waypaper's config.ini is seeded — as a
  # writable file, not xdg.configFile, since nitrogen rewrites its own
  # config every time you pick a new wallpaper through the GUI, and
  # home-manager-managed files would be read-only symlinks it can't save to.
  # -------------------------------------------------------------------------
  home.activation.seedNitrogenConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/nitrogen"
    [ -f "$HOME/.config/nitrogen/nitrogen.cfg" ] || cat > "$HOME/.config/nitrogen/nitrogen.cfg" <<'EOF'
[geometry]
posx=0
posy=0
width=800
height=600

[nitrogen]
recurse=false
sort=alphabetic
icon_caption=true
dirs=/home/healer/.local/share/hypr-nix-dots/assets/wallpapers;
EOF
    [ -f "$HOME/.config/nitrogen/bg-saved.cfg" ] || cat > "$HOME/.config/nitrogen/bg-saved.cfg" <<'EOF'
[xin_-1]
file=/home/healer/.local/share/hypr-nix-dots/assets/wallpapers/6.png
mode=5
bgcolor=#000000
EOF
  '';

  # -------------------------------------------------------------------------
  # picom config — mirrors Hyprland's decoration block (home/desktop/
  # hyprland.nix) as closely as picom's feature set allows: same rounding,
  # same blur strength/passes-equivalent, same active/inactive opacity
  # split, no shadow (matching the current Hyprland setup, which also has
  # none). Keep these two in sync by hand if you tune one later.
  # -------------------------------------------------------------------------
  xdg.configFile."picom/picom.conf".text = ''
    backend = "glx";
    vsync = true;

    corner-radius = 8;
    round-borders = 1;
    rounded-corners-exclude = [
      "window_type = 'dock'",
      "window_type = 'desktop'"
    ];

    blur: {
      method = "dual_kawase";
      strength = 5;
    }
    blur-background = true;
    blur-background-frame = true;
    blur-background-fixed = true;
    blur-background-exclude = [
      "window_type = 'dock'",
      "window_type = 'desktop'"
    ];

    active-opacity = 0.90;
    inactive-opacity = 0.80;
    frame-opacity = 0.90;
    inactive-opacity-override = false;

    opacity-rule = [
      "90:class_g = 'kitty'",
      "90:class_g = 'Alacritty'",
      "95:class_g = 'Thunar'"
    ];

    shadow = false;

    fading = true;
    fade-in-step = 0.03;
    fade-out-step = 0.03;
    fade-delta = 4;

    mark-wmwin-focused = true;
    mark-ovredir-focused = true;
    detect-rounded-corners = true;
    detect-client-opacity = true;
    detect-transient = true;
    use-damage = true;
  '';

  # -------------------------------------------------------------------------
  # Polybar — replaces i3status, themed with the same Nord palette as
  # everything else (colors.nix). Battery/network module settings
  # (battery name, adapter name, interface-type) use generic defaults
  # below; laptop hardware naming varies (BAT0 vs BAT1, wlan0 vs
  # wlp2s0, etc.) — check `ls /sys/class/power_supply/` and
  # `ip link` on the actual laptop once migrated, and adjust the
  # [module/battery] and [module/network] sections below if needed.
  # -------------------------------------------------------------------------
  xdg.configFile."polybar/config.ini".text = ''
    [colors]
    background = ${colors.background}
    background-alt = ${colors.color0}
    foreground = ${colors.foreground}
    primary = ${colors.color4}
    secondary = ${colors.color6}
    alert = ${colors.color1}
    disabled = ${colors.color8}

    [bar/mainbar]
    width = 100%
    height = 30
    radius = 8
    fixed-center = true

    background = ${colors.background}dd
    foreground = ${colors.foreground}

    line-size = 0
    border-size = 0

    padding-left = 1
    padding-right = 1
    module-margin = 1

    font-0 = "JetBrainsMono Nerd Font:size=11;3"

    modules-left = i3
    modules-center = date
    modules-right = pulseaudio network memory cpu battery

    cursor-click = pointer
    enable-ipc = true

    [module/i3]
    type = internal/i3
    format = <label-state> <label-mode>
    index-sort = true
    wrapping-scroll = false

    label-focused = %index%
    label-focused-background = ''${colors.primary}
    label-focused-foreground = ''${colors.background}
    label-focused-padding = 1

    label-unfocused = %index%
    label-unfocused-padding = 1

    label-urgent = %index%
    label-urgent-background = ''${colors.alert}
    label-urgent-padding = 1

    [module/date]
    type = internal/date
    interval = 1
    date = "%a %d %b"
    time = "%H:%M"
    label = "%date%  %time%"

    [module/cpu]
    type = internal/cpu
    interval = 2
    format-prefix = "CPU "
    format-prefix-foreground = ''${colors.secondary}
    label = %percentage%%

    [module/memory]
    type = internal/memory
    interval = 2
    format-prefix = "MEM "
    format-prefix-foreground = ''${colors.secondary}
    label = %percentage_used%%

    [module/pulseaudio]
    type = internal/pulseaudio
    format-volume = "VOL <label-volume>"
    label-volume = %percentage%%
    label-muted = "MUTED"
    label-muted-foreground = ''${colors.disabled}

    ; interface-type auto-selects the active wired/wireless adapter rather
    ; than hardcoding an interface name that may differ on the real laptop
    [module/network]
    type = internal/network
    interface-type = wireless
    interval = 2
    format-connected = "NET <label-connected>"
    label-connected = %essid% %downspeed:9%
    format-disconnected = "Not connected"

    ; adapter is more commonly ADP1 on ASUS ROG hardware than generic AC —
    ; verify with `ls /sys/class/power_supply/` once on the actual laptop
    [module/battery]
    type = internal/battery
    battery = BAT0
    adapter = ADP1
    full-at = 98
    format-charging = "CHG <label-charging>"
    format-discharging = "BAT <label-discharging>"
    format-full = "FULL <label-full>"
    label-charging = %percentage%%
    label-discharging = %percentage%%
    label-full = %percentage%%
  '';
}
