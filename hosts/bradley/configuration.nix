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
        configurationLimit = 10;
      };
    };
  };

  programs.nix-ld.enable = true;
  programs.nm-applet.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    deno
  ];

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
  # services.automatic-timezoned.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable programs
  programs = {
    zsh.enable = true;
    dconf.enable = true;
    thunar.enable = true;
    nano.enable = false;
    steam.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enables docker in rootless mode
  virtualisation = {
    docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
    # Enables virtualization for virt-manager
    libvirtd.enable = true;
  };

  services = {
    blueman.enable = true;
    logmein-hamachi.enable = false;
    flatpak.enable = false;
  };

  environment.pathsToLink = ["/libexec"];
  environment.sessionVariables = {
    # NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = "macOS";
    XCURSOR_SIZE = "24";
    NVD_BACKEND = "direct";
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = true;
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver mesa];
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver mesa];
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Sound
  # sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # jack.enable = true;
  };

  users = {
    users = {
      bradley = {
        isNormalUser = true;
        description = "bradley";
        shell = pkgs.zsh;
        extraGroups = ["networkmanager" "wheel" "input" "docker" "libvirtd"];
        packages = with pkgs; [
          # Gui
          firefox
          google-chrome
          discord
          ldtk

          # Commands-Line
          neovim
          htop
          btop
          neofetch
          steam-run
          starship
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    pamixer
    ripgrep
    gcc
    eza
    gh
    fzf
    unzip
    zip
    git
    wget
    playerctl
    fd
    jq

    # nix
    nil
    alejandra

    # Rust
    rustup

    # Go
    go
    gopls

    # C && C++
    clang
    gnumake
    clang-tools

    # typescript and javascript
    nodejs_22
    prettierd
    nodePackages.typescript-language-server
    nodePackages.prettier
    vscode-langservers-extracted

    # mdformat
    marksman
    cbfmt
    python311Packages.mdformat-tables

    # Lua
    lua5_1
    luajitPackages.luarocks
    lua-language-server
    stylua

    # Neovim
    tree-sitter

    # Python
    python311
    pyright
    ruff
    python311Packages.flake8
  ];

  # Nvidia

  # services.xserver.videoDrivers = ["nvidia"];
  # programs.sway = {
  #   enable = true;
  #   xwayland.enable = true;
  #   wrapperFeatures.gtk = true;
  #   extraPackages = with pkgs; [
  #     wmenu
  #     dunst
  #     wlr-randr
  #     wl-clipboard
  #     autotiling-rs
  #   ];
  # };
  #
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd \"sway --unsupported-gpu --config $HOME/.config/sway/config\"";
  #       user = "bradley";
  #     };
  #   };
  # };

  services.xserver = {
    videoDrivers = ["nvidia"];
    excludePackages = [pkgs.xterm];

    enable = true;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3blocks
        dmenu
        xclip
        xorg.xrandr
        feh
        autotiling
        volumeicon
        alsa-utils

       myxer
      ];
    };

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      lightdm.enable = true;
    };
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
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
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # Enables flakes + garbage collector
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      auto-optimise-store = true;
      # substituters = ["https://hyprland.cachix.org"];
      # trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
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
