{
  nixpkgs,
  microvm,
  system,
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    microvm.nixosModules.microvm

    {
      networking.hostName = "netvm";
      system.stateVersion = "22.11";

      # For WLAN firmwares
      hardware.enableRedistributableFirmware = true;

      microvm.hypervisor = "crosvm";

      microvm.devices = [
        {
          bus = "pci";
          path = "0001:01:00.0";
        }
      ];

      # Laptop
      # microvm.devices = [
      #   {
      #     bus = "pci";
      #     path = "0000:03:00.0";
      #   }
      #   {
      #     bus = "pci";
      #     path = "0000:05:00.0";
      #   }
      # ];

      networking.wireless = {
        enable = true;
      };
    }
  ];
}
