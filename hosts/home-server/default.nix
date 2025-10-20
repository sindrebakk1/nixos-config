# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  profile = {
    username = "sindreb";
    extraGroups = [ "networkmanager" "docker" "wheel" ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  fileSystems."/mnt/shared" = {
    device = "/dev/disk/by-uuid/0bae4459-dcd2-43a6-b14a-83ee07f4740f";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  systemd.network.links."10-ethernet" = {
    matchConfig = {
      MACAddress = "5a:86:e4:48:d3:de";
    };
    linkConfig = {
      Name = "eth0";
    };
  };

  networking = {
    hostName = "home-server";
    useDHCP = false;
    macvlans = {
      macvlan0 = {
        interface = "eth0";
        mode = "bridge";
      };
    };

    interfaces = {
      eth0 = {
        useDHCP = false;
        macAddress = "5a:86:e4:48:d3:de";
        ipv4.addresses = [{ address = "192.168.1.10"; prefixLength = 24; }];
      };
      macvlan0 = {
        ipv4 = {
          addresses = [{
            address = "192.168.1.200";
            prefixLength = 24;
          }];
          routes = [{
            address = "192.168.1.20";
            prefixLength = 32;
          }];
        };
      };
    };

    defaultGateway = "192.168.1.1";

    nameservers = [ "192.168.1.1" "1.1.1.1" "8.8.8.8" ];

    resolvconf.enable = false;

    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 139 443 445 32400 32469 3005 8324 ];
      allowedUDPPorts = [ 53 137 138 1900 5353 32410 32412 32413 32414 51820 ];
      interfaces.wg0 = {
        allowedTCPPorts = [ 22 ];
      };
    };

    nat = {
      enable = true;
      externalInterface = "eth0";
      internalInterfaces = [ "wg0" ];
    };

    wireguard.interfaces.wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = "/etc/wireguard/privatekey";
      peers = [
        {
          publicKey = "la3Mnh1cRLsFajaSNjM8OTWudMKa6+IZuk9++2xJF1E=";
          allowedIPs = [ "10.100.0.11/32" ];
        }
        {
          publicKey = "KmSWJB+0rvwBISHEWKHVmGg8SJKqD2oSdnVQsK2blGQ=";
          allowedIPs = [ "10.100.0.12/32" ];
        }
        {
          publicKey = "sUxraWa0lCqhwJAnfq920ZFt12CFTBCzShzuxN0h/FM=";
          allowedIPs = [ "10.100.0.13/32" ];
        }
        {
          publicKey = "PsEXLh5qcb+sSJFn021HZ/0CcJW2kIxwnYQUKFvwhkU=";
          allowedIPs = [ "10.100.0.15/32" ];
        }
      ];
    };
  };

  users = {
    groups = {
      sambashare = {};
    };
    users = {
      sambauser = {
        isNormalUser = true;
        description = "Samba Shared User";
        extraGroups = [ "sambashare" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    wireguard-tools
    curl
    wget
    jq
  ];

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    dnsmasq = {
      enable = true;
      settings = {
        listen-address = [ "10.100.0.1" ];
        address = [ "/home.sindrebakken.dev/10.100.0.1" ];
        domain-needed = true;
        bogus-priv = true;
      };
    };

    cloudflare-dyndns = {
      enable = true;
      apiTokenFile = "/etc/cloudflare-ddns/token";
      domains = [ "home.sindrebakken.dev" ];
      ipv4 = true;
      ipv6 = false;
      proxied = false;
      deleteMissing = false;
      frequency = "5m";
    };

    sshguard.enable = true;

    caddy = {
      enable = true;
      extraConfig = ''
        plex.sindrebakken.dev {
          reverse_proxy 192.168.1.20:32400

          header {
            Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
            X-Content-Type-Options "nosniff"
            X-Frame-Options "DENY"
            Referrer-Policy "no-referrer"
            Content-Security-Policy "default-src 'self' https://assets.plex.tv https://plex.tv https://plex.direct; \
              script-src 'self' 'unsafe-inline' 'unsafe-eval'; \
              style-src 'self' 'unsafe-inline'; \
              img-src 'self' data: blob: https://assets.plex.tv https://plex.tv; \
              connect-src 'self' wss://plex.direct https://plex.tv; \
              frame-src 'self'; \
              font-src 'self' data:;"
          }
        }
      '';
    };

    samba = {
      enable = true;
      openFirewall = true;  # <--- Add this if it's missing
      settings.global = {
        workgroup = "WORKGROUP";
        security = "user";
        "guest ok" = "yes";
        "map to guest" = "Bad User";
        interfaces = [ "lo" "eth0" "wg0" ];
        "hosts allow" = "127.0.0.1 192.168.0.0/16 10.100.0.0/16";
        "hosts deny" = "0.0.0.0/0";
      };

      settings.media = {
        path = "/mnt/shared/media";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "sambauser, sindreb";
        "create mask" = "0666";
        "directory mask" = "0777";
      };
    };

    avahi = {
      enable = true;
      publish = {
        enable = true;
        workstation = true;
        userServices = true;
        addresses = ["192.168.1.10"];
      };
      extraConfig = ''
        [server]
        allow-interfaces=eth0
      '';
      openFirewall = true;
      nssmdns4 = true;
    };
  };

  virtualisation.docker.enable = true;

  systemd.services = {
    "wg-quick-wg0".wantedBy = [ "multi-user.target" ];

    "plex-docker-compose" = {
      description = "Plex Media Server Docker Compose";
      after = [ "docker.service" "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = "/etc/plex";
        ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
        ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
        TimeoutStartSec = "0";
      };
      wantedBy = [ "multi-user.target" ];
    };

    "qbittorrent-docker-compose" = {
      description = "QbitTorrent Docker Compose";
      after = [ "docker.service" "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = "/etc/qbittorrent";
        ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
        ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
        TimeoutStartSec = "0";
      };
      wantedBy = [ "multi-user.target" ];
    };

    "acl-setup" = {
      description = "Apply ACLs to /mnt/shared/media for sambashare";
      after = [ "local-fs.target" "systemd-tmpfiles-setup.service" ];
      wants = [ "local-fs.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = let script = pkgs.writeShellScript "acl-setup" ''
          ${pkgs.acl}/bin/setfacl -m u:1000:rwx /mnt/shared/media
          ${pkgs.acl}/bin/setfacl -m g:sambashare:rwx /mnt/shared/media
          ${pkgs.acl}/bin/setfacl -d -m u:1000:rwx /mnt/shared/media
          ${pkgs.acl}/bin/setfacl -d -m g:sambashare:rwx /mnt/shared/media
        ''; in "${script}";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /mnt/shared/plex/config 0755 1000 1000 - -"
    "d /mnt/shared/plex/transcode 0755 1000 1000 - -"
    "d /mnt/shared/qbittorrent/appdata 0755 1000 1000 - -"
    "d /mnt/shared/media 2775 1000 1000 - -"
  ];

  system.stateVersion = "25.05";
}
