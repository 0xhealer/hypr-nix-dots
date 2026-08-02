{ pkgs, ... }:

{
  # -------------------------------------------------------------------------
  # MPV Media Player
  # -------------------------------------------------------------------------
  programs.mpv = {
    enable = true;
    
    config = {
      # High Quality Playback
      profile = "gpu-hq";
      vo = "gpu-next";
      gpu-api = "vulkan";
      
      # UI Options
      keep-open = "yes";
      autofit-larger = "80%x80%";
      cursor-autohide = 1000;
      
      # Subtitle Styling
      sub-font = "JetBrainsMono Nerd Font";
      sub-font-size = 24;
    };
  };
}