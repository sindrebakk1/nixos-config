{ pkgs, inputs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.default ];
  
  home-manager.users.sindreb = {
    home.packages = with pkgs; [
      lazygit
      ghostty
    ];
    
    programs.git = {
      userName = "sindrebakk1";
      userEmail = "sindre.bakken.naesset@gmail.com";
    };
    
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
    };

    programs.waybar.enable = true;
    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.settings = {
      "$terminal" = "ghostty";
      "$fileBrowser" = "nemo";
      "$mod" = "SUPER";
      exec-once = [
	"$terminal"
	"waybar & hyprpaper &"
      ];
      bind = [
        "$mod, F, exec, firefox"
	"$mod, E, exec, $fileBrowser"
	"$mod, T, exec, $terminal"
      ] ++ (
        builtins.concatLists (builtins.genList (i:
	  let ws = i + 1;
	  in [
	    "$mod, code:1${toString i}, workspace, ${toString ws}"
	    "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
	  ]
	)
	9)
      );
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.nnn.enable = true;
    
    home.stateVersion = "24.11";
  };
}
