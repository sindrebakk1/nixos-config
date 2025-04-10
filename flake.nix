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

    stylix.url = "github:danth/stylix";

    yazi.url = "github:sxyazi/yazi";
  };

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://yazi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    nur,
    home-manager,
    sops-nix,
    stylix,
    yazi,
    ... 
  }@inputs:
  let
    inherit (self) ouputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      builtins.currentSystem
    ];

    sharedModules = [
      ({
	inputs,
	outputs,
	lib,
	config,
	pkgs,
	...
      }: {
	nixpkgs.overlays = [
	  yazi.overlays.default
	];
      })
      
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

    overlays = [
      yazi.overlays.default
    ];

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
