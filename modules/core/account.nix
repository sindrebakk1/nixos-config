{ config, lib, pkgs, ... }:
let
  u   = config.profile.username;
  cfg = config.profile.userAuth;
  pwKey  = cfg.secretKeys.passwordHash;
  pwPath = config.sops.secrets.${pwKey}.path;
in
{
  config = {
    users.mutableUsers = false;
    users.allowNoPasswordLogin = lib.mkForce cfg.disablePassword;

    sops.secrets.${pwKey} = lib.mkIf (!cfg.disablePassword) {
      neededForUsers = true;
      sopsFile = cfg.sopsFile;
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
        hashedPasswordFile = pwPath;
      })
    ];

    security.sudo.wheelNeedsPassword =
      if cfg.disablePassword then lib.mkForce false else cfg.sudoWheelNeedsPassword;

    time.timeZone = "Europe/Oslo";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };
}
