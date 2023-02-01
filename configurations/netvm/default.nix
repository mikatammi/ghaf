{
  nixpkgs,
  microvm,
  system,
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ../../modules/development/authentication.nix
    ../../modules/development/ssh.nix

    microvm.nixosModules.microvm

    ({pkgs, ...}: {
      networking.hostName = "netvm";
      system.stateVersion = "22.11";

      environment.systemPackages = with pkgs; [
        pciutils
        usbutils
      ];

      # For WLAN firmwares
      hardware.enableRedistributableFirmware = true;

      microvm.hypervisor = "crosvm";

      networking.interfaces.eth0.useDHCP = true;
      networking.firewall.allowedTCPPorts = [22];

      #users.users."graf" = {
      #    isNormalUser = true;
      #    password = "ghaf";
      #    extraGroups = ["wheel"];
      #};

      # TODO: IDea. Maybe use udev rules for connecting
      # devices to crosvm
      # microvm.devices = [
      #   {
      #     bus = "usb";
      #     path = "vendorid=0x050d,productid=0x2103";
      #   }
      # ];
      # microvm.devices = [
      #   {
      #     bus = "pci";
      #     path = "0001:00:00.0";
      #   }
      #   {
      #     bus = "pci";
      #     path = "0001:01:00.0";
      #   }
      # ];

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
      microvm.interfaces = [
        {
          type = "tap";
          id = "vm-netvm";
          mac = "02:00:00:01:01:01";
        }
      ];

      # networking.useNetworkd = true;
      # systemd.network = {
      #   netdevs."virbr0".netdevConfig = {
      #     Kind = "bridge";
      #     Name = "virbr0";
      #   };
      #   networks."virbr0" = {
      #     matchConfig.Name = "virbr0";
      #     networkConfig = {
      #       DHCPServer = true;
      #       IPv6SendRA = true;
      #     };
      #     addresses = [ {
      #       addressConfig.Address = "192.168.100.1/24";
      #     } {
      #       addressConfig.Address = "fd12:3456:789a::1/64";
      #     } ];
      #     ipv6Prefixes = [ {
      #       ipv6PrefixConfig.Prefix = "fd12:3456:789a::/64";
      #     } ];
      #   };
      # };
      # networking.firewall.allowedUDPPorts = [ 67 ];

      # networking.nat = {
      #   enable = true;
      #   enableIPv6 = true;
      #   internalInterfaces = [ "eth0" ];
      # };

      networking.wireless = {
        enable = true;

	networks."SSID_OF_NETWORK".psk = "WPA_PASSWORD";
      };
    })
  ];
}
