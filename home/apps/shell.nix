{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # Shell Environment Variables
  # -------------------------------------------------------------------------
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "bat";
  };

  # -------------------------------------------------------------------------
  # Fish Shell Configuration
  # -------------------------------------------------------------------------
  programs.fish = {
    enable = true;

    # Disable default greeting banner
    interactiveShellInit = ''
      set fish_greeting
    '';

    # Convenient CLI Aliases
    shellAliases = {
      # Navigation & Core Replacement Tools
      ls = "eza --icons";
      ll = "eza -la --icons";
      tree = "eza --tree --icons";
      cat = "bat";
      cd = "z";

      # Information & Git
      ff = "fastfetch";
      lg = "lazygit";

      # NixOS Workflows
      rebuild = "sudo nixos-rebuild switch --flake ~/.local/share/hypr-nix-dots#nixos";
      ncg = "nix-collect-garbage -d";
    };
  };

  # -------------------------------------------------------------------------
  # Shell Integration for Zoxide / Eza / Bat
  # -------------------------------------------------------------------------
  programs.zoxide.enableFishIntegration = true;
  programs.eza.enableFishIntegration = true;
}