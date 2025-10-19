{ config, ... }:
let u = config.profile.username;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${u} = {
      home.username      = u;
      home.homeDirectory = config.profile.homeDir;
      home.stateVersion  = config.profile.hmStateVersion;
    };
  };
}
