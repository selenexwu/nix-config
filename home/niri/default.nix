{ lib, config, pkgs, inputs, ... }: {
  imports = [
    inputs.niri.homeModules.niri
  ];

  home.packages = with pkgs; [
    xwayland-satellite
    fuzzel
  ];

  programs = {
    niri = {
      enable = true;
      settings = {
        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;

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
          gaps = 8;
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

        binds = with config.lib.niri.actions; {
          "Mod+Shift+Slash".action = show-hotkey-overlay;
          "Mod+Return".action = spawn "kitty";
          "Mod+Space".action = spawn "fuzzel";
          "Mod+O" = { action = toggle-overview; repeat = false; };
          "Mod+Shift+Q" = { action = close-window; repeat = false; };

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

          # TODO: replace with flameshot
          "Print".action = screenshot;
          # "Ctrl+Print".action = screenshot-screen;
          "Alt+Print".action = screenshot-window;

          "Mod+Escape" = { action = toggle-keyboard-shortcuts-inhibit; allow-inhibiting = false; };

          "Mod+Shift+E".action = quit;
          "Mod+Shift+P".action = power-off-monitors;
        };

      };
    };
  };
}
