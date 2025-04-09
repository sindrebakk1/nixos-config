{
  config,
  lib,
  ...
}: {
  options.settings.graphical.hyprpaper = {
    enable = lib.mkEnableOption "hyprpaper";
  };
}
