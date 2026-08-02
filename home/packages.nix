{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # Wayland, Theming & Desktop Utilities
    waypaper
    awww
    grim
    slurp
    swappy
    wl-clipboard
    cliphist
    pamixer
    brightnessctl
    playerctl

    # Modern CLI & Terminal Enhancements
    zoxide
    fzf
    bat
    btop
    lazygit

    # User GUI Applications, Productivity & Media
    vscode
    obsidian
    mpv
    vlc
    loupe
    vesktop

    thunar
    thunar-archive-plugin
    thunar-volman

    # Archive utilities for GUI file manager context menus
    file-roller
  ];
}
