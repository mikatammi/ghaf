{
  self,
  system,
}: {
  config,
  lib,
  pkgs,
  ...
}: {
  microvm.vms."netvm-${system}" = {
    flake = self;
    autostart = true;
  };
  networking.useNetworkd = true;
  systemd.network = {
    netdevs."virbr0".netdevConfig = {
      Kind = "bridge";
      Name = "virbr0";
    };
    networks."virbr0" = {
      matchConfig.Name = "virbr0";
      networkConfig = {
        DHCPServer = true;
        IPv6SendRA = true;
      };
      addresses = [
        {
          addressConfig.Address = "192.168.100.1/24";
        }
        {
          addressConfig.Address = "fd12:3456:789a::1/64";
        }
      ];
      ipv6Prefixes = [
        {
          ipv6PrefixConfig.Prefix = "fd12:3456:789a::/64";
        }
      ];
    };
    networks."11-netvm" = {
      matchConfig.Name = "vm-*";
      networkConfig.Bridge = "virbr0";
    };
  };
  networking.firewall.allowedUDPPorts = [67];
}
