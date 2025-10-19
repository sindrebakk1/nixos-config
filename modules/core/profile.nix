{ lib, config, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options.profile = {
    username = mkOption {
      type = types.str;
      description = "Primary user.";
    };
    
    uid = mkOption {
      type = types.int;
      default = 1000;
      readOnly = true;
      description = "User ID";
    };
    
    hmStateVersion = mkOption {
      type = types.str; default = config.system.stateVersion;
      description = "HM stateVersion (defaults to system.stateVersion).";
    };
    
    homeDir = mkOption {
      type = types.str;
      readOnly = true;
      default = "/home/${config.profile.username}";
    };
    
    userAuth = {
      enablePassword = mkEnableOption "Enable password for the profile user.";

      sopsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
      };

      secretKey = mkOption {
        type = types.str;
        default = "users/${config.profile.username}/password-hash";
      };

      sudoWheelNeedsPassword = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config.assertions = [
    { assertion = config.profile.userAuth.enablePassword -> (config.profile.userAuth.sopsFile != null
        || config.sops.defaultSopsFile != null);
      message = "Password enabled but no sopsFile/defaultSopsFile configured."; }

    { assertion = builtins.match "^[0-9]{2}\\.[0-9]{2}$" config.profile.hmStateVersion != null;
      message   = "profile.hmStateVersion should look like YY.MM (e.g. 25.05)."; }
  ];
}
