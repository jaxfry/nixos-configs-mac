{
  # Enable system-level zsh (needed to hook into nix-daemon)
  programs.zsh.enable = true;

  # Determinate manages the Nix installation/daemon on this machine.
  nix.enable = false;
}
