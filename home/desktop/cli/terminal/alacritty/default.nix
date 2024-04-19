{...}: {
  home.file.".config/alacritty/catppuccin.toml".source = ./themes/catppuccin.toml;
  programs.alacritty = {
    enable = true;
    settings = {
      import = ["~/.config/alacritty/catppuccin.toml"];
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
      env = {
        TERM = "xterm-256color";
      };
      window = {
        padding = {
          x = 10;
          y = 0;
        };
        dynamic_padding = true;
      };
      keyboard = {
        bindings = [
          {
            key = "w";
            mods = "control";
            chars = "tmuxsess \r";
          }
        ];
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
