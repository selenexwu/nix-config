{ lib, config, pkgs, inputs, ... }: {
  imports = [
    inputs.niri.homeModules.niri
  ];

  home.packages = with pkgs; [
    xwayland-satellite
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    gnome-keyring
    bibata-cursors
    wl-mirror
    wlr-which-key
    jq
    grim
    slurp
    satty
    wl-clipboard-rs
  ];

  systemd.user.services = {
    swaybg = {
      Install = {
        WantedBy = ["niri.target"];
      };
      Unit = {
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        Requisite = "graphical-session.target";
      };
      Service = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i ${./wallpaper.png}";
        Restart = "on-failure";
      };
    };
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || niri msg action do-screen-transition && hyprlock --no-fade-in";
          before_sleep_cmd = "loginctl lock-session";
        };
        listner = [];
      };
    };
  };

  programs = {
    fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "Fantasque Sans Mono:size=11";
        };
      };
    };

    hyprlock = {
      enable = true;
      settings = {
        "$font" = "Monospace";
        general = {
          hide_cursor = false;
        };

        animations = {
          enabled = true;
          bezier = "linear, 1, 1, 0, 0";
          animation = [
            "fadeIn, 1, 5, linear"
            "fadeOut, 1, 5, linear"
            "inputFieldDots, 1, 2, linear"
          ];
        };

        background = {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
        };

        input-field = {
          monitor = "";
          size = "20%, 5%";
          outline_thickness = 3;
          inner_color = "rgba(0, 0, 0, 0.0)"; # no fill

          outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
          fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";

          font_color = "rgb(143, 143, 143)";
          fade_on_empty = false;
          rounding = 15;

          font_family = "$font";
          placeholder_text = "Input password...";
          fail_text = "$PAMFAIL";

          # uncomment to use a letter instead of a dot to indicate the typed password
          # dots_text_format = "*";
          # dots_size = 0.4;
          dots_spacing = 0.3;

          # uncomment to use an input indicator that does not show the password length (similar to swaylock's input indicator)
          # hide_input = true;

          position = "0, -20";
          halign = "center";
          valign = "center";
        };

        label = [
          {
            monitor = "";
            text = "$TIME"; # ref. https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#variable-substitution
            font_size = 90;
            font_family = "$font";

            position = "-30, 0";
            halign = "right";
            valign = "top";
          }
          {
            monitor = "";
            text = "cmd[update:60000] date +\"%A, %d %B %Y\""; # update every 60 seconds
            font_size = 25;
            font_family = "$font";

            position = "-30, -150";
            halign = "right";
            valign = "top";
          }
        ];
      };
    };

    niri = {
      enable = true;
      settings = {
        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;

        debug = {
          honor-xdg-activation-with-invalid-serial = [];
        };

        cursor = {
          theme = "Bibata-Original-Classic";
          size = 24;
        };

        spawn-at-startup =
          let
            sh = [
              "sh"
              "-c"
            ];
          in
            [
              { command = sh ++ [ "systemctl --user start waybar.service" ]; }
              { command = sh ++ [ "systemctl --user start swaybg.service" ]; }
              # { command = sh ++ [ "sleep 1 && blueman-applet" ]; }
              # { command = [ "nm-applet" ]; }
            ];

        outputs = {
          "eDP-1" = {
            scale = 1.0;
          };
        };

        input = {
          keyboard = {
            xkb = {
              layout = "us";
              options = "compose:ralt";
            };
            numlock = true;
          };

          touchpad = {
            natural-scroll = false;
          };

          focus-follows-mouse = {
            enable = true;
            max-scroll-amount = "95%";
          };

          workspace-auto-back-and-forth = true;
        };

        layout = {
          gaps = 16;

          background-color = "transparent";

          preset-column-widths = [
            { proportion = 1.0 / 3.0; }
            { proportion = 0.5; }
            { proportion = 2.0 / 3.0; }
          ];

          preset-window-heights = [
            { proportion = 1.0 / 3.0; }
            { proportion = 0.5; }
            { proportion = 2.0 / 3.0; }
            { proportion = 1.0; }
          ];

          border.enable = false;

          focus-ring = {
            enable = true;
            width = 4;
            active = {
              color = "#bd93f9";
            };
            inactive = {
              color = "#6272a4";
            };
          };

          shadow = {
            enable = true;
          };

          tab-indicator = {
            enable = true;
            place-within-column = true;
            width = 8;
            corner-radius = 8;
            gap = 8;
            gaps-between-tabs = 8;
            position = "left";
            active = {
              color = "#bd93f9";
            };
            inactive = {
              color = "#6272a4";
            };
            length.total-proportion = 1.0;
          };
        };

        window-rules = [
          {
            geometry-corner-radius =
              let radius = 8.0; in
              {
                bottom-left = radius;
                bottom-right = radius;
                top-left = radius;
                top-right = radius;
              };
            clip-to-geometry = true;
            draw-border-with-background = false;
          }
        ];

        layer-rules = [
          # {
          #   matches = [ { namespace = "^wallpaper$"; } ];
          #   place-within-backdrop = true;
          # }
        ];

        overview = {
          backdrop-color = "#b2e4ff";
        };

        binds =
          let which-key = name: settings:
                config.lib.niri.actions.spawn "wlr-which-key" (
                  builtins.toString ((pkgs.formats.yaml {}).generate "${name}-wlr-which-key.yaml" ({
                    # TODO: theming
                    # namespace = "wlr-which-key";
                  } // settings)));
          in
            with config.lib.niri.actions; {
              "Mod+Shift+Slash".action = show-hotkey-overlay;
              "Mod+Return".action = spawn "kitty";
              "Mod+Space".action = spawn "fuzzel";
              "Mod+Ctrl+L".action = spawn-sh "loginctl lock-session";
              "Mod+O" = { action = toggle-overview; repeat = false; };
              "Mod+Shift+Q" = { action = close-window; repeat = false; };

              # TODO: volume + brightness buttons

              "Mod+Left".action = focus-column-or-monitor-left;
              "Mod+H".action = focus-column-or-monitor-left;
              "Mod+Right".action = focus-column-or-monitor-right;
              "Mod+L".action = focus-column-or-monitor-right;
              "Mod+Up".action = focus-window-or-workspace-up;
              "Mod+K".action = focus-window-or-workspace-up;
              "Mod+Down".action = focus-window-or-workspace-down;
              "Mod+J".action = focus-window-or-workspace-down;
              "Mod+Home".action = focus-column-first;
              "Mod+End".action = focus-column-last;

              "Mod+Shift+Left".action = move-column-left-or-to-monitor-left;
              "Mod+Shift+H".action = move-column-left-or-to-monitor-left;
              "Mod+Shift+Right".action = move-column-right-or-to-monitor-right;
              "Mod+Shift+L".action = move-column-right-or-to-monitor-right;
              "Mod+Shift+Up".action = move-window-up-or-to-workspace-up;
              "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
              "Mod+Shift+Down".action = move-window-down-or-to-workspace-down;
              "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
              "Mod+Shift+Home".action = move-column-to-first;
              "Mod+Shift+End".action = move-column-to-last;

              # TODO: more monitor-related keybinds

              "Mod+Shift+Ctrl+Left".action = move-workspace-to-monitor-left;
              "Mod+Shift+Ctrl+H".action = move-workspace-to-monitor-left;
              "Mod+Shift+Ctrl+Right".action = move-workspace-to-monitor-right;
              "Mod+Shift+Ctrl+L".action = move-workspace-to-monitor-right;
              "Mod+Shift+Ctrl+Up".action = move-workspace-up;
              "Mod+Shift+Ctrl+K".action = move-workspace-up;
              "Mod+Shift+Ctrl+Down".action = move-workspace-down;
              "Mod+Shift+Ctrl+J".action = move-workspace-down;

              "Mod+WheelScrollLeft".action = focus-column-or-monitor-left;
              "Mod+WheelScrollRight".action = focus-column-or-monitor-right;
              "Mod+Shift+WheelScrollLeft".action = move-column-left;
              "Mod+Shift+WheelScrollRight".action = move-column-right;
              "Mod+WheelScrollUp" = { action = focus-workspace-up; cooldown-ms = 150; };
              "Mod+WheelScrollDown" = { action = focus-workspace-down; cooldown-ms = 150; };
              "Mod+Shift+WheelScrollUp" = { action = move-window-to-workspace-up; cooldown-ms = 150; };
              "Mod+Shift+WheelScrollDown" = { action = move-window-to-workspace-down; cooldown-ms = 150; };

              "Mod+1".action = focus-workspace 1;
              "Mod+2".action = focus-workspace 2;
              "Mod+3".action = focus-workspace 3;
              "Mod+4".action = focus-workspace 4;
              "Mod+5".action = focus-workspace 5;
              "Mod+6".action = focus-workspace 6;
              "Mod+7".action = focus-workspace 7;
              "Mod+8".action = focus-workspace 8;
              "Mod+9".action = focus-workspace 9;
              "Mod+0".action = focus-workspace 10;
              "Mod+Shift+1".action.move-window-to-workspace = 1;
              "Mod+Shift+2".action.move-window-to-workspace = 2;
              "Mod+Shift+3".action.move-window-to-workspace = 3;
              "Mod+Shift+4".action.move-window-to-workspace = 4;
              "Mod+Shift+5".action.move-window-to-workspace = 5;
              "Mod+Shift+6".action.move-window-to-workspace = 6;
              "Mod+Shift+7".action.move-window-to-workspace = 7;
              "Mod+Shift+8".action.move-window-to-workspace = 8;
              "Mod+Shift+9".action.move-window-to-workspace = 9;
              "Mod+Shift+0".action.move-window-to-workspace = 10;

              "Mod+Tab".action = focus-workspace-previous;

              "Mod+BracketLeft".action = consume-or-expel-window-left;
              "Mod+BracketRight".action = consume-or-expel-window-right;

              "Mod+R".action = switch-preset-column-width;
              "Mod+Shift+R".action = switch-preset-window-height;
              "Mod+Ctrl+R".action = reset-window-height;
              "Mod+F".action = maximize-column;
              "Mod+Shift+F".action = fullscreen-window;
              "Mod+Ctrl+F".action = expand-column-to-available-width;
              "Mod+C".action = center-column;
              "Mod+Ctrl+C".action = center-visible-columns;
              "Mod+Minus".action = set-column-width "-10%";
              "Mod+Equal".action = set-column-width "+10%";
              "Mod+Shift+Minus".action = set-window-height "-10%";
              "Mod+Shift+Equal".action = set-window-height "+10%";

              "Mod+V".action = toggle-window-floating;
              "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

              "Mod+W".action = toggle-column-tabbed-display;

              "Print".action = spawn-sh "set -e; grim -t ppm -o \"$(niri msg -j focused-output | jq -r '.name')\" - | satty -f - --init-tool=crop --copy-command=wl-copy --output-filename=\"$(xdg-user-dir PICTURES)/Screenshots/Screenshot-%Y-%m-%d-%H:%M:%S.png\" --actions-on-enter=\"save-to-clipboard,exit\" --brush-smooth-history-size=5 --disable-notifications --fullscreen --early-exit";
              # "Ctrl+Print".action = screenshot-screen;
              # "Alt+Print".action = screenshot-window;

              "Mod+Escape" = { action = toggle-keyboard-shortcuts-inhibit; allow-inhibiting = false; };

              "Mod+Shift+E".action = quit;
              "Mod+Shift+P".action = power-off-monitors;

              "Mod+M".action = which-key "mirror" {
                menu = [
                  {
                    key = "m";
                    desc = "mirror";
                    cmd = "wl-present mirror $(niri msg -j focused-output | jq -r '.name')";
                  }
                  {
                    key = "o";
                    desc = "set output";
                    cmd = "wl-present set-output";
                  }
                  {
                    key = "r";
                    desc = "set region";
                    cmd = "wl-present set-region";
                  }
                  {
                    key = "R";
                    desc = "unset region";
                    cmd = "wl-present unset-region";
                  }
                  {
                    key = "s";
                    desc = "set-scaling";
                    cmd = "wl-present set-scaling";
                  }
                  {
                    key = "f";
                    desc = "toggle freeze";
                    cmd = "wl-present toggle-freeze";
                  }
                ];
              };
            };

      };
    };
  };
}
