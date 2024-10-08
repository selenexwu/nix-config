{ lib, config, pkgs, inputs, ... }: {
  imports = [];

  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    #config = ./config.ini;
    script = builtins.readFile ./launch.sh;
    settings = 
      let colors = {
            # TODO: Replace with nix-colors
            background = "#222";
            background-alt = "#444";
            foreground = "#dfdfdf";
            foreground-alt = "#555";
            alert = "#bd2c40";
            yellow = "#ffb52a";
            blue = "#0a6cf5";
            red = "#e15551";
            green = "#06b153";
          }; in {
            "global/wm" = {
              margin.bottom = 0;
              margin.top = 0;
            };

            "bar/main" = {
              monitor = "eDP-1";
              bottom = true;
              fixed-center = true;
              width = "100%";
              height = 27;
              offset.x = 0;
              offset.y = 0;
              background = colors.background;
              foreground = colors.foreground;
              line.size = 3;
              line.color = "#f00";
              border.size = 4;
              border.color = "#00000000";
              padding.left = 0;
              padding.right = 2;
              module-margin.left = 1;
              module-margin.right = 2;
              font = [
                "Fantasque Sans Mono:pixelsize=12;1"
                "Iosevka Nerd Font:pixelsize=14;2"
                "Noto Sans CJK JP:pixelsize=12;1"
              ];
              modules = {
                left = "i3";
                center = "spotify-play-pause spotify-previous spotify-song spotify-next";
                right = "dunst backlight battery pulseaudio date";
              };
              tray = {
                position = "right";
                padding = 2;
                offset.x = 0;
                offset.y = 0;
              };
              enable-ipc = true;
            };

            "module/i3" = {
              type = "internal/i3";
              label = rec {
                mode = {
                  foreground = "#000";
                  background = colors.yellow;
                  padding = 2;
                };

                unfocused = {
                  text = "%index%";
                  padding = 2;
                };

                focused = {
                  text = unfocused.text;
                  background = colors.background-alt;
                  underline = colors.yellow;
                  padding = unfocused.padding;
                };

                visible = focused;

                urgent = {
                  text = unfocused.text;
                  background = colors.alert;
                  padding = unfocused.padding;
                };
              };
            };

            "module/date" = {
              type = "internal/date";
              interval = 5;
              date = "%m/%d/%Y";
              time = "%l:%M %p";
              label = "%date% %time%";
              format.prefix.foreground = colors.foreground-alt;
              format.underline = colors.blue;
            };

            "module/pulseaudio" = {
              type = "internal/pulseaudio";
              use-ui-max = false;
              interval = 5;
              format = rec {
                volume = {
                  text = "<ramp-volume> <bar-volume>";
                  underline = colors.yellow;
                };
                muted = {
                  underline = volume.underline;
                };
              };
              label.muted = {
                text = "󰝟  muted";
                foreground = colors.foreground-alt;
              };
              ramp.volume = ["󰕿 " "󰖀 " "󰕾 "];
              bar.volume = {
                width = 11;
                foreground = [
                  "#55aa55"
                  "#55aa55"
                  "#55aa55"
                  "#55aa55"
                  "#55aa55"
                  "#f5a70a"
                  "#ff5555"
                ];
                gradient = false;
                indicator = "|";
                fill = "-";
                empty.text = "-";
                empty.foreground = colors.foreground-alt;
              };
            };

            "module/battery" = {
              type = "internal/battery";
              battery = "BAT1";
              adapter = "ACAD";
              format = rec {
                charging = {
                  text = "<animation-charging> <label-charging>";
                  underline = colors.yellow;
                };
                discharging = {
                  text = "<ramp-capacity> <label-discharging>";
                  underline = charging.underline;
                };
                full = {
                  prefix.text = "  ";
                  prefix.foreground = colors.foreground-alt;
                  underline = colors.green;
                };
              };
              ramp.capacity = {
                text = [" " " " " " " " " " " " " " " " " " " "];
                foreground = colors.foreground-alt;
              };
              animation.charging = {
                text = [" " " " " " " "];
                foreground = colors.foreground-alt;
                framerate = 750;
              };
            };

            "module/backlight" = {
              type = "internal/backlight";
              card = "intel_backlight";
              enable-scroll = true;
              format = {
                text = "<ramp> <label>";
                underline = colors.yellow;
              };
              ramp = {
                text = ["󰖨 "];
                foreground = colors.foreground-alt;
              };
              label = "%percentage%%";
            };

            "module/spotify-song" = {
              type = "custom/script";
              interval = 1;
              exec = "playerctl -p spotify metadata --format \"{{ artist }}: {{ title }}\"";
              exec-if = "playerctl --player=spotify status";
              click-left = "i3-msg '[class=\"Spotify\"] focus'";
            };

            "module/spotify-play-pause" = {
              type = "custom/script";
              interval = 1;
              exec = "if [ $(playerctl -p spotify status) = \"Playing\" ]; then echo \"󰏤 \"; else echo \"󰐊 \"; fi";
              exec-if = "playerctl --player=spotify status";
              click-left = "playerctl --player=spotify play-pause";
            };

            "module/spotify-previous" = {
              type = "custom/script";
              exec = "echo 󰒮 ";
              exec-if = "playerctl --player=spotify status";
              click-left = "playerctl --player=spotify previous";
            };

            "module/spotify-next" = {
              type = "custom/script";
              exec = "echo 󰒭 ";
              exec-if = "playerctl --player=spotify status";
              click-left = "playerctl --player=spotify next";
            };

            "module/dunst" = {
              type = "custom/ipc";
              initial = 1;
              format = {
                foreground = colors.foreground-alt;
                underline = colors.yellow;
              };
              hook = [
                "echo \"%{A1:dunstctl set-paused true && polybar-msg hook dunst 2:} %{A}\" &"
                "echo \"%{A1:dunstctl set-paused false && polybar-msg hook dunst 1:} %{A}\" &"
              ];
            };
          };
  };
  
  home.packages = with pkgs; [
    fantasque-sans-mono
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
    noto-fonts-cjk-sans
    playerctl
  ];
  
  /*
  systemd.user.services.polybar = {
    Install.WantedBy = [ "graphical-session.target" ];
  };
  */
}
