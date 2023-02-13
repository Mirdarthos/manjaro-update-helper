# Maintainer: Mirdarthos mirdarthos[at]duck[dot]com

pkgname=my-universal-manjaro-update-helper
pkgver=2.1
pkgrel=1
pkgdesc="A helper for updating Manjaro Linux."
arch=('any')
url="https://github.com/Mirdarthos/manjaro-update-helper"
license=('Apache')
depends=('xsel' 'ncurses' 'pamac-cli' 'pacman' 'inxi' 'meld')
optdepends=('timeshift: For creating backups with prior to updating if custom command not specified.')
source=("$pkgname-$pkgver.tar.gz::$url/archive/refs/tags/V$pkgver.tar.gz")
sha256sums=('3af96ecfa322e05b5ca5e216abf1fc879f62466e58ec79e255a4b44a01ed2b70')

package() {
    cd manjaro-update-helper-$pkgver
    install -Dm755 src/usr/bin/mumuh -t "$pkgdir/usr/bin/"
}
