{ config, lib, ... }: {
  options.settings.core.wireless.enable = lib.mkEnableOption "wireless";

  config = lib.mkIf config.settings.core.wireless.enable {
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
  };
}
