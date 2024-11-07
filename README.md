# Build Fedora Bootc Images for the Raspberry Pi

This project aims at providing an easy way to build and manage Fedora bootc images for the Raspberry Pi.
Follow the instructions below to create your own.

## Customizing the OS

The OS can be customized in the Containerfile which uses the `fedora-bootc` base image and adds only a few packages on top.
The idea is to containerize applications instead of making them part of the bootc host.
This way, updates to applications are decoupled from the OS and do not require a reboot of the system.

## Build Steps

You can use the Makefile to automate most of the tasks involved:
* `make oci-image` to build the OCI image
* `make disk-image` to convert the OCI image into a disk image

Before running `make disk-image`, make sure to copy your public SSH key into the `config.toml`.

You can use the following variables to tweak the image via `make $VARIABLE=$VALUE`:
* `OCI_IMAGE` to change the reference of the OCI image (default: quay.io/vrothberg/fedora-bootc-pi:41`
* `DISK_TYPE` to change the type of the disk image (default: raw)
* `ROOTFS` to change the default filesystem of the disk image (default: xfs)
* `ARCH` to change the architecture of the OCI and disk image (default: arm64)

Changing the variables may come in handy if you desire to run the disk image in a VM before.
For more information on supported values and next steps, please refer to the [bootc-image-builder](https://github.com/osbuild/bootc-image-builder) and the [Fedora Bootc documentation](https://docs.fedoraproject.org/en-US/bootc/).

**Note**: If you are running on another platform than ARM64, the build steps will take longer due to emulation.

## Flashing an SD Card

For flashing the disk image to an SD card you may use the official Raspberry Pi [Imager](https://www.raspberrypi.com/software/) tool.
There are some additional steps required after flashing the disk, which are explained in a [great blog post by Ben Breard](https://mrguitar.net/?p=2605).
