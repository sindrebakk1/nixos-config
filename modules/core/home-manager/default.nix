{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users = {
      sindreb = _: {
        home = {
          stateVersion = config.settings.stateVersion;
          programs.neovim = {
            enable = true;
            defaultEditor = true;
          };
        };
        systemd.user.sessionVariables = config.home-manager.users.sindreb.home.sessionVariables;
      };
      root = _: { home.stateVersion = config.settings.stateVersion; };
    };
  };
}
