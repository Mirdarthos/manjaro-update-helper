# Maintainer: Mirdarthos mirdarthos[at]duck[dot]com
# shellcheck disable=all

pkgname=mirdarthos-universal-manjaro-update-helper
replaces=('my-universal-manjaro-update-helper')
conflicts=('my-universal-manjaro-update-helper')
pkgver=7.5
pkgrel=1
pkgdesc="A helper for updating Manjaro Linux."
arch=('any')
url="https://github.com/Mirdarthos/manjaro-update-helper"
license=('Apache')
depends=('sudo' 'xclip' 'ncurses' 'pamac-cli' 'pacman' 'inxi' 'meld' 'pacman-mirrors' 'libnotify')
optdepends=('timeshift: For creating backups with prior to updating if custom command not specified or making a backup snapshot skipped.')
source=("${pkgname}-${pkgver}.tar.gz::${url}/archive/refs/tags/V${pkgver}.tar.gz")

package() {
    cd manjaro-update-helper-$pkgver
    install -Dm755 src/usr/bin/mumuh -t "$pkgdir/usr/bin/"
}
sha256sums=('411778d366d48fa2f3a6126ad9e8b930e7543a4d39080d684ead8bd7c611873a')
