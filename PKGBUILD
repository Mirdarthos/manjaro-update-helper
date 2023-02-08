# Maintainer: Mirdarthos <mirdarthos@duck.com>

pkgname=mumuh
pkgver=v2.0.RC11
pkgrel=1
pkgdesc="My Universal Manjaro Update Helper (mumuh) is a helper for updating your Manjaro Linux."
url="https://github.com/Mirdarthos/manjaro-update-helper"
license=('Apache 2.0')

depends=('xsel' 'ncurses' 'pamac-cli' 'pacman' 'inxi' 'meld')
checkdepends=('xsel' 'ncurses' 'pamac-cli' 'pacman' 'inxi' 'meld')

source=("mumuh.zip+https://github.com/Mirdarthos/manjaro-update-helper/archive/refs/heads/master.zip")
md5sum=('4231ad74ff3775fc8e5a400c273b8c25')

package() {
    cd "$srcdir"
    install --owner=root --group=root --mode=0644 "${srcdir}/usr/bin/system_update_script.sh" --target-directory="/usr/bin/system_update_script.sh"
    install --owner=root --group=root --mode=0644 "${srcdir}/usr/applications/mumuh.desktop" --target-directory="/usr/applications/mumuh.desktop"
}