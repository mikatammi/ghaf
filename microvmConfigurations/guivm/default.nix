# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  nixpkgs,
  microvm,
  system,
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    # TODO: Enable only for development builds
    ../../modules/development/authentication.nix
    ../../modules/development/ssh.nix
    ../../modules/development/packages.nix

    ../../modules/graphics/weston.nix

    ../../modules/hardware/nvidia-gpu.nix

    microvm.nixosModules.microvm

    ({pkgs, ...}: {
      networking.hostName = "guivm";
      # TODO: Maybe inherit state version
      system.stateVersion = "22.11";

      # TODO: crosvm PCI passthrough does not currently work
      microvm.hypervisor = "qemu";

      networking = {
        enableIPv6 = false;
        interfaces.ethint0.useDHCP = false;
        firewall.allowedTCPPorts = [22];
        useNetworkd = true;
      };

      microvm.interfaces = [
        {
          type = "tap";
          id = "vm-guivm";
          mac = "03:00:00:01:01:01";
        }
      ];

      networking.nat = {
        enable = true;
        internalInterfaces = ["enp0s4"];
      };

      # TODO: Set the interface name to something pre-defined.
      # Setting the name manually with ip link set <iface> name <newname>
      # works. The following breaks things for some reason:
      #
      # Set internal network's interface name to ethint0
      # systemd.network.links."10-ethint0" = {
      #   matchConfig.PermanentMACAddress = "02:00:00:01:01:01";
      #   linkConfig.Name = "ethint0";
      # };

      systemd.network = {
        enable = true;
        networks."10-ethint0" = {
          matchConfig.MACAddress = "03:00:00:01:01:01";
          address = ["192.168.100.3/24"];
          linkConfig.ActivationPolicy = "always-up";
        };
      };

      microvm.qemu.bios.enable = false;

      microvm.devices = [
        # GPU
        {
          bus = "pci";
          path = "0005:01:00.0";
        }
        # HDMI audio
        {
          bus = "pci";
          path = "0005:01:00.1";
        }
      ];
    })
  ];
}
