# See https://docs.fedoraproject.org/en-US/bootc
FROM quay.io/fedora/fedora-bootc:41

# Install packages on the host I really need. Everything else goes into
# containers.
RUN dnf -y install neovim git sshd

# Allow passwordless sudo for the wheel group
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel-passwordless-sudo
