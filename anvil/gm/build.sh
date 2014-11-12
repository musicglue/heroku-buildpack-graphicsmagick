#!/bin/bash

set -e
set -o pipefail
shopt -s dotglob

compile_dir=$(pwd)

echo "Compile dir: $compile_dir"

indent ()
{
  c='s/^/       /'
  sed -u "$c"
}

heading ()
{
  echo ""
  echo "+ $1"
  echo ""
}

configure_gm ()
{
  ./configure \
    --prefix=/app/local
}

compile_gm ()
{
  make && make install
}

SOURCES_URL="https://musicglue-buildpacks.s3.amazonaws.com/source"

export PATH=/sbin:$PATH

mkdir -p /app/local /tmp/build
cd /tmp/build

heading "Fetching sources"

curl -#SL $SOURCES_URL/GraphicsMagick-1.3.20.tar.gz -o - | tar zx

cd GraphicsMagick-1.3.20 

heading "Configuring Graphics Magick"
configure_gm | indent

heading "Compiling Graphics Magick"
compile_gm | indent

cd ..

# Cleanup

rm -rf /app/local/share

rm -rf $compile_dir
mv /app/local $compile_dir

heading "Done!"
