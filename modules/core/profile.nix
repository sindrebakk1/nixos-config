{ lib, config, ... }:
let
  inherit (lib) mkOption mkEnableOption mkDefault types;
in
{
  options.profile = {
    username = mkOption {
      type = types.nullOr types.nonEmptyStr;
      default = null;
      description = "Primary user (required).";
      example = "sindreb";
    };
    
    uid = mkOption {
      type = types.int;
      default = 1000;
      description = "User ID";
    };

    userAuth = {
      disablePassword = mkEnableOption "Disable password for the profile user. (for WSL)";
      sopsFile = mkOption {
        type = types.nullOr types.path;
        default = config.sops.defaultSopsFile;
        description = "SOPS file to read the user auth secrets from; falls back to sops.defaultSopsFile.";
      };
      secretKeys.passwordHash = mkOption {
        type = types.str;
        default = "users/${config.profile.username}/password-hash";
        description = "Key path inside the SOPS YAML where the *hashed* password is stored.";
      };
      sudoWheelNeedsPassword = mkOption {
        type = types.bool;
        default = true;
        description = "Require sudo password for wheel group.";
      };
    };

    homeManager = {
      enable = (mkEnableOption "Enable Home Manager for the profile user") // { default = true; };
      stateVersion = mkOption {
        type = types.str; default = config.system.stateVersion;
        description = "HM stateVersion (defaults to system.stateVersion).";
      };
      homeDir = mkOption {
        type = types.str;
        readOnly = true;
        default = "/home/${config.profile.username}";
        description = "Derived home directory.";
      };
      git = {
        enable = (mkEnableOption "Enable Git HM module") // { default = true; };
        enableGitHubCredentials = (mkEnableOption "Set up github credentials stored with SOPS") // { default = true; };
        sopsFile = mkOption {
          type = types.nullOr types.path;
          default = config.sops.defaultSopsFile;
          description = "SOPS file to read the git secrets from; falls back to sops.defaultSopsFile.";
        };
        secretKeys.githubToken = mkOption {
          type = types.str;
          default = "home-manager/${config.profile.username}/github/token";
          description = "Key path inside the SOPS YAML where the github token is stored.";
        };
      };
      ssh = {
        enable = (mkEnableOption "Enable SSH HM module") // { default = true; };
        enableSopsAuthorizedKeys = (mkEnableOption "Enable managing authorized_keys with SOPS") // { default = true; };
        sopsFile = mkOption {
          type = types.nullOr types.path;
          default = config.sops.defaultSopsFile;
          description = "SOPS file to read the ssh secrets from; falls back to sops.defaultSopsFile.";
        };
        secretKeys.authorizedKeys = mkOption {
          type = types.str;
          default = "home-manager/${config.profile.username}/ssh/${config.networking.hostName}/authorized_keys";
          description = "Key path inside the SOPS YAML where the users authorized_keys file is stored.";
        };
      };
      shell = {
        enable = (mkEnableOption "Enable shell HM module") // { default = true; };
        transientPrompt = (mkEnableOption "Enable transient prompt") // { default = true; };
        starship = {
          enable =  (mkEnableOption "Enable starship prompt") // { default = true; };
        };
      };
    };
  };

  config.assertions = [
    { assertion = config.profile.username != null; message = "profile.username is required"; }
    {
      assertion = (config.profile.userAuth.sopsFile != null);
      message = "profile.userAuth.sopsFile or sops.defaultSopsFile must be set";
    }
    {
      assertion = (
        !config.profile.homeManager.enable
        || !config.profile.homeManager.git.enable
        || config.profile.homeManager.git.sopsFile != null);
      message = "profile.homeManager.git.sopsFile or sops.defaultSopsFile must be set";
    }
    {
      assertion = (
        !config.profile.homeManager.enable
        || !config.profile.homeManager.ssh.enable
        || config.profile.homeManager.ssh.sopsFile != null);
      message = "profile.homeManager.ssh.sopsFile or sops.defaultSopsFile must be set";
    }
    {
      assertion = builtins.match "^[0-9]{2}\\.[0-9]{2}$" config.profile.homeManager.stateVersion != null;
      message   = "profile.hmStateVersion should look like YY.MM (e.g. 25.05).";
    }
    {
      assertion = !(config.profile.userAuth.disablePassword
        && config.profile.userAuth.sudoWheelNeedsPassword);
      message = "Invalid combo: password is disabled but sudoWheelNeedsPassword = true.";
    }
  ];
}
