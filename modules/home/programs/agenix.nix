{ config, lib, ... }:
let
  homeDir = config.home.homeDirectory;
  envFile = "${homeDir}/.env";
  claudishEnvSecretFile = ../../../secrets/claudish-env.age;
  hasClaudishEnvSecret = builtins.pathExists claudishEnvSecretFile;
  claudishEnvTemplate = ''
    # Claudish / external model configuration
    # Fill in the keys you use, then run `update`.
    OPENROUTER_API_KEY=
    GEMINI_API_KEY=
    OPENAI_API_KEY=
    ANTHROPIC_API_KEY=sk-ant-api03-placeholder

    # Optional custom endpoints
    GEMINI_BASE_URL=
    OPENAI_BASE_URL=
    OLLAMA_BASE_URL=
    LMSTUDIO_BASE_URL=

    # Optional default model
    CLAUDISH_MODEL=openai/gpt-5.3
  '';
in
{
  age.identityPaths = [
    "${homeDir}/.ssh/id_ed25519"
    "${homeDir}/.ssh/id_rsa"
  ];

  age.secrets = lib.mkIf hasClaudishEnvSecret {
    claudish-env = {
      file = claudishEnvSecretFile;
      path = envFile;
      mode = "600";
      symlink = false;
    };
  };

  home.activation.bootstrapClaudishEnv = lib.mkIf (!hasClaudishEnvSecret) (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f "$HOME/.env" ] && [ ! -L "$HOME/.env" ]; then
        cat >"$HOME/.env" <<'EOF'
${claudishEnvTemplate}
EOF
        chmod 600 "$HOME/.env"
      fi
    ''
  );

  home.activation.ensureClaudishEnvPermissions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -f "$HOME/.env" ]; then
      chmod 600 "$HOME/.env"
    fi
  '';

  programs.zsh.initContent = lib.mkAfter ''
    if [ -f "$HOME/.env" ]; then
      set -a
      source "$HOME/.env"
      set +a
    fi
  '';

  programs.bash = {
    enable = true;
    initExtra = ''
      if [ -f "$HOME/.env" ]; then
        set -a
        . "$HOME/.env"
        set +a
      fi
    '';
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if test -f $HOME/.env
        while read -l line
          set line (string trim -- $line)
          if test -z "$line"; or string match -qr '^#' -- $line
            continue
          end

          set line (string replace -r '^export\s+' '' -- $line)
          set -l kv (string split -m1 '=' -- $line)
          if test (count $kv) -eq 2
            set -l key (string trim -- $kv[1])
            set -l value (string trim -- $kv[2])
            set value (string trim --chars "'" -- $value)
            set value (string trim --chars '"' -- $value)
            set -gx $key $value
          end
        end < $HOME/.env
      end
    '';
  };

  programs.nushell = {
    enable = true;
    extraEnv = ''
      let env_file = ($nu.home-path | path join ".env")
      if ($env_file | path exists) {
        for line in (open $env_file | lines) {
          let trimmed = ($line | str trim)
          if ($trimmed == "" or ($trimmed | str starts-with "#")) {
            continue
          }

          let normalized = ($trimmed | str replace --regex '^export\s+' '')
          let parsed = ($normalized | parse "{key}={value}")

          if (($parsed | length) == 1) {
            let key = ($parsed.0.key | str trim)
            let value = (
              $parsed.0.value
              | str trim
              | str trim --char "'"
              | str trim --char '"'
            )
            load-env { ($key): $value }
          }
        }
      }
    '';
  };
}
