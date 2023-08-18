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
    enableSyntaxHighlighting = true;
    prezto = {
      enable = true;
      caseSensitive = false;
      editor.keymap = null;
      prompt.theme = "powerlevel10k";
    };
    shellAliases = {
      rm = "echo 'This is not the command you are looking for.'; false";
    };
    initExtra = ''
      # powerlevel10k configs from wizard
      source ${./p10k.zsh}

      # up and down arrows use history
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey "''${terminfo[kcuu1]}" up-line-or-beginning-search
      bindkey "''${terminfo[kcud1]}" down-line-or-beginning-search
    '';
  };

  programs.kitty.font = {
    package = pkgs.meslo-lgs-nf;
    name = "MesloLGS NF";
    size = 12;
  };
}
