# Maintainer: Cody Greene <cody at variable dot run>
pkgname=systemd-boot-kernel
pkgver=$(git describe --long --tags --dirty | sed "s/^v//;s/-/.r/;s/-/./g")
pkgrel=1
pkgdesc="systemd-boot automation using kernel-install"
arch=(any)
url="https://github.com/cody-greene/systemd-boot-kernel"
license=(GPL2)
depends=(findutils grep mkinitcpio systemd)
conflicts=(systemd-boot-manager)

package() {
  cd "$startdir"
  install -D -m755 -t "${pkgdir}/usr/bin" sdboot-kernel
  cp -a usr etc "${pkgdir}"
}

#source=("${pkgname}-${pkgver}.tgz::https://github.com/cody-greene/systemd-boot-kernel/archive/refs/tags/v${pkgver}.tar.gz")
#sha256sums=(SKIP)
