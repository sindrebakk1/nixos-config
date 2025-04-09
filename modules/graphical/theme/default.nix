{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.settings.graphical.theme = {
    enable = lib.mkOption {
      default = true;
    };
  };

  config = lib.mkIf config.settings.graphical.theme.enable {
    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-pale.yaml";

    stylix.image = ./assets/lofoten.png;

    programs.dconf.enable = true;

    home-manager.users.sindreb =
      { pkgs, ... }:
      {
        gtk = {
          enable = true;
          gtk2.extraConfig = "gtk-application-prefer-dark-theme = true;";
          gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
        };

        qt = {
          enable = true;
        };
      };
  };
}
