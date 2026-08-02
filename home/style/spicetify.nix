{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  # -------------------------------------------------------------------------
  # Spicetify — themes the Spotify client itself, since plain Spotify's UI
  # doesn't take any of our palette. Using the bundled Dracula theme rather
  # than hand-injecting our exact hex values: colors.nix is already a
  # Dracula-style palette, so it's a close match, and spicetify themes have
  # their own per-theme color-injection format that isn't uniform enough
  # to safely hardcode against without testing on a real install.
  #
  # NOTE: this manages its own Spotify package, replacing the plain
  # `spotify-vm-safe` wrapper in home/packages.nix (that one is no longer
  # needed — remove it from the packages list to avoid two competing
  # Spotify installs). If the VM's --disable-gpu crash workaround turns out
  # to still be needed with Spicetify's Spotify, that'll need re-applying
  # here instead.
  # -------------------------------------------------------------------------
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.dracula;
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
    ];
  };
}
