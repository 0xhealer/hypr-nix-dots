{ pkgs, ... }:

let
  colors = import ../style/colors.nix;
in
{
  # -------------------------------------------------------------------------
  # Waybar — layout ported from harsh-m-patil/.dotfiles (pre-nix branch):
  # three independently-floating pill groups (left/center/right) on a fully
  # transparent bar surface, rather than one continuous bar. Colors swapped
  # for our own palette (style/colors.nix) instead of their Catppuccin Mocha.
  # -------------------------------------------------------------------------
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;
        margin-top = 5;
        margin-left = 10;
        margin-right = 10;

        modules-left = [ "hyprland/window" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "pulseaudio" "network" "temperature" "battery" "clock" ];

        "hyprland/window" = {
          format = "{}";
          max-length = 45;
          separate-outputs = true;
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = { active = ""; };
          sort-by-number = true;
        };

        clock = {
          format = "{:%a %d %b  %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        temperature = {
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = [ "" "" "" ];
        };

        battery = {
          states = { warning = 30; critical = 15; };
          format = "{icon}  {capacity}%";
          format-charging = "  {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          interval = 5;
        };

        network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "  {ipaddr}";
          format-disconnected = "Not connected";
          tooltip-format-wifi = "  {essid} ({signalStrength}%)";
          on-click = "nm-connection-editor";
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
      };
    };

    style = ''
      * {
          font-family: "JetBrainsMono Nerd Font";
          font-size: 13px;
      }

      window#waybar {
          background-color: transparent;
          color: ${colors.foreground};
      }

      button {
          box-shadow: none;
          border: none;
          border-radius: 0;
      }

      #workspaces button {
          padding: 0 6px;
          background-color: transparent;
          color: ${colors.foreground};
          border-radius: 8px;
      }

      #workspaces button:hover {
          background: rgba(255, 255, 255, 0.08);
      }

      #workspaces button.active {
          background-color: ${colors.color4};
          color: ${colors.background};
      }

      #window, #clock, #battery, #temperature, #network, #pulseaudio {
          padding: 0 10px;
          color: ${colors.foreground};
      }

      .modules-left, .modules-center, .modules-right {
          background-color: ${colors.color0};
          border-radius: 15px;
      }

      .modules-right { padding: 0 10px; }
      .modules-left { padding: 0 16px; }
      .modules-center { padding: 0 10px; }

      #battery.charging {
          color: ${colors.color6};
      }

      @keyframes blink {
          to { color: ${colors.background}; }
      }

      #battery.critical:not(.charging) {
          background-color: ${colors.color1};
          color: ${colors.foreground};
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: steps(12);
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #pulseaudio.muted {
          color: ${colors.color8};
      }
    '';
  };
}
