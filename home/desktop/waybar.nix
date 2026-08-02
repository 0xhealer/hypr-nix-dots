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
        height = 26;
        margin-top = 6;
        margin-left = 16;
        margin-right = 16;
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
          font-size: 12px;
      }

      window#waybar {
          background: alpha(${colors.background}, 0.55);
          color: ${colors.foreground};
          border-radius: 14px;
          border: 1px solid alpha(${colors.foreground}, 0.08);
      }

      #workspaces, #clock, #pulseaudio, #network, #battery, #tray {
          margin: 3px 2px;
          padding: 0 6px;
      }

      #workspaces button {
          padding: 0 6px;
          color: ${colors.foreground};
          border-radius: 8px;
      }

      #workspaces button.active {
          background: alpha(${colors.color4}, 0.35);
          border-radius: 8px;
      }

      #clock {
          font-weight: 600;
      }
    '';
  };
}
