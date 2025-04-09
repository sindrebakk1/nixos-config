{
  config,
  lib,
  pkgs,
  ...
}: {
  options.settings.graphical.fuzzel = {
    enable = lib.mkEnableOption "fuzzel";
  };

  config = lib.mkIf config.settings.graphical.fuzzel.enable {
    home-manager.users.sindreb = {
      home.packages = with pkgs; [
        papirus-icon-theme
      ];

      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            terminal = "${pkgs.ghostty}/bin/ghostty";
            layer = "overlay";
            icon-theme = "Papirus-Dark";
            prompt = " ";
          };
          border = {
            radius = "10";
            width = "1";
          };
          dmenu = {
            exit-immediately-if-empty = "yes";
          };
        };
      };
    };
  };
}
