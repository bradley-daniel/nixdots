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
        dotDir = "${config.xdg.configHome}/zsh";

        enableCompletion = true;
        completionInit = ''
            autoload -U colors && colors
            autoload -U compinit
            zstyle ':completion:*' menu select colors
            zstyle ':completion:*:default' list-colors $LS_COLORS
            zmodload zsh/complist
            compinit
            _comp_options+=(globdots)		# Include hidden files.

            # Make zsh autocomplete with up arrow
            autoload -Uz history-search-end
            zle -N history-beginning-search-backward-end history-search-end
            zle -N history-beginning-search-forward-end history-search-end
            bindkey "$terminfo[kcuu1]" history-beginning-search-backward-end
            bindkey "$terminfo[kcud1]" history-beginning-search-forward-
        '';
        historySubstringSearch.enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
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
            la = "eza -alh --icons";
            vim = "nvim";
            nixswitch = "sudo nixos-rebuild switch --flake ~/.nixdots#bradley";
        };
        initContent = lib.mkBefore ''
            if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
              eval "$(starship init zsh)"
              # source ${./p10k.zsh}
            else
              bash -i
             fi

            source ${./config.zsh}
            source $HOME/Dev/bin/zshrc.zsh
        '';
        shellGlobalAliases = {eza = "eza --icons --git";};
    };
}
