# Maintainer: Mirdarthos <mirdarthos@duck.com>

pkgname=mumuh
pkgver=v1.0.0
pkgrel=1
pkgdesc="My Universal Manjaro Update Helper (mumuh) is a helper for updating your Manjaro Linux."
url="https://github.com/Mirdarthos/manjaro-update-helper"
license=('Apache 2.0')
install=$pkgname.install

depends=('xsel' 'ncurses' 'pamac-cli' 'pacman' 'inxi' 'meld')
checkdepends=('xsel' 'ncurses' 'pamac-cli' 'pacman' 'inxi' 'meld')

source=("https://github.com/examplerepo/exampleapp/releases/download/$pkgver/$pkgname-$pkgver-linux-amd64.tar.gz")
sha256sums_x86_64=('de3edfb94d5d0ae3d027c6c743e27290fa0500da4777da57154f2acab52775bf')

package() {
    cd "$srcdir"
    install --owner=root --group=root --mode=0644 "${srcdir}/usr/bin/system_update_script.sh" --target-directory="${pkgdir}/usr/bin/system_update_script.sh"
    install --owner=root --group=root --mode=0644 "${srcdir}/usr/applications/mumuh.desktop" --target-directory="${pkgdir}/usr/applications/mumuh.desktop"
}