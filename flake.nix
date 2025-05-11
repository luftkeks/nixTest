{
  description = "NixOS config for Raspberry Pi 4 Mini-NAS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        formatter = pkgs.nixpkgs-fmt;
      }) // {
      nixosConfigurations.raspberrypi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/raspberrypi.nix
        ];
      };
    };
}
