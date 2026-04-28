{ config, lib, ... }:

let
  # List of extensions to automatically install (documented for user intent)
  vsCodeExtensions = [
    # Language Support
    "ms-python.python"
    "ms-python.vscode-pylance"
    "golang.go"
    "rust-lang.rust-analyzer"

    # AI Agents
    "anthropic.claude-code"

    # Formatting & Linting
    "esbenp.prettier-vscode"
    "ms-python.black-formatter"
    "ms-python.isort"
    "ms-python.flake8"
    "ms-vscode.makefile-tools"

    # Git
    "eamodio.gitlens"
    "mhutchie.git-graph"
    "github.vscode-github-actions"

    # UI & Themes
    "pkief.material-icon-theme"
    "zhuangtongfa.material-theme"
    "catppuccin.catppuccin-vsc"

    # Productivity
    "usernamehw.errorlens"
    "ms-vscode.hexeditor"

    # Docker & Containers
    "ms-azuretools.vscode-docker"

    # Java
    "vscjava.vscode-gradle"

    # Markdown
    "yzhang.markdown-all-in-one"

    # Terminal
    "formulahendry.auto-rename-tag"
    "christian-kohler.path-intellisense"

    # Nix
    "jnoortheen.nix-ide"

    # Terraform & Kubernetes
    "hashicorp.terraform"
    "4ops.terraform"
  ];
in
{
  # Manage VS Code configuration files
  home.file."Library/Application Support/Code/User/settings.json" = {
    force = true;
    text = ''
    {
      // Window settings
      "window.commandCenter": true,
      "workbench.colorTheme": "Catppuccin Mocha",

      // Editor font settings
      "editor.fontFamily": "'SF Mono', 'JetBrains Mono', 'Fira Code', 'Source Code Pro', Monaco, 'Cascadia Code', Menlo, Consolas, monospace",
      "editor.fontSize": 13,
      "editor.fontLigatures": true,
      "editor.fontWeight": "400",
      "editor.lineHeight": 1.5,
      "editor.letterSpacing": 0,

      // Terminal font settings - Nerd Fonts only
      "terminal.integrated.fontFamily": "'JetBrainsMono Nerd Font', 'FiraCode Nerd Font', 'MesloLGS Nerd Font', 'Hack Nerd Font', 'SF Mono', Monaco, 'Cascadia Code', monospace",
      "terminal.integrated.fontSize": 13,
      "terminal.integrated.fontWeight": "400",
      "terminal.integrated.lineHeight": 1.4,
      "terminal.integrated.fontLigatures": true,

      // Editor settings
      "editor.tabSize": 2,
      "editor.insertSpaces": true,
      "editor.detectIndentation": false,
      "editor.formatOnSave": true,
      "editor.formatOnPaste": true,
      "editor.minimap.enabled": true,
      "editor.bracketPairColorization.enabled": true,
      "editor.guides.bracketPairs": "active",
      "editor.renderWhitespace": "selection",
      "editor.rulers": [],
      "editor.wordWrap": "on",
      "editor.smoothScrolling": true,
      "editor.cursorBlinking": "smooth",
      "editor.cursorSmoothCaretAnimation": "on",
      "workbench.scrollbar.vertical": "hidden",
      "workbench.scrollbar.horizontal": "auto",

      // File settings
      "files.autoSave": "afterDelay",
      "files.autoSaveDelay": 1000,
      "files.trimTrailingWhitespace": true,
      "files.insertFinalNewline": true,
      "files.exclude": {
        "**/.git": true,
        "**/.DS_Store": true,
        "**/node_modules": true,
        "**/.next": true,
        "**/dist": true,
        "**/build": true
      },

      // Git settings
      "git.enableSmartCommit": true,
      "git.confirmSync": false,
      "git.autofetch": true,

      // Explorer settings
      "explorer.confirmDelete": false,
      "explorer.confirmDragAndDrop": false,

      // Workbench settings
      "workbench.editor.enablePreview": false,
      "workbench.startupEditor": "newUntitledFile",

      // Language-specific settings
      "[json]": {
        "editor.defaultFormatter": "vscode.json-language-features",
        "editor.formatOnSave": true
      },
      "[jsonc]": {
        "editor.defaultFormatter": "vscode.json-language-features",
        "editor.formatOnSave": true
      },
      "[javascript]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode",
        "editor.formatOnSave": true
      },
      "[typescript]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode",
        "editor.formatOnSave": true
      },
      "[python]": {
        "editor.defaultFormatter": "ms-python.black-formatter",
        "editor.formatOnSave": true,
        "editor.tabSize": 4
      },
      "[nix]": {
        "editor.tabSize": 2,
        "editor.formatOnSave": false,
        "editor.defaultFormatter": null
      },

      // Nix IDE extension settings
      "nix.enableLanguageServer": true,
      "nix.serverPath": "nil",
      "nix.formatterPath": "nixpkgs-fmt",
      "nix.showNixOSOptions": false,
      "nix.serverSettings": {
        "nil": {
          "formatting": {
            "command": [ "nixpkgs-fmt" ]
          },
          "diagnostics": {
            "ignored": [
              "unused_binding",
              "unused_with",
              "dead_code"
            ]
          }
        }
      },
      "[terraform]": {
        "editor.defaultFormatter": "hashicorp.terraform",
        "editor.formatOnSave": true,
        "editor.tabSize": 2
      },
      "[hcl]": {
        "editor.defaultFormatter": "hashicorp.terraform",
        "editor.formatOnSave": true,
        "editor.tabSize": 2
      },
      "[yaml]": {
        "editor.tabSize": 2,
        "editor.insertSpaces": true
      },
      "[markdown]": {
        "editor.wordWrap": "on",
        "editor.quickSuggestions": {
          "comments": "off",
          "strings": "off",
          "other": "off"
        }
      }
    }
  '';
  };

  home.file."Library/Application Support/Code/User/keybindings.json" = {
    force = true;
    text = ''
    [
      // Add custom VS Code keybindings here
    ]
  '';
  };
}