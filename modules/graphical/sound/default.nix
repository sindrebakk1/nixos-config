{config, lib, ...}: {
  options.settings.graphical.sound = {
    enable = lib.mkEnableOption "Sound";
  };
  config = lib.mkIf config.settings.graphical.sound.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true;
    };
  };
}
