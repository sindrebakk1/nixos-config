{config, ...}: {
  config = {
    users = {
      mutableUsers = false;
      users = {
        sindreb = {
          isNormalUser = true;
	  home = "/home/sindreb";
          description = "Sindre B";
          extraGroups = [ "networkmanager" "wheel" "systemd-journal" ];
          hashedPasswordFile = config.sops.secrets."users/sindreb".path;
        };
	root.hashedPasswordFile = config.sops.secrets."users/root".path;
      };
    };
  };
}
