#!/bin/bash
set -x

sed -i 'y/āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜĀÁǍÀĒÉĚÈĪÍǏÌŌÓǑÒŪÚǓÙǕǗǙǛ/aaaaeeeeiiiioooouuuuuuuuAAAAEEEEIIIIOOOOUUUUUUUU/' $TRAVIS_BUILD_DIR/data/standard.deck.csv

mkdir $TRAVIS_BUILD_DIR/build
mkdir $TRAVIS_BUILD_DIR/pdf

Rscript --no-save --no-restore --verbose $TRAVIS_BUILD_DIR/R/decks.preparation.R

python $TRAVIS_BUILD_DIR/countersheet.py -r 30 -n deck -d $TRAVIS_BUILD_DIR/data/woc.deck.en.csv -p $TRAVIS_BUILD_DIR/build $TRAVIS_BUILD_DIR/woc.deck.svg > $TRAVIS_BUILD_DIR/build/woc.deck.en.svg
pdftk $TRAVIS_BUILD_DIR/build/*.pdf cat output $TRAVIS_BUILD_DIR/pdf/woc.deck.en.pdf
rm $TRAVIS_BUILD_DIR/build/*.pdf

python $TRAVIS_BUILD_DIR/countersheet.py -r 30 -n deck -d $TRAVIS_BUILD_DIR/data/woc.deck.it.csv -p $TRAVIS_BUILD_DIR/build $TRAVIS_BUILD_DIR/woc.deck.svg > $TRAVIS_BUILD_DIR/build/woc.deck.it.svg
pdftk $TRAVIS_BUILD_DIR/build/*.pdf cat output $TRAVIS_BUILD_DIR/pdf/woc.deck.it.pdf
rm $TRAVIS_BUILD_DIR/build/*.pdf

# Build rules PDF
pandoc --variable urlcolor=cyan $TRAVIS_BUILD_DIR/woc.rules.en.md --variable mainfont="Liberation Serif" --variable sansfont="Liberation Sans" -o $TRAVIS_BUILD_DIR/pdf/woc.rules.en.pdf --latex-engine=xelatex
