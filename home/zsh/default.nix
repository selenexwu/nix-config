{ lib, config, pkgs, inputs, ... }: {
  imports = []; 

  home.packages = with pkgs; [
    trashy
  ];

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    prezto = {
      enable = true;
      caseSensitive = false;
      editor.keymap = null;
      prompt.theme = "powerlevel10k";
    };
  };

  programs.kitty.font = {
    package = pkgs.meslo-lgs-nf;
    name = "MesloLGS NF";
    size = 12;
  };
}
