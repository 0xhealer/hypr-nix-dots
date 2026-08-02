{ pkgs, ... }:

{
  # Enable RealtimeKit for low-latency PipeWire scheduling
  security.rtkit.enable = true;

  # PipeWire Sound Server Configuration
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth Hardware & Codec Settings
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true; # Enables battery level reporting & experimental codecs
      };
    };
  };
}