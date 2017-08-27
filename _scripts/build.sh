#!/bin/bash
set -x

sed -i 'y/āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜĀÁǍÀĒÉĚÈĪÍǏÌŌÓǑÒŪÚǓÙǕǗǙǛ/aaaaeeeeiiiioooouuuuuuuuAAAAEEEEIIIIOOOOUUUUUUUU/' $TRAVIS_BUILD_DIR/english.cards.csv

mkdir $TRAVIS_BUILD_DIR/build
mkdir $TRAVIS_BUILD_DIR/pdf

python $TRAVIS_BUILD_DIR/countersheet.py -r 30 -n deck -d $TRAVIS_BUILD_DIR/english.cards.csv -p $TRAVIS_BUILD_DIR/build $TRAVIS_BUILD_DIR/english.cards.svg > $TRAVIS_BUILD_DIR/build/en.standard.deck.svg
pdftk $TRAVIS_BUILD_DIR/build/*.pdf cat output $TRAVIS_BUILD_DIR/pdf/woc.deck.en.pdf
cp $TRAVIS_BUILD_DIR/pdf/woc.deck.en.pdf $TRAVIS_BUILD_DIR/pdf/woc.deck.en-$(date '+%Y%m%d').pdf
rm $TRAVIS_BUILD_DIR/build/*.pdf

python $TRAVIS_BUILD_DIR/countersheet.py -r 30 -n deck -d $TRAVIS_BUILD_DIR/english.cards.csv -p $TRAVIS_BUILD_DIR/build $TRAVIS_BUILD_DIR/italian.cards.svg > $TRAVIS_BUILD_DIR/build/it.standard.deck.svg
pdftk $TRAVIS_BUILD_DIR/build/*.pdf cat output $TRAVIS_BUILD_DIR/pdf/woc.deck.it.pdf
cp $TRAVIS_BUILD_DIR/pdf/woc.deck.it.pdf $TRAVIS_BUILD_DIR/pdf/woc.deck.it-$(date '+%Y%m%d').pdf
rm $TRAVIS_BUILD_DIR/build/*.pdf

# Build rules PDF
pandoc --variable urlcolor=cyan $TRAVIS_BUILD_DIR/woc.rules.en.md --variable mainfont="Liberation Serif" --variable sansfont="Liberation Sans" -o $TRAVIS_BUILD_DIR/pdf/woc.rules.en.pdf
cp $TRAVIS_BUILD_DIR/pdf/woc.rules.en.pdf $TRAVIS_BUILD_DIR/pdf/woc.rules.en-$(date '+%Y%m%d').pdf