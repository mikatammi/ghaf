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
}
