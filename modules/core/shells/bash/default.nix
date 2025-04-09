_: {
  home-manager.users.sindreb = {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      sessionVariables = {
        DEFAULT_USER = "sindreb";
      };
      shellAliases = {
        config = "cd ~/.nixos";

        # Directory traversal
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "......" = "cd ../../../../..";
        
	#Neovim aliases
	vim = "nvim";
	vi = "nvim";
      };
    };
  };
}
