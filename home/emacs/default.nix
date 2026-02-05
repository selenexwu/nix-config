{ lib, config, pkgs, inputs, ... }: {
  imports = []; 
  
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = epkgs: [ epkgs.vterm ];
  };

  # services.emacs = {
  #   enable = true;
  #   client = {
  #     enable = true;
  #     arguments = [ "-c" "-a emacs" ];
  #   };
  # };

  home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom-config";
      DOOMLOCALDIR = "${config.xdg.configHome}/doom-local";
      DOOMPROFILELOADFILE = "${config.xdg.cacheHome}/profile-load.el";
    };
    # shellAliases = {
    #   "emacs" = "emacsclient -t";
    # };
  };

  xdg = {
    enable = true;
    configFile = {
      "doom-config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Documents/nix-config/home/emacs/doom.d";
      "emacs".source = inputs.doomemacs;
    };
  };

  home.packages = with pkgs; [
    # DOOM Emacs dependencies
    # binutils
    (ripgrep.override { withPCRE2 = true; })
    # gnutls
    fd
    # imagemagick
    # zstd
    # sqlite
    # editorconfig-core-c
    # emacs-all-the-icons-fonts
    poppler
    ghostscript
    gopls
    basedpyright
    tree-sitter-grammars.tree-sitter-typst
    tinymist
    clang-tools # for clangd (c/c++ lsp)
    kubectl # for connecting to kubernetes via TRAMP
  ];
}
