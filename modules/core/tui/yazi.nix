_: {
  config = {
    home-manager.users.sindreb = {
      progrmas.yazi = {
        enable = true;
	enableBashIntegration = true;
	settings = {
          manager = {
	    show-hidden = true;
	    sort-by = "modified";
	  };
        };
      };
    };
  };
}
    
