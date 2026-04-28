{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    # Retained for currently used GUI tooling still depending on this Electron build.
    "electron-36.9.5"
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.hack
  ];

  environment.systemPackages = (with pkgs; [
    # Communication
    slack
    zoom-us
    discord
    # teams

    # Shell, Terminals
    nushell
    kitty
    alacritty

    # Browsers
    firefox

    # Development Tools
    gh
    devbox

    # Productivity
    lazygit
    fish
    direnv
    obsidian
    bitwarden-cli

    # Note-taking and documentation
    joplin-desktop

    # Editors
    neovim
    vim

    # Shell tools
    zsh
    zsh-completions
    bash-completion

    # Essential CLI tools
    htop
    btop   # Modern alternative to top
    bottom # Modern alternative to htop
    zellij
    neofetch
    fastfetch
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
    du-dust # dust package in nix
    delta
    tealdeer # tldr client in rust
    p7zip

    # File management
    ranger

    # Screenshot tools
    flameshot

    # languages and runtimes
    uv
    yarn
    nodejs_22
    jq
    yq
    gnused
    coreutils
    meson
    act
    lua
    nixpkgs-fmt

    # Media
    aria2
    yt-dlp
    ffmpeg
    git-crypt
    nil
    nixd

    # Virtualization
    vagrant
    packer

    # VPN
  ]);

  home-manager.users.${config.system.primaryUser}.home.packages = with pkgs; [
    # Custom packaged GUI apps
    (stdenvNoCC.mkDerivation {
      pname = "hayase";
      version = "6.4.60";
      src = fetchurl {
        url = "https://api.hayase.watch/files/mac-hayase-6.4.60-mac.zip";
        sha256 = "65f662764cf74d57ce4f4ec25e9279d0b1a8ec5aad1295085808a803e9e59a70";
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
    zsh-completions

    # Productivity

    # Containerization

    # Infrastructure as Code
    ansible
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
      "node"
      "pngquant"
      "oxipng"
      "act"
      "telnet"
      "mise"
      "just"
      "qemu"
      "grpcurl"
      "yt-dlp"
      "maven"
      "openjdk"
      "anomalyco/tap/opencode"
      "nuclei"
      "platformio"
      "spicetify-cli"
      "kismetwireless/kismet/kismet"
    ];

    taps = [
      "FelixKratz/formulae"
      "mrkai77/cask"
      "keith/formulae"
      "mmazzarolo/formulae"
      "supabase/tap"
      "anomalyco/tap"
      "manaflow-ai/cmux"
      "kismetwireless/kismet"
    ];

    casks = [
      "kicad"
      "ollama"
      "cursor"
      "visual-studio-code"
      "intellij-idea-ce"
      "autodesk-fusion"
      "raycast"
      "bitwarden"
      "zen-browser"
      "google-chrome"
      "brave-browser"
      "iterm2"
      "notion"
      "qbittorrent"
      "orbstack"
      "dockdoor"
      "cloudflare-warp"
      "burp-suite"
      "angry-ip-scanner"
      "metasploit"
      "wireshark-app"
      "iina"
      "handbrake"
      "audacity"
      "obs"
      "davinci-resolve"
      "sdrpp"
      "sdrangel"
      "bambu-studio"
      "jdownloader"
      "iloader"
      "prism-launcher"
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
      "tabby"
      "spotify"
      "keepassxc"
      "balenaetcher"
      "mark-text"
      "manaflow-ai/cmux/cmux"
      "antigravity"
      #"claude-code" # installed via npm: npm install -g @anthropic-ai/claude-code
      # "codex"  # installed via npm: @openai/codex
      # "openclaw"
      # "dia"
    ];

    masApps = {
      "The Unarchiver" = 425424353;
      "Amphetamine" = 937984704;
      "rcmd" = 1596283165;
      "Betternet VPN" = 1028905953;
      "Xcode" = 497799835;
    };

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

}
