# Maintainer: Mirdarthos mirdarthos[at]duck[dot]com
# shellcheck disable=all

pkgname=mirdarthos-universal-manjaro-update-helper
replaces=('my-universal-manjaro-update-helper')
conflicts=('my-universal-manjaro-update-helper')
pkgver=9
pkgrel=1
pkgdesc="A helper for updating Manjaro Linux."
arch=('any')
url="https://github.com/Mirdarthos/manjaro-update-helper"
license=('Apache')
depends=('sudo' 'xclip' 'ncurses' 'pamac-cli' 'pacman' 'inxi' 'meld' 'pacman-mirrors' 'libnotify' 'pacman-contrib' 'pacutils')
optdepends=('timeshift: For creating backups with prior to updating if custom command not specified or making a backup snapshot skipped.',
            'kdialog: For displaying windowed messages where some (error) message(s) support it instead of a popup message.')
source=("${pkgname}-${pkgver}.tar.gz::${url}/archive/refs/tags/v${pkgver}.tar.gz")
package() {
    cd manjaro-update-helper-$pkgver
    install -Dm755 src/usr/bin/mumuh -t "$pkgdir/usr/bin/"
}

sha256sums=('80d83fe0a319c62e828753504f897b442733bab9c66279a9a084df2b5725f4b7')
