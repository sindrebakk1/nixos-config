{
  config,
  lib,
  ...
}: {
  options = {
    settings.core.nix = {
      enableDirenv = lib.mkOption {default = true;};
      unfreePackages = lib.mkOption {
        default = [];
      };
    };
  };

  config = {
    nixpkgs.config = {
      allowUnfree = true;
    };

    nix = {
      settings = {
        trusted-users = [
          "sindreb"
        ];
        experimental-features = ["nix-command" "flakes"];
        warn-dirty = true;
      };

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
    };
  };
}
