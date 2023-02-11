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

conflicts=()
replaces=()
backup=()

package() {
    unzip mumuh.zip -d /tmp
    cd "/tmp" || exit
    sudo install --owner=root --group=root --mode=0644 "${srcdir}/src/usr/bin/system_update_script.sh" --target-directory="/usr/bin/"
    sudo install --owner=root --group=root --mode=0644 "${srcdir}/src/usr/applications/mumuh.desktop" --target-directory="/usr/share/applications/"
}
sha256sums=('e3945ed87382dbb995ea664c0674ad7c8426e1121d3d3bfc42476b7ae2a5b373')
