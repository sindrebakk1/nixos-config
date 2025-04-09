{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./lazygit.nix
    ./github.nix
  ];

  options.settings.git = {
    enable = lib.mkOption {
      default = true;
    };
    username = lib.mkOption {
      default = "sindrebakk1";
    };
    email = lib.mkOption {
      default = "sindre.bakken.naesset@gmail.com";
    };
  };

  config =
    let
      base = {
        programs.git = {
          enable = true;

          userEmail = config.settings.git.email;
          userName = config.settings.git.username;

          extraConfig = {
            init.defaultBranch = "main";
            push.autoSetupRemote = true;
          };
        };
      };
    in
    {
      home-manager.users.sindreb = { ... }: base;
      home-manager.users.root = { ... }: base;
    };
}
