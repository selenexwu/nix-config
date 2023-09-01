{ lib, config, pkgs, inputs, ... }: {
  imports = [];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = [ pkgs.xclip ];
  };

}
