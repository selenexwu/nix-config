{ lib, config, pkgs, inputs, ... }: {
  imports = [];

  services.picom = {
    enable = true;
    backend = "xrender";
    vSync = true;
    shadow = true;
    shadowExclude = [ "class_g *= 'QtNeko'" ];
    fade = true;
    inactiveOpacity = 0.95;
    settings = {
      frame-opacity = 0.7;
      inactive-opacity-override = false;
      focus-exclude = [ "fullscreen" ];
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;
    };
  };
}
