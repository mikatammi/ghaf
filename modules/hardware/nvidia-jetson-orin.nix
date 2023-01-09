{pkgs, ...}: {
  hardware.nvidia-jetpack = {
    enable = true;
    som = "orin-agx";
    carrierBoard = "devkit";
    modesetting.enable = true;

    # flashScriptOverrides.flashArgs = "jetson-agx-orin-devkit usb0";
  };
}
