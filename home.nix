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
    
    programs.nnn.enable = true;

    programs.waybar.enable = true;
    
    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.package = null;
    wayland.windowManager.hyprland.portalPackage = null;
    wayland.windowManager.hyprland.settings = {
      "$terminal" = "ghostty";
      "$fileBrowser" = "nnn";
      "$mod" = "SUPER";
      exec-once = [
	"waybar & hyprpaper &"
      ];
      bind = [
        "$mod, F, exec, firefox"
	"$mod, E, exec, $terminal, -p, $fileBrowser"
	"$mod, T, exec, $terminal"
	"$mod, G, exec, $terminal, -p, lazygit"
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

    home.stateVersion = "24.11";
  };
}
