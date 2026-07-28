# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  programs.hyprland.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.settings = {
    max-jobs = 15;
    cores = 7;
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.tailscale.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."tochka" = {
    isNormalUser = true;
    description = "Fedor Romanov";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Nix garbage collection setup
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.settings.auto-optimise-store = true;

  # Home Manager Settings
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Load your separate home.nix file here:
  home-manager.users.tochka = import ./home.nix;

  programs.fish.enable = true;

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";

    WLR_NO_HARDWARE_CURSORS = "0";
    NIXOS_OZONE_WL = "1";
  };

  # Aliases
  environment.shellAliases = {
    # Bash
    ll = "ls -l";

    # Git
    gs = "git status";
    gl = "git log";
    gds = "git diff --staged";
    gia = "git add .; git status";

    # Laravel
    sailupd = "sail down; sail up -d; sail npm run dev";
    laratest = "composer run format; sail pest; vendor/bin/rector; git add .; git status";

    # NixOs
    rebuild = "cd /home/tochka/nix; git add .; git status; sudo nixos-rebuild switch --flake /home/tochka/nix/.#nixos";
    updatere = "cd /home/tochka/nix; git add .; git status; sudo nixos-rebuild switch --flake /home/tochka/nix/.#nixos --recreate-lock-file";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
  # Modesetting is required for most modern desktop environments (e.g., Wayland)
    modesetting.enable = true;

  # Enable power management options (helps prevent issues with suspend/resume)
    powerManagement.enable = false;
    powerManagement.finegrained = false;

  # Enable the NVIDIA settings menu
    nvidiaSettings = true;

    # Select the appropriate driver package
    # Options: stable, beta, production, legacy_390, etc.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Set open-source kernel modules (recommended true for Turing/RTX 20 series or newer)
    open = true; # Set to false if you have GTX 10-series or older cards
  };

  hardware.nvidia.prime = {
    # Enable offload mode (renders apps on dGPU only when requested)
    offload = {
      enable = true;
      enableOffloadCmd = true; # Adds the `nvidia-offload` wrapper command
    };

    # Replace these with your actual PCI Bus IDs found via lspci
    intelBusId = "PCI:0:2:0";  # Use amdgpuBusId if using an AMD CPU
    nvidiaBusId = "PCI:1:0:0";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Modern Nerd Fonts for terminal icons & glyphs
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];

    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" "FiraCode Nerd Font" ];
    };
  };

  services.flatpak.enable = true;

  programs.gpu-screen-recorder.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     # System
     home-manager
     wf-recorder
     kdePackages.dolphin

     # CLI
     vim
     vis
     btop
     fastfetch
     git
     wget
     kitty
     foot
     tree

     # Regular Apps
     telegram-desktop
     vesktop
     spotify
     spicetify-cli
     rnote
 
     freecad

     # Programming
     vscode
     jetbrains.phpstorm
     jetbrains.webstorm

     opencode
     tailscale

     laravel
     php85
     nodejs_26
     python3
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
