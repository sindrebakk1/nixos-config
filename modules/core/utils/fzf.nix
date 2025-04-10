_: {
  config = {
    home-manager.users.sindreb = {
      programs.fzf = {
        enable = true;
        enableBashIntegration = true;
      };
    };
  };
}
