# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
#
# Common ghaf modules
#
{
  imports = [
    ./version
    ./boot/systemd-boot-dtb.nix
    ./development
    ./windows-launcher
    ./users/accounts.nix
    ./firewall
    ./virtualization/docker.nix
    ./profiles
    ./hardware
    ./tpm2
    ./common.nix
  ];
}
