{ config, pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  # Basic user information
  home.username = "tochka";
  home.homeDirectory = "/home/tochka";

  home.stateVersion = "26.05";
 
  home.sessionVariables = {
    HYPRCURSOR_THEME = "Bibata-Modern-Classic";
    HYPRCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  # Keeps your pointer cursor synced automatically
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  }; 

  gtk = {
    enable = true;
    iconTheme = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    };
  };

  wayland.windowManager.hyprland.settings = {
    bind = [
      "SUPER, T, exec, foot"
    ];
  };
 
  xdg.configFile."caelestia/hypr-vars.lua" = {
    text = ''
      return {
        fileExplorer = "dolphin",
      }
    '';
    force = true;
  }; 

  xdg.configFile."caelestia/hypr-user.lua" = {
    force = true;
    text = ''
      hl.monitor({
        output = "HDMI-A-1",
        mode = "2560x1440@144.00",
        position = "1920x0",
        scale = 1
      })

      hl.monitor({
        output = "eDP-2",
        mode = "1920x1200@144.00",
        position = "0x0",
        scale = 1
      })
    '';
  };

  # Keyboard layouts
  xdg.configFile."hypr/hyprland/input.lua" = {
    force = true;
    text = ''
      local vars = require("variables")

      hl.config({
        input = {
          kb_layout          = "us,se,ru",
          kb_options = "grp:alt_shift_toggle",
          numlock_by_default = false,
          repeat_delay       = 250,
          repeat_rate        = 35,
          focus_on_close     = 1,

          touchpad           = {
            natural_scroll       = true,
            disable_while_typing = vars.touchpadDisableTyping,
            scroll_factor        = vars.touchpadScrollFactor,
          },
        },

        binds = {
          scroll_event_delay = 0,
        },

        cursor = {
          hotspot_padding = 1,
        },
      })
    '';
  };

  # User-only packages
  home.packages = [
    inputs.caelestia-cli.packages.${pkgs.stdenv.hostPlatform.system}.with-shell
    pkgs.fuzzel
    pkgs.cliphist
    pkgs.wl-clipboard
    pkgs.grim
    pkgs.slurp
    pkgs.swappy
    pkgs.gpu-screen-recorder
    pkgs.hyprpicker
    pkgs.vscodium
    pkgs.thunar
    pkgs.pavucontrol
    pkgs.todoist  
];

  # Program configurations
  programs.git = {
    enable = true;

    settings.user.name = "Fedor Romanov";
    settings.user.email = "fedor1378romanov@gmail.com";

    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
      format = "ssh";
    };
  };

  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  # ... your other options (home.packages, pointerCursor, etc.) ...

  programs.spicetify = {
    enable = true;

    enabledCustomApps = with spicePkgs.apps; [
      marketplace
    ];

    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      shuffle
    ];

    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };
 
  # Vis config
  # xdg.configFile."vis/visrc.lua".source = ./visrc.lua;
}
