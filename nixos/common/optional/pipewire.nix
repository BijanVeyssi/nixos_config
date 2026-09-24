{ ... }:

{
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };

    extraConfig.client."91-loopback-microphone" = {
      "context.modules" = [
        {
          name = "libpipewire-module-loopback";
          args = {
            "capture.props" = {
              "audio.position" = "MONO"; # Set to MONO for a single channel
            };
            "playback.props" = {
              "media.class" = "Audio/Source"; # Important for the virtual microphone
              "node.description" = "Virtual Microphone"; # Description for identification
            };
          };
        }
      ];
    };
  };

  hardware.alsa.enablePersistence = true;
}
