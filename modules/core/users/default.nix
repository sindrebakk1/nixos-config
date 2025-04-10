{config, ...}: {
  config = {
    users = {
      users = {
        sindreb = {
          isNormalUser = true;
	  home = "/home/sindreb";
          description = "Sindre B";
          extraGroups = [ "networkmanager" "wheel" "systemd-journal" ];
        };
      };
    };
  };
}
