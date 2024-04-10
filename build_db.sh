#!/usr/bin/env bash
#
# Script for building the NurdzLinux Core Repository

echo $0
full_path=$(realpath $0)
dir_path=$(dirname $full_path)

any_dir=$HOME/Dev/NurdzLinux/nurdzlinux-pkgbuild/any
any_pkgbuild=$(find ${any_dir} -type f -name "*.pkg.tar.zst" | awk -F / 'BEGIN {OFS="/"} {$1=""; print $0}')

x86_dir=$HOME/Dev/NurdzLinux/nurdzlinux-pkgbuild/x86_64
x86_pkgbuild=$(find ${x86_dir} -type f -name "*.pkg.tar.zst" | awk -F / 'BEGIN {OFS="/"} {$1=""; print $0}')

for x in ${any_pkgbuild}; do
	mv ${x} any/
	echo "Moving ${x}"
done

for x in ${x86_pkgbuild}; do
	mv ${x} x86_64/
	echo "Moving ${x}"
done

echo "###########################"
echo "Building the repo database."
echo "###########################"

## Arch: any
cd any
rm nurdzlinux-core-repo*

echo "################################"
echo "Building for architecture 'any'."
echo "################################"

## repo-add
## -s: signs the packages
## -n: only add new packages not already in database
## -R: remove old package files when updating their entry
repo-add -n -R nurdzlinux-core-repo.db.tar.gz *.pkg.tar.zst

# Removing the symlinks because GitHub can't handle them.
rm nurdzlinux-core-repo.db nurdzlinux-core-repo.db.sig nurdzlinux-core-repo.files nurdzlinux-core-repo.files.sig

# Renaming the tar.gz files without the extension.
mv nurdzlinux-core-repo.db.tar.gz nurdzlinux-core-repo.db
mv nurdzlinux-core-repo.db.tar.gz.sig nurdzlinux-core-repo-db.sig
mv nurdzlinux-core-repo.files.tar.gz nurdzlinux-core-repo.files
mv nurdzlinux-core-repo.files.tar.gz.sig nurdzlinux-core-repo.files.sig

echo "#######################################"
echo "Packages in the repo have been updated!"
echo "#######################################"

## Arch: x86_64
cd ../x86_64
rm nurdzlinux-core-repo*

echo "###################################"
echo "Building for architecture 'x86_64'."
echo "###################################"

## repo-add
## -s: signs the packages
## -n: only add new packages not already in database
## -R: remove old package files when updating their entry
repo-add -n -R nurdzlinux-core-repo.db.tar.gz *.pkg.tar.zst

# Removing the symlinks because GitHub can't handle them.
rm nurdzlinux-core-repo.db nurdzlinux-core-repo.db.sign nurdzlinux-core-repo.files nurdzlinux-core-repo.files.sig

# Renaming the tar.gz files without the extension.
mv nurdzlinux-core-repo.db.tar.gz nurdzlinux-core-repo.db
mv nurdzlinux-core-repo.db.tar.gz.sign nurdzlinux-core-repo-db.sig
mv nurdzlinux-core-repo.files.tar.gz nurdzlinux-core-repo.files
mv nurdzlinux-core-repo.files.tar.gz.sig nurdzlinux-core-repo.files.sig

echo "#######################################"
echo "Packages in the repo have been updated!"
echo "#######################################"
