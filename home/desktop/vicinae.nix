{ pkgs, inputs, ... }:

{
  # -------------------------------------------------------------------------
  # Vicinae — the actual launcher used in harsh-m-patil/.dotfiles' main
  # branch (a Raycast-style launcher, not Rofi). The flake input and
  # home-manager module were already wired into flake.nix; this is what
  # actually turns it on, matching their real home.nix configuration.
  #
  # Bound to Super+Space, alongside Rofi (Super+R) rather than replacing
  # it — same "keep both available" approach as the Quickshell/Waybar
  # bar fallback.
  # -------------------------------------------------------------------------
  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };

    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      bluetooth
      nix
      power-profile
    ];
  };
}
