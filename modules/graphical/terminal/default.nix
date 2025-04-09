{
  config,
  lib,
  ...
}: {
  options.settings.graphical.terminal.enable = lib.mkEnableOption "terminal";

  config = lib.mkIf config.settings.graphical.terminal.enable {
    home-manager.users.sindreb = {pkgs, ...}: {
      programs.ghostty = {
        enable = true;
	enableBashIntegration = true;
      };
    };
  };
}
