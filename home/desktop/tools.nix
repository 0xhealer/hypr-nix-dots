{ pkgs, ... }:

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

  xdg.configFile."waypaper/config.ini".text = ''
    [Settings]
    language = en
    folder = ~/.local/share/hypr-nix-dots/assets/wallpapers
    wallpaper = ~/.local/share/hypr-nix-dots/assets/wallpapers/6.png
    backend = swww
    fill = fill
    sort = name
    subfolders = False
    number_of_columns = 3
    post_command = wallust run $wallpaper
    swww_transition_type = outer
    swww_transition_step = 90
    swww_transition_angle = 30
    swww_transition_duration = 2
    swww_transition_fps = 60
  '';
}