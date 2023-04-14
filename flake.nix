# Welcome to ground zero. Where the whole flake gets set up and all its modules
# are loaded.
{
  description = "You shall meet your doom here";

  inputs = {
    # Core dependencies.
    nixpkgs.url = "nixpkgs/nixos-unstable"; # primary nixpkgs
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable"; # for packages on the edge

    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    # Extras
    hyprland.url = "github:hyprwm/Hyprland";
    vscode-server.url = "github:msteen/nixos-vscode-server";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Theme
    base16 = {
      url = "github:shaunsingh/base16.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    base16-oxocarbon = {
      url = "github:shaunsingh/base16-oxocarbon";
      flake = false;
    };

  };

  outputs =
    inputs @ { self
    , nixpkgs
    , nixpkgs-unstable
    , ...
    }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      mkPkgs = pkgs: extraOverlays:
        import pkgs {
          inherit system;
          config.allowUnfree = true; # forgive me Stallman senpai
          overlays = extraOverlays ++ (lib.attrValues self.overlays);
        };

      pkgs = mkPkgs nixpkgs [ self.overlay ];
      pkgs' = mkPkgs nixpkgs-unstable [ ];

      lib =
        nixpkgs.lib.extend
          (self: super: {
            my = import ./lib {
              inherit pkgs inputs;
              lib = self;
            };
          });
    in
    {
      lib = lib.my;

      overlay = final: prev: {
        unstable = pkgs';
        my = self.packages."${system}";
      };

      overlays =
        mapModules ./overlays import;

      packages."${system}" =
        mapModules ./packages (p: pkgs.callPackage p { });

      nixosModules =
        { dotfiles = import ./.; } // mapModulesRec ./modules import;

      nixosConfigurations =
        mapHosts ./hosts { };

      devShell."${system}" =
        import ./shell.nix { inherit pkgs; };

      templates =
        {
          full = {
            path = ./.;
            description = "A grossly incandescent nixos config";
          };
        }
        // import ./templates;
      defaultTemplate = self.templates.full;

      defaultApp."${system}" = {
        type = "app";
        program = ./bin/hey;
      };
    };
}
