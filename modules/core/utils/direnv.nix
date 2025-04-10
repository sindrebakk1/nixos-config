_: {
  config = {
    home-manager.users.sindreb = {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
