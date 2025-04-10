_: {
  config = {
    home-manager.users.sindreb = {
      programs.eza = {
        enable = true;
        enableBashIntegration = true;
        icons = "auto";
        git = true;
      };
    };
  };
}
