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
    kernelPath = "${config.boot.kernelPackages.kernel}/" + "${config.system.boot.loader.kernelFile}";
    initrdPath = "${config.system.build.initialRamdisk}/" + "${config.system.boot.loader.initrdFile}";
    fdtPath = "${config.hardware.deviceTree.package}/${config.hardware.deviceTree.name}";
    loaderConf = pkgs.writeText "loader.conf" ''
      timeout 0
      default nixos-generation-1.conf
      console-mode keep
    '';
    entriesSrel = pkgs.writeText "entries.srel" ''
      type1

    '';
    entry = pkgs.writeText "nixos-generation-1.conf" ''
      title NixOS
      version Generation 1
      linux /EFI/nixos/${config.system.boot.loader.kernelFile}
      initrd /EFI/nixos/${config.system.boot.loader.initrdFile}
      options init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}
      machine-id 0123456789abcdef0123456789abcdef

      devicetree /EFI/nixos/${config.hardware.deviceTree.name}
    '';
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
