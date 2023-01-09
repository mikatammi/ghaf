{
  pkgs,
  lib,
  ...
}: {
  boot.kernelParams = ["intel_iommu=on" "iommu=pt"];
  boot.kernelModules = ["kvm-intel" "vfio-pci"];
}
