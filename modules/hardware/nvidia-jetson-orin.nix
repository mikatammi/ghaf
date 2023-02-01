{
  pkgs,
  lib,
  ...
}: {
  hardware.nvidia-jetpack = {
    enable = true;
    som = "orin-agx";
    carrierBoard = "devkit";
    modesetting.enable = true;
  };

  # TODO: rpfilter module missing from kernel
  networking.firewall.enable = false;
  boot.kernelPatches = [
    {
      name = "my-tegra-kernel-patches";
      patch = null;
      structuredExtraConfig = with lib.kernel; {
        CONFIG_IP_NF_MATCH_RPFILTER = module;

        CONFIG_VFIO = module;
        CONFIG_VFIO_PCI = module;
        CONFIG_VFIO_PLATFORM = module;
        CONFIG_VFIO_AMBA = module;
        CONFIG_VFIO_MDEV = module;
        CONFIG_VFIO_MDEV_DEVICE = module;

        CONFIG_VIRTIO_PCI = module;
        CONFIG_VIRTIO_PCI_LEGACY = yes;
        CONFIG_VIRTIO_BALLOON = module;
        CONFIG_VIRTIO_INPUT = module;
        CONFIG_VIRTIO_MMIO = module;

        CONFIG_DRM_VIRTIO_GPU = module;
      };
    }
    # TODO: Remove when this patch gets merged to mainline.
    #       Patch to devicetree for getting rust-vmm based VMMs to work on
    #       NVIDIA Jetson Orin.
    {
      name = "gicv3-patch";
      patch = pkgs.fetchpatch {
        url = "https://github.com/OE4T/linux-tegra-5.10/commit/9ca6e31d17782e0cf5249eb59f71dcd7d8903303.patch";
        sha256 = "sha256-PzEQO6Jh/kkoGu329LCYdhdR8mNmo6KGKKVKOeMRZrI=";
      };
    }
  ];
}
