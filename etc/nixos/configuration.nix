# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  #boot.initrd.checkJournalingFS = false;

  # networking.hostName = "nixos"; # Define your hostname.
  networking.hostId = "f26b24f8";
  # networking.wireless.enable = true;  # Enables wireless.
  networking.networkmanager.enable = true;


  # Select internationalisation properties.
  i18n = {
    consoleFont = "inconsolata";
    consoleKeyMap = "dvorak";
    defaultLocale = "en_US.UTF-8";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    (pkgs.lib.overrideDerivation pkgs.git (attrs: { version = "2.2.2"; }))
    python3
    python2
    fish
    inconsolata
    vim
    firefox
    chromium
    networkmanagerapplet
    gnome3.dconf
    gnome3.gnome_icon_theme
    gnome3.gnome_themes_standard
    hipchat
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "";
  services.xserver.xkbVariant = "dvorak";

 # Enable xmonad
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;
  services.xserver.windowManager.default = "xmonad";

  # Enable the touchpad
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;
  

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.desktopManager.default = "xfce";

  services.dbus.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.cpennington = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["wheel" "networkmanager"];
  };

  fileSystems = {
    "/home" = { device = "/dev/sda2"; };
    "/mnt/external" = { device = "/dev/sdb1"; };
  };

  swapDevices = [ { device = "/dev/sda3"; } ];

}
