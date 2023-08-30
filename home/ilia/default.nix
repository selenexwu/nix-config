{ lib, config, pkgs, inputs, ... }: {
  imports = [];

  home.packages = with pkgs; [
    (import ./ilia.nix { inherit pkgs; } )
  ];
}
