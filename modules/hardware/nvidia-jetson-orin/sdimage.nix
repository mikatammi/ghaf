{
  config,
  pkgs,
  modulesPath,
  lib,
  ...
}: {
  imports = [
    (modulesPath + "/installer/sd-card/sd-image.nix")
  ];

  boot.loader.grub.enable = false;
  disabledModules = [(modulesPath + "/profiles/all-hardware.nix")];

  sdImage = let
    mkESPContent = pkgs.substituteAll {
      src = ./mk-esp-contents.py;
      isExecutable = true;
      inherit (pkgs.buildPackages) python3;
    };
    fdtPath = "${config.hardware.deviceTree.package}/${config.hardware.deviceTree.name}";
  in {
    firmwareSize = 256;
    # TODO: Replace contents of the populateFirmwareCommands with proper
    #       bootpsec-based ESP partition generation.
    populateFirmwareCommands = ''
      mkdir -pv firmware
      ${mkESPContent} --toplevel ${config.system.build.toplevel} --output firmware/ --device-tree ${fdtPath}
    '';
    populateRootCommands = ''
    '';
    postBuildCommands = ''
      stat --printf=%s firmware_part.img > $out/esp.size
      stat --printf=%s root-fs.img > $out/root.size

      ${pkgs.zstd}/bin/pzstd -p $NIX_BUILD_CORES -19 firmware_part.img -o $out/esp.img.zst
      ${pkgs.zstd}/bin/pzstd -p $NIX_BUILD_CORES -19 root-fs.img -o $out/root.img.zst

      # Save toplevel derivation of system for debug purposes
      ln -sf ${config.system.build.toplevel} $out/toplevel
    '';
  };
}
