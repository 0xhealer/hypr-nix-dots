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

    # Extensions removed — "bluetooth"/"nix"/"power-profile" were an
    # unverified guess at what's in vicinae-extensions' package set, and at
    # least "bluetooth" doesn't actually exist there. Find the real names
    # with `nix eval github:vicinaehq/extensions#packages.x86_64-linux
    # --apply builtins.attrNames` and add them back here if wanted.
    extensions = [ ];
  };
}
