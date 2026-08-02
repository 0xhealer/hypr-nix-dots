{ pkgs, ... }:

let
  colors = import ../style/colors.nix;
in
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        corner_radius = 10;
        frame_width = 2;
        font = "JetBrainsMono Nerd Font 10";
        transparency = 15;
      };
      urgency_low = {
        background = colors.background;
        foreground = colors.foreground;
      };
      urgency_normal = {
        background = colors.background;
        foreground = colors.foreground;
      };
      urgency_critical = {
        background = colors.background;
        foreground = colors.color1;
      };
    };
  };
}
