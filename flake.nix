{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    waybarpin.url = "github:nixos/nixpkgs/73bf415737ceb66a6298f806f600cfe4dccd0a41";

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, waybarpin, ... }@inputs:
    let
      overlays = [
        (final: prev: {
          waybar = waybarpin.legacyPackages.${prev.system}.waybar;
	})
      ];
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
    
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [ 
	    ({...}: {
	      nixpkgs.overlays = overlays;
	    })
            ./configuration.nix
            # inputs.home-manager.nixosModules.default
          ];
        };

    };
}
