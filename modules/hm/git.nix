# modules/hm/git.nix
{ config, ... }:
let
  u          = config.profile.username;
  secretName = "services/github/token";
  tokenPath  = config.sops.secrets.${secretName}.path;
in {
  sops.secrets.${secretName} = {
    owner = u;
    group = "root";
    mode  = "0400";
    # sopsFile omitted -> uses sops.defaultSopsFile from your sops.nix
  };

  home-manager.users.${u}.programs.git = {
    enable = true;
    userName  = "Sindre Bakken Næsset";
    userEmail = "sindrebn@exorlive.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      credential."https://github.com" = {
        username = "sindrebakk1";
        helper = "!f() { echo password=$(cat ${tokenPath}); }; f";
      };
    };
  };
}
