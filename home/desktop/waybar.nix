{ pkgs, ... }:

let
  colors = import ../style/colors.nix;
in
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" "tray" ];
        clock = { format = "{:%a %d %b  %H:%M}"; };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-icons = [ "" "" "" ];
        };
        battery = {
          format = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };
        network = {
          format-wifi = " {essid}";
          format-ethernet = " {ipaddr}";
        };
      };
    };

    style = ''
      * {
          font-family: "JetBrainsMono Nerd Font";
          font-size: 13px;
      }

      window#waybar {
          background: alpha(${colors.background}, 0.75);
          color: ${colors.foreground};
          border-radius: 10px;
          margin: 6px 10px;
      }

      #workspaces button {
          padding: 0 8px;
          color: ${colors.foreground};
      }

      #workspaces button.active {
          background: alpha(${colors.color4}, 0.4);
          border-radius: 8px;
      }

      #clock, #pulseaudio, #network, #battery, #tray {
          padding: 0 10px;
      }
    '';
  };
}
