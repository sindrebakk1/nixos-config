{ lib, config, ... }:
let
  u   = config.profile.username;
  cfg = config.profile.homeManager;
in
lib.mkIf config.profile.homeManager.enable {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${u} = {
      home.username      = u;
      home.homeDirectory = cfg.homeDir;
      home.stateVersion  = cfg.stateVersion;
    };
  };
}
