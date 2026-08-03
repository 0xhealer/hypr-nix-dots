{ ... }: {
    imports = [
        ./audio.nix
        ./display.nix
        ./network.nix
        ./packages.nix
        ./services.nix
        ./system.nix
        ./virtualisation.nix
        ./i3.nix
    ];
}
