#!/bin/bash
set -e

if ! [ -d "dist/linux-unpacked" ]; then
  # echo "App not found, please build first."
  # exit 1
  npm install
  ./build.sh --linux --x64
fi

if ! command -v flatpak &> /dev/null; then
  apt update
  apt install -y flatpak flatpak-builder
fi

if ! command -v convert &> /dev/null; then
  apt install -y imagemagick
fi

if ! flatpak remotes | grep -q flathub; then
  flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
fi

if ! flatpak info org.freedesktop.Platform//23.08 &> /dev/null; then
  flatpak install -y --noninteractive --assumeyes --user flathub org.freedesktop.Platform//23.08
fi

if ! flatpak info org.freedesktop.Sdk//23.08 &> /dev/null; then
  flatpak install -y --noninteractive --assumeyes --user flathub org.freedesktop.Sdk//23.08
fi

if ! flatpak info org.electronjs.Electron2.BaseApp//23.08 &> /dev/null; then
  flatpak install -y --noninteractive --assumeyes --user flathub org.electronjs.Electron2.BaseApp//23.08
fi

if ! flatpak info org.freedesktop.Sdk.Extension.node18//23.08 &> /dev/null; then
  flatpak install -y --noninteractive --assumeyes --user flathub org.freedesktop.Sdk.Extension.node18//23.08
fi

mkdir -p tmp
cp -r dist/linux-unpacked/. tmp/app/
chmod +x tmp/app/webmc
convert build/icon.iconset/icon_512x512@2x.png -resize 512x512\! tmp/icon.png
cp WebMC.desktop tmp/
cp zypak-wrapper.sh tmp/

flatpak-builder --force-clean build-dir xyz.webmc.desktop.yml
flatpak build-export repo build-dir
flatpak build-bundle repo webmc.flatpak xyz.webmc.desktop

rm -rf .flatpak-builder
rm -rf build-dir
rm -rf repo
rm -rf tmp