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

    * {
        background-color: transparent;
        text-color: ${colors.foreground};
    }

    window {
        background-color: ${colors.background};
        border-radius: 12px;
        border: 2px;
        border-color: ${colors.color4};
        width: 600px;
    }

    mainbox {
        background-color: transparent;
        padding: 12px;
        children: [ "inputbar", "listview" ];
    }

    inputbar {
        background-color: ${colors.color0};
        text-color: ${colors.foreground};
        border-radius: 8px;
        padding: 8px 12px;
        margin: 0 0 10px 0;
        children: [ "prompt", "entry" ];
    }

    prompt {
        text-color: ${colors.color4};
        padding: 0 8px 0 0;
    }

    entry {
        text-color: ${colors.foreground};
        placeholder-color: ${colors.color8};
        placeholder: "Search...";
    }

    listview {
        background-color: transparent;
        lines: 8;
        spacing: 4px;
        scrollbar: false;
    }

    element {
        background-color: transparent;
        text-color: ${colors.foreground};
        border-radius: 8px;
        padding: 8px 10px;
    }

    element normal.urgent, element alternate.urgent {
        text-color: ${colors.color1};
    }

    element selected {
        background-color: ${colors.color4};
        text-color: ${colors.background};
    }

    element-icon {
        size: 24px;
        padding: 0 10px 0 0;
    }

    element-text {
        vertical-align: 0.5;
    }
  '';
}
