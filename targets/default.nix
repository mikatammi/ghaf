# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
#
# List of target configurations
{
  self,
  lib,
  nixpkgs,
  nixos-generators,
  nixos-hardware,
  microvm,
  jetpack-nixos,
  vmd,
  vmmanager,
}:
lib.foldr lib.recursiveUpdate {} [
  (import ./nvidia-jetson-orin.nix {inherit self lib nixpkgs nixos-generators microvm jetpack-nixos vmd vmmanager;})
  (import ./vm.nix {inherit self lib nixos-generators microvm vmd vmmanager;})
  (import ./generic-x86_64.nix {inherit self lib nixos-generators nixos-hardware microvm vmd vmmanager;})
  (import ./imx8qm-mek.nix {inherit self lib nixos-generators nixos-hardware microvm vmd vmmanager;})
]
