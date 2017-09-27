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

# Inkscape Modules Location
if [ "$(uname)" == "Darwin" ]; then
  export PYTHONPATH=/usr/local/lib/python:/Applications/Inkscape.app/Contents/Resources/share/inkscape/extensions:$PYTHONPATH
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  export PYTHONPATH=/usr/local/lib/python:/usr/share/inkscape/extensions/:$PYTHONPATH
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
sudo locale-gen "it_IT.UTF-8"

export WOC_DECK_LOCALE=it
Rscript --no-save --no-restore $BUILD_DIR/R/decks.preparation.R

python $BUILD_DIR/countersheet.py -r 30 -n deck -d $BUILD_DIR/build/woc.deck.it.csv -p $BUILD_DIR/build $BUILD_DIR/woc.deck.svg > $BUILD_DIR/build/woc.deck.it.svg
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$BUILD_DIR/pdf/woc.deck.it.pdf $BUILD_DIR/build/*.pdf
rm $BUILD_DIR/build/*.pdf


rm $BUILD_DIR/build/*.*

# Build rules PDF
pandoc --variable urlcolor=cyan $BUILD_DIR/woc.rules.en.md --variable mainfont="Liberation Serif" --variable sansfont="Liberation Sans" -o $BUILD_DIR/pdf/woc.rules.en.pdf --latex-engine=xelatex
