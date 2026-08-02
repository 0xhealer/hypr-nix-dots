{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "kitty";
  };

  # NOTE: rofi/colors.rasi is a wallust target — seeded once (writably) by
  # the activation script in style/wallust.nix, not managed here.

  xdg.configFile."rofi/config.rasi".text = ''
    @import "colors.rasi"

    configuration {
        modi: "drun,run,window";
        show-icons: true;
        font: "JetBrainsMono Nerd Font 11";
    }

    window {
        background-color: @background;
        border-radius: 12px;
        border: 2px;
        border-color: @accent;
    }

    element selected {
        background-color: @accent;
        text-color: @background;
    }
  '';
}
