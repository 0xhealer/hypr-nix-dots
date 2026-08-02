{ pkgs, ... }:

{
  home.packages = [ pkgs.wlogout ];

  xdg.configFile."wlogout/layout.json".text = ''
    [
      { "label": "lock", "action": "hyprlock", "text": "Lock", "keybind": "l" },
      { "label": "logout", "action": "hyprctl dispatch exit", "text": "Logout", "keybind": "e" },
      { "label": "suspend", "action": "systemctl suspend", "text": "Suspend", "keybind": "s" },
      { "label": "reboot", "action": "systemctl reboot", "text": "Reboot", "keybind": "r" },
      { "label": "shutdown", "action": "systemctl poweroff", "text": "Shutdown", "keybind": "p" }
    ]
  '';

  xdg.configFile."wlogout/style.css".text = ''
    * {
        background-image: none;
        transition: 200ms;
    }
    window {
        background-color: rgba(11, 13, 15, 0.75);
    }
    button {
        color: #F8F8F2;
        background-color: rgba(54, 64, 73, 0.6);
        border-radius: 14px;
        border: 2px solid rgba(149, 128, 255, 0.3);
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        margin: 10px;
    }
    button:focus, button:active, button:hover {
        background-color: rgba(149, 128, 255, 0.25);
        border: 2px solid rgba(149, 128, 255, 0.8);
    }
  '';
}
