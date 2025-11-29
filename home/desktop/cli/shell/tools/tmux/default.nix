{
    config,
    pkgs,
    lib,
    ...
}: {
    programs.tmux = {
        enable = true;
        baseIndex = 1;
        prefix = "C-space";
        mouse = true;
        extraConfig = ''
            set -g default-terminal "tmux-256color"
            set -ag terminal-overrides ",xterm-256color:RGB"

            bind r source-file ~/.config/tmux/tmux.conf

            # Vim style pane selection
            set-window-option -g mode-keys vi

            bind h select-pane -L
            bind j select-pane -D
            bind k select-pane -U
            bind l select-pane -R


            # keybindings
            set -g set-clipboard on
            bind-key -T copy-mode-vi v send-keys -X begin-selection
            bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
            bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

            bind '"' split-window -v -c "#{pane_current_path}"
            bind % split-window -h -c "#{pane_current_path}"
        '';
        plugins = with pkgs; [
            tmuxPlugins.vim-tmux-navigator
            tmuxPlugins.yank
            tmuxPlugins.sensible
            {
                plugin = pkgs.tmuxPlugins.catppuccin.overrideAttrs
                (_: {
                    src = pkgs.fetchFromGitHub {
                        owner = "Bradley-Daniel";
                        repo = "catppuccin-tmux";
                        rev = "b6a9b36f1f2afb40478e8f98ac3af7aefa869e64";
                        sha256 = "sha256-e/2IvlUbKzjEbnK1WqhzEu1PMDPfQ+X/MBEcDX15FnU=";
                    };
                });
            }
        ];
    };
}
