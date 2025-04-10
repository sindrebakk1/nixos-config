{ config, lib, ... }: {
  options.settings.core.wireless.enable = lib.mkEnableOption "wireless";

  config = lib.mkIf config.settings.core.wireless.enable {
    networking.networkManager.enable = true;
  };
}
