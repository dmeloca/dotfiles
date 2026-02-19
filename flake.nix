{
  description = "Ch1p's basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    oxwm = {
      url = "github:tonybanters/oxwm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, oxwm,... }: {
    nixosConfigurations.aleph0 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ ... }: {
         disabledModules = [
         "services/x11/window-managers/oxwm.nix"
         ];
         })
      ./configuration.nix
        oxwm.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.ch1p = import ./home.nix;
            backupFileExtension = "backup";
          };
        }	
      ];
    };
  };
}

