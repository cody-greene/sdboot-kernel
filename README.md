# sdboot-kernel
A package to enable systemd-boot automation using kernel-install on Arch-based distros.

The kernel-install hooks were adapted from the AUR package originally written by Tilmann Meyer. Inspired by [eos-systemd-boot](https://gitlab.com/dalto.8/eos-systemd-boot)

The package basically does a few things:
- Overrides the mkinitcpio hooks to generate presets that work with kernel-install
- Installs hooks to automate the installation and removal of kernels using kernel-install
- Saves kernel options to /etc/kernel/cmdline to support recovery in a chroot
- Installs a hook to update systemd-boot

Compared to [systemd-boot-manager](https://gitlab.com/dalto.8/systemd-boot-manager) this:
- has no global config file itself, but kernel-install is configurable (see the man page)
- does not support "fallback" initrds
- does support multi-boot scenarios, e.g. multiple installations of the same OS with the same kernel version

[](https://systemd.io/BOOT_LOADER_SPECIFICATION)
> Note: $BOOT should be considered shared among all OS installations of a
> system. Instead of maintaining one $BOOT per installed OS (as /boot/ was
> traditionally handled), all installed OS share the same place to drop in
> their boot-time configuration.

Example partition layout:
```
+----------------------+------------------------+------------------------+
| EFI System Partition | Root filesystem #1     | Root filesystem #2     |
|                      |                        |                        |
|                      | /boot                  | /boot                  |
| /efi                 | /                      | /                      |
|----------------------|------------------------|------------------------|
| /dev/sda1            | /dev/sda2              | /dev/sda3              |
+----------------------+------------------------+------------------------+
```

Additional information:
- [kernel-install](https://man.archlinux.org/man/kernel-install.8.en)
- [machine-id](https://man.archlinux.org/man/machine-id.5)
- [systemd-boot](https://man.archlinux.org/man/systemd-boot.7)

```
Usage: sdboot-kernel [action]

Actions:
  all      Run 'initrd' & 'entries' for all available kernels
  initrd   Generate presets and run mkinitcpio, placing initrd in
           $BOOT/MACHINE_ID/KERNEL_VERSION/
  entries  Generate systemd-boot loader entries and install kernels & ucode to
           $BOOT
  remove   Remove orphaned sdboot entries and mkinitcpio presets
           note: entries for other machine-ids are untouched

$BOOT = EFI system partiton; /efi, /boot or /boot/efi
```

After installing this package and initializing, your $BOOT partition should look like this:
```
$ pacman -S sdboot-kernel

$ bootctl install

$ sdboot-kernel all

$ find /efi -type f | sort
/efi/${MACHINE_ID}/5.15.25-1-MANJARO/amd-ucode.img
/efi/${MACHINE_ID}/5.15.25-1-MANJARO/initrd
/efi/${MACHINE_ID}/5.15.25-1-MANJARO/linux
/efi/${MACHINE_ID}/5.17.0-2-MANJARO/amd-ucode.img
/efi/${MACHINE_ID}/5.17.0-2-MANJARO/initrd
/efi/${MACHINE_ID}/5.17.0-2-MANJARO/linux
/efi/EFI/BOOT/BOOTX64.EFI
/efi/EFI/systemd/systemd-bootx64.efi
/efi/loader/entries/${MACHINE_ID}-5.15.25-1-MANJARO.conf
/efi/loader/entries/${MACHINE_ID}-5.17.0-2-MANJARO.conf
/efi/loader/loader.conf
/efi/loader/random-seed

$ find /boot -type f | sort
/boot/amd-ucode.img
/boot/linux515-x86_64.kver
/boot/linux517-x86_64.kver
```

The following hooks will run when installing a kernel:
- /usr/share/libalpm/hooks/90-sdboot-kernel-initrd.hook
- /usr/share/libalpm/hooks/91-sdboot-kernel-entries.hook

And when removing a kernel:
- /usr/share/libalpm/hooks/60-sdboot-kernel-remove.hook

The following hooks from other packages are disabled:
- /usr/share/libalpm/hooks/60-mkinitcpio-remove.hook
- /usr/share/libalpm/hooks/90-mkinitcpio-install.hook
- /usr/lib/kernel/install.d/50-depmod.install
- /usr/lib/kernel/install.d/50-mkinitcpio.install
