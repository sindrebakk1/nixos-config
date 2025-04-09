{
  config,
  lib,
  ...
}: {
  options.settings.graphical.waybar = {
    enable = lib.mkEnableOption "Waybar Status Bar";
  };

  config = lib.mkIf config.settings.graphical.waybar.enable {
    home-manager.users.sindreb = {pkgs, ...}: {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = [
          {
            layer = "top";
            position = "top";
            output = [
              "DP-2"
              "HDMI-A-1"
            ];
            modules-left = ["hyprland/workspaces"];
            modules-center = ["hyprland/window"];
            modules-right = ["custom/notifications" "network" "backlight" "battery" "clock" "tray" "custom/lock" "custom/power"];

            "hyprland/workspaces" = {
              disable-scroll = true;
              sort-by-name = false;
              all-outputs = true;
              persistent-workspaces = {
                "Home" = [];
                "2" = [];
                "3" = [];
                "4" = [];
                "5" = [];
                "6" = [];
                "7" = [];
                "8" = [];
                "9" = [];
                "0" = [];
              };
            };

            "tray" = {
              icon-size = 21;
              spacing = 10;
            };

            "clock" = {
              timezone = "Europe/Amsterdam";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              format-alt = "  {:%d/%m/%Y}";
              format = "  {:%H:%M}";
            };

            "network" = {
              format-wifi = "{icon} ({signalStrength}%)  ";
              format-ethernet = "{ifname}: {ipaddr}/{cidr} 󰈀 ";
              format-linked = "{ifname} (No IP) 󰌘 ";
              format-disc = "Disconnected 󰟦 ";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
            };

            "backlight" = {
              device = "intel_backlight";
              format = "{icon}";
              format-icons = ["" "" "" "" "" "" "" "" ""];
            };

            "battery" = {
              states = {
                warning = 30;
                critical = 15;
              };
              format = "{icon}";
              format-charging = "󰂄";
              format-plugged = "󱟢";
              format-alt = "{icon}";
              format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            };

            ## https://github.com/Frost-Phoenix/nixos-config/blob/4d75ca005a820672a43db9db66949bd33f8fbe9c/modules/home/waybar/settings.nix#L116
            "custom/notifications" = {
              tooltip = false;
              format = "{icon} Notifications";
              format-icons = {
                notification = "󱥁 <span foreground='red'><sup></sup></span>";
                none = "󰍥 ";
                dnd-notification = "󱙍 <span foreground='red'><sup></sup></span>";
                dnd-none = "󱙎 ";
                inhibited-notification = "󱥁 <span foreground='red'><sup></sup></span>";
                inhibited-none = "󰍥 ";
                dnd-inhibited-notification = "󱙍 <span foreground='red'><sup></sup></span>";
                dnd-inhibited-none = "󱙎 ";
              };
              return-type = "json";
              exec-if = "which swaync-client";
              exec = "swaync-client -swb";
              on-click = "swaync-client -t -sw";
              on-click-right = "swaync-client -d -sw";
              escape = true;
            };
            ##

            "custom/lock" = {
              tooltip = false;
              on-click = "${pkgs.hyprlock}/bin/hyprlock";
              format = " ";
            };

            "custom/power" = {
              tooltip = false;
              on-click = "${pkgs.wlogout}/bin/wlogout &";
              format = " ";
            };
          }
        ];
      };
    };
  };
}
