{ pkgs, ... }:

{
  # Bootloader Configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable Nix Flakes & CLI Tools
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true; # Automatically deduplicate nix store
  };

  # Power Management Daemon
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Hardware Graphics Acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Locale & Timezone Settings
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # System-wide Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # NixOS Release Version (Do not change after initial install)
  system.stateVersion = "24.05";
}