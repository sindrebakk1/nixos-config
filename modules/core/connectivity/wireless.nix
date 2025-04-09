{ config, lib, ... }: {
  options.settings.core.wireless.enable = lib.mkEnableOption "wireless";

  config = lib.mkIf config.settings.core.wireless.enable {
    networking.wireless = {
      enable = true;
      secretsFile = config.sops.secrets.wireless.path;
      networks = {
        "@home_5G_uuid@" = {pskRaw = "ext:home_psk";};
        "@home_uuid@" = {pskRaw = "ext:home_psk";};
      };
    };
  };
}
