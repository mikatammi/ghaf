{
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
  ];
  networking.hostName = "ghaf-host";
  system.stateVersion = "22.11";

  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
  ];
}
