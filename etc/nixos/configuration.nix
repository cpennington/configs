# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  nixpkgs.config = {
    allowUnfree = true;
    firefox = {
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = true;
    };
  };

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
    git
    python3
    python2Full
    python27Packages.virtualenv
    python27Packages.pip
    python27Packages.paver
    #pkgs.stdenv.lib.overrideDerivation fish (oldAttrs: {
    #  name = "fish-master-cec1dc";
    #  src = pkgs.fetchurl {
    #    url = "https://github.com/fish-shell/fish-shell/archive/cec1dc20956ece1d475641fcf59e0f46a92b8917.tar.gz";
    #    md5 = "ea24070abae4dbb298fb04df2dee695b";
    #  };
    #})
    fish
    inconsolata
    corefonts
    ubuntu_font_family
    vim
    firefox
    chromium
    networkmanagerapplet
    hipchat
    dropbox
    keepassx2
    sublime3
    gitAndTools.tig
    ghc.ghc784
    xchat
    hexchat
    vagrant
    linuxPackages.virtualbox
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

  # Enable nvidia drivers
  services.xserver.videoDrivers = ["nvidia"];

  # Enable hardware acceleration for 32bit colors
  hardware.opengl.driSupport32Bit = true;
  
  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.desktopManager.default = "xfce";

  services.mongodb.enable = true;
  services.mongodb.dbpath = "/mnt/external/mongodb";

  services.mysql = {
    enable = true;
    package = pkgs.mysql55;
    socketFile = "/tmp/mysql.sock";
  };

  services.memcached.enable = true;

  services.syslogd.enable = true;

  services.dbus.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.cpennington = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["wheel" "networkmanager" "mysql"];
  };

  fileSystems = {
    "/home" = { device = "/dev/sda2"; };
    "/mnt/external" = { device = "/dev/sdb1"; };
  };

  swapDevices = [ { device = "/dev/sda3"; } ];

  time.timeZone = "America/New_York";


   fonts = {
     enableFontDir = true;
     enableGhostscriptFonts = true;
     fonts = with pkgs; [
       inconsolata  # monospaced
       corefonts  # Micrsoft free fonts
       ubuntu_font_family  # Ubuntu fonts
     ];
   };
  services.nfs.server.enable = true;

  security.pam.loginLimits = [ { domain = "*"; item = "nofile"; type = "-"; value = "999999"; }];
 
  nix.binaryCaches = [
    "https://cache.nixos.org"
    "https://hydra.nixos.org"
  ];

  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;
  boot.kernel.sysctl."fs.inotify.max_user_instances" = 524288;
  networking.extraHosts = ''
    127.0.0.1 localhost.edx.org
  '';
}
