{...}: {
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
  ];

}
