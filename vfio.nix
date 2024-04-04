let
  graphicsId = "10de:2560";
  audioId = "10de:228e";
  graphicsPci = "0000:01:00.0";
  audioPci = "0000:01:00.1";
  gpuIds = [
    graphicsId
    audioId
  ];
in
{ pkgs, lib, config, ... }: {
  options.vfio.enable = with lib;
    mkEnableOption "Configure the machine for VFIO";

  config =
    let cfg = config.vfio;
    in {
      services.udev.extraRules = ''
      TAG=="seat", ENV{ID_FOR_SEAT}=="drm-pci-${builtins.replaceStrings ["." ":"] ["_" "_"] graphicsPci}", ENV{ID_SEAT}="seat1", TAG-="master-of-seat"
      SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0666"
      '';
      
      boot = {
        extraModulePackages = with config.boot.kernelPackages; [
          kvmfr
        ];

        initrd.kernelModules = [
          "vfio_pci"
          "vfio"
          "nouveau"
          "kvmfr"
        ];

        kernelParams = [
          "amd_iommu=on"
          "nosimplefb=1"
          "iommu=pt"
          "vfio_iommu_type1.allow_unsafe_interrupts=1"
          "kvm.ignore_msrs=1"
          "pci=realloc"
          "clock=tsc"
        ] ++ lib.optional cfg.enable
          ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIds);
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
        hooks.qemu.win11 = pkgs.writeShellScript "win11" ''
          set -x

          if [ "$1" != "win11" ]; then
            exit
          fi

          case $2 in
          prepare)
              modprobe -r nouveau 

              modprobe kvmfr static_size_mb=32

              echo "${builtins.replaceStrings [":"] [" "] graphicsId}" > /sys/bus/pci/drivers/vfio-pci/new_id
              echo "${builtins.replaceStrings [":"] [" "] audioId}" > /sys/bus/pci/drivers/vfio-pci/new_id

              echo 1 > /sys/bus/pci/rescan
  
              systemctl set-property --runtime -- user.slice AllowedCPUs=0,1
              systemctl set-property --runtime -- system.slice AllowedCPUs=0,1
              systemctl set-property --runtime -- init.scope AllowedCPUs=0,1
              ;;

            release)    
              virsh nodedev-detach pci_${builtins.replaceStrings ["." ":"] ["_" "_"] graphicsPci}
              virsh nodedev-detach pci_${builtins.replaceStrings ["." ":"] ["_" "_"] audioPci}
  
              echo 1 > /sys/bus/pci/devices/${graphicsPci}/remove
              echo 1 > /sys/bus/pci/devices/${audioPci}/remove
  
              echo "${builtins.replaceStrings [":"] [" "] graphicsId}" > /sys/bus/pci/drivers/vfio-pci/remove_id
              echo "${builtins.replaceStrings [":"] [" "] audioId}" > /sys/bus/pci/drivers/vfio-pci/remove_id

              echo 1 > /sys/bus/pci/rescan

              modprobe nouveau 

              systemctl set-property --runtime -- user.slice AllowedCPUs=0-15
              systemctl set-property --runtime -- system.slice AllowedCPUs=0-15
              systemctl set-property --runtime -- init.scope AllowedCPUs=0-15

              echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
              ;;
            esac
        '';
      };
      environment.sessionVariables = {
        __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa_drivers}/share/glvnd/egl_vendor.d/50_mesa.json";
      };
    };
}

