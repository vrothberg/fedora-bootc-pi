OCI_IMAGE ?= quay.io/vrothberg/fedora-bootc-pi:41
DISK_TYPE ?= raw
ROOTFS ?= xfs
ARCH ?= arm64

.PHONY: oci-image
oci-image:
	podman build --platform linux/$(ARCH) -t $(OCI_IMAGE) .

# See https://github.com/osbuild/bootc-image-builder
.PHONY: disk-image
disk-image: oci-image
	podman run \
		--rm \
		-it \
		--privileged \
		--pull=newer \
		--security-opt label=type:unconfined_t \
		-v ./config.toml:/config.toml:ro \
		-v ./output:/output \
		-v /var/lib/containers/storage:/var/lib/containers/storage \
		quay.io/centos-bootc/bootc-image-builder:latest \
		--target-arch $(ARCH) \
		--type $(DISK_TYPE) \
		--rootfs $(ROOTFS) \
		--local \
		$(OCI_IMAGE)
