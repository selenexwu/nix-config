{ lib, config, pkgs, inputs, ... }: {
  imports = [];

  services.polybar =
    let package = pkgs.polybarFull; in
    {
    enable = true;
    inherit package;
    # config = ./config.ini;
    # script = builtins.readFile ./launch.sh;
    script = ''
    PRIMARY=$(${pkgs.xorg.xrandr}/bin/xrandr --query | ${pkgs.gnugrep}/bin/grep " primary" | ${pkgs.coreutils-full}/bin/cut -d" " -f1)
    for m in $(${pkgs.xorg.xrandr}/bin/xrandr --query | ${pkgs.gnugrep}/bin/grep " connected" | ${pkgs.coreutils-full}/bin/cut -d" " -f1); do
      if [[ $m == $PRIMARY ]]; then
        BAR="main"
      else
        BAR="secondary"
      fi
      MONITOR=$m polybar $BAR -r 2>&1 | ${pkgs.coreutils-full}/bin/tee /tmp/polybar-$m.log &
    done
    '';
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
          };
          defaultBar = {
            monitor = "\${env:MONITOR:}";
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
            padding.right = 0;
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
              right = "xfce-notify backlight battery pulseaudio date";
            };
            enable-ipc = true;
          };
      in {
        "global/wm" = {
          margin.bottom = 0;
          margin.top = 0;
        };

        "bar/main" = lib.recursiveUpdate defaultBar {modules.right = defaultBar.modules.right + " tray";};
        "bar/secondary" = defaultBar;

        "module/i3" = {
          type = "internal/i3";
          pin-workspaces = true;
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

        "module/tray" = {
          type = "internal/tray";
          tray-padding = "2px";
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
          exec = "${pkgs.playerctl}/bin/playerctl -p spotify metadata --format \"{{ artist }}: {{ title }}\"";
          exec-if = "${pkgs.playerctl}/bin/playerctl --player=spotify status";
          click-left = "${pkgs.i3}/bin/i3-msg '[class=\"Spotify\"] focus'";
        };

        "module/spotify-play-pause" = {
          type = "custom/script";
          interval = 1;
          exec = "if [ $(${pkgs.playerctl}/bin/playerctl -p spotify status) = \"Playing\" ]; then echo \"󰏤 \"; else echo \"󰐊 \"; fi";
          exec-if = "${pkgs.playerctl}/bin/playerctl --player=spotify status";
          click-left = "${pkgs.playerctl}/bin/playerctl --player=spotify play-pause";
        };

        "module/spotify-previous" = {
          type = "custom/script";
          exec = "echo 󰒮 ";
          exec-if = "${pkgs.playerctl}/bin/playerctl --player=spotify status";
          click-left = "${pkgs.playerctl}/bin/playerctl --player=spotify previous";
        };

        "module/spotify-next" = {
          type = "custom/script";
          exec = "echo 󰒭 ";
          exec-if = "${pkgs.playerctl}/bin/playerctl --player=spotify status";
          click-left = "${pkgs.playerctl}/bin/playerctl --player=spotify next";
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

        "module/xfce-notify" = {
          type = "custom/ipc";
          initial = 1;
          format = {
            foreground = colors.foreground-alt;
            underline = colors.yellow;
          };
          hook = [
            "echo \"%{A1:${pkgs.xfce.xfconf}/bin/xfconf-query -c xfce4-notifyd -p /do-not-disturb -s true && ${package}/bin/polybar-msg hook xfce-notify 2:} %{A}\" &"
            "echo \"%{A1:${pkgs.xfce.xfconf}/bin/xfconf-query -c xfce4-notifyd -p /do-not-disturb -s false && ${package}/bin/polybar-msg hook xfce-notify 1:} %{A}\" &"
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
