{ lib, config, pkgs, inputs, ... }: {
  imports = [

  ];

  home.packages = with pkgs; [

  ];

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "niri.target";
    };
  };
}
