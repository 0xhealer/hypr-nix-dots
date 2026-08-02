{ pkgs, lib, ... }:

{
  # -------------------------------------------------------------------------
  # wallust — generates a color palette from the current wallpaper and
  # pushes it into Waybar/Kitty/Rofi/Dunst/Hyprland via templates below.
  # Triggered automatically by Waypaper's post_command (see desktop/tools.nix).
  # -------------------------------------------------------------------------
  programs.wallust = {
    enable = true;
    settings = {
      backend = "full";
      color_space = "lab";
      palette = "dark";

      templates = {
        waybar = {
          template = "waybar-colors.css";
          target = "~/.config/waybar/colors.css";
        };
        kitty = {
          template = "kitty-colors.conf";
          target = "~/.config/kitty/colors.conf";
        };
        rofi = {
          template = "rofi-colors.rasi";
          target = "~/.config/rofi/colors.rasi";
        };
        dunst = {
          template = "dunstrc";
          target = "~/.config/dunst/dunstrc";
        };
        hyprland = {
          template = "hyprland-colors.conf";
          target = "~/.config/hypr/colors.conf";
        };
      };
    };
  };

  xdg.configFile."wallust/templates/hyprland-colors.conf".text = ''
    $active_border = rgb({{color4}})
    $inactive_border = rgb({{color8}})
    $accent = rgb({{color6}})
  '';

  xdg.configFile."wallust/templates/waybar-colors.css".text = ''
    @define-color background {{background}};
    @define-color foreground {{foreground}};
    @define-color color0 {{color0}};
    @define-color color1 {{color1}};
    @define-color color2 {{color2}};
    @define-color color3 {{color3}};
    @define-color color4 {{color4}};
    @define-color color5 {{color5}};
    @define-color color6 {{color6}};
    @define-color color7 {{color7}};
    @define-color color8 {{color8}};
  '';

  # kitty-colors.conf template intentionally omitted here — the exact
  # Dracula-style palette you supplied is seeded as the default in
  # apps/editor.nix; wallust will overwrite ~/.config/kitty/colors.conf
  # the first time you pick a wallpaper in Waypaper, same as the others.
  xdg.configFile."wallust/templates/kitty-colors.conf".text = ''
    background {{background}}
    foreground {{foreground}}
    cursor {{cursor}}

    color0  {{color0}}
    color1  {{color1}}
    color2  {{color2}}
    color3  {{color3}}
    color4  {{color4}}
    color5  {{color5}}
    color6  {{color6}}
    color7  {{color7}}
    color8  {{color8}}
    color9  {{color9}}
    color10 {{color10}}
    color11 {{color11}}
    color12 {{color12}}
    color13 {{color13}}
    color14 {{color14}}
    color15 {{color15}}
  '';

  xdg.configFile."wallust/templates/rofi-colors.rasi".text = ''
    * {
        background: {{background}};
        foreground: {{foreground}};
        accent: {{color4}};
        urgent: {{color1}};
    }
  '';

  xdg.configFile."wallust/templates/dunstrc".text = ''
    [global]
        corner_radius = 10
        frame_width = 2
        font = JetBrainsMono Nerd Font 10
        transparency = 15

    [urgency_low]
        background = "{{background}}"
        foreground = "{{foreground}}"

    [urgency_normal]
        background = "{{background}}"
        foreground = "{{foreground}}"

    [urgency_critical]
        background = "{{background}}"
        foreground = "{{color1}}"
  '';

  # -------------------------------------------------------------------------
  # Seed the wallust *target* files with your exact supplied palette.
  #
  # These targets (hypr/colors.conf, waybar/colors.css, rofi/colors.rasi,
  # kitty/colors.conf, dunst/dunstrc) are NOT managed via xdg.configFile,
  # because home-manager would symlink them read-only into the Nix store —
  # and wallust needs to overwrite them at runtime every time you pick a
  # new wallpaper in Waypaper. Instead this activation script writes them
  # once, as plain writable files, and only if they don't already exist —
  # so re-running `home-manager switch` never clobbers whatever wallust
  # has generated since.
  # -------------------------------------------------------------------------
  home.activation.seedWallustTargets = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/hypr" "$HOME/.config/waybar" "$HOME/.config/rofi" \
             "$HOME/.config/kitty" "$HOME/.config/dunst"

    [ -f "$HOME/.config/hypr/colors.conf" ] || cat > "$HOME/.config/hypr/colors.conf" <<'EOF'
$active_border = rgb(9580FF)
$inactive_border = rgb(364049)
$accent = rgb(80FFEA)
EOF

    [ -f "$HOME/.config/waybar/colors.css" ] || cat > "$HOME/.config/waybar/colors.css" <<'EOF'
@define-color background #0B0D0F;
@define-color foreground #F8F8F2;
@define-color color0 #22212C;
@define-color color1 #FF9580;
@define-color color2 #8AFF80;
@define-color color3 #FFFF80;
@define-color color4 #9580FF;
@define-color color5 #FF80BF;
@define-color color6 #80FFEA;
@define-color color7 #F8F8F2;
@define-color color8 #364049;
EOF

    [ -f "$HOME/.config/rofi/colors.rasi" ] || cat > "$HOME/.config/rofi/colors.rasi" <<'EOF'
* {
    background: #0B0D0F;
    foreground: #F8F8F2;
    accent: #9580FF;
    urgent: #FF9580;
}
EOF

    [ -f "$HOME/.config/kitty/colors.conf" ] || cat > "$HOME/.config/kitty/colors.conf" <<'EOF'
background #0B0D0F
foreground #F8F8F2
cursor #708CA9
cursor_text_color #708CA9
selection_background #414D58
selection_foreground #F8F8F2

color0  #22212C
color1  #FF9580
color2  #8AFF80
color3  #FFFF80
color4  #9580FF
color5  #FF80BF
color6  #80FFEA
color7  #F8F8F2
color8  #364049
color9  #FFAA99
color10 #A2FF99
color11 #FFFF99
color12 #AA99FF
color13 #FF99CC
color14 #99FFEE
color15 #FFFFFF
EOF

    [ -f "$HOME/.config/dunst/dunstrc" ] || cat > "$HOME/.config/dunst/dunstrc" <<'EOF'
[global]
    corner_radius = 10
    frame_width = 2
    font = JetBrainsMono Nerd Font 10
    transparency = 15

[urgency_low]
    background = "#0B0D0F"
    foreground = "#F8F8F2"

[urgency_normal]
    background = "#0B0D0F"
    foreground = "#F8F8F2"

[urgency_critical]
    background = "#0B0D0F"
    foreground = "#FF9580"
EOF
  '';
}
