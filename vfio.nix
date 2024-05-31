{ pkgs, lib, config, ... }: {
  options = with lib; {
    vfio = {
      enable = mkEnableOption "Configure the machine for VFIO";
      vms = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "The names of the VMs to configure";
      };
      devices.kernelModules = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "The modules for the passed through devices";
      };
      devices.ids = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "The IDs for the passed through devices";
      };
      devices.pciIds = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "The PCI IDs for the passed through devices";
      };
    };
  };

  config =
    let 
      cfg = config.vfio;
    in lib.mkIf cfg.enable {
      services.udev = builtins.listToAttrs(
        map(id: {
          name = "extraRules";
          value = ''
            TAG=="seat", ENV{ID_FOR_SEAT}=="drm-pci-${builtins.replaceStrings ["." ":"] ["_" "_"] id}", ENV{ID_SEAT}="seat1", TAG-="master-of-seat"
            SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0666"
          '';
        })
      cfg.devices.pciIds);

      boot = {
        extraModulePackages = with config.boot.kernelPackages; [
          kvmfr
        ];

        initrd.kernelModules = [
          "vfio_pci"
          "vfio"
          "kvmfr"
        ] ++ cfg.devices.kernelModules;

        kernelParams = [
          "amd_iommu=on"
          "nosimplefb=1"
          "iommu=pt"
          "vfio_iommu_type1.allow_unsafe_interrupts=1"
          "kvm.ignore_msrs=1"
          "pci=realloc"
          "clock=tsc"
          ''vfio-pci.ids=${"vfio-pci.ids=" + lib.concatStringsSep "," cfg.devices.ids}''
        ];
      };

      virtualisation.spiceUSBRedirection.enable = true;
      virtualisation.libvirtd = {
        enable = true;
        qemu.verbatimConfig = ''
        cgroup_device_acl = [
          "/dev/null",
          "/dev/full",
          "/dev/zero",
          "/dev/random",
          "/dev/urandom",
          "/dev/ptmx",
          "/dev/kvm",
          "/dev/kqemu",
          "/dev/rtc",
          "/dev/hpet",
          "/dev/kvmfr0"
        ]
        '';

      hooks.qemu = builtins.listToAttrs(
        map(
          vm: {
            name = vm; 
            value = pkgs.writeShellScript vm 
              (''
              set -x

              if [ "$1" != "${vm}" ]; then
                exit
              fi

              case $2 in
                prepare)
              '' 
              +
              (lib.concatLines (
                map(
                  kernelModule: "  modprobe -r ${kernelModule}"
                ) (lib.reverseList cfg.devices.kernelModules)
              ))
              +
              ''

                modprobe kvmfr static_size_mb=32
              ''
              +
              (lib.concatLines (
                map(
                  id: ''  echo "${builtins.replaceStrings [":"] [" "] id}" > /sys/bus/pci/drivers/vfio-pci/new_id''
                ) cfg.devices.ids
              ))
              +
              ''

                echo 1 > /sys/bus/pci/rescan
      
                systemctl set-property --runtime -- user.slice AllowedCPUs=0,1
                systemctl set-property --runtime -- system.slice AllowedCPUs=0,1
                systemctl set-property --runtime -- init.scope AllowedCPUs=0,1
                ;;

                release)
              ''
              +
              (lib.concatLines (
                map(
                  pciId: 
                    ''
                      virsh nodedev-detach pci_${builtins.replaceStrings ["." ":"] ["_" "_"] pciId}
                      echo 1 > /sys/bus/pci/devices/${pciId}/remove
                    ''
                ) cfg.devices.pciIds 
              ))
              +
              (lib.concatLines (
                map(
                  id: ''  echo "${builtins.replaceStrings [":"] [" "] id}" > /sys/bus/pci/drivers/vfio-pci/remove_id''
                ) cfg.devices.ids
              ))
              +
              ''

                echo 1 > /sys/bus/pci/rescan
              ''
              +
              (lib.concatLines (
                map(
                  kernelModule: "  modprobe ${kernelModule}"
                ) cfg.devices.kernelModules
              ))
              +
              ''

                nvidia-xconfig --query-gpu-info > /dev/null 2>&1

                systemctl set-property --runtime -- user.slice AllowedCPUs=0-15
                systemctl set-property --runtime -- system.slice AllowedCPUs=0-15
                systemctl set-property --runtime -- init.scope AllowedCPUs=0-15

                echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
                ;;
              esac
            '');
          }
        ) cfg.vms
      );
    };
    environment.sessionVariables = {
      __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa_drivers}/share/glvnd/egl_vendor.d/50_mesa.json";
    };
  };
}

