{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # i3/X11 — a second, permanent session alongside Hyprland. Mainly so a
  # guest who's used to i3 has a familiar option rather than being dropped
  # into an unfamiliar Wayland compositor. Hyprland stays the default at
  # the SDDM login screen; i3 is just an additional selectable session.
  # -------------------------------------------------------------------------
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
}
