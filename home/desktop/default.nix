{ ... }: {
    imports = [
        ./hyprland.nix
        ./hyprlock.nix
        ./hypridle.nix
        # ./waybar.nix      -- swapped out for quickshell.nix; flip back any time
        ./quickshell.nix
        ./wlogout.nix
        ./shell.nix
        ./tools.nix
    ];
}
