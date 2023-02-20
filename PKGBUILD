# Maintainer: Mirdarthos mirdarthos[at]duck[dot]com

pkgname=my-universal-manjaro-update-helper
pkgver=2.3.1
pkgrel=1
pkgdesc="A helper for updating Manjaro Linux."
arch=('any')
url="https://github.com/Mirdarthos/manjaro-update-helper"
license=('Apache')
depends=('xclip' 'ncurses' 'pamac-cli' 'pacman' 'inxi' 'meld' 'pacman-mirrors')
optdepends=('timeshift: For creating backups with prior to updating if custom command not specified.')
source=("$pkgname-$pkgver.tar.gz::$url/archive/refs/tags/V$pkgver.tar.gz")
sha256sums=('41fcdaae7318eb776573810c1ceacb082769df1fd62bbd32027d5055638156b8')

package() {
    cd manjaro-update-helper-$pkgver
    install -Dm755 src/usr/bin/mumuh -t "$pkgdir/usr/bin/"
}
