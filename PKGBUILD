# Maintainer: Mirdarthos mirdarthos[at]duck[dot]com

pkgname=my-universal-manjaro-update-helper
pkgver=v2.0.RC12
pkgrel=1
pkgdesc="a Helper for updating your Manjaro Linux."
arch=('any')
url="https://github.com/Mirdarthos/manjaro-update-helper"
license=('Apache 2.0')
depends=('xsel' 'ncurses' 'pamac-cli' 'pacman' 'inxi' 'meld')
makedepends=()
optdepends=('timeshift: For creating backups with prior to updating.')

source=("manjaro-update-helper.zip::https://github.com/Mirdarthos/manjaro-update-helper/archive/refs/heads/master.zip")
sha256sums=('SKIP')

conflicts=()
replaces=()
backup=()

package() {
    # unzip manjaro-update-helper.zip
    sudo install --owner=root --group=root --mode=0355 "${srcdir}/manjaro-update-helper-master/src/usr/bin/mumuh" --target-directory="/usr/bin/"
    sudo rm --force --recursive "${srcdir}/manjaro-update-helper-master"
}