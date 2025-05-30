<!-- spell-checker:ignore pacman pamac nixpkgs openmandriva conda winget openembedded yocto bblayers bitbake -->

# Installation

This is a list of uutils packages in various distributions and package managers.
Note that these are packaged by third-parties and the packages might contain
patches.

You can also [build uutils from source](build.md).

<!-- toc -->

## Cargo

[![crates.io package](https://repology.org/badge/version-for-repo/crates_io/uutils-coreutils.svg)](https://crates.io/crates/coreutils)

```shell
# Linux
cargo install coreutils --features unix --locked
# MacOs
cargo install coreutils --features macos --locked
# Windows
cargo install coreutils --features windows --locked
```

## Linux

### Alpine

[![Alpine Linux Edge package](https://repology.org/badge/version-for-repo/alpine_edge/uutils-coreutils.svg)](https://pkgs.alpinelinux.org/packages?name=uutils-coreutils)

```shell
apk update uutils-coreutils
```

> **Note**: Requires the `edge` repository.

### Arch

[![Arch package](https://repology.org/badge/version-for-repo/arch/uutils-coreutils.svg)](https://archlinux.org/packages/extra/x86_64/uutils-coreutils/)

```shell
pacman -S uutils-coreutils
```

### Debian

[![Debian package](https://repology.org/badge/version-for-repo/debian_unstable/uutils-coreutils.svg)](https://packages.debian.org/sid/source/rust-coreutils)

```shell
apt install rust-coreutils
# To use it:
export PATH=/usr/lib/cargo/bin/coreutils:$PATH
```

### Fedora

[![Fedora package](https://repology.org/badge/version-for-repo/fedora_rawhide/uutils-coreutils.svg)](https://packages.fedoraproject.org/pkgs/rust-coreutils/uutils-coreutils)

```shell
dnf install uutils-coreutils
# To use it:
export PATH=/usr/libexec/uutils-coreutils:$PATH
```

### Gentoo

[![Gentoo package](https://repology.org/badge/version-for-repo/gentoo/uutils-coreutils.svg)](https://packages.gentoo.org/packages/sys-apps/uutils-coreutils)

```shell
emerge -pv sys-apps/uutils-coreutils
```

### Manjaro

[![Manjaro Stable package](https://repology.org/badge/version-for-repo/manjaro_stable/uutils-coreutils.svg)](https://packages.manjaro.org/?query=uutils-coreutils)
[![Manjaro Testing package](https://repology.org/badge/version-for-repo/manjaro_testing/uutils-coreutils.svg)](https://packages.manjaro.org/?query=uutils-coreutils)
[![Manjaro Unstable package](https://repology.org/badge/version-for-repo/manjaro_unstable/uutils-coreutils.svg)](https://packages.manjaro.org/?query=uutils-coreutils)

```shell
pacman -S uutils-coreutils
# or
pamac install uutils-coreutils
```

### NixOS

[![nixpkgs unstable package](https://repology.org/badge/version-for-repo/nix_unstable/uutils-coreutils.svg)](https://search.nixos.org/packages?query=uutils-coreutils)

```shell
nix-env -iA nixos.uutils-coreutils
```

### OpenMandriva Lx

[![openmandriva cooker package](https://repology.org/badge/version-for-repo/openmandriva_cooker/uutils-coreutils.svg)](https://repology.org/project/uutils-coreutils/versions)

```shell
dnf install uutils-coreutils
```

### RHEL/AlmaLinux/CENTOS Stream/Rocky Linux/EPEL 9

[![epel 9 package](https://repology.org/badge/version-for-repo/epel_9/uutils-coreutils.svg)](https://packages.fedoraproject.org/pkgs/rust-coreutils/uutils-coreutils/epel-9.html)

```shell
# Install EPEL 9 - Specific For RHEL please check codeready-builder-for-rhel-9 First then install epel
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y
# Install Core Utils
dnf install uutils-coreutils
# To use it:
export PATH=/usr/libexec/uutils-coreutils:$PATH
```

### Ubuntu

[![Ubuntu package](https://repology.org/badge/version-for-repo/ubuntu_25_04/uutils-coreutils.svg)](https://packages.ubuntu.com/source/plucky/rust-coreutils)

```shell
apt install rust-coreutils
# To use it:
export PATH=/usr/lib/cargo/bin/coreutils:$PATH
```

## MacOS

### Homebrew

[![Homebrew package](https://repology.org/badge/version-for-repo/homebrew/uutils-coreutils.svg)](https://formulae.brew.sh/formula/uutils-coreutils)

```shell
brew install uutils-coreutils
```

### MacPorts

[![MacPorts package](https://repology.org/badge/version-for-repo/macports/uutils-coreutils.svg)](https://ports.macports.org/port/coreutils-uutils/)

```
port install coreutils-uutils
```

## FreeBSD

[![FreeBSD port](https://repology.org/badge/version-for-repo/freebsd/rust-coreutils.svg)](https://repology.org/project/rust-coreutils/versions)

```sh
pkg install rust-coreutils
```

## Windows

### Winget

```shell
winget install uutils.coreutils
```

### Scoop

[Scoop package](https://scoop.sh/#/apps?q=uutils-coreutils&s=0&d=1&o=true)

```shell
scoop install uutils-coreutils
```

## Alternative installers

### Conda

[Conda package](https://anaconda.org/conda-forge/uutils-coreutils)

```
conda install -c conda-forge uutils-coreutils
```

### Yocto

[Yocto recipe](https://github.com/openembedded/meta-openembedded/tree/master/meta-oe/recipes-core/uutils-coreutils)

The uutils-coreutils recipe is provided as part of the meta-openembedded yocto layer.
Clone [poky](https://github.com/yoctoproject/poky) and [meta-openembedded](https://github.com/openembedded/meta-openembedded/tree/master), add
`meta-openembedded/meta-oe` as layer in your `build/conf/bblayers.conf` file,
and then either call `bitbake uutils-coreutils`, or use
`PREFERRED_PROVIDER_coreutils = "uutils-coreutils"` in your `build/conf/local.conf` file and
then build your usual yocto image.

## Non-standard packages

### `coreutils-uutils` (AUR)

[AUR package](https://aur.archlinux.org/packages/coreutils-uutils)

Cross-platform Rust rewrite of the GNU coreutils being used as actual system coreutils.
