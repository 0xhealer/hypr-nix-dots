{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # GTK Config — theme, icons, and cursor all pulled straight from nixpkgs.
  #
  # We tried the exact Sweet-Mars variant + Sweet-cursors + Sweet-folders
  # built from EliverLara's upstream GitHub repos, then nixpkgs' own `sweet`
  # package once that failed — but `sweet` has since been removed from
  # nixpkgs entirely (its dependency `gtk-engine-murrine` was dropped for
  # being unmaintained GTK2-only). None of that is worth the churn for a
  # purely cosmetic layer, so this now uses adw-gtk3 — an actively
  # maintained GTK3 port of libadwaita with no legacy-engine dependencies —
  # plus candy-icons and Bibata cursors, all hash-verified in nixpkgs
  # already. No custom fetchFromGitHub, no hash-guessing, no 404s.
  # -------------------------------------------------------------------------
  gtk = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
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
  home.sessionVariables.GTK_THEME = "adw-gtk3-dark";
  home.packages = with pkgs; [ libsForQt5.qt5ct qt6Packages.qt6ct ];
}
