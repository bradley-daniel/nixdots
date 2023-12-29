{...}: {
  home.file.".config/alacritty/catppuccin.yml".source = ./themes/catppuccin.yml;
  programs.alacritty = {
    enable = true;
    settings = {
      import = ["~/.config/alacritty/catppuccin.yml"];
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };

        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };

        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };

        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
        size = 12;
      };
      window = {
        padding = {
          x = 10;
          y = 0;
        };
        dynamic_padding = true;
      };
      cursor = {
        style = {
          # shape = "Beam";
          shape = "Block";
          blinking = "Always";
        };
        blink_interval = 450;
      };
    };
  };
}
