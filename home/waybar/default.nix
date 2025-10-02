{ lib, config, pkgs, inputs, ... }: {
  imports = [

  ];

  home.packages = with pkgs; [
    fantasque-sans-mono
    nerd-fonts.iosevka
    noto-fonts-cjk-sans
    playerctl
    pulseaudio
  ];

  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 30;
        spacing = 4;
        modules-left = ["niri/workspaces"];
        modules-center = [];
        modules-right = ["backlight" "battery" "pulseaudio" "clock" "tray"];
        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };
        "battery" = {
          format = "{icon}  {capacity}%";
          states = {
            full = 100;
            good = 85;
            half = 60;
            warning = 30;
            critical = 15;
          };
          format-icons = {
            full = "";
            good = "";
            half = "";
            warning = "";
            critical = "";
          };
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 muted";
          format-icons = {
            default = ["󰕿" "󰖀" "󰕾"];
          };
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-click-right = "pavucontrol";
        };
        "clock" = {
          format = "{:%I:%M %p %D}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            on-scroll = 1;
          };
        };
        "tray" = {
          icon-size = 16;
          spacing = 8;
        };
      };
    };
  };
}
