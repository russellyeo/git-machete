#!/usr/bin/env bash

set -e -o pipefail -u

git clone https://aur.archlinux.org/git-machete.git
cd git-machete/

sed -i "s/.*pytest  *-m.*/  pytest --numprocesses=auto -m 'not completion_e2e' -vv/" PKGBUILD
sed -i "s/checkdepends=.*/checkdepends=('python-pytest' 'python-pytest-mock' 'python-pytest-xdist')/" PKGBUILD
sed -i "s/pkgver=.*/pkgver=0.0.0/" PKGBUILD

url=https://github.com/VirtusLab/git-machete/archive/$GIT_REVISION.tar.gz
sed -i "s!::[^\"]*!::$url!" PKGBUILD
sed -i "s!cd ..srcdir/.pkgname-..pkgver..!ls -l \$srcdir/; cd \$srcdir/git-machete-$GIT_REVISION!" PKGBUILD
hash=$(curl -L -s $url | sha256sum | head -c 64)
sed -i "s/sha256sums=.*/sha256sums=('$hash')/" PKGBUILD
cat PKGBUILD

makepkg --syncdeps --log --install --clean --noconfirm
