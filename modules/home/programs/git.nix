{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "JaxFry";
        email = "jaxfry999@gmail.com";
      };

      alias = {
        lg     = "log --oneline --graph --decorate --all";
        st     = "status -sb";
        undo   = "reset --soft HEAD~1";
        wip    = "commit -am 'WIP'";
        pushf  = "push --force-with-lease";
        recent = "branch --sort=-committerdate --format='%(refname:short)' | head -10";
      };

      init = {
        defaultBranch = "main";
      };

      pull = {
        rebase = true;
      };

      merge = {
        conflictstyle = "diff3";
      };

      diff = {
        colorMoved = "default";
      };

      push = {
        autoSetupRemote = true;
        default = "current";
      };

      core = {
        editor = "nvim";
        hooksPath = "~/.config/git/hooks";
      };
    };

    ignores = [
      ".DS_Store"
      "._*"
      ".Spotlight-V100"
      ".Trashes"
      ".env"
      ".env.local"
      ".env.*.local"
      "*.pem"
      "*.key"
      ".vscode/"
      ".idea/"
      "*.swp"
      ".direnv/"
      "*.log"
      ".cache/"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };
}
