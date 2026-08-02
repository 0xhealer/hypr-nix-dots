{ pkgs, lib, ... }:

{
  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=$HOME/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=sans-serif
  '';

  # NOT xdg.configFile: Waypaper writes its own state (last-picked wallpaper,
  # fill mode, sort order, etc.) back to config.ini after every GUI
  # interaction — a home-manager-managed file here would be a read-only
  # Nix store symlink, and Waypaper would hit a permission error trying to
  # save (a confirmed upstream-reported failure mode in exactly this setup:
  # anufrievroman/waypaper#98). Seeded once, writably, same reasoning as
  # every other "runtime tool needs to write here" file in this repo.
  home.activation.seedWaypaperConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/waypaper"
    [ -f "$HOME/.config/waypaper/config.ini" ] || cat > "$HOME/.config/waypaper/config.ini" <<'EOF'
[Settings]
language = en
folder = ~/.local/share/hypr-nix-dots/assets/wallpapers
wallpaper = ~/.local/share/hypr-nix-dots/assets/wallpapers/6.png
backend = awww
fill = fill
sort = name
subfolders = False
number_of_columns = 3
swww_transition_type = outer
swww_transition_step = 90
swww_transition_angle = 30
swww_transition_duration = 2
swww_transition_fps = 60
EOF
  '';
}