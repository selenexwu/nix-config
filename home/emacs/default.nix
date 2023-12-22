{ lib, config, pkgs, inputs, ... }: {
  imports = []; 
  
  services.emacs = {
    enable = true;
    package = pkgs.emacs;
    client = {
      enable = true;
      arguments = [ "-c" "-a emacs" ];
    };
  };

  home = {
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom-config";
      DOOMLOCALDIR = "${config.xdg.configHome}/doom-local";
    };
  };

  xdg = {
    enable = true;
    configFile = {
      "doom-config/config.el".source = ./doom.d/config.el;
      "doom-config/init.el".source = ./doom.d/init.el;
      "doom-config/packages.el".text = ./doom.d/packages.el;
      "emacs" = {
        source = builtins.fetchGit "https://github.com/hlissner/doom-emacs";
        onChange = "${pkgs.writeShellScript "doom-change" ''
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom -y install
          else
            ${config.xdg.configHome}/emacs/bin/doom -y sync -u
          fi
        ''}";
      };
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
    # nodePackages.javascript-typescript-langserver
    # sqlite
    # editorconfig-core-c
    emacs-all-the-icons-fonts
  ];
}
