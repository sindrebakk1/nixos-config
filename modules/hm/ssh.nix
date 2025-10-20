{ config, lib, pkgs, ... }:
let
  u   = config.profile.username;
  cfg = config.profile.homeManager.ssh;
  akKey = cfg.secretKeys.authorizedKeys;
  hostname = config.networking.hostName;
in
lib.mkIf cfg.enable {
  home-manager.users.${u} = { lib, config, pkgs, ... }:
  let
    homeDir = config.home.homeDirectory;
    host = hostname;
  in {
    sops.secrets.${akKey} = lib.mkIf cfg.enableSopsAuthorizedKeys {
      sopsFile = cfg.sopsFile;
      path = "${homeDir}/.ssh/authorized_keys";
      mode = "0600";
    };

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
