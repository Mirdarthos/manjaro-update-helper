# Maintainer: Mirdarthos mirdarthos[at]duck[dot]com
# shellcheck disable=all

pkgname=my-universal-manjaro-update-helper
pkgver=4.4
pkgrel=1
pkgdesc="A helper for updating Manjaro Linux."
arch=('any')
url="https://github.com/Mirdarthos/manjaro-update-helper"
license=('Apache')
depends=('sudo' 'xclip' 'ncurses' 'pamac-cli' 'pacman' 'inxi' 'meld' 'pacman-mirrors' 'libnotify')
optdepends=('timeshift: For creating backups with prior to updating if custom command not specified or making a backup snapshot skipped.')
source=("$pkgname-$pkgver.tar.gz::$url/archive/refs/tags/V$pkgver.tar.gz")

package() {
    cd manjaro-update-helper-$pkgver
    install -Dm755 src/usr/bin/mumuh -t "$pkgdir/usr/bin/"
}
sha256sums=('af1bb376bb5604298224e70032b82e433e9df8d466469b8a2808fa76b8799dfa')
