{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
    };
    dotDir = ".config/zsh";
    history = {
      save = 10000;
      size = 10000;
      expireDuplicatesFirst = true;
      path = "${config.xdg.dataHome}/zsh_history";
      ignoreSpace = true;
    };
    historySubstringSearch.enable = true;
    shellAliases = {
      l = "eza -lh --icons";
      ls = "eza -h --git --icons --color=auto --group-directories-first -s extension";
      vim = "nvim";
      quarto = "steam-run $HOME/Personal/bin/quarto";
      nano="nvim";
    };
    initExtra = ''
      unset zle_bracketed_paste
      if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
        source ${./p10k.zsh}
      else
        bash -i
       fi
      export EDITOR=nvim
    '';
    plugins = [
      {
        file = "powerlevel10k.zsh-theme";
        name = "powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
      }
    ];

    shellGlobalAliases = {eza = "eza --icons --git";};
  };
}
