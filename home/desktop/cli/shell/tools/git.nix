{
  lib,
  osConfig,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "bradley-daniel";
    userEmail = "danielbradley.2020@gmail.com";
    extraConfig = {
      init = {defaultBranch = "main";};
      github.user = "redyf";
      core.editor = "nvim";
      pull.rebase = false;
    };
  };
}
