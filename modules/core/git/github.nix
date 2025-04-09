{
  lib,
  config,
  ...
}: let
  base = home: {
    programs.gh = {
      enable = true;
      settings = {
        editor = "nvim";
      };
    };
  };
in {
  home-manager.users.sindreb = {...}: (base "/home/sindreb");
}
