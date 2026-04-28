{ pkgs, ... }:

let
  theme = import ../theme.nix;
  c = theme.colors;
in

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;
    
    # Initialize zoxide dynamically for the 'z' alias to work
    initExtra = ''
      eval "$(zoxide init zsh)"
    '';

    # Zsh plugins
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
      #theme = "robbyrussell";
      plugins = [
        "git"
        "docker"
        "macos"
        "colored-man-pages"
        "ansible"
        "argocd"
        "gcloud"
        "fzf"
        "sudo"
      ];
    };

    # Shell aliases - imported from modules/aliases.nix
    shellAliases = import ../../aliases.nix;

    # Additional zsh configuration
    initContent = ''
      # Add zsh-completions to fpath FIRST, before anything else
      fpath+=${pkgs.zsh-completions}/share/zsh/site-functions

      # Powerlevel10k configuration
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Source Powerlevel10k theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Load managed Powerlevel10k config
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Custom prompt or other configurations
      export EDITOR="nvim"
      export VISUAL="nvim"

      # First run: setup_krew && install_krew_plugins functions
      export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$HOME/.local/bin:$PATH"

      # fzf configuration
      export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

      # Homebrew
      eval "$(/opt/homebrew/bin/brew shellenv)"

      # Crossplane completions
      if command -v crossplane &> /dev/null; then
        # Try both syntaxes in case the command format varies by version
        source <(crossplane completions 2>/dev/null) || \
        source <(crossplane completions zsh 2>/dev/null) || true
      fi

      # Source custom functions from ~/.cheats/functions.sh
      if [[ -f ~/.cheats/functions.sh ]]; then
        source ~/.cheats/functions.sh
      fi

      # Completion styling
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
    '';
  };

  home.file.".p10k.zsh".text = ''
    # Managed by Home Manager in modules/home/programs/zsh.nix
    # Full Powerlevel10k profile tuned for fast DevOps workflows.

    typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
    typeset -g POWERLEVEL9K_MODE='nerdfont-complete'
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
    typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
    typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

    # Keep segments compact and clean.
    typeset -g POWERLEVEL9K_BACKGROUND=clear
    typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
    typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
    typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=' '
    typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=' '
    typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''

    # Two-line prompt with an explicit command line marker.
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
    typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=''
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=''

    # Prompt layout.
    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
      os_icon
      dir
      vcs
      newline
      prompt_char
    )

    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
      status
      command_execution_time
      background_jobs
      direnv
      virtualenv
      pyenv
      goenv
      nodenv
      rust_version
      aws
      gcloud
      context
      time
    )

    # Core look.
    typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='${c.sapphire}'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='${c.green}'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='${c.red}'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='>'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='x'

    # Directory: readable and compact.
    typeset -g POWERLEVEL9K_DIR_FOREGROUND='${c.text}'
    typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='${c.subtext1}'
    typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='${c.blue}'
    typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
    typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2

    # Git status.
    typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='git:'
    typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='${c.green}'
    typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='${c.yellow}'
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='${c.peach}'
    typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND='${c.red}'

    # Command execution and status.
    typeset -g POWERLEVEL9K_STATUS_OK=false
    typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='${c.red}'
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='${c.subtext1}'

    # Time.
    typeset -g POWERLEVEL9K_TIME_FOREGROUND='${c.subtext1}'
    typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
    typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=true

    # Cloud/IaC context shown only when relevant commands are typed.

    typeset -g POWERLEVEL9K_AWS_FOREGROUND='${c.peach}'
    typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND='${c.sapphire}'

    # Make risky contexts visually loud.
      '*prod*' PROD
      '*production*' PROD
      '*staging*' STAGING
      '*' DEFAULT
    )

    # User@host context.
    typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
    typeset -g POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND='${c.subtext1}'
    typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='${c.red}'
  '';
}
