{ lib, config, pkgs, ... }:
let
  u = config.profile.username;
  cfg = config.profile.homeManager.shell;
  starshipPath = ../../starship.toml;
in
lib.mkIf cfg.enable {
  home-manager.users.${u} = {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      sessionVariables = {
        DEFAULT_USER = "${u}";
      };
    };
    programs.starship = lib.mkIf cfg.starship.enable {
      enable = true;
      enableBashIntegration = true;
      settings = (builtins.fromTOML (builtins.readFile starshipPath));
    };
  };
}
