{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # Kitty Terminal — includes colors.conf, which is seeded with your exact
  # supplied palette and then owned by wallust after your first wallpaper
  # pick in Waypaper (see style/wallust.nix for the seeding mechanism).
  # -------------------------------------------------------------------------
  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableFishIntegration = true;
    };

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      background_opacity = "0.85";
      dynamic_background_opacity = "yes";
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 8;
      hide_window_decorations = "yes";
    };

    extraConfig = ''
      include colors.conf
    '';
  };
}
