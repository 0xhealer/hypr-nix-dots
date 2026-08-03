{ ... }: {
    imports = [
        ./hyprland.nix
        ./hyprlock.nix
        ./hypridle.nix
        ./waybar.nix      # installed alongside quickshell as an auto-fallback if qs fails to launch
        ./quickshell.nix
        ./vicinae.nix
        ./wlogout.nix
        ./shell.nix
        ./tools.nix
        ./i3.nix
    ];
}
