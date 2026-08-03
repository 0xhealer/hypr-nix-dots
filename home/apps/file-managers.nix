{ pkgs, lib, ... }:

{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      manager = {
        show_hidden = true;
        sort_by = "alphabetical";
        sort_dir_first = true;
      };
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
      "application/x-gnome-saved-search" = [ "thunar.desktop" ];
    };
  };

  # Thunar's icon view defaults to 100% zoom, which renders quite large.
  # Forced every rebuild via xfconf (its actual settings backend) — not
  # "seed once" like our other activation scripts, since we're actively
  # tuning this value. If you later want to freely change it yourself via
  # Thunar's View menu without it reverting on the next rebuild, remove
  # this activation block entirely.
  #
  # `|| true` matters here: xfconf-query needs a live D-Bus session to
  # talk to, which doesn't exist when rebuilding from a plain TTY/SSH
  # session (not inside a graphical session). Without the fallback, that
  # failure was taking down the *entire* home-manager activation, not just
  # this one cosmetic setting — every other activation step downstream of
  # this one silently never ran either. Now it just skips quietly and
  # applies next time you rebuild from inside an actual desktop session.
  home.activation.setThunarZoom = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.xfce.xfconf}/bin/xfconf-query -c thunar \
      -p /last-icon-view-zoom-level -n -t string -s THUNAR_ZOOM_LEVEL_25_PERCENT \
      || echo "xfconf-query failed (no D-Bus session? not fatal, skipping)"
  '';
}