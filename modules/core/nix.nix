{ config, lib, pkgs, inputs, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
      trusted-users = [ "root" config.profile.username ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    optimise.automatic = true;
  };

  nix.registry = lib.mkIf (inputs != null) {
    nixpkgs     .flake = inputs.nixpkgs;
    home-manager.flake = inputs.home-manager;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      # permittedInsecurePackages = [ ];
    };
  };
}
