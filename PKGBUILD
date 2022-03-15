# Maintainer: Cody Greene <cody at variable dot run>
pkgname=sdboot-kernel
pkgver='0.5'
pkgrel=1
pkgdesc='systemd-boot automation using kernel-install'
arch=(any)
url='https://github.com/cody-greene/sdboot-kernel'
license=(GPL2)
depends=(systemd findutils grep mkinitcpio)
conflicts=(systemd-boot-manager)

package() {
  cp -a ../{usr,etc} ${pkgdir}
}
