{
    description = "Bradley's NixOs config of desktop";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {
        self,
        nixpkgs,
        home-manager,
        utils,
        ...
    } @ inputs: {
        nixosConfigurations = {
            bradley = nixpkgs.lib.nixosSystem
            {
                system = "x86_64-linux";
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
                ];
            };
        };
    };
}
