{ pkgs, ... }:

let
  colors = import ../style/colors.nix;
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "kitty";
  };

  xdg.configFile."rofi/config.rasi".text = ''
    configuration {
        modi: "drun,run,window";
        show-icons: true;
        font: "JetBrainsMono Nerd Font 11";
    }

    window {
        background-color: ${colors.background};
        border-radius: 12px;
        border: 2px;
        border-color: ${colors.color4};
    }

    element selected {
        background-color: ${colors.color4};
        text-color: ${colors.background};
    }
  '';
}
