{ lib, config, ... }:
let
  u = config.profile.username;
  cfg = config.profile.homeManager.git;
  tokenKey = cfg.secretKeys.githubToken;
in
lib.mkIf cfg.enable {
  home-manager.users.${u} = { config, ... }: {
    sops.secrets.${tokenKey} = lib.mkIf cfg.enableGitHubCredentials {
      sopsFile = cfg.sopsFile;
    };

    programs.git = {
      enable = true;
      userName  = "Sindre Bakken Næsset";
      userEmail = "sindrebn@exorlive.com";

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        credential."https://github.com" = lib.mkIf cfg.enableGitHubCredentials {
          username = "sindrebakk1";
          helper = ''!f() { echo password=$(cat ${config.sops.secrets.${tokenKey}.path}); }; f'';
        };
      };
    };
  };
}
