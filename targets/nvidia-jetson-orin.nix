# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  self,
  lib,
  nixpkgs,
  nixos-generators,
  microvm,
  jetpack-nixos,
}: let
  name = "nvidia-jetson-orin";
  system = "aarch64-linux";

  # Import custom format module
  formatModule = {
    imports = [
      # Needed for formatAttr
      (nixos-generators + "/format-module.nix")

      ../modules/hardware/nvidia-jetson-orin/format-module.nix
    ];
  };
  nvidia-jetson-orin = som: variant: extraModules: let
    netvmExtraModules = [
      {
        # The Nvidia Orin hardware dependent configuration is in
        # modules/hardware/nvidia-jetson-orin/jetson-orin.nx
        # Please refer to that section for hardware dependent netvm configuration.
        # To enable or disable wireless
        networking.wireless.enable = som == "agx";
        # Wireless Configuration
        # Orin AGX has WiFi enabled where Orin Nx does not

        # For WLAN firmwares
        hardware.enableRedistributableFirmware = som == "agx";
        # Note: When 21.11 arrives replace the below statement with
        # wirelessRegulatoryDatabase = true;
      }
    ];
    hostConfiguration = lib.nixosSystem {
      inherit system;
      specialArgs = {inherit lib;};

      modules =
        [
          jetpack-nixos.nixosModules.default
          ../modules/hardware/nvidia-jetson-orin
          microvm.nixosModules.host
          ../modules/host
          ../modules/virtualization/microvm/microvm-host.nix
          ../modules/virtualization/microvm/netvm.nix
          {
            ghaf = {
              hardware.nvidia.orin.enable = true;
              hardware.nvidia.orin.somType = som;

              virtualization.microvm-host.enable = true;
              host.networking.enable = true;

              virtualization.microvm.netvm.enable = true;
              virtualization.microvm.netvm.extraModules = netvmExtraModules;

              # Enable all the default UI applications
              profiles = {
                applications.enable = true;

                #TODO clean this up when the microvm is updated to latest
                release.enable = variant == "release";
                debug.enable = variant == "debug";
              };
              # TODO when supported on x86 move under virtualization
              windows-launcher.enable = true;
            };
          }

          (
            {
              pkgs,
              config,
              ...
            }: let
              stdenv = pkgs.gcc9Stdenv;
              inherit (jetpack-nixos.legacyPackages.${config.nixpkgs.buildPlatform.system}) bspSrc l4tVersion;
              inherit
                (pkgs.callPackages (jetpack-nixos + "/optee.nix") {
                  inherit bspSrc l4tVersion stdenv;
                })
                opteeClient
                buildOpteeTaDevKit
                ;
              pcks11Ta = stdenv.mkDerivation {
                pname = "pkcs11";
                version = l4tVersion;
                src = pkgs.fetchgit {
                  url = "https://nv-tegra.nvidia.com/r/tegra/optee-src/nv-optee";
                  rev = "jetson_${l4tVersion}";
                  sha256 = "sha256-44RBXFNUlqZoq3OY/OFwhiU4Qxi4xQNmetFmlrr6jzY=";
                };
                nativeBuildInputs = [(pkgs.buildPackages.python3.withPackages (p: [p.cryptography]))];
                makeFlags = [
                  "-C optee/optee_os/ta/pkcs11"
                  "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
                  "TA_DEV_KIT_DIR=${buildOpteeTaDevKit {
                    socType = "t234";
                    inherit (config.hardware.nvidia-jetpack.firmware.optee) taPublicKeyFile;
                    opteePatches = config.hardware.nvidia-jetpack.firmware.optee.patches;
                    extraMakeFlags = config.hardware.nvidia-jetpack.firmware.optee.extraMakeFlags;
                  }}/export-ta_arm64"
                  "CFG_PKCS11_TA_TOKEN_COUNT=3"
                  "CFG_PKCS11_TA_HEAP_SIZE=32768"
                  "CFG_PKCS11_TA_AUTH_TEE_IDENTITY=y"
                  "CFG_PKCS11_TA_ALLOW_DIGEST_KEY=y"
                  "OPTEE_CLIENT_EXPORT=${opteeClient}"
                  "O=$(PWD)/out"
                ];
                installPhase = ''
                  runHook preInstall
                  install -Dm755 -t $out out/fd02c9da-306c-48c7-a49c-bbd827ae86ee.ta
                  runHook postInstall
                '';
              };
            in {
              hardware.nvidia-jetpack.firmware.optee.clientLoadPath = pkgs.linkFarm "optee-load-path" [
                {
                  # By default, tee_supplicant expects to find the TAs under
                  # optee_armtz
                  name = "optee_armtz/fd02c9da-306c-48c7-a49c-bbd827ae86ee.ta";
                  path = "${pcks11Ta}/fd02c9da-306c-48c7-a49c-bbd827ae86ee.ta";
                }
              ];
            }
          )

          formatModule
        ]
        ++ (import ../modules/module-list.nix)
        ++ extraModules;
    };
  in {
    inherit hostConfiguration;
    name = "${name}-${som}-${variant}";
    package = hostConfiguration.config.system.build.${hostConfiguration.config.formatAttr};
  };
  nvidia-jetson-orin-agx-debug = nvidia-jetson-orin "agx" "debug" [];
  nvidia-jetson-orin-agx-release = nvidia-jetson-orin "agx" "release" [];
  nvidia-jetson-orin-nx-debug = nvidia-jetson-orin "nx" "debug" [];
  nvidia-jetson-orin-nx-release = nvidia-jetson-orin "nx" "release" [];
  generate-nodemoapps = tgt:
    tgt
    // rec {
      name = tgt.name + "-nodemoapps";
      hostConfiguration = tgt.hostConfiguration.extendModules {
        modules = [
          {
            ghaf.graphics.weston.enableDemoApplications = lib.mkForce false;
          }
        ];
      };
      package = hostConfiguration.config.system.build.${hostConfiguration.config.formatAttr};
    };
  generate-cross-from-x86_64 = tgt:
    tgt
    // rec {
      name = tgt.name + "-from-x86_64";
      hostConfiguration = tgt.hostConfiguration.extendModules {
        modules = [
          {
            nixpkgs.buildPlatform.system = "x86_64-linux";
          }

          ../overlays/cross-compilation.nix
        ];
      };
      package = hostConfiguration.config.system.build.${hostConfiguration.config.formatAttr};
    };
  # Base targets to use for generating demoapps and cross-compilation targets
  baseTargets = [
    nvidia-jetson-orin-agx-debug
    nvidia-jetson-orin-agx-release
    nvidia-jetson-orin-nx-debug
    nvidia-jetson-orin-nx-release
  ];
  # Add nodemoapps targets
  targets = baseTargets ++ (map generate-nodemoapps baseTargets);
  crossTargets = map generate-cross-from-x86_64 targets;
  mkFlashScript = import ../lib/mk-flash-script;
  generate-flash-script = tgt: flash-tools-system:
    mkFlashScript {
      inherit nixpkgs;
      inherit (tgt) hostConfiguration;
      inherit jetpack-nixos;
      inherit flash-tools-system;
    };
in {
  nixosConfigurations =
    builtins.listToAttrs (map (t: lib.nameValuePair t.name t.hostConfiguration) (targets ++ crossTargets));

  packages = {
    aarch64-linux =
      builtins.listToAttrs (map (t: lib.nameValuePair t.name t.package) targets)
      # EXPERIMENTAL: The aarch64-linux hosted flashing support is experimental
      #               and it simply might not work. Providing the script anyway
      // builtins.listToAttrs (map (t: lib.nameValuePair "${t.name}-flash-script" (generate-flash-script t "aarch64-linux")) targets);
    x86_64-linux =
      builtins.listToAttrs (map (t: lib.nameValuePair t.name t.package) crossTargets)
      // builtins.listToAttrs (map (t: lib.nameValuePair "${t.name}-flash-script" (generate-flash-script t "x86_64-linux")) (targets ++ crossTargets));
  };
}
