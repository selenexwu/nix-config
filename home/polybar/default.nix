{ lib, config, pkgs, inputs, ... }: {
  imports = [];

  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    extraConfig = builtins.readFile ./config;
    script = builtins.readFile ./launch.sh;
  };
  
  home.packages = with pkgs; [
    fantasque-sans-mono
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
    noto-fonts-cjk-sans
  ];

  systemd.user.services.polybar = {
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
