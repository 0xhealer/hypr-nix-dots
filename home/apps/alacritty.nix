{ pkgs, ... }:

let
  colors = import ../style/colors.nix;
in
{
  # -------------------------------------------------------------------------
  # Alacritty — installed as a fallback in case Kitty keeps crashing. The
  # Super+Return bind in desktop/hyprland.nix tries Kitty first and falls
  # back to this automatically (`kitty || alacritty`).
  # -------------------------------------------------------------------------
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        size = 12;
      };

      window = {
        opacity = 0.85;
        padding = { x = 8; y = 8; };
      };

      colors = {
        primary = {
          background = colors.background;
          foreground = colors.foreground;
        };
        cursor = {
          text = colors.cursor;
          cursor = colors.cursor;
        };
        selection = {
          text = colors.selectionForeground;
          background = colors.selectionBackground;
        };
        normal = {
          black = colors.color0;
          red = colors.color1;
          green = colors.color2;
          yellow = colors.color3;
          blue = colors.color4;
          magenta = colors.color5;
          cyan = colors.color6;
          white = colors.color7;
        };
        bright = {
          black = colors.color8;
          red = colors.color9;
          green = colors.color10;
          yellow = colors.color11;
          blue = colors.color12;
          magenta = colors.color13;
          cyan = colors.color14;
          white = colors.color15;
        };
      };
    };
  };
}
