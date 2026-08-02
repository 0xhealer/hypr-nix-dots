{ pkgs, ... }:

let
  colors = import ../style/colors.nix;
in
{
  # -------------------------------------------------------------------------
  # Kitty Terminal — static central palette (see style/colors.nix)
  # -------------------------------------------------------------------------
  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableFishIntegration = true;
    };

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      background_opacity = "0.85";
      dynamic_background_opacity = "yes";
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 8;
      hide_window_decorations = "yes";

      background = colors.background;
      foreground = colors.foreground;
      cursor = colors.cursor;
      cursor_text_color = colors.cursor;
      selection_background = colors.selectionBackground;
      selection_foreground = colors.selectionForeground;

      color0 = colors.color0;
      color1 = colors.color1;
      color2 = colors.color2;
      color3 = colors.color3;
      color4 = colors.color4;
      color5 = colors.color5;
      color6 = colors.color6;
      color7 = colors.color7;
      color8 = colors.color8;
      color9 = colors.color9;
      color10 = colors.color10;
      color11 = colors.color11;
      color12 = colors.color12;
      color13 = colors.color13;
      color14 = colors.color14;
      color15 = colors.color15;
    };
  };
}
