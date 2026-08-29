{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.hack
  ];

  environment.systemPackages = (with pkgs; [
    # Communication
    # chatgpt  # nixpkgs package installs outdated "ChatGPT Classic" build; using official cask instead
    # teams

    # Shell, Terminals
    nushell
    kitty

    # Development Tools
    gh

    # Productivity
    lazygit
    fish
    direnv
    bitwarden-cli
    # obsidian  # Broken in nixpkgs (dmg extraction fails on 1.13.4); using cask instead

    # Editors
    neovim
    vim

    # Shell tools
    zsh
    bash-completion

    # Essential CLI tools
    btop
    zellij
    fastfetch
    cmatrix
    git
    curl
    wget
    tree
    ripgrep  # Fast grep alternative
    fzf      # Fuzzy finder
    eza      # Better ls
    tmux
    iproute2mac
    fd
    zoxide
    dust # disk usage tool
    delta
    tealdeer # tldr client in rust
    p7zip
    nmap

    # File management
    ranger

    # languages and runtimes
    uv
    yarn
    bun
    nodejs_22
    jq
    yq
    gnused
    coreutils
    meson
    lua
    nixpkgs-fmt

    # Media
    aria2
    ffmpeg
    git-crypt
    nil
    nixd

    # VPN
  ]);

  home-manager.users.${config.system.primaryUser}.home.packages = with pkgs; [
    (stdenvNoCC.mkDerivation {
      pname = "hayase";
      version = "6.4.79";
      src = fetchurl {
        url = "https://api.hayase.watch/files/mac-hayase-6.4.79-mac.zip";
        sha256 = "sha256-BFeUgvv0mxBQfmVJDW2nYn5WeidFnLOXjAG3+xRcLCc=";
      };
      dontUnpack = true;
      nativeBuildInputs = [ unzip ];
      installPhase = ''
        mkdir -p $out/Applications
        unzip $src -d $out/Applications/
      '';
    })

    # CLI helpers
    nnn

    # Productivity

    # Containerization

    # Infrastructure as Code
    # checkov  # Temporarily disabled due to pyarrow build issue
    # pre-commit  # Temporarily disabled due to Swift build issues with clang 21.1.8
    gitleaks


    # Container tools

    # Cloud CLI tools; gcloud components list
    awscli
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])

    # Database clients
    postgresql
    mariadb

    # VPN clients
    tailscale  # Tailscale CLI
  ];

  homebrew = {
    enable = true;

    brews = [
      "xz"
      "zlib"
      "gnupg"
      "macos-trash"
      "git-lfs"
      "cmake"
      "pngquant"
      "oxipng"
      "act"
      "telnet"
      "mise"
      "just"
      "qemu"
      "grpcurl"
      "maven"
      "openjdk"
      "opencode"
      "ghidra"
      "platformio"
      "spicetify-cli"
    ];

    taps = [
      "supabase/tap"
      # "anomalyco/tap" # Not required while using Homebrew core opencode formula
      # "manaflow-ai/cmux" # Not required while using Homebrew core cmux cask
    ];

    casks = [
      "kicad"
      "ollama-app"
      "visual-studio-code"
      "intellij-idea-ce"
      "autodesk-fusion"
      "raycast"
      "bitwarden"
      "zen"
      "google-chrome"
      "brave-browser"
      "notion"
      "qbittorrent"
      "orbstack"
      "cloudflare-warp"
      "burp-suite"
      "angry-ip-scanner"
      "wireshark-app"
      "iina"
      "handbrake-app"
      "audacity"
      "obs"
      "osu"
      # "davinci-resolve" # Temporarily disabled: cask is unavailable in Homebrew
      # "sdrpp" # Temporarily disabled: cask is unavailable in Homebrew
      # "sdrangel" # Temporarily disabled: cask is unavailable in Homebrew
      "bambu-studio"
      "jdownloader"
      "iloader"
      "prismlauncher"
      "karabiner-elements"
      "tailscale-app"
      "ghostty"
      "zed"
      "motrix"
      "font-maple-mono"
      "font-maple-mono-nf"
      "font-sf-mono"
      "font-sf-pro"
      "sf-symbols"
      # "tabby" # Temporarily disabled: upstream release asset is 404 in Homebrew cask
      "spotify"
      "balenaetcher"
      "cmux"
      "telegram-desktop"
      "obsidian"
      "chatgpt"
      # "codex"  # installed via npm: @openai/codex
      # "openclaw"
      # "dia"
    ];

    masApps = {
      "The Unarchiver" = 425424353;
      "Amphetamine" = 937984704;
      "Betternet VPN" = 1028905953;
      "Xcode" = 497799835;
    };

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

}
