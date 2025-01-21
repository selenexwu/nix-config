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
      "doom-config/config.el".source = ./doom.d/config.el;
      "doom-config/init.el" = {
        source = ./doom.d/init.el;
        onChange = "${pkgs.writeShellScript "doom-config-init-change" ''
          export PATH="${config.services.emacs.package}/bin:$PATH"
          export PATH="${config.programs.git.package}/bin:$PATH"
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          export DOOMPROFILELOADFILE="${config.home.sessionVariables.DOOMPROFILELOADFILE}"
          ${config.xdg.configHome}/emacs/bin/doom --force sync
          ${config.xdg.configHome}/emacs/bin/doom env
        ''}";
      };
      "doom-config/packages.el" = {
        source = ./doom.d/packages.el;
        onChange = "${pkgs.writeShellScript "doom-config-packages-change" ''
          export PATH="${config.services.emacs.package}/bin:$PATH"
          export PATH="${config.programs.git.package}/bin:$PATH"
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          export DOOMPROFILELOADFILE="${config.home.sessionVariables.DOOMPROFILELOADFILE}"
          ${config.xdg.configHome}/emacs/bin/doom --force sync -u
          ${config.xdg.configHome}/emacs/bin/doom env
        ''}";
      };
      "emacs" = {
        source = inputs.doomemacs;
        onChange = "${pkgs.writeShellScript "doom-change" ''
          export PATH="${config.services.emacs.package}/bin:$PATH"
          export PATH="${config.programs.git.package}/bin:$PATH"
          export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
          export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
          export DOOMPROFILELOADFILE="${config.home.sessionVariables.DOOMPROFILELOADFILE}"
          if [ ! -d "$DOOMLOCALDIR" ]; then
            ${config.xdg.configHome}/emacs/bin/doom --force install
          else
            ${config.xdg.configHome}/emacs/bin/doom --force clean
            ${config.xdg.configHome}/emacs/bin/doom --force sync -u
          fi
          ${config.xdg.configHome}/emacs/bin/doom env
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
    # sqlite
    # editorconfig-core-c
    # emacs-all-the-icons-fonts
    poppler
    ghostscript
    gopls
    basedpyright
  ];
}
