pkgname=sdboot-kernel
pkgver=1.0
pkgrel=0
pkgdesc='systemd-boot automation using kernel-install'
arch=(any)
url='https://github.com/cody-greene/sdboot-kernel'
license=(GPL2)
depends=(systemd findutils mkinitcpio)
conflicts=(systemd-boot-manager)

package() {
  cp -a ../{usr,etc} ${pkgdir}
}
