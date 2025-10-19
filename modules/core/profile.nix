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
      description = "Derived home directory.";
    };
    
    userAuth = {
      disablePassword = mkEnableOption "Disable password for the profile user. (for WSL)";

      sopsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "SOPS file to read the password hash from; falls back to sops.defaultSopsFile.";
      };

      secretKey = mkOption {
        type = types.str;
        readOnly = true;
        default = "users/${config.profile.username}/password-hash";
        description = "Key path inside the SOPS YAML where the *hashed* password is stored.";
      };

      sudoWheelNeedsPassword = mkOption {
        type = types.bool;
        default = true;
        description = "Require sudo password for wheel group.";
      };
    };
  };

  config.assertions = [
    {
      assertion = config.profile.userAuth.disablePassword ||
        (config.profile.userAuth.sopsFile != null || config.sops.defaultSopsFile != null);
      message = "Password enabled but no sopsFile/defaultSopsFile configured.";
    }
    {
      assertion = builtins.match "^[0-9]{2}\\.[0-9]{2}$" config.profile.hmStateVersion != null;
      message   = "profile.hmStateVersion should look like YY.MM (e.g. 25.05).";
    }
    {
      assertion = !(config.profile.userAuth.disablePassword
        && config.profile.userAuth.sudoWheelNeedsPassword);
      message = "Invalid combo: password is disabled but sudoWheelNeedsPassword = true.";
    }
  ];
}
