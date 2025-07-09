### Andromeda Eggs 

Andromeda Eggs ===> Based on Penguins Eggs ===> Andromeda Eggs for opensuse

## nest (/home/eggs)

* iso -> .mnt/iso
* livefs -> .mnt/filesystem.squashfs
* ovarium
* README.md
* egg-of_image.iso
* egg-of_image.md5
* egg-of_image.sha256


Under the hood all remain unchanged, but the importants things now are more visible.

## .mnt
* efi-work
* filesystem.squashfs
* iso
* memdiskDir

### efi-work
The directory efi is used to build the part for UEFI compatibility. It consist in two directories
* boot 
* efi

### filesystemfs.squashfs

This is the centre of the central zone, it consist in all the filesystem of your system, mounted  binded and overlay.
Here we will made all the operations needing to have a filesystem adapted to be compressed and put in a iso image.
Due the fact who actually is not a real copy of your filesystem, we use overlayfs to get this witable and don't cause problems at your current filesytem.
You will find in it all the filesystem you will found in your image when it is booted.

### Directory iso

It is the simple structure of an iso image.
* boot
* efi
* isolinux
* live

You already knw boot and efi, are necessary for UEFI and consist in the copy of efi.
* isolinux contain the isolinux files for the boot of the livecd.
* live contain only 3 files, vmliz, initrd.img and filesystem.squashfs who is the compressef for of the omologue directory.
