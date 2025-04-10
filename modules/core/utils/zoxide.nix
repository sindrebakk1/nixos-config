_: {
  config = {
    home-manager.users.sindreb = {
      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
      };
    };
  };
}
