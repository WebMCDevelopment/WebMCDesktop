#!/bin/bash

ARGS="$*"

if [ -z "$ARGS" ]; then
  echo "Usage: ./build.sh [--win] [--linux] [--mac] [--universal]"
  exit 1
fi

mkdir -p build
curl -fsSL "https://webmc.xyz/assets/img/webmc.png" -o "./build/icon.png"
if [[ $? -ne 0 ]]; then
  echo "Failed to download icon."
  exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  mkdir -p build/icon.iconset
  sips -z 16 16     build/icon.png --out build/icon.iconset/icon_16x16.png
  sips -z 32 32     build/icon.png --out build/icon.iconset/icon_16x16@2x.png
  sips -z 32 32     build/icon.png --out build/icon.iconset/icon_32x32.png
  sips -z 64 64     build/icon.png --out build/icon.iconset/icon_32x32@2x.png
  sips -z 128 128   build/icon.png --out build/icon.iconset/icon_128x128.png
  sips -z 256 256   build/icon.png --out build/icon.iconset/icon_128x128@2x.png
  sips -z 256 256   build/icon.png --out build/icon.iconset/icon_256x256.png
  sips -z 512 512   build/icon.png --out build/icon.iconset/icon_256x256@2x.png
  sips -z 512 512   build/icon.png --out build/icon.iconset/icon_512x512.png
  cp build/icon.png build/icon.iconset/icon_512x512@2x.png
  iconutil -c icns build/icon.iconset -o build/icon.icns
fi

npx electron-builder $ARGS