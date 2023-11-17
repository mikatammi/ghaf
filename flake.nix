# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  description = "Ghaf - Documentation and implementation for TII SSRC Secure Technologies Ghaf Framework";

  nixConfig = {
    extra-trusted-substituters = [
      "https://cache.vedenemo.dev"
      "https://cache.ssrcdevops.tii.ae"
    ];
    extra-trusted-public-keys = [
      "cache.vedenemo.dev:8NhplARANhClUSWJyLVk4WMyy1Wb4rhmWW2u8AejH9E="
      "cache.ssrcdevops.tii.ae:oOrzj9iCppf+me5/3sN/BxEkp5SaFkHfKTPPZ97xXQk="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    #
    # Flake and repo structuring configurations
    #
    # Allows us to structure the flake with the NixOS module system
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
                    inputs.nixpkgs-lib.follows = "nixpkgs";
    }
    flake-root.url = "github:srid/flake-root";

    # Format all the things
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For preserving compatibility with non-Flake users
    flake-compat = {
      url = "github:nix-community/flake-compat";
      flake = false;
    };

    flake-utils.url = "github:numtide/flake-utils";

    #
    # Target Building and services
    #
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    jetpack-nixos = {
      url = "github:anduril/jetpack-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #
    # Security
    #
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-parts.follows = "flake-parts";
      };
    };

    lib-extras = {
      url = "github:aldoborrero/lib-extras/v0.2.2";
      inputs.flake-parts.follows = "flake-parts";
      inputs.flake-root.follows = "flake-root";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
  };

  outputs = inputs @ {flake-parts, ...}: let
    lib = import ./lib.nix {inherit inputs;};
  in
    flake-parts.lib.mkFlake
    {
      inherit inputs;
      specialArgs = {
        inherit lib;
      };
    } {
      # Toggle this to allow debugging in the repl
      # see:https://flake.parts/debug
      debug = false;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "riscv64-linux"
      ];

      imports = [
        ./nix
        ./packages
      ];

      flake.nixosModules = with lib;
        mapAttrs (_: import)
        (rakeLeaves ./modules);
    };
}
# : let
#
# in
#   # Combine list of attribute sets together
#   lib.foldr lib.recursiveUpdate {} [
#     # Documentation
#     (flake-utils.lib.eachSystem systems (system: let
#       pkgs = nixpkgs.legacyPackages.${system};
#     in {
#       packages.doc = pkgs.callPackage ./docs {
#         revision = lib.version;
#         options = let
#           cfg = nixpkgs.lib.nixosSystem {
#             inherit system;
#             modules =
#               lib.ghaf.modules
#               ++ [
#                 jetpack-nixos.nixosModules.default
#                 microvm.nixosModules.host
#                 lanzaboote.nixosModules.lanzaboote
#               ];
#           };
#         in
#           cfg.options;
#       };
#     }))
#
#     # Target configurations
#     (import ./targets {inherit self lib nixpkgs nixos-generators nixos-hardware microvm jetpack-nixos lanzaboote;})
#     # User apps
#     (import ./user-apps {inherit lib nixpkgs flake-utils;})
#     # Hydra jobs
#     (import ./hydrajobs.nix {inherit self lib;})
#     #templates
#     (import ./templates)
#   ];

