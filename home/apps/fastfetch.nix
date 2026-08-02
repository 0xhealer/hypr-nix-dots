{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # Fastfetch System Information Tool
  # -------------------------------------------------------------------------
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        type = "kitty-direct";
        source = "~/.local/share/hypr-nix-dots/assets/fastfetch/logo.png";
        width = 28;
        height = 12;
        padding = {
          top = 1;
          left = 2;
        };
      };

      display = {
        separator = " ➜ ";
      };

      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "break"
        "colors"
      ];
    };
  };
}