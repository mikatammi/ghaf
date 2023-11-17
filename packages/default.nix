# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }: let
    inherit (lib.flakes) platformPkgs;
    inherit (pkgs) callPackage;
  in {
    packages = platformPkgs system {
      gala-app = callPackage ./gala {};
      windows-launcher = callPackage ./windows-launcher {enableSpice = false;};
      windows-launcher-spice = callPackage ./windows-launcher {enableSpice = true;};
    };
  };
}
