{
    pkgs,
    config,
    home,
    ...
}: {
    home.pointerCursor = {
        name = "Adwaita";
        size = 32;
        x11.enable = true;
        package = pkgs.apple-cursor;
    };
    qt = {
        enable = true;
        platformTheme.name = "gtk";
    };
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
            size = 32; # Affects gtk applications as the name suggests
            package = pkgs.apple-cursor;
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
