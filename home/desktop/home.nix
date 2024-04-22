{pkgs, ...}: {
  home = {
    username = "bradley";
    homeDirectory = "/home/bradley";
    stateVersion = "23.11";
  };

  programs = {
    home-manager.enable = true;
  };

  imports = [
    ./cli
    ./graphical
    ./system
    ./themes
    # ./dev
  ];

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: true;
    };
  };

  fonts.fontconfig.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/Dev/bin"
    "$HOME/.cargo/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  home.pointerCursor = {
    name = "macOS-BigSur";
    package = pkgs.apple-cursor;
    size = 32;
  };
}
