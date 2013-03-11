#!/bin/sh

set -e

name=$(echo $1 | sed -e 's/\.tiff$//')

du -sh $name.tiff
convert $name.tiff $name.png
du -sh $name.png

pngcrush $name.png $name.crushed.png
mv -f $name.crushed.png $name.png
du -sh $name.png

rm -f $name.tiff
