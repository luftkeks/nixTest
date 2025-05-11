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
        # Basis-Konfiguration für das NixOS-System
        system = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          kernelPackages = pkgs.linux-aarch64.raspberrypi;
          initrd = true;
          modules = [
            ./hosts/raspberrypi.nix
          ];
        };

        # Zusätzliche Pakete und Dienste
        packages = with pkgs; [
          nixpkgs-fmt
          networkmanager
          samba
          rsync
        ];

        # UEFI-Unterstützung aktivieren
        boot.loader.grub.enable = true;
        boot.loader.grub.version = 2;
        boot.loader.efiSupport = true;
      });
    };
}
