{ lib, config, pkgs, inputs, ... }: {
  imports = [];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = [ pkgs.xclip pkgs.gnumake pkgs.gcc pkgs.cargo ];
  };

  xdg.configFile.nvim = {
    source = let astronvim = pkgs.fetchFromGitHub {
        owner = "AstroNvim";
        repo = "AstroNvim";
        rev = "v3.36.6";
        sha256 = "sha256-XbvqX7xEdgfS8/fNvkwB4x7SW4S/Myh3MJS8TH70Xs0=";
    };
    in astronvim;
    # recursive = true;
  };
  # xdg.configFile."nvim/lua/user" = {
  #   source = ./user;
  #   # recursive = true;
  # };

}
