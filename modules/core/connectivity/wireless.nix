{ config, lib, ... }: {
  options.settings.core.wireless.enable = lib.mkEnableOption "wireless";

  config = lib.mkIf config.settings.core.wireless.enable {
    networking.wireless = {
      enable = true;
      secretsFile = config.sops.secrets.wireless.path;
      networks = {
        "Big_Birb_5G" = {pskRaw = "ext:home_psk";};
        "Big_Birb" = {pskRaw = "ext:home_psk";};
      };
    };
  };
}
