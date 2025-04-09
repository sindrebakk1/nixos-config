{
  config,
  lib,
  ...
}:
{
  imports = [
    ./applications
    ./desktop
    ./terminal
    ./theme
    ./sound
    ./xdg
  ];

  options.settings.graphical = {
    enable = lib.mkEnableOption "graphical environment";
  };

  config = lib.mkIf config.settings.graphical.enable {
    dc-tec = {
      graphical = {
        hyprland.enable = lib.mkDefault true;
        hyprlock.enable = lib.mkDefault true;
        hyprpaper.enable = lib.mkDefault true;
        waybar.enable = lib.mkDefault true;
        swaync.enable = lib.mkDefault true;
        terminal.enable = lib.mkDefault true;
        xdg.enable = lib.mkDefault true;
        fuzzel.enable = lib.mkDefault true;
        theme.enable = lib.mkDefault true;
        sound.enable = lib.mkDefault true;
        applications = {
          firefox.enable = lib.mkDefault true;
          obsidian.enable = lib.mkDefault true;
        };
      };
    };
  };
}
