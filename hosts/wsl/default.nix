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

  system.stateVersion = "25.05";
}
