{
  pkgs,
  config,
  ...
}: {
  gtk = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
    };

    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };

    cursorTheme = {
      name = "macOS";
      # package = pkgs.apple-cursor;
      size = 32; # Affects gtk applications as the name suggests
    };

    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
