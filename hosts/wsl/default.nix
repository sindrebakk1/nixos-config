{ config, pkgs, lib, ... }: 
{
  networking.hostName = "wsl";

  profile = {
    username = "sindreb";
    userAuth = {
      disablePassword = true;
      sudoWheelNeedsPassword = false;
    };
  };
  
  wsl = {
    enable = true;
    defaultUser = config.profile.username;
    docker-desktop.enable = true;
    useWindowsDriver = true;
  };
  
  environment.systemPackages = with pkgs; [
    curl
    wget
    ripgrep
    fastfetchMinimal
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  systemd.tmpfiles.rules = [
    "d /mnt/d/wsl-home 0755 root root -"
    "d /mnt/d/wsl-home/sindreb 0755 sindreb users -"
  ];

  fileSystems."/home/sindreb" = {
    device = "/mnt/d/wsl-home/sindreb";
    fsType = "none";
    options = [ "bind" "x-systemd.requires=mnt-d.mount" "x-systemd.after=mnt-d.mount" ];
  };

  system.stateVersion = "25.05";
}
