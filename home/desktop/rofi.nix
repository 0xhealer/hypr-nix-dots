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

  # -------------------------------------------------------------------------
  # Layout ported from harsh-m-patil/.dotfiles (pre-nix branch) — a two-column
  # grid launcher with a colored "prompt" pill. Colors swapped for our own
  # palette. Window sized down from the original 1000x360 (which rendered
  # far too wide) to a more reasonable ~700x420.
  # -------------------------------------------------------------------------
  xdg.configFile."rofi/config.rasi".text = ''
    configuration {
        modi: "run,drun,window";
        show-icons: true;
        drun-display-format: "{icon} {name}";
        location: 0;
        disable-history: false;
        hide-scrollbar: true;
        display-drun: "   Apps ";
        display-run: "   Run ";
        display-window: "   Window";
        sidebar-mode: true;
    }

    * {
        bg-col:       ${colors.background};
        bg-col-light: ${colors.color0};
        border-col:   ${colors.color4};
        selected-col: ${colors.background};
        accent:       ${colors.color4};
        fg-col:       ${colors.foreground};
        fg-col2:      ${colors.color1};
        grey:         ${colors.color8};

        font: "JetBrainsMono Nerd Font 12";
    }

    element-text, element-icon, mode-switcher {
        background-color: inherit;
        text-color: inherit;
    }

    window {
        height: 420px;
        width: 700px;
        border: 2px;
        border-radius: 15px;
        border-color: @border-col;
        background-color: @bg-col;
    }

    mainbox {
        background-color: @bg-col;
    }

    inputbar {
        children: [ prompt, entry ];
        background-color: @bg-col;
        border-radius: 5px;
        padding: 2px;
    }

    prompt {
        background-color: @accent;
        padding: 6px;
        text-color: @bg-col;
        border-radius: 3px;
        margin: 16px 0px 0px 16px;
    }

    textbox-prompt-colon {
        expand: false;
        str: ":";
    }

    entry {
        padding: 6px;
        margin: 16px 0px 0px 10px;
        text-color: @fg-col;
        background-color: @bg-col;
    }

    listview {
        border: 0px;
        padding: 6px 0px 0px;
        margin: 10px 0px 0px 16px;
        columns: 2;
        lines: 8;
        background-color: @bg-col;
    }

    element {
        padding: 5px;
        background-color: @bg-col;
        text-color: @fg-col;
    }

    element-icon {
        size: 26px;
    }

    element selected {
        background-color: @selected-col;
        text-color: @fg-col2;
    }

    mode-switcher {
        spacing: 0;
    }

    button {
        padding: 10px;
        background-color: @bg-col-light;
        text-color: @grey;
        vertical-align: 0.5;
        horizontal-align: 0.5;
    }

    button selected {
        background-color: @bg-col;
        text-color: @accent;
    }

    message {
        background-color: @bg-col-light;
        margin: 2px;
        padding: 2px;
        border-radius: 5px;
    }

    textbox {
        padding: 6px;
        margin: 16px 0px 0px 16px;
        text-color: @accent;
        background-color: @bg-col-light;
    }
  '';
}
