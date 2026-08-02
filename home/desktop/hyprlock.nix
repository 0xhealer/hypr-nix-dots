{ pkgs, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = false;
        grace = 2;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "250, 60";
          outline_thickness = 2;
          dots_size = 0.25;
          dots_spacing = 0.2;
          outer_color = "rgb(9580ff)";
          inner_color = "rgb(34, 33, 44)";
          font_color = "rgb(248, 248, 242)";
          fade_on_empty = false;
          placeholder_text = "Password...";
          position = "0, -100";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          text = "cmd[update:1000] echo \"$(date +'%H:%M')\"";
          font_size = 90;
          position = "0, 150";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
