{ lib, config, pkgs, inputs, ... }: {
  imports = [];

  home.packages = with pkgs; [
    neovim
    xclip
  ];

  home.shellAliases = {
    vim = "nvim";
  };
}
