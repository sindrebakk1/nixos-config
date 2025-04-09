{
  config,
  lib,
  pkgs,
  ...
}: {
  options.settings.graphical.applications.obsidian.enable = lib.mkEnableOption "obsidian";

  config = lib.mkIf config.settings.graphical.applications.obsidian.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
