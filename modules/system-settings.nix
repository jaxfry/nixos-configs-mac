{
  # Security settings
  # Enable touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Share one sudo auth across all ttys/sessions so darwin-rebuild's internal
  # sudo calls (launchctl asuser-wrapped defaults writes, home-manager
  # activation, brew bundle) don't re-prompt for Touch ID after the initial
  # `sudo darwin-rebuild`.
  security.sudo.extraConfig = ''
    Defaults timestamp_type=global
    Defaults timestamp_timeout=60
  '';

  # System settings and optimizations
  system = {
    defaults = {
      menuExtraClock = {
        Show24Hour = true; # show 24 hour clock
        ShowAMPM = false;
      };
      # Dock settings
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.2;
        expose-animation-duration = 0.1;
        tilesize = 48;
        launchanim = false;
        show-recents = false;
        show-process-indicators = true;
        orientation = "bottom";
        mru-spaces = false;  # Don't rearrange spaces
      };

      # Finder settings
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = false;
        ShowPathbar = true;
        ShowStatusBar = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";  # List view
        _FXShowPosixPathInTitle = true;
      };

      # Login window settings
      loginwindow = {
        autoLoginUser = null;
        GuestEnabled = false;
        DisableConsoleAccess = true;
        LoginwindowText = "Welcome to macOS";
      };

      # Global macOS settings
      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = true; # enable natural scrolling(default to true)
        "com.apple.sound.beep.feedback" = 0;     # disable beep sound when pressing volume up/down key
        "com.apple.keyboard.fnState" = false;    # Use media keys by default

        # Keyboard settings
        ApplePressAndHoldEnabled = false;        # Enable key repeat
        InitialKeyRepeat = 25;                   # Normal key repeat delay
        KeyRepeat = 5;                           # Normal key repeat rate
        
        # Interface settings
        AppleShowAllExtensions = true;
        AppleShowAllFiles = false;
        
        # Automatic features
        NSAutomaticCapitalizationEnabled = true;
        NSAutomaticDashSubstitutionEnabled = true;
        NSAutomaticPeriodSubstitutionEnabled = true;
        NSAutomaticQuoteSubstitutionEnabled = true;
        NSAutomaticSpellingCorrectionEnabled = true;
        
        # Window animations
        NSWindowResizeTime = 0.001;
        
        # Expand save and print panels by default
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
      };

      # Trackpad settings
      trackpad = {
        Clicking = true;  # Tap to click
        TrackpadThreeFingerDrag = false;
      };

      # Screen saver settings
      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };

      # Screenshot settings
      screencapture = {
        location = "~/Pictures/Screenshots";
        type = "png";
        disable-shadow = true;
      };

      # Custom user preferences
      CustomUserPreferences = {
        # Disable annoying features
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };

        # Free Cmd+Space for Raycast by disabling Spotlight shortcuts.
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            "64" = {
              enabled = false;
            };
            "65" = {
              enabled = false;
            };
          };
        };

        # Set Zen as default web browser for HTTP/HTTPS links.
        "com.apple.LaunchServices/com.apple.launchservices.secure" = {
          LSHandlers = [
            {
              LSHandlerURLScheme = "http";
              LSHandlerRoleAll = "app.zen-browser.zen";
            }
            {
              LSHandlerURLScheme = "https";
              LSHandlerRoleAll = "app.zen-browser.zen";
            }
          ];
        };

        # Require password immediately after sleep or screen saver begins
        "com.apple.screensaver" = {
          askForPassword = 1;
          askForPasswordDelay = 0;
        };
      };
    };

    # Keyboard settings
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;  # Remap Caps Lock to Control
    };

    # Set macOS version
    stateVersion = 6;

  };
}
