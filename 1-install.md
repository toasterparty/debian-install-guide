# Install Debian

## Prepare Installation Media

1. Download the latest stable AMD64 Debian “netinst” image from https://www.debian.org/CD/netinst. This is v12.7.0 as of writing.

*NOTE: If you will not have an Ethernet available connection during install, you can use the offline "CD" install image from https://www.debian.org/CD/http-ftp.*

2. Download the latest portable release of **Etcher** from https://github.com/balena-io/etcher/releases. I reccommend the portable version which can be found by clicking *"Show all assets"* and downloading the file called **balenaEtcher-win32-x64-X.Y.Z.zip**

3. Insert your USB drive into your PC and use `balenaEtcher.exe` to flash your `debian-X.Y.Z-amd64-netinst.iso` file to the device.

*WARNING: This will erase the contents of your USB drive. Please backup any files before writing the image.*

## Install Debian

1. Insert the storage media into your machine and try holding different keyboard keys on boot until you are able to boot off your storage media.

2. Use the arrow keys and Enter to select your USB installation media (e.g. `UEFI: Samsung Flash Drive 1100, Partition 1`)

3. Select `Install` from the  menu and follow the prompts for one-time setup. Use the reccommended defaults with the following exceptions:

### Disk Partition

Choose `Guided - use entire disk and set up LVM`.

### Software Selection

Use the arrow keys and Space Bar to adjust until `SSH server` and `standard system utilities` are the only selected entries.
