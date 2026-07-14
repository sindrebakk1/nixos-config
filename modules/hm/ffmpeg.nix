{ pkgs, lib, config, ... }:
let
  u          = config.profile.username;
  cfg        = config.profile.homeManager.ffmpeg;
in
lib.mkIf cfg.enable {
  home-manager.users.${u}.home.packages = with pkgs; [
    ffmpeg-full
  ];
}
