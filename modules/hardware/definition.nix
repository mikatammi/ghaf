# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
#
# Module for Hardware Definitions
#
# The point of this module is to only store information about the hardware
# configuration, and the logic that uses this information should be elsewhere.
{lib, ...}: {
  options.ghaf.hardware.definition = with lib; let
    pciDevSubmodule = types.submodule {
      path = mkOption {
        type = str;
        description = ''
          PCI device path
        '';
      };
      vendorId = mkOption {
        type = nullOr str;
        default = null;
        description = ''
          PCI Vendor ID (optional)
        '';
      };
      productId = mkOption {
        type = nullOr str;
        default = null;
        description = ''
          PCI Product ID (optional)
        '';
      };
    };
  in {
    name = mkOption {
      description = "Name of the hardware";
      type = types.str;
      default = "";
    };

    network = {
      # TODO? Should add NetVM enabler here?
      # netvm.enable = mkEnableOption = "NetVM";

      pciDevices = mkOption {
        description = "PCI Devices to passthrough to NetVM";
        type = types.listOf pciDevSubmodule;
        default = [];
        example = literalExpression ''
          [{
            path = "0000:00:14.3";
            vendorId = "8086";
            productId = "51f1";
          }]
        '';
      };
    };

    gpu = {
      # TODO? Should add GuiVM enabler here?
      # guivm.enable = mkEnableOption = "NetVM";

      pciDevices = mkOption {
        description = "PCI Devices to passthrough to GuiVM";
        type = types.listOf pciDevSubmodule;
        default = [];
        example = literalExpression ''
          [{
            path = "0000:00:02.0";
            vendorId = "8086";
            productId = "a7a1";
          }]
        '';
      };
    };
  };
}
