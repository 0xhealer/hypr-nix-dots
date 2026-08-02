{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # GTK Config — theme, icons, and cursor all pulled straight from nixpkgs.
  #
  # We tried building the exact Sweet-Mars variant + Sweet-cursors +
  # Sweet-folders from EliverLara's upstream GitHub repos, but that meant
  # chasing fake-hash placeholders derivation by derivation, and then a
  # genuine 404 (Sweet-cursors isn't a maintained standalone repo anymore —
  # its actual home is a "nova" branch inside the main Sweet repo). None of
  # that is worth the churn for a purely cosmetic layer, so this uses the
  # closest equivalents that are already packaged and hash-verified in
  # nixpkgs: no custom fetchFromGitHub, no hash-guessing, no 404s.
  # -------------------------------------------------------------------------
  gtk = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    theme = {
      name = "Sweet-Dark";
      package = pkgs.sweet;
    };

    iconTheme = {
      name = "candy-icons";
      package = pkgs.candy-icons;
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Qt apps follow the same theme via qt5ct/qt6ct
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct";
  home.packages = with pkgs; [ libsForQt5.qt5ct qt6Packages.qt6ct ];
}
