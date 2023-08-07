{ lib, config, pkgs, inputs, ... }: {
  imports = [];

  home.packages = with pkgs; [
    neovim
  ];

  home.shellAliases = {
    vim = "nvim";
  };
}
