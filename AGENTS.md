# Nix-Darwin macOS Config — Agent Guide

## Rebuild
- After editing any `.nix` file: `sudo darwin-rebuild switch --flake .`
- **New files must be `git add`-ed first** (flakes require tracked files)
- Shell aliases exist: `update` → rebuild, `upgrade` → `nix flake update && rebuild`, `cleanup` → `nix-collect-garbage -d`

## Where to put things
All changes go in these files:
- **System pkgs** (nix, all users): `environment.systemPackages` in `modules/packages.nix`
- **User pkgs** (nix, jaxon only): `home-manager.users.*.home.packages` in `modules/packages.nix`
- **Homebrew CLI tools**: `homebrew.brews` in `modules/packages.nix`
- **Homebrew GUI apps**: `homebrew.casks` in `modules/packages.nix`
- **Mac App Store apps**: `homebrew.masApps` in `modules/packages.nix` (app ID number)
- **Custom taps**: `homebrew.taps` in `modules/packages.nix`
- **Shell aliases**: `modules/aliases.nix` (plain nix attrset, auto-loaded by zsh.nix)
- **New home-manager program**: create `modules/home/programs/foo.nix`, add import to `home.nix`
- **macOS defaults** (Dock, Finder, keyboard, trackpad): `modules/system-settings.nix`
- **Nix daemon settings**: `modules/nix-core.nix`
- **Theme colors**: `modules/home/theme.nix`
- **Neovim**: `nixvim.nix`
- **Secrets (SSH keys placeholder)**: `secrets/secrets.nix`

## Gotchas
- `onActivation.cleanup = "zap"` — removes **any** Homebrew app not in cask list
- `nix.enable = false` — Determinate Systems manages the nix daemon, not nix-darwin
- Empty dirs at `~/.config/<app>/` block home-manager symlinks — delete them first
- Disabled packages are commented with a reason: `# checkov  # Temporarily disabled due to...`
- Global git pre-commit hook (gitleaks secret scanning) on every commit — set in `home.nix`
- Cursor/VSCode configs go to `~/Library/Application Support/` via `home.file`, not xdg

## Flake structure
- Host: `maple`, User: `jaxon`, Platform: `aarch64-darwin`
- Hostnames are in a list in `flake.nix` — add new ones there for multi-machine
- Inputs: nixpkgs (unstable), nix-darwin (master), home-manager, nixvim, nix-index-database
- Font standard: `JetBrainsMono Nerd Font`, size 14
- Terminal standard: Edo theme, 92% opacity, blur 20-30, block cursor

## Commits
- Style: lowercase, imperative, concise ("add X package", "fix Y", "rm Z")
