# Maintainer: Mirdarthos mirdarthos[at]duck[dot]com

pkgname=mumuh
pkgver=v2.0.RC12
pkgrel=1
pkgdesc="a Helper for updating your Manjaro Linux."
arch=('any')
url="https://github.com/Mirdarthos/manjaro-update-helper"
license=('Apache 2.0')
depends=('xsel' 'ncurses' 'pamac-cli' 'pacman' 'inxi' 'meld')
makedepends=('unzip')
optdepends=('timeshift: For creating backups with prior to updating.')

source=("mumuh.zip::https://github.com/Mirdarthos/manjaro-update-helper/archive/refs/heads/master.zip")
sha256sums=('9769a8fdfb5e15678a7d5235a243d268c2a050689603b0c2f18d191180518522')

conflicts=()
replaces=()
backup=()

package() {
    unzip mumuh.zip -d /tmp
    cd "/tmp" || exit
    sudo install --owner=root --group=root --mode=0644 "${srcdir}/src/usr/bin/system_update_script.sh" --target-directory="/usr/bin/"
    sudo install --owner=root --group=root --mode=0644 "${srcdir}/src/usr/applications/mumuh.desktop" --target-directory="/usr/share/applications/"
}
