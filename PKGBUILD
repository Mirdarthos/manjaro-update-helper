# Maintainer: Mirdarthos mirdarthos[at]duck[dot]com
# shellcheck disable=all

pkgname=my-universal-manjaro-update-helper
pkgver=3.2
pkgrel=1
pkgdesc="A helper for updating Manjaro Linux."
arch=('any')
url="https://github.com/Mirdarthos/manjaro-update-helper"
license=('Apache')
depends=('sudo' 'xclip' 'ncurses' 'pamac-cli' 'pacman' 'inxi' 'meld' 'pacman-mirrors' 'libnotify')
optdepends=('timeshift: For creating backups with prior to updating if custom command not specified.')
source=("$pkgname-$pkgver.tar.gz::$url/archive/refs/tags/V$pkgver.tar.gz")
sha256sums=('f7c36b407d312348159cc5b11378f16090a259eead8c1ecb37a9cd9866a0df5e')

package() {
    cd manjaro-update-helper-$pkgver
    install -Dm755 src/usr/bin/mumuh -t "$pkgdir/usr/bin/"
}
