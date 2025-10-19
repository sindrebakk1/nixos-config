{ config, lib, pkgs, ... }:
let
  u   = config.profile.username;
  cfg = config.profile.userAuth;
  secretKey = cfg.secretKey;
in
{
  config = {
    users.mutableUsers = false;
    users.allowNoPasswordLogin = lib.mkForce cfg.disablePassword;

    sops.secrets.${secretKey} = lib.mkIf (!cfg.disablePassword) {
      neededForUsers = true;
    };

    users.users.${u} = lib.mkMerge [
      {
        isNormalUser = true;
        extraGroups  = [ "wheel" ];
        uid          = config.profile.uid;
      }

      (lib.mkIf cfg.disablePassword {
        hashedPassword = lib.mkForce "!";
        hashedPasswordFile = lib.mkForce null;
      })

      (lib.mkIf (!cfg.disablePassword) {
        hashedPasswordFile = config.sops.secrets.${secretKey}.path;
      })
    ];

    security.sudo.wheelNeedsPassword =
      if cfg.disablePassword then lib.mkForce false else cfg.sudoWheelNeedsPassword;
  };
}
