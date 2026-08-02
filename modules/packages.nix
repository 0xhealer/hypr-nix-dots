{ pkgs, ... }:

{
  # Allow unfree packages globally
  nixpkgs.config.allowUnfree = true;

  # Core System Packages
  environment.systemPackages = with pkgs; [
    # Core CLI Utilities
    git
    curl
    wget
    ripgrep
    fd
    tree
    fish
    gcc
    gnumake
    eza
    fastfetch
    unzip
    nixd
    nixfmt-rfc-style
    lua-language-server
    stylua
    p7zip

    # Hardware & System Info Tools
    pciutils
    usbutils
    playerctl
    lm_sensors
    brightnessctl
    networkmanagerapplet
    blueman
    pavucontrol

    # Sound & Wayland Utilities
    wireplumber
    wl-clipboard

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}