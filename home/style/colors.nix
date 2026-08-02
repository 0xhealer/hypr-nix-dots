# Central color palette — plain Nix values, imported directly by every
# themed app (Waybar, Kitty, Alacritty, Rofi, Dunst, Hyprland). Static by
# design: no wallpaper-driven regeneration, no runtime file-writing tool
# to fight home-manager's read-only symlinks over. Change a value here,
# rebuild, and it's consistent everywhere.
#
# Nord palette (nordtheme.com) — full turnaround from the earlier
# Dracula-style scheme.
{
  background = "#0B0E11"; # darkened from Nord0 (#2E3440) — pure blackish, not grey-blue
  foreground = "#D8DEE9"; # Nord4
  cursor = "#88C0D0"; # Nord8
  selectionBackground = "#434C5E"; # Nord2
  selectionForeground = "#ECEFF4"; # Nord6

  color0 = "#3B4252";  # Nord1  - black
  color1 = "#BF616A";  # Nord11 - red
  color2 = "#A3BE8C";  # Nord14 - green
  color3 = "#EBCB8B";  # Nord13 - yellow
  color4 = "#81A1C1";  # Nord9  - blue
  color5 = "#B48EAD";  # Nord15 - magenta
  color6 = "#88C0D0";  # Nord8  - cyan
  color7 = "#E5E9F0";  # Nord5  - white
  color8 = "#4C566A";  # Nord3  - bright black
  color9 = "#BF616A";  # Nord11 - bright red
  color10 = "#A3BE8C"; # Nord14 - bright green
  color11 = "#EBCB8B"; # Nord13 - bright yellow
  color12 = "#81A1C1"; # Nord9  - bright blue
  color13 = "#B48EAD"; # Nord15 - bright magenta
  color14 = "#8FBCBB"; # Nord7  - bright cyan
  color15 = "#ECEFF4"; # Nord6  - bright white
}
