{ pkgs, ... }:

let
  colors = import ../style/colors.nix;
in
{
  # -------------------------------------------------------------------------
  # Waybar — ported directly from a real reference config.jsonc/style.css
  # (the same three-floating-pill layout as harsh-m-patil/.dotfiles, likely
  # its original inspiration), recolored to our own palette instead of
  # Catppuccin Mocha.
  #
  # persistent-workspaces is the important addition here: without it, if
  # only one workspace has ever been created, the workspace module renders
  # a single bare button with no visible pill container around it — the
  # tiny purple dot instead of a proper pill. This forces 5 slots to always
  # show regardless of how many are actually in use.
  # -------------------------------------------------------------------------
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        margin-top = 5;
        margin-left = 10;
        margin-right = 10;

        modules-left = [ "hyprland/window" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "pulseaudio" "network" "temperature" "battery" "clock" ];

        "hyprland/window" = {
          format = "{}";
          max-length = 45;
          rewrite = { "" = "Desktop"; };
          separate-outputs = true;
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = { active = " "; };
          sort-by-number = true;
          persistent-workspaces = {
            "*" = 5;
          };
        };

        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        cpu = {
          format = "  {usage}%";
          tooltip = false;
        };

        memory = {
          format = "{}%  ";
        };

        temperature = {
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = [ "" "" "" ];
        };

        battery = {
          states = { warning = 30; critical = 15; };
          format = "{icon}  {capacity}%";
          format-full = "{icon}  {capacity}%";
          format-charging = "  {capacity}%";
          format-plugged = "  {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
          interval = 5;
        };

        network = {
          format = "{ifname}";
          format-wifi = "  {signalStrength}%  {bandwidthDownBytes}  {bandwidthUpBytes} ";
          format-ethernet = "   {bandwidthDownBytes}  {bandwidthUpBytes} ";
          format-disconnected = "Not connected";
          tooltip-format = "  {ifname} via {gwaddri}";
          tooltip-format-wifi = "   {essid} ({signalStrength}%)";
          tooltip-format-ethernet = "  {ifname} ({ipaddr}/{cidr})";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          interval = 1;
          on-click = "nm-connection-editor";
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
      };
    };

    style = ''
      * {
          font-family: "JetBrainsMono Nerd Font", Roboto, Helvetica, Arial, sans-serif;
          font-size: 15px;
      }

      window#waybar {
          background-color: rgba(0, 0, 0, 0);
          color: ${colors.foreground};
          border-radius: 13px;
          transition-property: background-color;
          transition-duration: 0.5s;
      }

      button {
          box-shadow: inset 0 -3px transparent;
          border: none;
          border-radius: 0;
      }

      button:hover {
          background: inherit;
          box-shadow: inset 0 -3px ${colors.foreground};
      }

      #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: ${colors.foreground};
      }

      #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
      }

      #workspaces button.focused,
      #workspaces button.active {
          background-color: ${colors.color4};
          box-shadow: inset 0 -3px ${colors.foreground};
      }

      #workspaces button.urgent {
          background-color: ${colors.color1};
      }

      #window, #clock, #battery, #cpu, #memory, #temperature, #network, #pulseaudio {
          padding: 0 10px;
          color: ${colors.foreground};
      }

      .modules-right, .modules-left, .modules-center {
          background-color: ${colors.color0};
          border-radius: 15px;
      }

      .modules-right { padding: 0 10px; }
      .modules-left { padding: 0 20px; }
      .modules-center { padding: 0 10px; }

      #battery.charging, #battery.plugged {
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
