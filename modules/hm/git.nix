{ lib, config, ... }:
let
  u          = config.profile.username;
  cfg        = config.profile.homeManager.git;
  tokenKey   = cfg.secretKeys.githubToken;
  tokenPath  = config.sops.secrets.${tokenKey}.path;
in
lib.mkIf cfg.enable {
  sops.secrets.${tokenKey} = lib.mkIf cfg.enableGitHubCredentials {
    owner = u;
    group = "root";
    mode  = "0400";
  };

  home-manager.users.${u}.programs.git = {
    enable = true;
    userName  = "Sindre Bakken Næsset";
    userEmail = "sindrebn@exorlive.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      credential."https://github.com" = lib.mkIf cfg.enableGitHubCredentials {
        username = "sindrebakk1";
        helper = "!f() { echo password=$(cat ${tokenPath}); }; f";
      };
    };
  };
}
