{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    kernelModules = ["v4l2loopback"]; # Autostart kernel modules on boot
    # extraModulePackages = with config.boot.kernelPackages; [v4l2loopback]; # loopback module to make OBS virtual camera work
    kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];

    supportedFilesystems = ["ntfs"];
    loader = {
      systemd-boot.enable = false;
      timeout = 3;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 3;
      };
    };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    deno

    # Add any missing dynamic libraries for unpackaged programs

    # here, NOT in environment.systemPackages
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --remember \
          --time \
          --asterisks \
          --user-menu \
          --cmd Hyprland
      '';
    };
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    # enableIPv6 = false;
    # dhcpcd.wait = "background";
    # dhcpcd.extraConfig = "noarp";
    hostName = "nixos"; # Define your hostname.
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable programs
  programs = {
    zsh.enable = true;
    # steam.enable = true;
    dconf.enable = true;
    thunar.enable = true;
    nano.enable = false;
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Enables docker in rootless mode
  virtualisation = {
    docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
    # Enables virtualization for virt-manager
    libvirtd.enable = true;
  };

  programs.neovim.defaultEditor = true;

  # environment = {
  #     XDG_CACHE_HOME = "\${HOME}/.cache";
  #     XDG_CONFIG_HOME = "\${HOME}/.config";
  #     XDG_BIN_HOME = "\${HOME}/.local/bin";
  #     XDG_DATA_HOME = "\${HOME}/.local/share";
  #     QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  #     QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  #     __GL_GSYNC_ALLOWED = "1";
  #     __GL_VRR_ALLOWED = "0"; # Controls if Adaptive Sync should be used. Recommended to set as “0” to avoid having problems on some games.
  #   };
  #
  #   sessionVariables = {
  #     NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
  #
  #     XDG_CURRENT_DESKTOP = "Hyprland";
  #     XDG_SESSION_TYPE = "wayland";
  #     XDG_SESSION_DESKTOP = "Hyprland";
  #     GDK_BACKEND = "wayland";
  #     CLUTTER_BACKEND = "wayland";
  #     MOZ_ENABLE_WAYLAND = 1;
  #   };
  # };
  # configuration.nix

  # Making sure to use the proprietary drivers until the issue above is fixed upstream

  services = {
    blueman.enable = true;
    logmein-hamachi.enable = false;
    flatpak.enable = false;
  };

  hardware = {
    # nvidia = {
    #   open = false;
    #   nvidiaSettings = true;
    #   powerManagement.enable = true;
    #   modesetting.enable = true;
    #   package = config.boot.kernelPackages.nvidiaPackages.stable;
    # };
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # jack.enable = true;
  };

  # services.

  users = {
    users = {
      bradley = {
        isNormalUser = true;
        description = "bradley";
        shell = pkgs.zsh;
        extraGroups = ["networkmanager" "wheel" "input" "docker" "libvirtd"];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    git
    wget
    playerctl

    steam-run

    inputs.xdg-portal-hyprland.packages.${system}.xdg-desktop-portal-hyprland

    # TODO: REMOVE
    neofetch
    swww
    dunst
    neovim
    nil
    gcc
    alejandra
    eza
    wl-clipboard
    ripgrep
    gh
    htop
    btop
    rustup
    fzf
    gimp

    polkit_gnome

    libreoffice

    lua-language-server
    stylua

    discord
    spotify
    wlr-randr
    pamixer

    google-chrome
    firefox

    waybar

    xwaylandvideobridge
  ];

  # Nvidia
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;
    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enables flakes + garbage collector
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      auto-optimise-store = true;
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1";
    GBM_BACKEND = "nvidia-drm";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    DISABLE_QT5_COMPAT = "0";
    ANKI_WAYLAND = "1";
    DIRENV_LOG_FORMAT = "";
    WLR_DRM_NO_ATOMIC = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    MOZ_ENABLE_WAYLAND = "1";
    WLR_BACKEND = "vulkan";
    WLR_NO_HARDWARE_CURSORS = "1";
    XDG_SESSION_TYPE = "wayland";
    CLUTTER_BACKEND = "wayland";
    WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
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
  # networking = {
  #   firewall = {
  #   Or disable the firewall altogether.
  #     enable = false;
  #     allowedTCPPorts = [ ... ];
  #     allowedUDPPorts = [ ... ];
  #   };
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
