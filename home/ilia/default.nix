{ lib, config, pkgs, inputs, ... }: {
  imports = [];

  home.packages = with pkgs; [
    (callPackage ./ilia.nix { } )
  ];
}
