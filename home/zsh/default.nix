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
    syntaxHighlighting.enable = true;
    prezto = {
      enable = true;
      caseSensitive = false;
      editor.keymap = null;
      prompt.theme = "powerlevel10k";
    };
    initExtra = "source ${./p10k.zsh}";
  };

  programs.kitty.font = {
    package = pkgs.meslo-lgs-nf;
    name = "MesloLGS NF";
    size = 12;
  };
}
