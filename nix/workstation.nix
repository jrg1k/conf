{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hwconf.nix
    ];

  # Enable swap on zram
  zramSwap = {
    enable = true;
    numDevices = 1;
    swapDevices = 1;
    memoryPercent = 100;
    #memoryMax = 8192;
    algorithm = "zstd";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    firewall.enable = true;
    hostName = "laptop";
    interfaces = {
      enp0s25.useDHCP = true;
      wlp3s0.useDHCP = true;
    };
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    useDHCP = false;
    wireless.iwd.enable = true;
  };

  time.timeZone = "Europe/Oslo";

  i18n.defaultLocale = "en_DK.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-extra
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  security.rtkit.enable = true;
  services = {
    chrony = {
      enable = true;
      enableNTS = true;
      servers = [ "sth1.nts.netnod.se" "sth2.nts.netnod.se" "nts.netnod.se" ];
    };
    gnome = {
      core-utilities.enable = false;
      tracker-miners.enable = false;
      tracker.enable = false;

    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
    flatpak.enable = true;
  };

  hardware.pulseaudio.enable = false;

  users.users.jk = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    alacritty
    chezmoi
    gnome.adwaita-icon-theme
    gnome.gnome-tweaks
    gnomeExtensions.appindicator
    lsd
    wl-clipboard
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs = {
    fish.enable = true;
    git.enable = true;
    neovim.enable = true;
  };
  users.defaultUserShell = pkgs.fish;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
