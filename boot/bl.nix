{ config, lib, ... }:

let
  cfg = config.nyx.boot;
in

{
  options.nyx.boot = {
    loader = lib.mkOption {
      type =  lib.types.enum [
        "systemdboot"
        "grub"
      ];
      default = "systemdboot";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.loader == "systemdboot") {
      boot.loader.systemd-boot.enable = true;
#     boot.loader.timeout = 0;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.systemd-boot.configurationLimit = 10;
    })

    (lib.mkIf (cfg.loader == "grub") {
      boot.loader.grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
#     boot.loader.timeout = 0;
      boot.loader.efi.canTouchEfiVariables = true;
    })
  ];
}
