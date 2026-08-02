{ pkgs, lib, ... }:

let
  # -------------------------------------------------------------------------
  # None of Sweet-Mars, Sweet-cursors, or Sweet-folders(Mars) are packaged
  # in nixpkgs as-is (only the default "sweet" GTK theme and "candy-icons"
  # are). These three build straight from EliverLara's upstream repos.
  #
  # IMPORTANT — before this builds, you MUST replace the `hash` placeholders
  # below with the real ones. Easiest way: leave them as-is, run
  # `nixos-rebuild switch --flake .#nixos`, let it fail with a hash
  # mismatch, and copy the "got: sha256-..." value it reports back in here
  # (repeat once per derivation, 3 times total).
  # -------------------------------------------------------------------------

  sweet-mars-theme = pkgs.stdenvNoCC.mkDerivation {
    pname = "sweet-mars-theme";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "EliverLara";
      repo = "Sweet";
      rev = "master";
      hash = lib.fakeHash;
    };
    nativeBuildInputs = [ pkgs.sassc pkgs.bash ];
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      patchShebangs ./change_color.sh
      # -m builds the Mars color variant; upstream names the output folder
      # "Sweet-Dark" region-swapped to Mars colors — verify the produced
      # folder name after first build and adjust the `cp` line below if
      # upstream has since changed it.
      bash ./change_color.sh -m
      mkdir -p $out/share/themes
      for d in Sweet-Dark Sweet-Mars Sweet-Dark-Mars; do
        [ -d "$d" ] && cp -r "$d" "$out/share/themes/Sweet-Mars"
      done
      runHook postInstall
    '';
  };

  sweet-cursors = pkgs.stdenvNoCC.mkDerivation {
    pname = "sweet-cursors";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "EliverLara";
      repo = "Sweet-cursors";
      rev = "master";
      hash = lib.fakeHash;
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/icons/Sweet-cursors
      cp -r ./* $out/share/icons/Sweet-cursors/
    '';
  };

  sweet-folders-mars = pkgs.stdenvNoCC.mkDerivation {
    pname = "sweet-folders-mars";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "EliverLara";
      repo = "Sweet-folders";
      rev = "master";
      hash = lib.fakeHash;
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/icons/Sweet-Mars
      cp -r ./Sweet-Mars/. $out/share/icons/Sweet-Mars/
      substituteInPlace $out/share/icons/Sweet-Mars/index.theme \
        --replace-warn \
          "Inherits=Pop,Zafiro-icons,gnome,ubuntu-mono-dark,Mint-X,elementary,gnome,hicolor" \
          "Inherits=candy-icons"
    '';
  };
in
{
  # -------------------------------------------------------------------------
  # GTK Config — Sweet-Mars theme, candy-icons + Sweet-folders (Mars),
  # Sweet-cursors
  # -------------------------------------------------------------------------
  gtk = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    theme = {
      name = "Sweet-Mars";
      package = sweet-mars-theme;
    };

    iconTheme = {
      name = "Sweet-Mars";
      package = pkgs.symlinkJoin {
        name = "sweet-mars-icons";
        paths = [ pkgs.candy-icons sweet-folders-mars ];
      };
    };

    cursorTheme = {
      name = "Sweet-cursors";
      package = sweet-cursors;
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
    name = "Sweet-cursors";
    package = sweet-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Qt apps follow the same theme via qt5ct/qt6ct
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct";
  home.packages = with pkgs; [ libsForQt5.qt5ct qt6ct ];
}
