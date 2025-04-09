_: {
  imports = [./hardware.nix];

  networking = {
    hostName = "think-pad";
  };

  settings = {
    stateVersion = "24.11";
    core = {
      wireless = {
        enable = true;
      };
    };
    graphical = {
      enable = true;
      hyprland = {
        enable = true;
      };
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
