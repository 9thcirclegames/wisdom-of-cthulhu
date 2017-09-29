#!/usr/bin/env bash

# Build Dir
if [ -n "${TRAVIS+x}" ]; then
  echo "** Executing in Travis CI environment";
  export BUILD_DIR=$TRAVIS_BUILD_DIR
 else
   if [ -n "${WOC_BUILD_DIR+x}" ]; then
     echo "** Executing in local environment; build dir set to $WOC_BUILD_DIR";
     export BUILD_DIR=$WOC_BUILD_DIR
   else
     echo "** Executing in local environment; build dir set to `pwd`"
     export BUILD_DIR=`pwd`
   fi
fi

export PATH=~/.local/bin:/opt/ghc/7.10.2/bin:~/.cabal/bin:/tmp/texlive/bin/x86_64-linux:$PATH

# Inkscape Modules Location
if [ "$(uname)" == "Darwin" ]; then
  export PYTHONPATH=/usr/local/lib/python:~/.local/lib/python2.7/site-packages:/Applications/Inkscape.app/Contents/Resources/share/inkscape/extensions:$PYTHONPATH
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  export PYTHONPATH=/usr/local/lib/python:~/.local/lib/python2.7/site-packages:/usr/share/inkscape/extensions/:$PYTHONPATH
fi

mkdir $BUILD_DIR/build
mkdir $BUILD_DIR/pdf

cp $BUILD_DIR/*.png $BUILD_DIR/build/

### English
export WOC_DECK_LOCALE=en
Rscript --no-save --no-restore $BUILD_DIR/R/decks.preparation.R

python $BUILD_DIR/countersheet.py -r 30 -n deck -d $BUILD_DIR/build/woc.deck.en.csv -p $BUILD_DIR/build $BUILD_DIR/woc.deck.svg > $BUILD_DIR/build/woc.deck.en.svg
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$BUILD_DIR/pdf/woc.deck.en.pdf $BUILD_DIR/build/*.pdf
rm $BUILD_DIR/build/*.pdf

### Italian
# This is not going to work without sudo, which is not available on container-based Travis CI
#sudo locale-gen "it_IT.UTF-8"

export WOC_DECK_LOCALE=it
Rscript --no-save --no-restore $BUILD_DIR/R/decks.preparation.R

python $BUILD_DIR/countersheet.py -r 30 -n deck -d $BUILD_DIR/build/woc.deck.it.csv -p $BUILD_DIR/build $BUILD_DIR/woc.deck.svg > $BUILD_DIR/build/woc.deck.it.svg
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$BUILD_DIR/pdf/woc.deck.it.pdf $BUILD_DIR/build/*.pdf
rm $BUILD_DIR/build/*.pdf


rm $BUILD_DIR/build/*.*

# Build rules PDF
# Due to pandoc not resizing images for some reason and I'm not motivated in debugging it, I'm going to resize images by myself
	shopt -s nullglob
	for i in icon.*.jpg icon.*.JPG icon.*.png icon.*.PNG; do

		convert $i                              \
 		-filter Lanczos                         \
    -colorspace sRGB                        \
    -units PixelsPerInch                    \
    -density 120                            \
 		-write mpr:main                         \
 		+delete                                 \
    mpr:main -resize '32x32>'  -write ${filename}-32px.${extension} +delete \
    mpr:main -resize '24x24>'  -write ${filename}-32px.${extension} +delete \
  	mpr:main -resize '16x16>'  -write ${filename}-16px.${extension} +delete \
    mpr:main -resize '12x12>'         ${filename}-12px.${extension}
	done

cp $BUILD_DIR/woc.rules.en.md $BUILD_DIR/woc.rules.en.resized.md

sed -i 's/\.png){height="12" width="12"}/-12px\.png)/g' $BUILD_DIR/woc.rules.en.resized.md
sed -i 's/\.png){height="16" width="16"}/-16px\.png)/g' $BUILD_DIR/woc.rules.en.resized.md
sed -i 's/\.png){height="24" width="24"}/-24px\.png)/g' $BUILD_DIR/woc.rules.en.resized.md
sed -i 's/\.png){height="32" width="42"}/-32ps\.png)/g' $BUILD_DIR/woc.rules.en.resized.md

pandoc $BUILD_DIR/woc.rules.en.resized.md -o $BUILD_DIR/pdf/woc.rules.en.pdf --latex-engine=xelatex
