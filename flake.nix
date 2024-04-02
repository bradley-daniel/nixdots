{
  description = "Bradley's NixOs config of desktop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    hyprland = {
      url = "github:hyprwm/hyprland";
    };
    waybar-hyprland.url = "github:hyprwm/hyprland";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      url = "github:bradley-daniel/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    hyprland,
    home-manager,
    utils,
    neovim,
    ...
  } @ inputs: {
    nixosConfigurations = {
      bradley =
        nixpkgs.lib.nixosSystem
        rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              inputs
              hyprland
              ;

            pkgs = import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
              };
              overlays = [
                (final: prev: {
                  neovim = inputs.neovim.packages.${final.system}.neovim;
                })
              ];
            };
          };
          # defaultPackage.${system} = with nixpkgs; {
          #   shellCommand = ''
          #     # Your shell command here
          #     echo "Hello, world!"
          #   '';
          # };
          modules = [
            ./hosts/bradley/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = false;
                extraSpecialArgs = {inherit inputs;};
                users.bradley = ./home/desktop/home.nix;
              };
            }
            hyprland.nixosModules.default
            {programs.hyprland.enable = true;}
          ];
        };
    };
  };
}
