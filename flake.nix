{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR"; 
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nur,
    home-manager,
    sops-nix,
    stylix,
    ... 
  }@inputs:
  let
    inherit (self) ouputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ];

    sharedModules = [
      nur.modules.nixos.default
      home-manager.nixosModules.home-manager
      sops-nix.nixosModules.sops
      stylix.nixosModules.stylix

      ./modules
    ];
      
  in
  {
    formatter = forAllSystems (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      pkgs.nixpkgs-fmt
    );

    nixosConfigurations = {
      think-pad = nixpkgs.lib.nixosSystem {
        specialArgs = {
	  inherit inputs;
	};
        modules = sharedModules ++ [ ./hosts/think-pad/default.nix ];
      };
    };
  };
}
