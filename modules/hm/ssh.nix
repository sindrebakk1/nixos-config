{ config, lib, pkgs, ... }:
let
  u    = config.profile.username;
  cfg  = config.profile.homeManager.ssh;
  akKey = cfg.secretKeys.authorizedKeys;

  homeDir = config.profile.homeManager.homeDir;
  host    = config.networking.hostName;
in
lib.mkIf cfg.enable {
  sops.secrets.${akKey} = lib.mkIf cfg.enableSopsAuthorizedKeys {
    sopsFile = cfg.sopsFile;
    path     = "${homeDir}/.ssh/authorized_keys";
    owner    = u;
    mode     = "0600";
  };

  home-manager.users.${u} = { lib, config, pkgs, ... }:
  let
    uHM    = config.home.username;
    homeHM = config.home.homeDirectory;
    hostHM = host;
  in {
    assertions = [{
      assertion = uHM != null && homeHM != null;
      message   = "home.username/homeDirectory must be bound before hm/ssh.nix.";
    }];

    programs.ssh = {
      enable  = true;
      package = pkgs.openssh;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        identitiesOnly = true;
        identityFile = [ "${homeHM}/.ssh/id_ed25519" ];
        serverAliveInterval = 30;
        serverAliveCountMax = 3;
        forwardAgent = false;
        compression = false;
        addKeysToAgent = "no";
        hashKnownHosts = true;
        userKnownHostsFile = "${homeHM}/.ssh/known_hosts";
        controlMaster = "auto";
        controlPersist = "5m";
        controlPath = "${homeHM}/.ssh/ctl-%C";
      };
      # matchBlocks."git" = { hostname = "github.com"; user = "git"; };
    };

    home.activation.prepareSshDir =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        set -euo pipefail
        mkdir -p "${homeHM}/.ssh"
        chmod 700 "${homeHM}/.ssh"
      '';

    home.activation.ensureSshKey =
      lib.hm.dag.entryAfter [ "prepareSshDir" ] ''
        set -euo pipefail
        if [ ! -f "${homeHM}/.ssh/id_ed25519" ]; then
          ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -N "" -C "${uHM}@${hostHM}" -f "${homeHM}/.ssh/id_ed25519"
          chmod 600 "${homeHM}/.ssh/id_ed25519"
          chmod 644 "${homeHM}/.ssh/id_ed25519.pub"
          echo "[ssh] Generated ssh key-pair for ${uHM}"
          echo "[ssh] > Public key: $(${pkgs.coreutils}/bin/cat "${homeHM}/.ssh/id_ed25519.pub")"
        fi
      '';
  };
}
