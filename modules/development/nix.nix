# SPDX-License-Identifier: Apache 2.0
{pkgs, ...}: {
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    keep-outputs          = true
    keep-derivations      = true
  '';
}
