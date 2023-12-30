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
      github.user = "bradley-daniel";
      core.editor = "nvim";
      pull.rebase = false;
      credential.helper = "${
        pkgs.git.override {withLibsecret = true;}
      }/bin/git-credential-libsecret";
    };
  };
}
