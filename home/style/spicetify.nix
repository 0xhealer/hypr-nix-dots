{ pkgs, lib, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  colors = import ./colors.nix;
  strip = c: lib.removePrefix "#" c;

  # -------------------------------------------------------------------------
  # Hand-authored Spicetify theme using our own colors.nix palette, instead
  # of a pre-packaged theme name (that's what "dracula" was — it doesn't
  # exist in spicetify-nix's bundled theme list). Built the same way
  # spicetify's own built-in customizable theme works: a color.ini with
  # named hex keys, confirmed against the official spicetify docs
  # (https://spicetify.app/docs/development/themes) and the SpicetifyDefault
  # theme's color.ini format.
  # -------------------------------------------------------------------------
  ourTheme = pkgs.runCommand "spicetify-our-palette" { } ''
    mkdir -p $out
    cat > $out/color.ini <<INI_EOF
[Custom]
text            = ${strip colors.foreground}
subtext         = ${strip colors.color8}
main            = ${strip colors.background}
sidebar         = ${strip colors.color0}
player          = ${strip colors.background}
card            = ${strip colors.color0}
shadow          = ${strip colors.color8}
selected-row    = ${strip colors.color4}
button          = ${strip colors.color4}
button-active   = ${strip colors.color6}
button-disabled = ${strip colors.color8}
tab-active      = ${strip colors.color0}
notification    = ${strip colors.color4}
notification-error = ${strip colors.color1}
misc            = ${strip colors.color8}
INI_EOF
    touch $out/user.css
  '';
in
{
  # -------------------------------------------------------------------------
  # Spicetify — themes the Spotify client itself, since plain Spotify's UI
  # doesn't take any of our palette.
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
    theme = {
      name = "OurPalette";
      src = ourTheme;
      injectCss = true;
      replaceColors = true;
    };
    colorScheme = "Custom";
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts
    ];
  };
}
