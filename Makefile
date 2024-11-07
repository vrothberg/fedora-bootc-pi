OCI_IMAGE ?= quay.io/vrothberg/fedora-bootc-pi:41
DISK_TYPE ?= raw
ROOTFS ?= xfs
ARCH ?= arm64
BIB_IMAGE ?= quay.io/centos-bootc/bootc-image-builder:latest

.PHONY: oci-image
oci-image:
	podman build --platform linux/$(ARCH) -t $(OCI_IMAGE) .

# See https://github.com/osbuild/bootc-image-builder
.PHONY: disk-image
disk-image:
	mkdir -p ./output
	podman run \
		--rm \
		-it \
		--privileged \
		--pull=newer \
		--security-opt label=type:unconfined_t \
		-v ./config.toml:/config.toml:ro \
		-v ./output:/output \
		-v /var/lib/containers/storage:/var/lib/containers/storage \
		$(BIB_IMAGE) \
		--target-arch $(ARCH) \
		--type $(DISK_TYPE) \
		--rootfs $(ROOTFS) \
		--local \
		$(OCI_IMAGE)

.PHONY: firmware
firmware:
	mkdir -p firmware-files
	podman run --platform linux/$(ARCH) --pull=never -it --rm -v ./firmware-files:/tmp/efi -v ./tools:/tools $(OCI_IMAGE) /tools/fetch_efi.sh
