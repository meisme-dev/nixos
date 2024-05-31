# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./vfio.nix
    ];

  # Enable flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  # Enable NTFS
  boot.supportedFilesystems = [ "ntfs" ];


  # Add binary caches to speed up builds
  nix.settings.trusted-substituters = [ "https://nix-community.cachix.org" ];
  nix.settings.trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  nix.settings.substituters = [ "https://nix-community.cachix.org" ];


  # Disable logging
  boot.kernelParams = [
    "quiet"
    "pcie_aspm=off"
  ];
  boot.consoleLogLevel = 0;


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;


  # Enable LUKS
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/4ce2b3fa-2a0a-4176-bb68-b818528ae8b6";
      preLVM = true;
    };
  };


  # Use latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;


  # Enable plymouth
  nixpkgs.overlays = [
    (final: prev: {
      adi1090x-plymouth-themes = prev.adi1090x-plymouth-themes.override { 
        selected_themes = ["hexagon"];
      };
    })
  ];

  boot.plymouth.enable = true;
  boot.plymouth.themePackages = with pkgs; [
      adi1090x-plymouth-themes
  ];
  boot.plymouth.theme = "hexagon";


  # Configure network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;


  # Set timezone
  time.timeZone = "Africa/Cairo";


  # Enable autologin
  services.getty.autologinUser = "meisme";


  # Enable GPU drivers
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];


  # Enable early KMS
  boot.initrd.kernelModules = [
    "nvidia"
    "amdgpu"
  ];


  # Disable internal speakers
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="sound", ATTRS{vendor}=="0x1022", ATTRS{device}=="0x15e3", RUN:="/bin/sh -c 'echo 1 > $sys$devpath/device/remove'"
  '';


  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
      vaapiVdpau
      libvdpau-va-gl
      libva
    ];
  };


  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:01:00:0";
      amdgpuBusId = "PCI:06:00:0";
    };
  };

 
  # Enable Gnome
  services.xserver.desktopManager.gnome.enable = true;


  # Enable CUPS to print documents.
  services.printing.enable = true;


  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };


  # Enable SWAP
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024;
  }];


  # Define a user account. 
  users.users.meisme = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
    shell = pkgs.zsh;
  };


  # Add sudo rule for chvt
  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "${pkgs.kbd}/bin/chvt";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/chvt";
          options = [ "NOPASSWD" ];
        }
      ];
      groups = [ "wheel" ];
    }];
  };


  # Improve performance
  security.pam.loginLimits = [
    { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  ];


  # Use GPG
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = lib.mkForce pkgs.pinentry-gnome3;
    enableSSHSupport = true;
  };

  
  # Enable gnome keyring for org.freedesktop.secrets
  services.gnome.gnome-keyring.enable = true;


  # Enable display manager
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;


  # Enable KDE Connect
  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;


  # Enable launching dynamically linked executables
  programs.nix-ld.enable = true;


  # Enable Sway 
  programs.sway.enable = true;

  # Add system packages
  environment.systemPackages = with pkgs; [
    vim
    virtiofsd
    wget
    git
    virt-manager
    polkit_gnome
    SDL2
    man-pages
    man-pages-posix
  ];


  # Enable additional man man pages
  documentation.dev.enable = true;

 
  # Enable ZSh
  programs.zsh.enable = true;


  # Enable dconf, required for certain programs
  programs.dconf.enable = true;


  # Enable virtualization
  vfio = {
    enable = true;
    vms = [ "win11" "bazzite" ];
    devices = {
      kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
      ids = [ "10de:2560" "10de:228e" ];
      pciIds = [ "0000:01:00.0" "0000:01:00.1" ];
    };
  };


  # Enable Waydroid
  virtualisation.waydroid.enable = true;


  # Enable flatpak
  services.flatpak.enable = true;


  # Enable KDE wallet
  security.pam.services.meisme.enableKwallet = true;


  # Disable random mac address
  networking.networkmanager.wifi.scanRandMacAddress = false;


  # Enable policy kit
  security.polkit.enable = true;


  # Enable DBUS
  services.dbus.enable = true;


  # Enable Bluetooth
  hardware.bluetooth.enable = true; 
  hardware.bluetooth.powerOnBoot = true; 


  # Enable XBOX controller driver
  hardware.xpadneo.enable = true;


  # Allow moonlight ports in firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 47984 47989 47990 48010 ];
    allowedUDPPorts = [ 5353 47998 47999 48000 48002 48010 ];
  };

 
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

