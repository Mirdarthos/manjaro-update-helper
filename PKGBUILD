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

source=("git+https://github.com/Mirdarthos/manjaro-update-helper.git")
sha256sums=('SKIP')

conflicts=()
replaces=()
backup=()

package() {
    sudo install --owner=root --group=root --mode=0644 "${srcdir}/manjaro-update-helper/src/usr/bin/system_update_script.sh" --target-directory="/usr/bin/"
    sudo install --owner=root --group=root --mode=0644 "${srcdir}/manjaro-update-helper/src/usr/share/applications/my-universal-manjaro-update-helper.desktop" --target-directory="/usr/share/applications/"
    sudo update-desktop-database /usr/share/applications
}