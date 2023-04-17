# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
#
# Enables NVIDIA's official drivers
#
{pkgs, ...}: {
  # open-driver only works with new (less than ~5 year old) NVIDIA cards
  # WARNING: Do not distribute binaries unless this is set to true. Otherwise
  #          it will be a GPL violation
  hardware.nvidia.open = false;

  # NVIDIA's driver does not officially support modesetting
  hardware.nvidia.modesetting.enable = false;

  nixpkgs.config.allowUnfree = true;

  services.xserver = {
    enable = false;
    videoDrivers = ["nvidia"];
  };
}
