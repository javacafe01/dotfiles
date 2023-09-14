{ config
, pkgs
, inputs
, colorIt ? false
, ...
}:

let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) shellThemeFromScheme;
  theme = config.colorScheme;
in
{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    dotDir = ".config/zsh";

    shellAliases = {
      ls = "eza --color=auto --icons";
      l = "ls -l";
      la = "ls -a";
      lla = "ls -la";
      lt = "ls --tree";
      cat = "bat --color always --plain";
      grep = "grep --color=auto";
      c = "clear";
      v = "nvim";
      xwin = "Xephyr -br -ac -noreset -screen 1960x1600 :1";
      xdisp = "DISPLAY=:1";
      rm = "${pkgs.trash-cli}/bin/trash-put";
    };

    initExtra = with theme.colors;''
        ${if colorIt then "${shellThemeFromScheme {scheme = theme;}}" else ""}
        set -k
        setopt auto_cd
        export PATH="''${HOME}/.local/bin:''${HOME}/go/bin:''${HOME}/.emacs.d/bin:''${HOME}/.npm/bin:''${HOME}/.cargo/bin:''${PATH}"
        setopt NO_NOMATCH   # disable some globbing

        function run() {
          nix run nixpkgs#$@
        }

      precmd() {
        printf '\033]0;%s\007' "$(dirs)"
      }

      command_not_found_handler() {
        printf 'Command not found ->\033[32;05;16m %s\033[0m \n' "$0" >&2
          return 127
      }

      export SUDO_PROMPT=$'Password for ->\033[32;05;16m %u\033[0m  '

        export FZF_DEFAULT_OPTS='
        --color fg:#${base06},bg:#${base00},hl:#${base04},fg+:#${base07},bg+:#${base00},hl+:#${base04},border:#${base03}
      --color pointer:#${base08},info:#${base03},spinner:#${base03},header:#${base03},prompt:#${base0B},marker:#${base0B}
      '

        FZF_TAB_COMMAND=(
            ${pkgs.fzf}/bin/fzf
            --ansi
            --expect='$continuous_trigger' # For continuous completion
            --nth=2,3 --delimiter='\x00'  # Don't search prefix
            --layout=reverse --height="''${FZF_TMUX_HEIGHT:=50%}"
            --tiebreak=begin -m --bind=tab:down,btab:up,change:top,ctrl-space:toggle --cycle
            '--query=$query'   # $query will be expanded to query string at runtime.
            '--header-lines=$#headers' # $#headers will be expanded to lines of headers at runtime
            )
        zstyle ':fzf-tab:*' command $FZF_TAB_COMMAND

        zstyle ':completion:complete:*:options' sort false
        zstyle ':fzf-tab:complete:_zlua:*' query-string input

        zstyle ':fzf-tab:complete:*:*' fzf-preview 'preview.sh $realpath'
    '';

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      save = 50000;
    };

    plugins = [
      {
        name = "zsh-completions";
        src = inputs.zsh-completions;
      }
      {
        name = "fzf-tab";
        src = inputs.fzf-tab;
      }
      {
        name = "zsh-syntax-highlighting";
        src = inputs.zsh-syntax-highlighting;
        file = "zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-nix-shell";
        src = inputs.zsh-nix-shell;
        file = "nix-shell.plugin.zsh";
      }
    ];
  };
}
