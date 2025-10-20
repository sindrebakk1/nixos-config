{ lib, config, inputs, pkgs, ... }:
let
  u   = config.profile.username;
  cfg = config.profile.homeManager;
in
lib.mkIf cfg.enable {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${u} = { lib, config, pkgs, ... }: {
      home.username      = u;
      home.homeDirectory = cfg.homeDir;
      home.stateVersion  = cfg.stateVersion;

      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      sops = {
        defaultSopsFile = ../../secrets/common.yaml;
        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      };

      home.activation.generateUserAgeKey =
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          set -euo pipefail
          key="${config.home.homeDirectory}/.config/sops/age/keys.txt"
          if [ ! -f "$key" ]; then
            install -d -m 700 "$(dirname "$key")"
            echo "[sops-nix] Generating *user* age key at $key"
            ${pkgs.age}/bin/age-keygen -o "$key"
            echo "[sops-nix] ✓ Key generated"
            echo "[sops-nix] User public key:"
            ${pkgs.age}/bin/age-keygen -y "$key" || true
          else
            echo "[sops-nix] Existing user SOPS key found — skipping generation."
          fi
        '';
    };
  };
}
