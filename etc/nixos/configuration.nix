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

    chromium = {
        enablePepperFlash = true;
        enablePepperPDF = true;
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

  # LIST : packages installed in system profile. To search by name, run:
  # $ nix-
  # env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    #ghc.ghc784
    chromium
    corefonts
    dropbox
    emacs
    firefox
    fish
    git
    gitAndTools.tig
    hexchat
    inconsolata
    keepassx2
    linuxPackages.virtualbox
    networkmanagerapplet
    python27Packages.paver
    python27Packages.pip
    python27Packages.virtualenv
    python2Full
    python3
    silver-searcher
    sublime3
    ubuntu_font_family
    unzip
    vagrant
    #vim
    xchat
    xmlsec
    zip
  ];

  nixpkgs.config.packageOverrides = pkgs: rec {
    fish = pkgs.stdenv.lib.overrideDerivation pkgs.fish (oldAttrs: {
      name = "fish-master-2.2b1";
      version = "2.2b1";
      
      src = pkgs.fetchurl {
        url = "https://github.com/fish-shell/fish-shell/archive/2.2b1.tar.gz";
        md5 = "dcdb28d5cba7019414bb763b85045dfc";
      };

      buildInputs = [ pkgs.ncurses pkgs.libiconv pkgs.autoreconfHook pkgs.autoconf pkgs.automake pkgs.libtool ]; 
    });
  };

  systemd.services.dd-agent.environment.PYTHONPATH = "${pkgs.pythonPackages.psutil}/lib/python2.7/site-packages";
  systemd.services.dogstatsd.environment.PYTHONPATH = "${pkgs.pythonPackages.psutil}/lib/python2.7/site-packages";

  # List services that you want to enable:

  services = {
    # Enable the OpenSSH daemon.
    # openssh.enable = true;

    # Enable CUPS to print documents.
    # printing.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "";
      xkbVariant = "dvorak";

      # Enable xmonad
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad-contrib
        ];
      };
      windowManager.default = "xmonad";

      # Enable the touchpad
      synaptics = {
        enable = true;
        twoFingerScroll = true;
        palmDetect = true;
      };

      # Enable nvidia drivers
      #videoDrivers = ["nvidia"];


      # Enable the KDE Desktop Environment.
      # displayManager.kdm.enable = true;
      # desktopManager.kde4.enable = true;
      desktopManager = {
        gnome3.enable = true;
        xfce.enable = true;
        xterm.enable = false;
        default = "xfce";
      };

    };

    dd-agent = {
      enable = true;
      api_key = "6552eb5172ef3552f7e00b25ec92730d";
    };
      
    # Enable hardware acceleration for 32bit colors
    #hardware.opengl.driSupport32Bit = true;

    mongodb = {
      enable = true;
      dbpath = "/home/cpennington/mongodb";
    };

    mysql = {
      enable = true;
      package = pkgs.mysql55;
      #socketFile = "/tmp/mysql.sock";
    };

    memcached.enable = true;

    syslogd.enable = true;

    dbus.enable = true;

    openssh.enable = true;
    nfs.server.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.cpennington = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["wheel" "networkmanager" "mysql"];
  };

  fileSystems = {
    "/home" = { device = "/dev/sda2"; };
    #"/mnt/external" = { device = "/dev/sdb1"; };
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
