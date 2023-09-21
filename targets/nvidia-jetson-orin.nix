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

        boot.kernelPatches = [
          {
            name = "vsock-config";
            patch = null;
            extraStructuredConfig = with lib.kernel; {
              # HAMRADIO is not set
              CAN = lib.mkDefault no;
              CAN_RAW = lib.mkDefault no;
              CAN_BCM = lib.mkDefault no;
              CAN_GW = lib.mkDefault no;
              CAN_J1939 = lib.mkDefault no;
              CAN_ISOTP = lib.mkDefault no;
              BT = lib.mkDefault no;
              BT_BREDR = lib.mkDefault no;
              BT_RFCOMM = lib.mkDefault no;
              BT_RFCOMM_TTY = lib.mkDefault no;
              BT_BNEP = lib.mkDefault no;
              # BT_BNEP_MC_FILTER is not set
              # BT_BNEP_PROTO_FILTER is not set
              BT_HIDP = lib.mkDefault no;
              # BT_HS is not set
              # BT_LE is not set
              BT_LEDS = lib.mkDefault no;
              # BT_MSFTEXT is not set
              # BT_AOSPEXT is not set
              # BT_DEBUGFS is not set
              # BT_SELFTEST is not set

              #
              # Bluetooth device drivers
              #
              BT_INTEL = lib.mkDefault no;
              BT_BCM = lib.mkDefault no;
              BT_RTL = lib.mkDefault no;
              BT_QCA = lib.mkDefault no;
              BT_MTK = lib.mkDefault no;
              BT_HCIBTUSB = lib.mkDefault no;
              # BT_HCIBTUSB_AUTOSUSPEND is not set
              BT_HCIBTUSB_BCM = lib.mkDefault no;
              BT_HCIBTUSB_MTK = lib.mkDefault no;
              BT_HCIBTUSB_RTL = lib.mkDefault no;
              BT_HCIBTSDIO = lib.mkDefault no;
              BT_HCIUART = lib.mkDefault no;
              BT_HCIUART_SERDEV = lib.mkDefault no;
              BT_HCIUART_H4 = lib.mkDefault no;
              BT_HCIUART_NOKIA = lib.mkDefault no;
              BT_HCIUART_BCSP = lib.mkDefault no;
              # BT_HCIUART_ATH3K is not set
              BT_HCIUART_LL = lib.mkDefault no;
              # BT_HCIUART_3WIRE is not set
              # BT_HCIUART_INTEL is not set
              BT_HCIUART_BCM = lib.mkDefault no;
              # BT_HCIUART_RTL is not set
              BT_HCIUART_QCA = lib.mkDefault no;
              # BT_HCIUART_AG6XX is not set
              BT_HCIUART_MRVL = lib.mkDefault no;
              BT_HCIBCM203X = lib.mkDefault no;
              BT_HCIBPA10X = lib.mkDefault no;
              BT_HCIBFUSB = lib.mkDefault no;
              BT_HCIDTL1 = lib.mkDefault no;
              BT_HCIBT3C = lib.mkDefault no;
              BT_HCIBLUECARD = lib.mkDefault no;
              BT_HCIVHCI = lib.mkDefault no;
              BT_MRVL = lib.mkDefault no;
              BT_MRVL_SDIO = lib.mkDefault no;
              BT_ATH3K = lib.mkDefault no;
              BT_MTKSDIO = lib.mkDefault no;
              BT_MTKUART = lib.mkDefault no;
              BT_QCOMSMD = lib.mkDefault no;
              BT_HCIRSI = lib.mkDefault no;
              BT_VIRTIO = lib.mkDefault no;
              # end of Bluetooth device drivers

              #
              # PCI switch controller drivers
              #
              PCI_SW_SWITCHTEC = lib.mkDefault no;
              # end of PCI switch controller drivers

              CXL_BUS = lib.mkDefault no;
              CXL_PCI = lib.mkDefault no;
              # CXL_MEM_RAW_COMMANDS is not set
              CXL_ACPI = lib.mkDefault no;
              CXL_PMEM = lib.mkDefault no;
              CXL_MEM = lib.mkDefault no;
              CXL_PORT = lib.mkDefault no;
              CXL_SUSPEND = lib.mkDefault no;
              CXL_REGION = lib.mkDefault no;
              PCCARD = lib.mkDefault no;
              PCMCIA = lib.mkDefault no;
              PCMCIA_LOAD_CIS = lib.mkDefault no;
              CARDBUS = lib.mkDefault no;

              #
              # PC-card bridges
              #
              YENTA = lib.mkDefault no;
              YENTA_O2 = lib.mkDefault no;
              YENTA_RICOH = lib.mkDefault no;
              YENTA_TI = lib.mkDefault no;
              YENTA_ENE_TUNE = lib.mkDefault no;
              YENTA_TOSHIBA = lib.mkDefault no;
              PD6729 = lib.mkDefault no;
              I82092 = lib.mkDefault no;
              PCCARD_NONSTATIC = lib.mkDefault no;
              RAPIDIO = lib.mkDefault no;
              RAPIDIO_TSI721 = lib.mkDefault no;
              # RAPIDIO_ENABLE_RX_TX_PORTS is not set
              # RAPIDIO_DMA_ENGINE is not set
              # RAPIDIO_DEBUG is not set
              RAPIDIO_ENUM_BASIC = lib.mkDefault no;
              RAPIDIO_CHMAN = lib.mkDefault no;
              RAPIDIO_MPORT_CDEV = lib.mkDefault no;

              #
              # RapidIO Switch drivers
              #
              RAPIDIO_CPS_XX = lib.mkDefault no;
              RAPIDIO_CPS_GEN2 = lib.mkDefault no;
              RAPIDIO_RXS_GEN3 = lib.mkDefault no;
              # end of RapidIO Switch drivers

              #
              # Tegra firmware driver
              #
              TEGRA_IVC = lib.mkDefault no;
              TEGRA_BPMP = lib.mkDefault no;
              # end of Tegra firmware driver

              #
              # Zynq MPSoC Firmware Drivers
              #
              ZYNQMP_FIRMWARE = lib.mkDefault no;
              # ZYNQMP_FIRMWARE_DEBUG is not set
              # end of Zynq MPSoC Firmware Drivers
              # end of Firmware Drivers

              GNSS = lib.mkDefault no;
              GNSS_SERIAL = lib.mkDefault no;
              GNSS_MTK_SERIAL = lib.mkDefault no;
              GNSS_SIRF_SERIAL = lib.mkDefault no;
              GNSS_UBX_SERIAL = lib.mkDefault no;
              GNSS_USB = lib.mkDefault no;
              MTD = lib.mkDefault no;
              # MTD_TESTS is not set

              #
              # Partition parsers
              #
              MTD_AR7_PARTS = lib.mkDefault no;
              MTD_BRCM_U_BOOT = lib.mkDefault no;
              MTD_CMDLINE_PARTS = lib.mkDefault no;
              MTD_OF_PARTS = lib.mkDefault no;
              MTD_OF_PARTS_BCM4908 = lib.mkDefault no;
              # MTD_OF_PARTS_LINKSYS_NS is not set
              MTD_AFS_PARTS = lib.mkDefault no;
              MTD_PARSER_TRX = lib.mkDefault no;
              MTD_REDBOOT_PARTS = lib.mkDefault no;
              # MTD_REDBOOT_PARTS_UNALLOCATED is not set
              # MTD_REDBOOT_PARTS_READONLY is not set
              MTD_QCOMSMEM_PARTS = lib.mkDefault no;
              # end of Partition parsers

              #
              # User Modules And Translation Layers
              #
              MTD_BLKDEVS = lib.mkDefault no;
              MTD_BLOCK = lib.mkDefault no;

              #
              # Note that in some cases UBI block is preferred. See MTD_UBI_BLOCK.
              #
              FTL = lib.mkDefault no;
              NFTL = lib.mkDefault no;
              # NFTL_RW is not set
              INFTL = lib.mkDefault no;
              RFD_FTL = lib.mkDefault no;
              SSFDC = lib.mkDefault no;
              SM_FTL = lib.mkDefault no;
              MTD_OOPS = lib.mkDefault no;
              MTD_PSTORE = lib.mkDefault no;
              MTD_SWAP = lib.mkDefault no;
              # MTD_PARTITIONED_MASTER is not set

              #
              # RAM/ROM/Flash chip drivers
              #
              MTD_CFI = lib.mkDefault no;
              MTD_JEDECPROBE = lib.mkDefault no;
              MTD_GEN_PROBE = lib.mkDefault no;
              MTD_CFI_ADV_OPTIONS = lib.mkDefault no;
              MTD_CFI_NOSWAP = lib.mkDefault no;
              # MTD_CFI_BE_BYTE_SWAP is not set
              # MTD_CFI_LE_BYTE_SWAP is not set
              # MTD_CFI_GEOMETRY is not set
              MTD_MAP_BANK_WIDTH_1 = lib.mkDefault no;
              MTD_MAP_BANK_WIDTH_2 = lib.mkDefault no;
              MTD_MAP_BANK_WIDTH_4 = lib.mkDefault no;
              MTD_CFI_I1 = lib.mkDefault no;
              MTD_CFI_I2 = lib.mkDefault no;
              # MTD_OTP is not set
              MTD_CFI_INTELEXT = lib.mkDefault no;
              MTD_CFI_AMDSTD = lib.mkDefault no;
              MTD_CFI_STAA = lib.mkDefault no;
              MTD_CFI_UTIL = lib.mkDefault no;
              MTD_RAM = lib.mkDefault no;
              MTD_ROM = lib.mkDefault no;
              MTD_ABSENT = lib.mkDefault no;
              # end of RAM/ROM/Flash chip drivers

              #
              # Mapping drivers for chip access
              #
              MTD_COMPLEX_MAPPINGS = lib.mkDefault no;
              MTD_PHYSMAP = lib.mkDefault no;
              # MTD_PHYSMAP_COMPAT is not set
              MTD_PHYSMAP_OF = lib.mkDefault no;
              # MTD_PHYSMAP_VERSATILE is not set
              # MTD_PHYSMAP_GEMINI is not set
              # MTD_PHYSMAP_GPIO_ADDR is not set
              MTD_PCI = lib.mkDefault no;
              MTD_PCMCIA = lib.mkDefault no;
              # MTD_PCMCIA_ANONYMOUS is not set
              MTD_INTEL_VR_NOR = lib.mkDefault no;
              MTD_PLATRAM = lib.mkDefault no;
              # end of Mapping drivers for chip access

              #
              # Self-contained MTD device drivers
              #
              MTD_PMC551 = lib.mkDefault no;
              # MTD_PMC551_BUGFIX is not set
              # MTD_PMC551_DEBUG is not set
              MTD_DATAFLASH = lib.mkDefault no;
              # MTD_DATAFLASH_WRITE_VERIFY is not set
              # MTD_DATAFLASH_OTP is not set
              MTD_MCHP23K256 = lib.mkDefault no;
              MTD_MCHP48L640 = lib.mkDefault no;
              MTD_SST25L = lib.mkDefault no;
              MTD_SLRAM = lib.mkDefault no;
              MTD_PHRAM = lib.mkDefault no;
              MTD_MTDRAM = lib.mkDefault no;
              MTD_BLOCK2MTD = lib.mkDefault no;

              #
              # Disk-On-Chip Device Drivers
              #
              MTD_DOCG3 = lib.mkDefault no;
              # end of Self-contained MTD device drivers

              #
              # NAND
              #
              MTD_NAND_CORE = lib.mkDefault no;
              MTD_ONENAND = lib.mkDefault no;
              # MTD_ONENAND_VERIFY_WRITE is not set
              MTD_ONENAND_GENERIC = lib.mkDefault no;
              # MTD_ONENAND_OTP is not set
              # MTD_ONENAND_2X_PROGRAM is not set
              MTD_RAW_NAND = lib.mkDefault no;

              #
              # Raw/parallel NAND flash controllers
              #
              MTD_NAND_DENALI = lib.mkDefault no;
              MTD_NAND_DENALI_PCI = lib.mkDefault no;
              MTD_NAND_DENALI_DT = lib.mkDefault no;
              MTD_NAND_OMAP2 = lib.mkDefault no;
              # MTD_NAND_OMAP_BCH is not set
              MTD_NAND_CAFE = lib.mkDefault no;
              MTD_NAND_MARVELL = lib.mkDefault no;
              MTD_NAND_BRCMNAND = lib.mkDefault no;
              MTD_NAND_BRCMNAND_BCM63XX = lib.mkDefault no;
              MTD_NAND_BRCMNAND_BCMBCA = lib.mkDefault no;
              MTD_NAND_BRCMNAND_BRCMSTB = lib.mkDefault no;
              MTD_NAND_BRCMNAND_IPROC = lib.mkDefault no;
              MTD_NAND_FSL_IFC = lib.mkDefault no;
              MTD_NAND_MXC = lib.mkDefault no;
              MTD_NAND_SUNXI = lib.mkDefault no;
              MTD_NAND_HISI504 = lib.mkDefault no;
              MTD_NAND_QCOM = lib.mkDefault no;
              MTD_NAND_MTK = lib.mkDefault no;
              MTD_NAND_MXIC = lib.mkDefault no;
              MTD_NAND_TEGRA = lib.mkDefault no;
              MTD_NAND_MESON = lib.mkDefault no;
              MTD_NAND_GPIO = lib.mkDefault no;
              MTD_NAND_PLATFORM = lib.mkDefault no;
              MTD_NAND_CADENCE = lib.mkDefault no;
              MTD_NAND_ARASAN = lib.mkDefault no;
              MTD_NAND_INTEL_LGM = lib.mkDefault no;
              MTD_NAND_ROCKCHIP = lib.mkDefault no;
              MTD_NAND_RENESAS = lib.mkDefault no;

              #
              # Misc
              #
              MTD_SM_COMMON = lib.mkDefault no;
              MTD_NAND_NANDSIM = lib.mkDefault no;
              MTD_NAND_RICOH = lib.mkDefault no;
              MTD_NAND_DISKONCHIP = lib.mkDefault no;
              # MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
              # MTD_NAND_DISKONCHIP_BBTWRITE is not set
              MTD_SPI_NAND = lib.mkDefault no;

              #
              # ECC engine support
              #
              MTD_NAND_ECC = lib.mkDefault no;
              MTD_NAND_ECC_SW_HAMMING = lib.mkDefault no;
              # MTD_NAND_ECC_SW_HAMMING_SMC is not set
              # MTD_NAND_ECC_SW_BCH is not set
              # MTD_NAND_ECC_MXIC is not set
              MTD_NAND_ECC_MEDIATEK = lib.mkDefault no;
              # end of ECC engine support
              # end of NAND

              #
              # LPDDR & LPDDR2 PCM memory drivers
              #
              MTD_LPDDR = lib.mkDefault no;
              MTD_QINFO_PROBE = lib.mkDefault no;
              # end of LPDDR & LPDDR2 PCM memory drivers

              MTD_SPI_NOR = lib.mkDefault no;
              MTD_SPI_NOR_USE_4K_SECTORS = lib.mkDefault no;
              # MTD_SPI_NOR_SWP_DISABLE is not set
              MTD_SPI_NOR_SWP_DISABLE_ON_VOLATILE = lib.mkDefault no;
              # MTD_SPI_NOR_SWP_KEEP is not set
              SPI_HISI_SFC = lib.mkDefault no;
              MTD_UBI = lib.mkDefault no;
              # MTD_UBI_FASTMAP is not set
              MTD_UBI_GLUEBI = lib.mkDefault no;
              # MTD_UBI_BLOCK is not set
              MTD_HYPERBUS = lib.mkDefault no;
              HBMC_AM654 = lib.mkDefault no;
              DTC = lib.mkDefault no;
              OF = lib.mkDefault no;
              # OF_UNITTEST is not set
              OF_FLATTREE = lib.mkDefault no;
              OF_EARLY_FLATTREE = lib.mkDefault no;
              OF_KOBJ = lib.mkDefault no;
              OF_DYNAMIC = lib.mkDefault no;
              OF_ADDRESS = lib.mkDefault no;
              OF_IRQ = lib.mkDefault no;
              OF_RESERVED_MEM = lib.mkDefault no;
              # OF_OVERLAY is not set
              OF_NUMA = lib.mkDefault no;
              PARPORT = lib.mkDefault no;
              PARPORT_PC = lib.mkDefault no;
              PARPORT_SERIAL = lib.mkDefault no;
              # PARPORT_PC_FIFO is not set
              PARPORT_PC_PCMCIA = lib.mkDefault no;
              PARPORT_AX88796 = lib.mkDefault no;
              # PARPORT_1284 is not set
              PARPORT_NOT_PC = lib.mkDefault no;
              PNP = lib.mkDefault no;
              PNP_DEBUG_MESSAGES = lib.mkDefault no;

              #
              # Protocols
              #
              PNPACPI = lib.mkDefault no;
              BLK_DEV = lib.mkDefault no;
              BLK_DEV_NULL_BLK = lib.mkDefault no;
              CDROM = lib.mkDefault no;
              PARIDE = lib.mkDefault no;

              #
              # Parallel IDE high-level drivers
              #
              PARIDE_PD = lib.mkDefault no;
              PARIDE_PCD = lib.mkDefault no;
              PARIDE_PF = lib.mkDefault no;
              PARIDE_PT = lib.mkDefault no;
              PARIDE_PG = lib.mkDefault no;

              #
              # Parallel IDE protocol modules
              #
              PARIDE_ATEN = lib.mkDefault no;
              PARIDE_BPCK = lib.mkDefault no;
              PARIDE_COMM = lib.mkDefault no;
              PARIDE_DSTR = lib.mkDefault no;
              PARIDE_FIT2 = lib.mkDefault no;
              PARIDE_FIT3 = lib.mkDefault no;
              PARIDE_EPAT = lib.mkDefault no;
              # PARIDE_EPATC8 is not set
              PARIDE_EPIA = lib.mkDefault no;
              PARIDE_FRIQ = lib.mkDefault no;
              PARIDE_FRPW = lib.mkDefault no;
              PARIDE_KBIC = lib.mkDefault no;
              PARIDE_KTTI = lib.mkDefault no;
              PARIDE_ON20 = lib.mkDefault no;
              PARIDE_ON26 = lib.mkDefault no;
              BLK_DEV_PCIESSD_MTIP32XX = lib.mkDefault no;
              ZRAM = lib.mkDefault no;
              ZRAM_DEF_COMP_LZORLE = lib.mkDefault no;
              # ZRAM_DEF_COMP_ZSTD is not set
              # ZRAM_DEF_COMP_LZ4 is not set
              # ZRAM_DEF_COMP_LZO is not set
              # ZRAM_DEF_COMP_LZ4HC is not set
              # ZRAM_DEF_COMP_842 is not set
              ZRAM_WRITEBACK = lib.mkDefault no;
              # ZRAM_MEMORY_TRACKING is not set
              BLK_DEV_LOOP = lib.mkDefault no;
              BLK_DEV_DRBD = lib.mkDefault no;
              # DRBD_FAULT_INJECTION is not set
              BLK_DEV_NBD = lib.mkDefault no;
              BLK_DEV_RAM = lib.mkDefault no;
              CDROM_PKTCDVD = lib.mkDefault no;
              # CDROM_PKTCDVD_WCACHE is not set
              ATA_OVER_ETH = lib.mkDefault no;
              XEN_BLKDEV_FRONTEND = lib.mkDefault no;
              XEN_BLKDEV_BACKEND = lib.mkDefault no;
              VIRTIO_BLK = lib.mkDefault no;
              BLK_DEV_RBD = lib.mkDefault no;
              BLK_DEV_UBLK = lib.mkDefault no;
              BLK_DEV_RNBD = lib.mkDefault no;
              BLK_DEV_RNBD_CLIENT = lib.mkDefault no;
              BLK_DEV_RNBD_SERVER = lib.mkDefault no;

              #
              # NVME Support
              #
              NVME_CORE = lib.mkDefault no;
              BLK_DEV_NVME = lib.mkDefault no;
              NVME_MULTIPATH = lib.mkDefault no;
              # NVME_VERBOSE_ERRORS is not set
              NVME_HWMON = lib.mkDefault no;
              NVME_FABRICS = lib.mkDefault no;
              NVME_RDMA = lib.mkDefault no;
              NVME_FC = lib.mkDefault no;
              NVME_TCP = lib.mkDefault no;
              # NVME_AUTH is not set
              NVME_APPLE = lib.mkDefault no;
              NVME_TARGET = lib.mkDefault no;
              # NVME_TARGET_PASSTHRU is not set
              NVME_TARGET_LOOP = lib.mkDefault no;
              NVME_TARGET_RDMA = lib.mkDefault no;
              NVME_TARGET_FC = lib.mkDefault no;
              NVME_TARGET_FCLOOP = lib.mkDefault no;
              NVME_TARGET_TCP = lib.mkDefault no;
              # NVME_TARGET_AUTH is not set
              # end of NVME Support

              #
              # Misc devices
              #
              SENSORS_LIS3LV02D = lib.mkDefault no;
              AD525X_DPOT = lib.mkDefault no;
              AD525X_DPOT_I2C = lib.mkDefault no;
              AD525X_DPOT_SPI = lib.mkDefault no;
              DUMMY_IRQ = lib.mkDefault no;
              PHANTOM = lib.mkDefault no;
              TIFM_CORE = lib.mkDefault no;
              TIFM_7XX1 = lib.mkDefault no;
              ICS932S401 = lib.mkDefault no;
              ENCLOSURE_SERVICES = lib.mkDefault no;
              HI6421V600_IRQ = lib.mkDefault no;
              HP_ILO = lib.mkDefault no;
              QCOM_COINCELL = lib.mkDefault no;
              QCOM_FASTRPC = lib.mkDefault no;
              APDS9802ALS = lib.mkDefault no;
              ISL29003 = lib.mkDefault no;
              ISL29020 = lib.mkDefault no;
              SENSORS_TSL2550 = lib.mkDefault no;
              SENSORS_BH1770 = lib.mkDefault no;
              SENSORS_APDS990X = lib.mkDefault no;
              HMC6352 = lib.mkDefault no;
              DS1682 = lib.mkDefault no;
              LATTICE_ECP3_CONFIG = lib.mkDefault no;
              SRAM = lib.mkDefault no;
              DW_XDATA_PCIE = lib.mkDefault no;
              PCI_ENDPOINT_TEST = lib.mkDefault no;
              XILINX_SDFEC = lib.mkDefault no;
              MISC_RTSX = lib.mkDefault no;
              HISI_HIKEY_USB = lib.mkDefault no;
              OPEN_DICE = lib.mkDefault no;
              VCPU_STALL_DETECTOR = lib.mkDefault no;
              C2PORT = lib.mkDefault no;

              #
              # EEPROM support
              #
              EEPROM_AT24 = lib.mkDefault no;
              EEPROM_AT25 = lib.mkDefault no;
              EEPROM_LEGACY = lib.mkDefault no;
              EEPROM_MAX6875 = lib.mkDefault no;
              EEPROM_93CX6 = lib.mkDefault no;
              EEPROM_93XX46 = lib.mkDefault no;
              EEPROM_IDT_89HPESX = lib.mkDefault no;
              EEPROM_EE1004 = lib.mkDefault no;
              # end of EEPROM support

              CB710_CORE = lib.mkDefault no;
              # CB710_DEBUG is not set
              CB710_DEBUG_ASSUMPTIONS = lib.mkDefault no;

              #
              # Texas Instruments shared transport line discipline
              #
              TI_ST = lib.mkDefault no;
              # end of Texas Instruments shared transport line discipline

              SENSORS_LIS3_I2C = lib.mkDefault no;
              ALTERA_STAPL = lib.mkDefault no;
              VMWARE_VMCI = lib.mkDefault no;
              GENWQE = lib.mkDefault no;
              ECHO = lib.mkDefault no;
              BCM_VK = lib.mkDefault no;
              # BCM_VK_TTY is not set
              MISC_ALCOR_PCI = lib.mkDefault no;
              MISC_RTSX_PCI = lib.mkDefault no;
              MISC_RTSX_USB = lib.mkDefault no;
              HABANA_AI = lib.mkDefault no;
              UACCE = lib.mkDefault no;
              # PVPANIC is not set
              GP_PCI1XXXX = lib.mkDefault no;
              # end of Misc devices

              #
              # SCSI device support
              #
              SCSI_MOD = lib.mkDefault no;
              RAID_ATTRS = lib.mkDefault no;
              SCSI_COMMON = lib.mkDefault no;
              SCSI = lib.mkDefault no;
              SCSI_DMA = lib.mkDefault no;
              SCSI_NETLINK = lib.mkDefault no;
              # SCSI_PROC_FS is not set

              #
              # SCSI support type (disk, tape, CD-ROM)
              #
              BLK_DEV_SD = lib.mkDefault no;
              CHR_DEV_ST = lib.mkDefault no;
              BLK_DEV_SR = lib.mkDefault no;
              CHR_DEV_SG = lib.mkDefault no;
              BLK_DEV_BSG = lib.mkDefault no;
              CHR_DEV_SCH = lib.mkDefault no;
              SCSI_ENCLOSURE = lib.mkDefault no;
              # SCSI_CONSTANTS is not set
              SCSI_LOGGING = lib.mkDefault no;
              # SCSI_SCAN_ASYNC is not set

              #
              # SCSI Transports
              #
              SCSI_SPI_ATTRS = lib.mkDefault no;
              SCSI_FC_ATTRS = lib.mkDefault no;
              SCSI_ISCSI_ATTRS = lib.mkDefault no;
              SCSI_SAS_ATTRS = lib.mkDefault no;
              SCSI_SAS_LIBSAS = lib.mkDefault no;
              SCSI_SAS_ATA = lib.mkDefault no;
              SCSI_SAS_HOST_SMP = lib.mkDefault no;
              SCSI_SRP_ATTRS = lib.mkDefault no;
              # end of SCSI Transports

              SCSI_LOWLEVEL = lib.mkDefault no;
              ISCSI_TCP = lib.mkDefault no;
              ISCSI_BOOT_SYSFS = lib.mkDefault no;
              SCSI_CXGB3_ISCSI = lib.mkDefault no;
              SCSI_CXGB4_ISCSI = lib.mkDefault no;
              SCSI_BNX2_ISCSI = lib.mkDefault no;
              SCSI_BNX2X_FCOE = lib.mkDefault no;
              BE2ISCSI = lib.mkDefault no;
              BLK_DEV_3W_XXXX_RAID = lib.mkDefault no;
              SCSI_HPSA = lib.mkDefault no;
              SCSI_3W_9XXX = lib.mkDefault no;
              SCSI_3W_SAS = lib.mkDefault no;
              SCSI_ACARD = lib.mkDefault no;
              SCSI_AACRAID = lib.mkDefault no;
              SCSI_AIC7XXX = lib.mkDefault no;
              # AIC7XXX_DEBUG_ENABLE is not set
              AIC7XXX_REG_PRETTY_PRINT = lib.mkDefault no;
              SCSI_AIC79XX = lib.mkDefault no;
              # AIC79XX_DEBUG_ENABLE is not set
              AIC79XX_REG_PRETTY_PRINT = lib.mkDefault no;
              SCSI_AIC94XX = lib.mkDefault no;
              # AIC94XX_DEBUG is not set
              SCSI_HISI_SAS = lib.mkDefault no;
              SCSI_HISI_SAS_PCI = lib.mkDefault no;
              # SCSI_HISI_SAS_DEBUGFS_DEFAULT_ENABLE is not set
              SCSI_MVSAS = lib.mkDefault no;
              SCSI_MVSAS_DEBUG = lib.mkDefault no;
              # SCSI_MVSAS_TASKLET is not set
              SCSI_MVUMI = lib.mkDefault no;
              SCSI_ADVANSYS = lib.mkDefault no;
              SCSI_ARCMSR = lib.mkDefault no;
              SCSI_ESAS2R = lib.mkDefault no;
              MEGARAID_NEWGEN = lib.mkDefault no;
              MEGARAID_MM = lib.mkDefault no;
              MEGARAID_MAILBOX = lib.mkDefault no;
              MEGARAID_LEGACY = lib.mkDefault no;
              MEGARAID_SAS = lib.mkDefault no;
              SCSI_MPT3SAS = lib.mkDefault no;
              SCSI_MPT2SAS = lib.mkDefault no;
              SCSI_MPI3MR = lib.mkDefault no;
              SCSI_SMARTPQI = lib.mkDefault no;
              SCSI_HPTIOP = lib.mkDefault no;
              SCSI_BUSLOGIC = lib.mkDefault no;
              # SCSI_FLASHPOINT is not set
              SCSI_MYRB = lib.mkDefault no;
              SCSI_MYRS = lib.mkDefault no;
              XEN_SCSI_FRONTEND = lib.mkDefault no;
              HYPERV_STORAGE = lib.mkDefault no;
              LIBFC = lib.mkDefault no;
              LIBFCOE = lib.mkDefault no;
              FCOE = lib.mkDefault no;
              SCSI_SNIC = lib.mkDefault no;
              # SCSI_SNIC_DEBUG_FS is not set
              SCSI_DMX3191D = lib.mkDefault no;
              SCSI_FDOMAIN = lib.mkDefault no;
              SCSI_FDOMAIN_PCI = lib.mkDefault no;
              SCSI_IPS = lib.mkDefault no;
              SCSI_INITIO = lib.mkDefault no;
              SCSI_INIA100 = lib.mkDefault no;
              SCSI_PPA = lib.mkDefault no;
              SCSI_IMM = lib.mkDefault no;
              # SCSI_IZIP_EPP16 is not set
              # SCSI_IZIP_SLOW_CTR is not set
              SCSI_STEX = lib.mkDefault no;
              SCSI_SYM53C8XX_2 = lib.mkDefault no;
              SCSI_SYM53C8XX_MMIO = lib.mkDefault no;
              SCSI_IPR = lib.mkDefault no;
              SCSI_IPR_TRACE = lib.mkDefault no;
              SCSI_IPR_DUMP = lib.mkDefault no;
              SCSI_QLOGIC_1280 = lib.mkDefault no;
              SCSI_QLA_FC = lib.mkDefault no;
              TCM_QLA2XXX = lib.mkDefault no;
              # TCM_QLA2XXX_DEBUG is not set
              SCSI_QLA_ISCSI = lib.mkDefault no;
              QEDI = lib.mkDefault no;
              QEDF = lib.mkDefault no;
              SCSI_LPFC = lib.mkDefault no;
              # SCSI_LPFC_DEBUG_FS is not set
              SCSI_EFCT = lib.mkDefault no;
              SCSI_DC395x = lib.mkDefault no;
              SCSI_AM53C974 = lib.mkDefault no;
              SCSI_WD719X = lib.mkDefault no;
              SCSI_DEBUG = lib.mkDefault no;
              SCSI_PMCRAID = lib.mkDefault no;
              SCSI_PM8001 = lib.mkDefault no;
              SCSI_BFA_FC = lib.mkDefault no;
              SCSI_VIRTIO = lib.mkDefault no;
              SCSI_CHELSIO_FCOE = lib.mkDefault no;
              SCSI_LOWLEVEL_PCMCIA = lib.mkDefault no;
              PCMCIA_AHA152X = lib.mkDefault no;
              PCMCIA_FDOMAIN = lib.mkDefault no;
              PCMCIA_QLOGIC = lib.mkDefault no;
              PCMCIA_SYM53C500 = lib.mkDefault no;
              # SCSI_DH is not set
              # end of SCSI device support

              ATA = lib.mkDefault no;
              SATA_HOST = lib.mkDefault no;
              PATA_TIMINGS = lib.mkDefault no;
              ATA_VERBOSE_ERROR = lib.mkDefault no;
              ATA_FORCE = lib.mkDefault no;
              ATA_ACPI = lib.mkDefault no;
              # SATA_ZPODD is not set
              SATA_PMP = lib.mkDefault no;

              #
              # Controllers with non-SFF native interface
              #
              SATA_AHCI = lib.mkDefault no;
              SATA_AHCI_PLATFORM = lib.mkDefault no;
              AHCI_BRCM = lib.mkDefault no;
              AHCI_DWC = lib.mkDefault no;
              AHCI_IMX = lib.mkDefault no;
              AHCI_CEVA = lib.mkDefault no;
              AHCI_MTK = lib.mkDefault no;
              AHCI_MVEBU = lib.mkDefault no;
              AHCI_SUNXI = lib.mkDefault no;
              AHCI_TEGRA = lib.mkDefault no;
              AHCI_XGENE = lib.mkDefault no;
              AHCI_QORIQ = lib.mkDefault no;
              SATA_AHCI_SEATTLE = lib.mkDefault no;
              SATA_INIC162X = lib.mkDefault no;
              SATA_ACARD_AHCI = lib.mkDefault no;
              SATA_SIL24 = lib.mkDefault no;
              ATA_SFF = lib.mkDefault no;

              #
              # SFF controllers with custom DMA interface
              #
              PDC_ADMA = lib.mkDefault no;
              SATA_QSTOR = lib.mkDefault no;
              SATA_SX4 = lib.mkDefault no;
              ATA_BMDMA = lib.mkDefault no;

              #
              # SATA SFF controllers with BMDMA
              #
              ATA_PIIX = lib.mkDefault no;
              SATA_DWC = lib.mkDefault no;
              # SATA_DWC_OLD_DMA is not set
              SATA_MV = lib.mkDefault no;
              SATA_NV = lib.mkDefault no;
              SATA_PROMISE = lib.mkDefault no;
              SATA_RCAR = lib.mkDefault no;
              SATA_SIL = lib.mkDefault no;
              SATA_SIS = lib.mkDefault no;
              SATA_SVW = lib.mkDefault no;
              SATA_ULI = lib.mkDefault no;
              SATA_VIA = lib.mkDefault no;
              SATA_VITESSE = lib.mkDefault no;

              #
              # PATA SFF controllers with BMDMA
              #
              PATA_ALI = lib.mkDefault no;
              PATA_AMD = lib.mkDefault no;
              PATA_ARTOP = lib.mkDefault no;
              PATA_ATIIXP = lib.mkDefault no;
              PATA_ATP867X = lib.mkDefault no;
              PATA_CMD64X = lib.mkDefault no;
              PATA_CYPRESS = lib.mkDefault no;
              PATA_EFAR = lib.mkDefault no;
              PATA_HPT366 = lib.mkDefault no;
              PATA_HPT37X = lib.mkDefault no;
              PATA_HPT3X2N = lib.mkDefault no;
              PATA_HPT3X3 = lib.mkDefault no;
              # PATA_HPT3X3_DMA is not set
              PATA_IMX = lib.mkDefault no;
              PATA_IT8213 = lib.mkDefault no;
              PATA_IT821X = lib.mkDefault no;
              PATA_JMICRON = lib.mkDefault no;
              PATA_MARVELL = lib.mkDefault no;
              PATA_NETCELL = lib.mkDefault no;
              PATA_NINJA32 = lib.mkDefault no;
              PATA_NS87415 = lib.mkDefault no;
              PATA_OLDPIIX = lib.mkDefault no;
              PATA_OPTIDMA = lib.mkDefault no;
              PATA_PDC2027X = lib.mkDefault no;
              PATA_PDC_OLD = lib.mkDefault no;
              PATA_RADISYS = lib.mkDefault no;
              PATA_RDC = lib.mkDefault no;
              PATA_SCH = lib.mkDefault no;
              PATA_SERVERWORKS = lib.mkDefault no;
              PATA_SIL680 = lib.mkDefault no;
              PATA_SIS = lib.mkDefault no;
              PATA_TOSHIBA = lib.mkDefault no;
              PATA_TRIFLEX = lib.mkDefault no;
              PATA_VIA = lib.mkDefault no;
              PATA_WINBOND = lib.mkDefault no;

              #
              # PIO-only SFF controllers
              #
              PATA_CMD640_PCI = lib.mkDefault no;
              PATA_MPIIX = lib.mkDefault no;
              PATA_NS87410 = lib.mkDefault no;
              PATA_OPTI = lib.mkDefault no;
              PATA_PCMCIA = lib.mkDefault no;
              PATA_PLATFORM = lib.mkDefault no;
              PATA_OF_PLATFORM = lib.mkDefault no;
              PATA_RZ1000 = lib.mkDefault no;

              #
              # Generic fallback / legacy drivers
              #
              PATA_ACPI = lib.mkDefault no;
              ATA_GENERIC = lib.mkDefault no;
              PATA_LEGACY = lib.mkDefault no;
              MD = lib.mkDefault no;
              BLK_DEV_MD = lib.mkDefault no;
              MD_LINEAR = lib.mkDefault no;
              MD_RAID0 = lib.mkDefault no;
              MD_RAID1 = lib.mkDefault no;
              MD_RAID10 = lib.mkDefault no;
              MD_RAID456 = lib.mkDefault no;
              MD_MULTIPATH = lib.mkDefault no;
              MD_FAULTY = lib.mkDefault no;
              MD_CLUSTER = lib.mkDefault no;
              BCACHE = lib.mkDefault no;
              # BCACHE_DEBUG is not set
              # BCACHE_CLOSURES_DEBUG is not set
              # BCACHE_ASYNC_REGISTRATION is not set
              BLK_DEV_DM_BUILTIN = lib.mkDefault no;
              BLK_DEV_DM = lib.mkDefault no;
              # DM_DEBUG is not set
              DM_BUFIO = lib.mkDefault no;
              # DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
              DM_BIO_PRISON = lib.mkDefault no;
              DM_PERSISTENT_DATA = lib.mkDefault no;
              DM_UNSTRIPED = lib.mkDefault no;
              DM_CRYPT = lib.mkDefault no;
              DM_SNAPSHOT = lib.mkDefault no;
              DM_THIN_PROVISIONING = lib.mkDefault no;
              DM_CACHE = lib.mkDefault no;
              DM_CACHE_SMQ = lib.mkDefault no;
              DM_WRITECACHE = lib.mkDefault no;
              DM_EBS = lib.mkDefault no;
              DM_ERA = lib.mkDefault no;
              DM_CLONE = lib.mkDefault no;
              DM_MIRROR = lib.mkDefault no;
              DM_LOG_USERSPACE = lib.mkDefault no;
              DM_RAID = lib.mkDefault no;
              DM_ZERO = lib.mkDefault no;
              DM_MULTIPATH = lib.mkDefault no;
              DM_MULTIPATH_QL = lib.mkDefault no;
              DM_MULTIPATH_ST = lib.mkDefault no;
              DM_MULTIPATH_HST = lib.mkDefault no;
              DM_MULTIPATH_IOA = lib.mkDefault no;
              DM_DELAY = lib.mkDefault no;
              DM_DUST = lib.mkDefault no;
              # DM_UEVENT is not set
              DM_FLAKEY = lib.mkDefault no;
              DM_VERITY = lib.mkDefault no;
              # DM_VERITY_VERIFY_ROOTHASH_SIG is not set
              # DM_VERITY_FEC is not set
              DM_SWITCH = lib.mkDefault no;
              DM_LOG_WRITES = lib.mkDefault no;
              DM_INTEGRITY = lib.mkDefault no;
              DM_AUDIT = lib.mkDefault no;
              TARGET_CORE = lib.mkDefault no;
              TCM_IBLOCK = lib.mkDefault no;
              TCM_FILEIO = lib.mkDefault no;
              TCM_PSCSI = lib.mkDefault no;
              TCM_USER2 = lib.mkDefault no;
              LOOPBACK_TARGET = lib.mkDefault no;
              TCM_FC = lib.mkDefault no;
              ISCSI_TARGET = lib.mkDefault no;
              ISCSI_TARGET_CXGB4 = lib.mkDefault no;
              SBP_TARGET = lib.mkDefault no;
              FUSION = lib.mkDefault no;
              FUSION_SPI = lib.mkDefault no;
              FUSION_FC = lib.mkDefault no;
              FUSION_SAS = lib.mkDefault no;
              FUSION_CTL = lib.mkDefault no;
              FUSION_LAN = lib.mkDefault no;
              # FUSION_LOGGING is not set

              #
              # IEEE 1394 (FireWire) support
              #
              FIREWIRE = lib.mkDefault no;
              FIREWIRE_OHCI = lib.mkDefault no;
              FIREWIRE_SBP2 = lib.mkDefault no;
              FIREWIRE_NET = lib.mkDefault no;
              FIREWIRE_NOSY = lib.mkDefault no;
              # end of IEEE 1394 (FireWire) support

              NETDEVICES = lib.mkDefault no;
              MII = lib.mkDefault no;
              NET_CORE = lib.mkDefault no;
              BONDING = lib.mkDefault no;
              DUMMY = lib.mkDefault no;
              WIREGUARD = lib.mkDefault no;
              # WIREGUARD_DEBUG is not set
              EQUALIZER = lib.mkDefault no;
              NET_FC = lib.mkDefault no;
              IFB = lib.mkDefault no;
              NET_TEAM = lib.mkDefault no;
              NET_TEAM_MODE_BROADCAST = lib.mkDefault no;
              NET_TEAM_MODE_ROUNDROBIN = lib.mkDefault no;
              NET_TEAM_MODE_RANDOM = lib.mkDefault no;
              NET_TEAM_MODE_ACTIVEBACKUP = lib.mkDefault no;
              NET_TEAM_MODE_LOADBALANCE = lib.mkDefault no;
              MACVLAN = lib.mkDefault no;
              MACVTAP = lib.mkDefault no;
              IPVLAN_L3S = lib.mkDefault no;
              IPVLAN = lib.mkDefault no;
              IPVTAP = lib.mkDefault no;
              VXLAN = lib.mkDefault no;
              GENEVE = lib.mkDefault no;
              BAREUDP = lib.mkDefault no;
              GTP = lib.mkDefault no;
              AMT = lib.mkDefault no;
              MACSEC = lib.mkDefault no;
              NETCONSOLE = lib.mkDefault no;
              # NETCONSOLE_DYNAMIC is not set
              NETPOLL = lib.mkDefault no;
              NET_POLL_CONTROLLER = lib.mkDefault no;
              NTB_NETDEV = lib.mkDefault no;
              RIONET = lib.mkDefault no;
              TUN = lib.mkDefault no;
              TAP = lib.mkDefault no;
              # TUN_VNET_CROSS_LE is not set
              VETH = lib.mkDefault no;
              VIRTIO_NET = lib.mkDefault no;
              NLMON = lib.mkDefault no;
              NET_VRF = lib.mkDefault no;
              VSOCKMON = lib.mkDefault no;
              MHI_NET = lib.mkDefault no;
              SUNGEM_PHY = lib.mkDefault no;
              ARCNET = lib.mkDefault no;
              ARCNET_1201 = lib.mkDefault no;
              ARCNET_1051 = lib.mkDefault no;
              ARCNET_RAW = lib.mkDefault no;
              ARCNET_CAP = lib.mkDefault no;
              ARCNET_COM90xx = lib.mkDefault no;
              ARCNET_COM90xxIO = lib.mkDefault no;
              ARCNET_RIM_I = lib.mkDefault no;
              ARCNET_COM20020 = lib.mkDefault no;
              ARCNET_COM20020_PCI = lib.mkDefault no;
              ARCNET_COM20020_CS = lib.mkDefault no;
              ATM_DRIVERS = lib.mkDefault no;
              ATM_DUMMY = lib.mkDefault no;
              ATM_TCP = lib.mkDefault no;
              ATM_LANAI = lib.mkDefault no;
              ATM_ENI = lib.mkDefault no;
              # ATM_ENI_DEBUG is not set
              # ATM_ENI_TUNE_BURST is not set
              ATM_NICSTAR = lib.mkDefault no;
              # ATM_NICSTAR_USE_SUNI is not set
              # ATM_NICSTAR_USE_IDT77105 is not set
              ATM_IDT77252 = lib.mkDefault no;
              # ATM_IDT77252_DEBUG is not set
              # ATM_IDT77252_RCV_ALL is not set
              ATM_IDT77252_USE_SUNI = lib.mkDefault no;
              ATM_IA = lib.mkDefault no;
              # ATM_IA_DEBUG is not set
              ATM_FORE200E = lib.mkDefault no;
              # ATM_FORE200E_USE_TASKLET is not set
              ATM_HE = lib.mkDefault no;
              # ATM_HE_USE_SUNI is not set
              ATM_SOLOS = lib.mkDefault no;
              # CAIF_DRIVERS is not set

              #
              # Distributed Switch Architecture drivers
              #
              B53 = lib.mkDefault no;
              B53_SPI_DRIVER = lib.mkDefault no;
              B53_MDIO_DRIVER = lib.mkDefault no;
              B53_MMAP_DRIVER = lib.mkDefault no;
              B53_SRAB_DRIVER = lib.mkDefault no;
              B53_SERDES = lib.mkDefault no;
              NET_DSA_BCM_SF2 = lib.mkDefault no;
              NET_DSA_LOOP = lib.mkDefault no;
              NET_DSA_HIRSCHMANN_HELLCREEK = lib.mkDefault no;
              NET_DSA_LANTIQ_GSWIP = lib.mkDefault no;
              NET_DSA_MT7530 = lib.mkDefault no;
              NET_DSA_MV88E6060 = lib.mkDefault no;
              NET_DSA_MICROCHIP_KSZ_COMMON = lib.mkDefault no;
              NET_DSA_MICROCHIP_KSZ9477_I2C = lib.mkDefault no;
              NET_DSA_MICROCHIP_KSZ_SPI = lib.mkDefault no;
              NET_DSA_MICROCHIP_KSZ8863_SMI = lib.mkDefault no;
              NET_DSA_MV88E6XXX = lib.mkDefault no;
              # NET_DSA_MV88E6XXX_PTP is not set
              NET_DSA_MSCC_FELIX = lib.mkDefault no;
              NET_DSA_MSCC_SEVILLE = lib.mkDefault no;
              NET_DSA_AR9331 = lib.mkDefault no;
              NET_DSA_QCA8K = lib.mkDefault no;
              NET_DSA_SJA1105 = lib.mkDefault no;
              # NET_DSA_SJA1105_PTP is not set
              NET_DSA_XRS700X = lib.mkDefault no;
              NET_DSA_XRS700X_I2C = lib.mkDefault no;
              NET_DSA_XRS700X_MDIO = lib.mkDefault no;
              NET_DSA_REALTEK = lib.mkDefault no;
              NET_DSA_REALTEK_MDIO = lib.mkDefault no;
              NET_DSA_REALTEK_SMI = lib.mkDefault no;
              NET_DSA_REALTEK_RTL8365MB = lib.mkDefault no;
              NET_DSA_REALTEK_RTL8366RB = lib.mkDefault no;
              NET_DSA_SMSC_LAN9303 = lib.mkDefault no;
              NET_DSA_SMSC_LAN9303_I2C = lib.mkDefault no;
              NET_DSA_SMSC_LAN9303_MDIO = lib.mkDefault no;
              NET_DSA_VITESSE_VSC73XX = lib.mkDefault no;
              NET_DSA_VITESSE_VSC73XX_SPI = lib.mkDefault no;
              NET_DSA_VITESSE_VSC73XX_PLATFORM = lib.mkDefault no;
              # end of Distributed Switch Architecture drivers

              ETHERNET = lib.mkDefault no;
              MDIO = lib.mkDefault no;
              NET_VENDOR_3COM = lib.mkDefault no;
              PCMCIA_3C574 = lib.mkDefault no;
              PCMCIA_3C589 = lib.mkDefault no;
              VORTEX = lib.mkDefault no;
              TYPHOON = lib.mkDefault no;
              NET_VENDOR_ACTIONS = lib.mkDefault no;
              OWL_EMAC = lib.mkDefault no;
              NET_VENDOR_ADAPTEC = lib.mkDefault no;
              ADAPTEC_STARFIRE = lib.mkDefault no;
              NET_VENDOR_AGERE = lib.mkDefault no;
              ET131X = lib.mkDefault no;
              NET_VENDOR_ALACRITECH = lib.mkDefault no;
              SLICOSS = lib.mkDefault no;
              NET_VENDOR_ALLWINNER = lib.mkDefault no;
              SUN4I_EMAC = lib.mkDefault no;
              NET_VENDOR_ALTEON = lib.mkDefault no;
              ACENIC = lib.mkDefault no;
              # ACENIC_OMIT_TIGON_I is not set
              ALTERA_TSE = lib.mkDefault no;
              NET_VENDOR_AMAZON = lib.mkDefault no;
              ENA_ETHERNET = lib.mkDefault no;
              NET_VENDOR_AMD = lib.mkDefault no;
              AMD8111_ETH = lib.mkDefault no;
              PCNET32 = lib.mkDefault no;
              PCMCIA_NMCLAN = lib.mkDefault no;
              AMD_XGBE = lib.mkDefault no;
              NET_XGENE = lib.mkDefault no;
              NET_XGENE_V2 = lib.mkDefault no;
              NET_VENDOR_AQUANTIA = lib.mkDefault no;
              AQTION = lib.mkDefault no;
              NET_VENDOR_ARC = lib.mkDefault no;
              ARC_EMAC_CORE = lib.mkDefault no;
              EMAC_ROCKCHIP = lib.mkDefault no;
              NET_VENDOR_ASIX = lib.mkDefault no;
              SPI_AX88796C = lib.mkDefault no;
              # SPI_AX88796C_COMPRESSION is not set
              NET_VENDOR_ATHEROS = lib.mkDefault no;
              ATL2 = lib.mkDefault no;
              ATL1 = lib.mkDefault no;
              ATL1E = lib.mkDefault no;
              ATL1C = lib.mkDefault no;
              ALX = lib.mkDefault no;
              NET_VENDOR_BROADCOM = lib.mkDefault no;
              B44 = lib.mkDefault no;
              B44_PCI_AUTOSELECT = lib.mkDefault no;
              B44_PCICORE_AUTOSELECT = lib.mkDefault no;
              B44_PCI = lib.mkDefault no;
              BCM4908_ENET = lib.mkDefault no;
              BCMGENET = lib.mkDefault no;
              BNX2 = lib.mkDefault no;
              CNIC = lib.mkDefault no;
              TIGON3 = lib.mkDefault no;
              TIGON3_HWMON = lib.mkDefault no;
              BNX2X = lib.mkDefault no;
              BNX2X_SRIOV = lib.mkDefault no;
              BGMAC = lib.mkDefault no;
              BGMAC_PLATFORM = lib.mkDefault no;
              SYSTEMPORT = lib.mkDefault no;
              BNXT = lib.mkDefault no;
              BNXT_SRIOV = lib.mkDefault no;
              BNXT_FLOWER_OFFLOAD = lib.mkDefault no;
              BNXT_HWMON = lib.mkDefault no;
              NET_VENDOR_CADENCE = lib.mkDefault no;
              MACB = lib.mkDefault no;
              MACB_USE_HWSTAMP = lib.mkDefault no;
              MACB_PCI = lib.mkDefault no;
              NET_VENDOR_CAVIUM = lib.mkDefault no;
              THUNDER_NIC_PF = lib.mkDefault no;
              THUNDER_NIC_VF = lib.mkDefault no;
              THUNDER_NIC_BGX = lib.mkDefault no;
              THUNDER_NIC_RGX = lib.mkDefault no;
              CAVIUM_PTP = lib.mkDefault no;
              LIQUIDIO = lib.mkDefault no;
              LIQUIDIO_VF = lib.mkDefault no;
              NET_VENDOR_CHELSIO = lib.mkDefault no;
              CHELSIO_T1 = lib.mkDefault no;
              # CHELSIO_T1_1G is not set
              CHELSIO_T3 = lib.mkDefault no;
              CHELSIO_T4 = lib.mkDefault no;
              CHELSIO_T4VF = lib.mkDefault no;
              CHELSIO_LIB = lib.mkDefault no;
              CHELSIO_INLINE_CRYPTO = lib.mkDefault no;
              CHELSIO_IPSEC_INLINE = lib.mkDefault no;
              CHELSIO_TLS_DEVICE = lib.mkDefault no;
              NET_VENDOR_CISCO = lib.mkDefault no;
              ENIC = lib.mkDefault no;
              NET_VENDOR_CORTINA = lib.mkDefault no;
              GEMINI_ETHERNET = lib.mkDefault no;
              NET_VENDOR_DAVICOM = lib.mkDefault no;
              DM9051 = lib.mkDefault no;
              DNET = lib.mkDefault no;
              NET_VENDOR_DEC = lib.mkDefault no;
              # NET_TULIP is not set
              NET_VENDOR_DLINK = lib.mkDefault no;
              DL2K = lib.mkDefault no;
              SUNDANCE = lib.mkDefault no;
              # SUNDANCE_MMIO is not set
              NET_VENDOR_EMULEX = lib.mkDefault no;
              BE2NET = lib.mkDefault no;
              BE2NET_HWMON = lib.mkDefault no;
              BE2NET_BE2 = lib.mkDefault no;
              BE2NET_BE3 = lib.mkDefault no;
              BE2NET_LANCER = lib.mkDefault no;
              BE2NET_SKYHAWK = lib.mkDefault no;
              NET_VENDOR_ENGLEDER = lib.mkDefault no;
              TSNEP = lib.mkDefault no;
              # TSNEP_SELFTESTS is not set
              NET_VENDOR_EZCHIP = lib.mkDefault no;
              EZCHIP_NPS_MANAGEMENT_ENET = lib.mkDefault no;
              NET_VENDOR_FREESCALE = lib.mkDefault no;
              FEC = lib.mkDefault no;
              FSL_FMAN = lib.mkDefault no;
              DPAA_ERRATUM_A050385 = lib.mkDefault no;
              FSL_PQ_MDIO = lib.mkDefault no;
              FSL_XGMAC_MDIO = lib.mkDefault no;
              GIANFAR = lib.mkDefault no;
              FSL_DPAA_ETH = lib.mkDefault no;
              FSL_DPAA2_ETH = lib.mkDefault no;
              FSL_DPAA2_PTP_CLOCK = lib.mkDefault no;
              FSL_DPAA2_SWITCH = lib.mkDefault no;
              FSL_ENETC = lib.mkDefault no;
              FSL_ENETC_VF = lib.mkDefault no;
              FSL_ENETC_IERB = lib.mkDefault no;
              FSL_ENETC_MDIO = lib.mkDefault no;
              FSL_ENETC_PTP_CLOCK = lib.mkDefault no;
              FSL_ENETC_QOS = lib.mkDefault no;
              NET_VENDOR_FUJITSU = lib.mkDefault no;
              PCMCIA_FMVJ18X = lib.mkDefault no;
              NET_VENDOR_FUNGIBLE = lib.mkDefault no;
              FUN_CORE = lib.mkDefault no;
              FUN_ETH = lib.mkDefault no;
              NET_VENDOR_GOOGLE = lib.mkDefault no;
              GVE = lib.mkDefault no;
              NET_VENDOR_HISILICON = lib.mkDefault no;
              HIX5HD2_GMAC = lib.mkDefault no;
              HISI_FEMAC = lib.mkDefault no;
              HIP04_ETH = lib.mkDefault no;
              # HI13X1_GMAC is not set
              HNS_MDIO = lib.mkDefault no;
              HNS = lib.mkDefault no;
              HNS_DSAF = lib.mkDefault no;
              HNS_ENET = lib.mkDefault no;
              HNS3 = lib.mkDefault no;
              HNS3_HCLGE = lib.mkDefault no;
              HNS3_HCLGEVF = lib.mkDefault no;
              HNS3_ENET = lib.mkDefault no;
              NET_VENDOR_HUAWEI = lib.mkDefault no;
              HINIC = lib.mkDefault no;
              NET_VENDOR_I825XX = lib.mkDefault no;
              NET_VENDOR_INTEL = lib.mkDefault no;
              E100 = lib.mkDefault no;
              E1000 = lib.mkDefault no;
              E1000E = lib.mkDefault no;
              IGB = lib.mkDefault no;
              IGB_HWMON = lib.mkDefault no;
              IGBVF = lib.mkDefault no;
              IXGB = lib.mkDefault no;
              IXGBE = lib.mkDefault no;
              IXGBE_HWMON = lib.mkDefault no;
              IXGBE_IPSEC = lib.mkDefault no;
              IXGBEVF = lib.mkDefault no;
              IXGBEVF_IPSEC = lib.mkDefault no;
              I40E = lib.mkDefault no;
              IAVF = lib.mkDefault no;
              I40EVF = lib.mkDefault no;
              ICE = lib.mkDefault no;
              ICE_SWITCHDEV = lib.mkDefault no;
              FM10K = lib.mkDefault no;
              IGC = lib.mkDefault no;
              NET_VENDOR_WANGXUN = lib.mkDefault no;
              NGBE = lib.mkDefault no;
              TXGBE = lib.mkDefault no;
              JME = lib.mkDefault no;
              NET_VENDOR_ADI = lib.mkDefault no;
              ADIN1110 = lib.mkDefault no;
              NET_VENDOR_LITEX = lib.mkDefault no;
              LITEX_LITEETH = lib.mkDefault no;
              NET_VENDOR_MARVELL = lib.mkDefault no;
              MVMDIO = lib.mkDefault no;
              MVNETA = lib.mkDefault no;
              MVPP2 = lib.mkDefault no;
              # MVPP2_PTP is not set
              PXA168_ETH = lib.mkDefault no;
              SKGE = lib.mkDefault no;
              # SKGE_DEBUG is not set
              # SKGE_GENESIS is not set
              SKY2 = lib.mkDefault no;
              # SKY2_DEBUG is not set
              OCTEONTX2_MBOX = lib.mkDefault no;
              OCTEONTX2_AF = lib.mkDefault no;
              # NDC_DIS_DYNAMIC_CACHING is not set
              OCTEONTX2_PF = lib.mkDefault no;
              OCTEONTX2_VF = lib.mkDefault no;
              OCTEON_EP = lib.mkDefault no;
              PRESTERA = lib.mkDefault no;
              PRESTERA_PCI = lib.mkDefault no;
              # NET_VENDOR_MEDIATEK is not set
              NET_VENDOR_MELLANOX = lib.mkDefault no;
              MLX4_EN = lib.mkDefault no;
              MLX4_CORE = lib.mkDefault no;
              MLX4_DEBUG = lib.mkDefault no;
              MLX4_CORE_GEN2 = lib.mkDefault no;
              MLX5_CORE = lib.mkDefault no;
              # MLX5_FPGA is not set
              MLX5_CORE_EN = lib.mkDefault no;
              MLX5_EN_ARFS = lib.mkDefault no;
              MLX5_EN_RXNFC = lib.mkDefault no;
              MLX5_MPFS = lib.mkDefault no;
              MLX5_ESWITCH = lib.mkDefault no;
              MLX5_BRIDGE = lib.mkDefault no;
              MLX5_CLS_ACT = lib.mkDefault no;
              MLX5_TC_SAMPLE = lib.mkDefault no;
              # MLX5_CORE_IPOIB is not set
              # MLX5_EN_MACSEC is not set
              # MLX5_EN_IPSEC is not set
              # MLX5_EN_TLS is not set
              MLX5_SW_STEERING = lib.mkDefault no;
              # MLX5_SF is not set
              MLXSW_CORE = lib.mkDefault no;
              MLXSW_CORE_HWMON = lib.mkDefault no;
              MLXSW_CORE_THERMAL = lib.mkDefault no;
              MLXSW_PCI = lib.mkDefault no;
              MLXSW_I2C = lib.mkDefault no;
              MLXSW_SPECTRUM = lib.mkDefault no;
              MLXSW_MINIMAL = lib.mkDefault no;
              MLXFW = lib.mkDefault no;
              MLXBF_GIGE = lib.mkDefault no;
              NET_VENDOR_MICREL = lib.mkDefault no;
              KS8842 = lib.mkDefault no;
              KS8851 = lib.mkDefault no;
              KS8851_MLL = lib.mkDefault no;
              KSZ884X_PCI = lib.mkDefault no;
              NET_VENDOR_MICROCHIP = lib.mkDefault no;
              ENC28J60 = lib.mkDefault no;
              # ENC28J60_WRITEVERIFY is not set
              ENCX24J600 = lib.mkDefault no;
              LAN743X = lib.mkDefault no;
              LAN966X_SWITCH = lib.mkDefault no;
              NET_VENDOR_MICROSEMI = lib.mkDefault no;
              MSCC_OCELOT_SWITCH_LIB = lib.mkDefault no;
              MSCC_OCELOT_SWITCH = lib.mkDefault no;
              NET_VENDOR_MICROSOFT = lib.mkDefault no;
              NET_VENDOR_MYRI = lib.mkDefault no;
              MYRI10GE = lib.mkDefault no;
              FEALNX = lib.mkDefault no;
              NET_VENDOR_NI = lib.mkDefault no;
              NI_XGE_MANAGEMENT_ENET = lib.mkDefault no;
              NET_VENDOR_NATSEMI = lib.mkDefault no;
              NATSEMI = lib.mkDefault no;
              NS83820 = lib.mkDefault no;
              NET_VENDOR_NETERION = lib.mkDefault no;
              S2IO = lib.mkDefault no;
              NET_VENDOR_NETRONOME = lib.mkDefault no;
              NFP = lib.mkDefault no;
              NFP_APP_FLOWER = lib.mkDefault no;
              NFP_APP_ABM_NIC = lib.mkDefault no;
              # NFP_DEBUG is not set
              NET_VENDOR_8390 = lib.mkDefault no;
              PCMCIA_AXNET = lib.mkDefault no;
              NE2K_PCI = lib.mkDefault no;
              PCMCIA_PCNET = lib.mkDefault no;
              NET_VENDOR_NVIDIA = lib.mkDefault no;
              FORCEDETH = lib.mkDefault no;
              NET_VENDOR_OKI = lib.mkDefault no;
              ETHOC = lib.mkDefault no;
              NET_VENDOR_PACKET_ENGINES = lib.mkDefault no;
              HAMACHI = lib.mkDefault no;
              YELLOWFIN = lib.mkDefault no;
              NET_VENDOR_PENSANDO = lib.mkDefault no;
              IONIC = lib.mkDefault no;
              NET_VENDOR_QLOGIC = lib.mkDefault no;
              QLA3XXX = lib.mkDefault no;
              QLCNIC = lib.mkDefault no;
              QLCNIC_SRIOV = lib.mkDefault no;
              QLCNIC_HWMON = lib.mkDefault no;
              NETXEN_NIC = lib.mkDefault no;
              QED = lib.mkDefault no;
              QED_LL2 = lib.mkDefault no;
              QED_SRIOV = lib.mkDefault no;
              QEDE = lib.mkDefault no;
              QED_RDMA = lib.mkDefault no;
              QED_ISCSI = lib.mkDefault no;
              QED_FCOE = lib.mkDefault no;
              QED_OOO = lib.mkDefault no;
              NET_VENDOR_BROCADE = lib.mkDefault no;
              BNA = lib.mkDefault no;
              NET_VENDOR_QUALCOMM = lib.mkDefault no;
              QCA7000 = lib.mkDefault no;
              QCA7000_SPI = lib.mkDefault no;
              QCA7000_UART = lib.mkDefault no;
              QCOM_EMAC = lib.mkDefault no;
              RMNET = lib.mkDefault no;
              NET_VENDOR_RDC = lib.mkDefault no;
              R6040 = lib.mkDefault no;
              NET_VENDOR_REALTEK = lib.mkDefault no;
              # 8139CP = lib.mkDefault no;
              # 8139TOO = lib.mkDefault no;
              # 8139TOO_PIO is not set
              # 8139TOO_TUNE_TWISTER is not set
              # 8139TOO_8129 = lib.mkDefault no;
              # 8139_OLD_RX_RESET is not set
              R8169 = lib.mkDefault no;
              NET_VENDOR_RENESAS = lib.mkDefault no;
              SH_ETH = lib.mkDefault no;
              RAVB = lib.mkDefault no;
              NET_VENDOR_ROCKER = lib.mkDefault no;
              ROCKER = lib.mkDefault no;
              NET_VENDOR_SAMSUNG = lib.mkDefault no;
              SXGBE_ETH = lib.mkDefault no;
              NET_VENDOR_SEEQ = lib.mkDefault no;
              NET_VENDOR_SILAN = lib.mkDefault no;
              SC92031 = lib.mkDefault no;
              NET_VENDOR_SIS = lib.mkDefault no;
              SIS900 = lib.mkDefault no;
              SIS190 = lib.mkDefault no;
              NET_VENDOR_SOLARFLARE = lib.mkDefault no;
              SFC = lib.mkDefault no;
              SFC_MTD = lib.mkDefault no;
              SFC_MCDI_MON = lib.mkDefault no;
              SFC_SRIOV = lib.mkDefault no;
              SFC_MCDI_LOGGING = lib.mkDefault no;
              SFC_FALCON = lib.mkDefault no;
              SFC_FALCON_MTD = lib.mkDefault no;
              SFC_SIENA = lib.mkDefault no;
              SFC_SIENA_MTD = lib.mkDefault no;
              SFC_SIENA_MCDI_MON = lib.mkDefault no;
              # SFC_SIENA_SRIOV is not set
              SFC_SIENA_MCDI_LOGGING = lib.mkDefault no;
              NET_VENDOR_SMSC = lib.mkDefault no;
              SMC91X = lib.mkDefault no;
              PCMCIA_SMC91C92 = lib.mkDefault no;
              EPIC100 = lib.mkDefault no;
              SMSC911X = lib.mkDefault no;
              SMSC9420 = lib.mkDefault no;
              NET_VENDOR_SOCIONEXT = lib.mkDefault no;
              SNI_AVE = lib.mkDefault no;
              SNI_NETSEC = lib.mkDefault no;
              NET_VENDOR_STMICRO = lib.mkDefault no;
              STMMAC_ETH = lib.mkDefault no;
              # STMMAC_SELFTESTS is not set
              STMMAC_PLATFORM = lib.mkDefault no;
              DWMAC_DWC_QOS_ETH = lib.mkDefault no;
              DWMAC_GENERIC = lib.mkDefault no;
              DWMAC_IPQ806X = lib.mkDefault no;
              DWMAC_MEDIATEK = lib.mkDefault no;
              DWMAC_MESON = lib.mkDefault no;
              DWMAC_QCOM_ETHQOS = lib.mkDefault no;
              DWMAC_ROCKCHIP = lib.mkDefault no;
              DWMAC_SOCFPGA = lib.mkDefault no;
              DWMAC_SUNXI = lib.mkDefault no;
              DWMAC_SUN8I = lib.mkDefault no;
              DWMAC_IMX8 = lib.mkDefault no;
              DWMAC_INTEL_PLAT = lib.mkDefault no;
              DWMAC_VISCONTI = lib.mkDefault no;
              DWMAC_LOONGSON = lib.mkDefault no;
              STMMAC_PCI = lib.mkDefault no;
              NET_VENDOR_SUN = lib.mkDefault no;
              HAPPYMEAL = lib.mkDefault no;
              SUNGEM = lib.mkDefault no;
              CASSINI = lib.mkDefault no;
              NIU = lib.mkDefault no;
              NET_VENDOR_SYNOPSYS = lib.mkDefault no;
              DWC_XLGMAC = lib.mkDefault no;
              DWC_XLGMAC_PCI = lib.mkDefault no;
              NET_VENDOR_TEHUTI = lib.mkDefault no;
              TEHUTI = lib.mkDefault no;
              NET_VENDOR_TI = lib.mkDefault no;
              TI_DAVINCI_MDIO = lib.mkDefault no;
              # TI_CPSW_PHY_SEL is not set
              TI_K3_AM65_CPSW_NUSS = lib.mkDefault no;
              # TI_K3_AM65_CPSW_SWITCHDEV is not set
              TI_K3_AM65_CPTS = lib.mkDefault no;
              # TI_AM65_CPSW_TAS is not set
              TLAN = lib.mkDefault no;
              NET_VENDOR_VERTEXCOM = lib.mkDefault no;
              MSE102X = lib.mkDefault no;
              NET_VENDOR_VIA = lib.mkDefault no;
              VIA_RHINE = lib.mkDefault no;
              # VIA_RHINE_MMIO is not set
              VIA_VELOCITY = lib.mkDefault no;
              NET_VENDOR_WIZNET = lib.mkDefault no;
              WIZNET_W5100 = lib.mkDefault no;
              WIZNET_W5300 = lib.mkDefault no;
              # WIZNET_BUS_DIRECT is not set
              # WIZNET_BUS_INDIRECT is not set
              WIZNET_BUS_ANY = lib.mkDefault no;
              WIZNET_W5100_SPI = lib.mkDefault no;
              NET_VENDOR_XILINX = lib.mkDefault no;
              XILINX_EMACLITE = lib.mkDefault no;
              XILINX_AXI_EMAC = lib.mkDefault no;
              XILINX_LL_TEMAC = lib.mkDefault no;
              NET_VENDOR_XIRCOM = lib.mkDefault no;
              PCMCIA_XIRC2PS = lib.mkDefault no;
              FDDI = lib.mkDefault no;
              DEFXX = lib.mkDefault no;
              SKFP = lib.mkDefault no;
              HIPPI = lib.mkDefault no;
              ROADRUNNER = lib.mkDefault no;
              # ROADRUNNER_LARGE_RINGS is not set
              QCOM_IPA = lib.mkDefault no;
              NET_SB1000 = lib.mkDefault no;
              PHYLINK = lib.mkDefault no;
              PHYLIB = lib.mkDefault no;
              SWPHY = lib.mkDefault no;
              # LED_TRIGGER_PHY is not set
              FIXED_PHY = lib.mkDefault no;
              SFP = lib.mkDefault no;

              #
              # MII PHY device drivers
              #
              AMD_PHY = lib.mkDefault no;
              MESON_GXL_PHY = lib.mkDefault no;
              ADIN_PHY = lib.mkDefault no;
              ADIN1100_PHY = lib.mkDefault no;
              AQUANTIA_PHY = lib.mkDefault no;
              AX88796B_PHY = lib.mkDefault no;
              BROADCOM_PHY = lib.mkDefault no;
              BCM54140_PHY = lib.mkDefault no;
              BCM7XXX_PHY = lib.mkDefault no;
              BCM84881_PHY = lib.mkDefault no;
              BCM87XX_PHY = lib.mkDefault no;
              BCM_CYGNUS_PHY = lib.mkDefault no;
              BCM_NET_PHYLIB = lib.mkDefault no;
              CICADA_PHY = lib.mkDefault no;
              CORTINA_PHY = lib.mkDefault no;
              DAVICOM_PHY = lib.mkDefault no;
              ICPLUS_PHY = lib.mkDefault no;
              LXT_PHY = lib.mkDefault no;
              INTEL_XWAY_PHY = lib.mkDefault no;
              LSI_ET1011C_PHY = lib.mkDefault no;
              MARVELL_PHY = lib.mkDefault no;
              MARVELL_10G_PHY = lib.mkDefault no;
              MARVELL_88X2222_PHY = lib.mkDefault no;
              MAXLINEAR_GPHY = lib.mkDefault no;
              MEDIATEK_GE_PHY = lib.mkDefault no;
              MICREL_PHY = lib.mkDefault no;
              MICROCHIP_PHY = lib.mkDefault no;
              MICROCHIP_T1_PHY = lib.mkDefault no;
              MICROSEMI_PHY = lib.mkDefault no;
              MOTORCOMM_PHY = lib.mkDefault no;
              NATIONAL_PHY = lib.mkDefault no;
              NXP_C45_TJA11XX_PHY = lib.mkDefault no;
              NXP_TJA11XX_PHY = lib.mkDefault no;
              AT803X_PHY = lib.mkDefault no;
              QSEMI_PHY = lib.mkDefault no;
              REALTEK_PHY = lib.mkDefault no;
              RENESAS_PHY = lib.mkDefault no;
              ROCKCHIP_PHY = lib.mkDefault no;
              SMSC_PHY = lib.mkDefault no;
              STE10XP = lib.mkDefault no;
              TERANETICS_PHY = lib.mkDefault no;
              DP83822_PHY = lib.mkDefault no;
              DP83TC811_PHY = lib.mkDefault no;
              DP83848_PHY = lib.mkDefault no;
              DP83867_PHY = lib.mkDefault no;
              DP83869_PHY = lib.mkDefault no;
              DP83TD510_PHY = lib.mkDefault no;
              VITESSE_PHY = lib.mkDefault no;
              XILINX_GMII2RGMII = lib.mkDefault no;
              MICREL_KS8995MA = lib.mkDefault no;
              # PSE_CONTROLLER is not set
              CAN_DEV = lib.mkDefault no;
              CAN_VCAN = lib.mkDefault no;
              CAN_VXCAN = lib.mkDefault no;
              CAN_NETLINK = lib.mkDefault no;
              CAN_CALC_BITTIMING = lib.mkDefault no;
              CAN_RX_OFFLOAD = lib.mkDefault no;
              CAN_CAN327 = lib.mkDefault no;
              CAN_FLEXCAN = lib.mkDefault no;
              CAN_GRCAN = lib.mkDefault no;
              CAN_JANZ_ICAN3 = lib.mkDefault no;
              CAN_KVASER_PCIEFD = lib.mkDefault no;
              CAN_SLCAN = lib.mkDefault no;
              CAN_XILINXCAN = lib.mkDefault no;
              CAN_C_CAN = lib.mkDefault no;
              CAN_C_CAN_PLATFORM = lib.mkDefault no;
              CAN_C_CAN_PCI = lib.mkDefault no;
              CAN_CC770 = lib.mkDefault no;
              CAN_CC770_ISA = lib.mkDefault no;
              CAN_CC770_PLATFORM = lib.mkDefault no;
              CAN_CTUCANFD = lib.mkDefault no;
              CAN_CTUCANFD_PCI = lib.mkDefault no;
              CAN_CTUCANFD_PLATFORM = lib.mkDefault no;
              CAN_IFI_CANFD = lib.mkDefault no;
              CAN_M_CAN = lib.mkDefault no;
              CAN_M_CAN_PCI = lib.mkDefault no;
              CAN_M_CAN_PLATFORM = lib.mkDefault no;
              CAN_M_CAN_TCAN4X5X = lib.mkDefault no;
              CAN_PEAK_PCIEFD = lib.mkDefault no;
              CAN_RCAR = lib.mkDefault no;
              CAN_RCAR_CANFD = lib.mkDefault no;
              CAN_SJA1000 = lib.mkDefault no;
              CAN_EMS_PCI = lib.mkDefault no;
              CAN_EMS_PCMCIA = lib.mkDefault no;
              CAN_F81601 = lib.mkDefault no;
              CAN_KVASER_PCI = lib.mkDefault no;
              CAN_PEAK_PCI = lib.mkDefault no;
              CAN_PEAK_PCIEC = lib.mkDefault no;
              CAN_PEAK_PCMCIA = lib.mkDefault no;
              CAN_PLX_PCI = lib.mkDefault no;
              CAN_SJA1000_ISA = lib.mkDefault no;
              CAN_SJA1000_PLATFORM = lib.mkDefault no;
              CAN_SOFTING = lib.mkDefault no;
              CAN_SOFTING_CS = lib.mkDefault no;

              #
              # CAN SPI interfaces
              #
              CAN_HI311X = lib.mkDefault no;
              CAN_MCP251X = lib.mkDefault no;
              CAN_MCP251XFD = lib.mkDefault no;
              # CAN_MCP251XFD_SANITY is not set
              # end of CAN SPI interfaces

              #
              # CAN USB interfaces
              #
              CAN_8DEV_USB = lib.mkDefault no;
              CAN_EMS_USB = lib.mkDefault no;
              CAN_ESD_USB = lib.mkDefault no;
              CAN_ETAS_ES58X = lib.mkDefault no;
              CAN_GS_USB = lib.mkDefault no;
              CAN_KVASER_USB = lib.mkDefault no;
              CAN_MCBA_USB = lib.mkDefault no;
              CAN_PEAK_USB = lib.mkDefault no;
              CAN_UCAN = lib.mkDefault no;
              # end of CAN USB interfaces

              # CAN_DEBUG_DEVICES is not set
              MDIO_DEVICE = lib.mkDefault no;
              MDIO_BUS = lib.mkDefault no;
              FWNODE_MDIO = lib.mkDefault no;
              OF_MDIO = lib.mkDefault no;
              ACPI_MDIO = lib.mkDefault no;
              MDIO_DEVRES = lib.mkDefault no;
              MDIO_SUN4I = lib.mkDefault no;
              MDIO_XGENE = lib.mkDefault no;
              MDIO_BITBANG = lib.mkDefault no;
              MDIO_BCM_IPROC = lib.mkDefault no;
              MDIO_BCM_UNIMAC = lib.mkDefault no;
              MDIO_CAVIUM = lib.mkDefault no;
              MDIO_GPIO = lib.mkDefault no;
              MDIO_HISI_FEMAC = lib.mkDefault no;
              MDIO_I2C = lib.mkDefault no;
              MDIO_MVUSB = lib.mkDefault no;
              MDIO_MSCC_MIIM = lib.mkDefault no;
              MDIO_OCTEON = lib.mkDefault no;
              MDIO_IPQ4019 = lib.mkDefault no;
              MDIO_IPQ8064 = lib.mkDefault no;
              MDIO_THUNDER = lib.mkDefault no;

              #
              # MDIO Multiplexers
              #
              MDIO_BUS_MUX = lib.mkDefault no;
              MDIO_BUS_MUX_MESON_G12A = lib.mkDefault no;
              MDIO_BUS_MUX_BCM_IPROC = lib.mkDefault no;
              MDIO_BUS_MUX_GPIO = lib.mkDefault no;
              MDIO_BUS_MUX_MULTIPLEXER = lib.mkDefault no;
              MDIO_BUS_MUX_MMIOREG = lib.mkDefault no;

              #
              # PCS device drivers
              #
              PCS_XPCS = lib.mkDefault no;
              PCS_LYNX = lib.mkDefault no;
              PCS_ALTERA_TSE = lib.mkDefault no;
              # end of PCS device drivers

              PLIP = lib.mkDefault no;
              PPP = lib.mkDefault no;
              PPP_BSDCOMP = lib.mkDefault no;
              PPP_DEFLATE = lib.mkDefault no;
              PPP_FILTER = lib.mkDefault no;
              PPP_MPPE = lib.mkDefault no;
              PPP_MULTILINK = lib.mkDefault no;
              PPPOATM = lib.mkDefault no;
              PPPOE = lib.mkDefault no;
              PPTP = lib.mkDefault no;
              PPPOL2TP = lib.mkDefault no;
              PPP_ASYNC = lib.mkDefault no;
              PPP_SYNC_TTY = lib.mkDefault no;
              SLIP = lib.mkDefault no;
              SLHC = lib.mkDefault no;
              SLIP_COMPRESSED = lib.mkDefault no;
              SLIP_SMART = lib.mkDefault no;
              # SLIP_MODE_SLIP6 is not set
              USB_NET_DRIVERS = lib.mkDefault no;
              USB_CATC = lib.mkDefault no;
              USB_KAWETH = lib.mkDefault no;
              USB_PEGASUS = lib.mkDefault no;
              USB_RTL8150 = lib.mkDefault no;
              USB_RTL8152 = lib.mkDefault no;
              USB_LAN78XX = lib.mkDefault no;
              USB_USBNET = lib.mkDefault no;
              USB_NET_AX8817X = lib.mkDefault no;
              USB_NET_AX88179_178A = lib.mkDefault no;
              USB_NET_CDCETHER = lib.mkDefault no;
              USB_NET_CDC_EEM = lib.mkDefault no;
              USB_NET_CDC_NCM = lib.mkDefault no;
              USB_NET_HUAWEI_CDC_NCM = lib.mkDefault no;
              USB_NET_CDC_MBIM = lib.mkDefault no;
              USB_NET_DM9601 = lib.mkDefault no;
              USB_NET_SR9700 = lib.mkDefault no;
              USB_NET_SR9800 = lib.mkDefault no;
              USB_NET_SMSC75XX = lib.mkDefault no;
              USB_NET_SMSC95XX = lib.mkDefault no;
              USB_NET_GL620A = lib.mkDefault no;
              USB_NET_NET1080 = lib.mkDefault no;
              USB_NET_PLUSB = lib.mkDefault no;
              USB_NET_MCS7830 = lib.mkDefault no;
              USB_NET_RNDIS_HOST = lib.mkDefault no;
              USB_NET_CDC_SUBSET_ENABLE = lib.mkDefault no;
              USB_NET_CDC_SUBSET = lib.mkDefault no;
              # USB_ALI_M5632 is not set
              # USB_AN2720 is not set
              USB_BELKIN = lib.mkDefault no;
              USB_ARMLINUX = lib.mkDefault no;
              # USB_EPSON2888 is not set
              # USB_KC2190 is not set
              USB_NET_ZAURUS = lib.mkDefault no;
              USB_NET_CX82310_ETH = lib.mkDefault no;
              USB_NET_KALMIA = lib.mkDefault no;
              USB_NET_QMI_WWAN = lib.mkDefault no;
              USB_HSO = lib.mkDefault no;
              USB_NET_INT51X1 = lib.mkDefault no;
              USB_CDC_PHONET = lib.mkDefault no;
              USB_IPHETH = lib.mkDefault no;
              USB_SIERRA_NET = lib.mkDefault no;
              USB_VL600 = lib.mkDefault no;
              USB_NET_CH9200 = lib.mkDefault no;
              USB_NET_AQC111 = lib.mkDefault no;
              USB_RTL8153_ECM = lib.mkDefault no;
              WLAN = lib.mkDefault no;
              WLAN_VENDOR_ADMTEK = lib.mkDefault no;
              ADM8211 = lib.mkDefault no;
              ATH_COMMON = lib.mkDefault no;
              WLAN_VENDOR_ATH = lib.mkDefault no;
              # ATH_DEBUG is not set
              ATH5K = lib.mkDefault no;
              # ATH5K_DEBUG is not set
              # ATH5K_TRACER is not set
              ATH5K_PCI = lib.mkDefault no;
              ATH9K_HW = lib.mkDefault no;
              ATH9K_COMMON = lib.mkDefault no;
              ATH9K_BTCOEX_SUPPORT = lib.mkDefault no;
              ATH9K = lib.mkDefault no;
              ATH9K_PCI = lib.mkDefault no;
              ATH9K_AHB = lib.mkDefault no;
              # ATH9K_DEBUGFS is not set
              # ATH9K_DYNACK is not set
              # ATH9K_WOW is not set
              ATH9K_RFKILL = lib.mkDefault no;
              # ATH9K_CHANNEL_CONTEXT is not set
              ATH9K_PCOEM = lib.mkDefault no;
              ATH9K_PCI_NO_EEPROM = lib.mkDefault no;
              ATH9K_HTC = lib.mkDefault no;
              # ATH9K_HTC_DEBUGFS is not set
              # ATH9K_HWRNG is not set
              CARL9170 = lib.mkDefault no;
              CARL9170_LEDS = lib.mkDefault no;
              CARL9170_WPC = lib.mkDefault no;
              # CARL9170_HWRNG is not set
              ATH6KL = lib.mkDefault no;
              ATH6KL_SDIO = lib.mkDefault no;
              ATH6KL_USB = lib.mkDefault no;
              # ATH6KL_DEBUG is not set
              # ATH6KL_TRACING is not set
              AR5523 = lib.mkDefault no;
              WIL6210 = lib.mkDefault no;
              WIL6210_ISR_COR = lib.mkDefault no;
              # WIL6210_TRACING is not set
              WIL6210_DEBUGFS = lib.mkDefault no;
              ATH10K = lib.mkDefault no;
              ATH10K_CE = lib.mkDefault no;
              ATH10K_PCI = lib.mkDefault no;
              # ATH10K_AHB is not set
              ATH10K_SDIO = lib.mkDefault no;
              ATH10K_USB = lib.mkDefault no;
              ATH10K_SNOC = lib.mkDefault no;
              # ATH10K_DEBUG is not set
              # ATH10K_DEBUGFS is not set
              # ATH10K_TRACING is not set
              WCN36XX = lib.mkDefault no;
              # WCN36XX_DEBUGFS is not set
              ATH11K = lib.mkDefault no;
              ATH11K_AHB = lib.mkDefault no;
              ATH11K_PCI = lib.mkDefault no;
              # ATH11K_DEBUG is not set
              # ATH11K_TRACING is not set
              WLAN_VENDOR_ATMEL = lib.mkDefault no;
              ATMEL = lib.mkDefault no;
              PCI_ATMEL = lib.mkDefault no;
              PCMCIA_ATMEL = lib.mkDefault no;
              AT76C50X_USB = lib.mkDefault no;
              WLAN_VENDOR_BROADCOM = lib.mkDefault no;
              B43 = lib.mkDefault no;
              B43_BCMA = lib.mkDefault no;
              B43_SSB = lib.mkDefault no;
              B43_BUSES_BCMA_AND_SSB = lib.mkDefault no;
              # B43_BUSES_BCMA is not set
              # B43_BUSES_SSB is not set
              B43_PCI_AUTOSELECT = lib.mkDefault no;
              B43_PCICORE_AUTOSELECT = lib.mkDefault no;
              # B43_SDIO is not set
              B43_BCMA_PIO = lib.mkDefault no;
              B43_PIO = lib.mkDefault no;
              B43_PHY_G = lib.mkDefault no;
              B43_PHY_N = lib.mkDefault no;
              B43_PHY_LP = lib.mkDefault no;
              B43_PHY_HT = lib.mkDefault no;
              B43_LEDS = lib.mkDefault no;
              B43_HWRNG = lib.mkDefault no;
              # B43_DEBUG is not set
              B43LEGACY = lib.mkDefault no;
              B43LEGACY_PCI_AUTOSELECT = lib.mkDefault no;
              B43LEGACY_PCICORE_AUTOSELECT = lib.mkDefault no;
              B43LEGACY_LEDS = lib.mkDefault no;
              B43LEGACY_HWRNG = lib.mkDefault no;
              B43LEGACY_DEBUG = lib.mkDefault no;
              B43LEGACY_DMA = lib.mkDefault no;
              B43LEGACY_PIO = lib.mkDefault no;
              B43LEGACY_DMA_AND_PIO_MODE = lib.mkDefault no;
              # B43LEGACY_DMA_MODE is not set
              # B43LEGACY_PIO_MODE is not set
              BRCMUTIL = lib.mkDefault no;
              BRCMSMAC = lib.mkDefault no;
              BRCMFMAC = lib.mkDefault no;
              BRCMFMAC_PROTO_BCDC = lib.mkDefault no;
              BRCMFMAC_PROTO_MSGBUF = lib.mkDefault no;
              BRCMFMAC_SDIO = lib.mkDefault no;
              BRCMFMAC_USB = lib.mkDefault no;
              BRCMFMAC_PCIE = lib.mkDefault no;
              # BRCM_TRACING is not set
              # BRCMDBG is not set
              WLAN_VENDOR_CISCO = lib.mkDefault no;
              AIRO_CS = lib.mkDefault no;
              WLAN_VENDOR_INTEL = lib.mkDefault no;
              IPW2100 = lib.mkDefault no;
              IPW2100_MONITOR = lib.mkDefault no;
              # IPW2100_DEBUG is not set
              IPW2200 = lib.mkDefault no;
              IPW2200_MONITOR = lib.mkDefault no;
              # IPW2200_RADIOTAP is not set
              # IPW2200_PROMISCUOUS is not set
              # IPW2200_QOS is not set
              # IPW2200_DEBUG is not set
              LIBIPW = lib.mkDefault no;
              # LIBIPW_DEBUG is not set
              IWLEGACY = lib.mkDefault no;
              IWL4965 = lib.mkDefault no;
              IWL3945 = lib.mkDefault no;

              #
              # iwl3945 / iwl4965 Debugging Options
              #
              # IWLEGACY_DEBUG is not set
              # end of iwl3945 / iwl4965 Debugging Options

              IWLWIFI = lib.mkDefault no;
              IWLWIFI_LEDS = lib.mkDefault no;
              IWLDVM = lib.mkDefault no;
              IWLMVM = lib.mkDefault no;
              IWLWIFI_OPMODE_MODULAR = lib.mkDefault no;
            };
          }
        ];
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
