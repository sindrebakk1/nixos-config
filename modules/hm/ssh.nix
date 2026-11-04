{ config, lib, pkgs, ... }:
let
  u   = config.profile.username;
  cfg = config.profile.homeManager.ssh;
  akKey = cfg.secretKeys.authorizedKeys;
  hostname = config.networking.hostName;
  homeDir  = config.profile.homeManager.homeDir;
  sshDir   = "${homeDir}/.ssh";
in
lib.mkIf cfg.enable {
  # authorized_keys is a *system* secret: decrypted at boot by the NixOS
  # sops-nix activation using the host key (/var/lib/sops-nix/keys.txt).
  # This must not live in Home Manager — HM sops runs as a systemd user
  # service and writes to /run/user/<uid>, which doesn't exist until the
  # user is logged in, leaving sshd with a dangling authorized_keys.
  sops.secrets.${akKey} = lib.mkIf cfg.enableSopsAuthorizedKeys {
    sopsFile = cfg.sopsFile;
    path     = "${sshDir}/authorized_keys";
    owner    = u;
    group    = "users";
    mode     = "0600";
  };

  # Make sure ~/.ssh exists with the right owner before sops-nix symlinks into
  # it; otherwise sops-nix creates it as root and HM can't write id_ed25519.
  system.activationScripts.sshUserDir = lib.mkIf cfg.enableSopsAuthorizedKeys {
    deps = [ "users" "groups" ];
    text = ''
      install -d -m 0700 -o ${u} -g users "${sshDir}"
    '';
  };
  system.activationScripts.setupSecrets.deps =
    lib.mkIf cfg.enableSopsAuthorizedKeys [ "sshUserDir" ];

  home-manager.users.${u} = { lib, config, pkgs, ... }:
  let
    homeDir = config.home.homeDirectory;
    host = hostname;
  in {
    programs.ssh = {
      enable = true;
      package = pkgs.openssh;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        identitiesOnly = true;
        identityFile = [ "${homeDir}/.ssh/id_ed25519" ];
        serverAliveInterval = 30;
        serverAliveCountMax = 3;
        forwardAgent = false;
        compression = false;
        addKeysToAgent = "no";
        hashKnownHosts = true;
        userKnownHostsFile = "${homeDir}/.ssh/known_hosts";
        controlMaster = "auto";
        controlPersist = "5m";
        controlPath = "${homeDir}/.ssh/ctl-%C";
      };
      # matchBlocks."git" = { hostname = "github.com"; user = "git"; };
    };

    # generate a keypair if missing — runs after programs.ssh activation
    home.activation.generateSshKey =
      lib.hm.dag.entryAfter [ "programs.ssh" ] ''
        set -euo pipefail
        key="${homeDir}/.ssh/id_ed25519"
        if [ ! -f "$key" ]; then
          echo "[ssh] Generating new ed25519 keypair..."
          ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -N "" \
            -C "${config.home.username}@${host}" \
            -f "$key" >/dev/null
          echo "[ssh] ✓ Key generated"
          echo "[ssh] > Public key:"
          ${pkgs.coreutils}/bin/cat "${homeDir}/.ssh/id_ed25519.pub"
        else
          echo "[ssh] Existing SSH key found — skipping generation."
        fi
      '';
  };
}
