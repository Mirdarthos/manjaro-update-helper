# Maintainer: Mirdarthos mirdarthos[at]duck[dot]com
# shellcheck disable=all

pkgname=my-universal-manjaro-update-helper
pkgver=4.3
pkgrel=1
pkgdesc="A helper for updating Manjaro Linux."
arch=('any')
url="https://github.com/Mirdarthos/manjaro-update-helper"
license=('Apache')
depends=('sudo' 'xclip' 'ncurses' 'pamac-cli' 'pacman' 'inxi' 'meld' 'pacman-mirrors' 'libnotify')
optdepends=('timeshift: For creating backups with prior to updating if custom command not specified.')
source=("$pkgname-$pkgver.tar.gz::$url/archive/refs/tags/V$pkgver.tar.gz")
sha256sums=('b550d3f50f21597d91dff0d2ea4c88a33b34caf70b56fd3043ce7929b311ce5f')

package() {
    cd manjaro-update-helper-$pkgver
    install -Dm755 src/usr/bin/mumuh -t "$pkgdir/usr/bin/"
}
