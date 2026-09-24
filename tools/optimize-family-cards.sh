#!/bin/sh
# Run after render-family-cards.swift to quantize full-color originals.
# Preserve the published filenames while applying pngquant's default dithering.
set -eu
cd "$(dirname "$0")/.."
command -v pngquant >/dev/null
command -v oxipng >/dev/null
for image in images/families/*.png; do
  pngquant --force --ext .png 24 "$image"
done
oxipng --opt max images/families/*.png
