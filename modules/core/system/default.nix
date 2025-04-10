{
  config,
  lib,
  pkgs,
  ...
}: {
  options.settings = {
    stateVersion = lib.mkOption {
      example = "24.11";
    };

    dataPrefix = lib.mkOption {
      example = "/data";
    };

    cachePrefix = lib.mkOption {
      example = "/cache";
    };
  };

  config = {
    system = {
      stateVersion = config.settings.stateVersion;
    };
    environment = {
      systemPackages = with pkgs; [
        wget
        curl
        coreutils
        direnv
        dnsutils
        lshw
        moreutils
        usbutils
        nmap
        util-linux
        whois
        unzip
        git
        age
        sops
        ssh-to-age
        fastfetch
        tlrc
        jq
        yq
        fd
        openssl
        tcpdump
        bridge-utils
      ];
    };

    security = {
      # sudo = {
      #   enable = false;
      # };

      doas = {
        enable = true;
        extraRules = [
          {
            users = ["sindreb"];
            noPass = true;
          }
        ];
      };

      polkit = {
        enable = true;
      };
    };

    time = {
      timeZone = lib.mkDefault "Europe/Oslo";
    };

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ALL = "en_US.UTF-8";
        LANGUAGE = "en_US:nb_NO";
        LC_TIME = "en_GB.UTF-8";
      };
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "nb_NO.UTF-8/UTF-8"
      ];
    };
  };
}
