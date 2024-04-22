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
    dotDir = ".config/zsh";

    initExtraFirst = ''
      if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
        source ${./p10k.zsh}
      else
        bash -i
       fi
    '';

    enableCompletion = true;
    completionInit = ''
      autoload -U colors && colors
      autoload -U compinit
      zstyle ':completion:*' menu select colors
      zstyle ':completion:*:default' list-colors $LS_COLORS
      zmodload zsh/complist
      compinit
      _comp_options+=(globdots)		# Include hidden files.
    '';
    historySubstringSearch.enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # oh-my-zsh.enable = true;

    history = {
      save = 10000;
      size = 10000;
      expireDuplicatesFirst = true;
      path = "${config.xdg.dataHome}/zsh_history";
      ignoreSpace = true;
    };
    shellAliases = {
      l = "eza -lh --icons";
      ls = "eza -h --git --icons --color=auto --group-directories-first -s extension";
      vim = "nvim";
      nixswitch = "sudo nixos-rebuild switch --flake ~/.nixdots#bradley";
    };
    initExtra = ''
      source $HOME/Dev/bin/zshrc.zsh
      source ${./keybinds.zsh}
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
