# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Disable X11.
  services.xserver.enable = false;

  services.displayManager.ly.enable = true;
   
  # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.gnome.enable = true;

  services.hypridle.enable = true;
  
  programs.hyprland.enable = true;

  programs.hyprlock.enable = true;

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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
  users.users.sindreb = {
    isNormalUser = true;
    description = "Sindre B";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim
     wget
     git
     kitty
     nemo
  ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    cheese
    gnome-music
    gnome-terminal
    epiphany
    geary
    gnome-characters
    totem
    tali
    iagno
    hitori
    atomix
  ]);

  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
      user.name = "sindrebakk1";
      user.email = "sindre.bakken.naesset@gmail.com";
    };
  };
  
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "RobotoMono" "DroidSansMono" ]; })
  ];
  
  # Home manager
  home-manager.users.sindreb = {
    home.packages = with pkgs; [
      lazygit
      ghostty
    ];
    
    programs.git = {
      userName = "sindrebakk1";
      userEmail = "sindre.bakken.naesset@gmail.com";
    };
    
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
    };

    programs.waybar.enable = true;
    
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$terminal" = "ghostty";
  	"$fileBrowser" = "nemo";
	exec-once = [
	  "$terminal"
	  "waybar & hyprpaper &"
	];
      };
    };

    programs.nnn.enable = true;
    
    home.stateVersion = "24.11";
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
  system.stateVersion = "24.11"; # Did you read the comment?
}
