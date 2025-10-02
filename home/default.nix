# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./polybar
    ./zsh
    ./nvim
    ./picom
    ./ilia
    ./emacs
    ./niri
    ./waybar
  ];

  /*
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };
  */

  home = {
    username = "selene";
    homeDirectory = "/home/selene";
    sessionVariables = {
      TERMINAL = "kitty";
    };
  };

  # Add stuff for your user as you see fit:
  home.packages = let
    tex = (pkgs.texlive.combine {
      inherit (pkgs.texlive) 
      scheme-medium
      algorithm2e
      exam
      preprint
      xcolor
      ifoddpage
      relsize
      enumitem
      gb4e
      tikz-qtree
      semantic
      phonrule
      ntheorem;
    });
  in
  with pkgs; [
    firefox
    tldr
    discord
    spotify
    baobab
    texmaker
    tex
    slack
    godot_4
    elan
    audacity
    python3
    flameshot
    # aseprite
    rocq-core
    rocqPackages.stdlib
    go
    ats2
    praat
    file
    smlnj
    # inputs.nix-xilinx.packages.x86_64-linux.vivado
    zoom-us
    htop
    hyfetch
  ];

  # Rocq path for stdlib
  home.sessionVariables.ROCQPATH = "/etc/profiles/per-user/selene/lib/coq/9.0/user-contrib/";

  programs.kitty = {
    enable = true;
    themeFile = "Dracula";
  };

  # services.flameshot = {
  #   enable = true;
  #   settings = {
  #     General.showHelp = false;
  #   };
  # };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };
    iconTheme = {
      package = pkgs.dracula-icon-theme;
      name = "Dracula";
    };
  };

  # basic configuration of git
  programs.git = {
    enable = true;
    userName = "Selene";
    userEmail = "sebastianxwu@gmail.com";
  };

  services.blueman-applet.enable = true;

  xdg.desktopEntries = {
    firefox-school = {
      name = "Firefox (School)";
      exec = "${pkgs.firefox}/bin/firefox -P school --name firefox %U";
      icon = "firefox";
      startupNotify = true;
      terminal = false;
      genericName = "Web Browser";
      categories = [ "Network" "WebBrowser" ];
    };
  };

  home.file.".gdbinit".text = ''
    set disassembly-flavor intel
  '';

  home.file.".xprofile".text = ''
    . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["firefox.desktop"];
    };
  };

  # Temporary fix for the non-existence of tray.target
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      # Requires = [ "graphical-session-pre.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
