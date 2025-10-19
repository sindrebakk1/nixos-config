{ config, lib, pkgs, ... }:
let
  u   = config.profile.username;
  cfg = config.profile.userAuth;
  secretKey = cfg.secretKey;
in
{
  config = {
    sops.secrets.${secretKey} = lib.mkIf cfg.enablePassword {
      sopsFile = cfg.sopsFile or config.sops.defaultSopsFile;
      mode  = "0400";
      owner = u;
      group = "root";
    };

    users.users.${u} = {
      isNormalUser = true;
      extraGroups  = [ "wheel" ];
      uid          = config.profile.uid;
      hashedPasswordFile = lib.mkIf cfg.enablePassword
        config.sops.secrets.${secretKey}.path;
    };

    security.sudo.wheelNeedsPassword = cfg.sudoWheelNeedsPassword;
  };
}
