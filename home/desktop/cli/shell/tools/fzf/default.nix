{
  # config,
  pkgs,
  # lib,
  ...
}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = {
      "bg+" = "#313244";
      bg = "#080A0F";
      spinner = "#f5e0dc";
      hl = "#f38ba8";

      fg = "#cdd6f4";
      header = "#f38ba8";
      info = "#cba6f7";
      pointer = "#f5e0dc";

      marker = "#f5e0dc";
      "fg+" = "#cdd6f4";
      prompt = "#cba6f7";
      "hl+" = "#f38ba8";
    };
  };
}
