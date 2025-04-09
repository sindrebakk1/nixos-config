{ config, lib, ... }: {
  options.settings.core.wireless.enable = lib.mkEnableOption "wireless";

  config = lib.mkIf config.settings.core.wireless.enable {
    networking.wireless = {
      enable = true;
      environmentFile = config.sops.secrets.wireless.path;
      networks = {
        "@home_5G_uuid@" {psk = "@home_psk@";};
        "@home_uuid@" {psk = "@home_psk@";};
      };
    };
  };
}
