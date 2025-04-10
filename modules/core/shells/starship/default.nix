{lib, ...}: {
  config = {
    home-manager.users.sindreb = {
      programs.starship = {
        enable = true;
        enableBashIntegration = true;
        settings = {
          command_timeout = 1000;
          character = {
	    disabled = false;
            success_symbol = "[❯](bold fg:green)";
            error_symbol = "[❯](bold fg:red)";
	  };

          format = lib.concatStrings [
	    "[](orange)"
	    "$os"
	    "$username"
	    "[](bg:yellow fg:orange)"
	    "$directory"
	    "[](fg:yellow bg:cyan)"
	    "$git_branch"
	    "$git_status"
	    "[](fg:cyan bg:blue)"
	    "$c"
	    "$rust"
	    "$golang"
	    "$nodejs"
	    "$php"
	    "$java"
	    "$kotlin"
	    "$haskell"
	    "$python"
	    "[](fg:blue bg:base02)"
	    "$docker_context"
	    "$conda"
	    "[](fg:base02 bg:base01)"
	    "$time"
	    "[ ](fg:base01)"
	    "$line_break$character"
          ];
	 
	  os = {
	    disabled = false;
	    style = "bg:orange fg:bright-white";
	  };

	  os.symbols = {
	    Windows = "󰍲";
	    Ubuntu = "󰕈";
	    SUSE = "";
	    Raspbian = "󰐿";
	    Mint = "󰣭";
	    Macos = "󰀵";
	    Manjaro = "";
	    Linux = "󰌽";
	    Gentoo = "󰣨";
	    Fedora = "󰣛";
	    Alpine = "";
	    Amazon = "";
	    Android = "";
	    Arch = "󰣇";
	    Artix = "󰣇";
	    EndeavourOS = "";
	    CentOS = "";
	    Debian = "󰣚";
	    Redhat = "󱄛";
	    RedHatEnterprise = "󱄛";
	    Pop = "";
	    NixOS = "󱄅";
	  };
	  
	  username = { 
	    show_always = true;
	    style_user = "bg:orange fg:bright-white";
	    style_root = "bg:orange fg:bright-white";
	    format = "[ $user ]($style)";
	  };

	  directory = {
	    style = "fg:bright-white bg:yellow";
	    format = "[ $path ]($style)";
	    truncation_length = 3;
	    truncation_symbol = "…/";
	  };

	  directory.substitutions = {
	    "Documents" = "󰈙 ";
	    "Downloads" = " ";
	    "Music" = "󰝚 ";
	    "Pictures" = " ";
	    "Developer" = "󰲋 ";
	  };

	  git_branch = {
	    symbol = "";
	    style = "bg:cyan";
	    format = "[[ $symbol $branch ](fg:bright-white bg:cyan)]($style)";
	  };

	  git_status = {
	    style = "bg:cyan";
	    format = "[[($all_status$ahead_behind )](fg:bright-white bg:cyan)]($style)";
	  };

	  nodejs = {
	    symbol = "";
	    style = "bg:blue";
	    format = "[[ $symbol( $version) ](fg:bright-white bg:blue)]($style)";
	  };

	  c = {
	    symbol = " ";
	    style = "bg:blue";
	    format = "[[ $symbol( $version) ](fg:bright-white bg:blue)]($style)";
	  };

	  rust = {
	    symbol = "";
	    style = "bg:blue";
	    format = "[[ $symbol( $version) ](fg:bright-white bg:blue)]($style)";
	  };

	  golang = {
	    symbol = "";
	    style = "bg:blue";
	    format = "[[ $symbol( $version) ](fg:bright-white bg:blue)]($style)";
	  };

	  php = {
	    symbol = "";
	    style = "bg:blue";
	    format = "[[ $symbol( $version) ](fg:bright-white bg:blue)]($style)";
	  };

	  java = {
	    symbol = "";
	    style = "bg:blue";
	    format = "[[ $symbol( $version) ](fg:bright-white bg:blue)]($style)";
	  };

	  kotlin = {
	    symbol = "";
	    style = "bg:blue";
	    format = "[[ $symbol( $version) ](fg:bright-white bg:blue)]($style)";
	  };

	  haskell = {
	    symbol = "";
	    style = "bg:blue";
	    format = "[[ $symbol( $version) ](fg:bright-white bg:blue)]($style)";
	  };

	  python = {
	    symbol = "";
	    style = "bg:blue";
	    format = "[[ $symbol( $version) ](fg:bright-white bg:blue)]($style)";
	  };

	  docker_context = {
	    symbol = "";
	    style = "bg:base02";
	    format = "[[ $symbol( $context) ](fg:#83a598 bg:base02)]($style)";
	  };

	  conda = {
	    style = "bg:base02";
	    format = "[[ $symbol( $environment) ](fg:#83a598 bg:base02)]($style)";
	  };

	  time = {
	    disabled = false;
	    time_format = "%R";
	    style = "bg:base01";
	    format = "[[  $time ](fg:bright-white bg:base01)]($style)";
	  };

	  line_break = {
	    disabled = false;
	  };
        };
      };
    };
  };
}
