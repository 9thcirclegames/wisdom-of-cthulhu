#!/bin/bash
set -x

mkdir $TRAVIS_BUILD_DIR/build.en
mkdir $TRAVIS_BUILD_DIR/pdf.en

mkdir $TRAVIS_BUILD_DIR/build.it
mkdir $TRAVIS_BUILD_DIR/pdf.it

python $TRAVIS_BUILD_DIR/countersheet.py -r 30 -n deck -d $TRAVIS_BUILD_DIR/english.cards.csv -p $TRAVIS_BUILD_DIR/pdf.en $TRAVIS_BUILD_DIR/english.cards.svg > $TRAVIS_BUILD_DIR/build.en/standard.deck.svg

pdfunite *.pdf standard.en.pdf

shopt -s extglob 
$ rm -- !(standard.en.pdf)