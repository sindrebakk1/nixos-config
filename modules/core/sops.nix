{ config, lib, pkgs, ... }:
let
  keyDir  = "/var/lib/sops-nix";
  keyFile = "${keyDir}/keys.txt";

  u = config.profile.username;
  userKeyPath = "/home/${u}/.config/sops/age/keys.txt";
in
{
  sops = {
    age.keyFile = keyFile;
    defaultSopsFile = ../../secrets/common.yaml;
  };

  environment.systemPackages = with pkgs; [ age sops ];

  systemd.tmpfiles.rules = [
    "d ${keyDir} 0700 root root -"
  ];

  system.activationScripts.sopsNixKey.text = ''
    set -euo pipefail

    if [ ! -f "${keyFile}" ]; then
      echo "[sops-nix] Generating system age key at ${keyFile}"
      install -m 0700 -d "${keyDir}"
      umask 077
      ${pkgs.age}/bin/age-keygen -o "${keyFile}"
      # double-check perms; age-keygen writes 0600, keep it that way
      chmod 600 "${keyFile}"
      echo "[sops-nix] System public key:"
      ${pkgs.age}/bin/age-keygen -y "${keyFile}" || true
    fi
  '';

  system.activationScripts.sopsUserKey.text = ''
    set -euo pipefail
    if [ -n "${u}" ] && [ ! -f "${userKeyPath}" ]; then
      echo "[sops-nix] Generating user age key at ${userKeyPath}"
      install -m 0700 -d "$(dirname ${userKeyPath})"
      umask 077
      ${pkgs.age}/bin/age-keygen -o "${userKeyPath}"
      chown ${u}:users "${userKeyPath}"
      chmod 600 "${userKeyPath}"
      echo "[sops-nix] User public key:"
      ${pkgs.age}/bin/age-keygen -y "${userKeyPath}" || true
    fi
  '';
}
