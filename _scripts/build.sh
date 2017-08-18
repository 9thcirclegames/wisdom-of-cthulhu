#!/bin/bash
set -x

mkdir $TRAVIS_BUILD_DIR/build
mkdir $TRAVIS_BUILD_DIR/pdf
python $TRAVIS_BUILD_DIR/countersheet.py -r 30 -n deck -d $TRAVIS_BUILD_DIR/english.cards.csv -p $TRAVIS_BUILD_DIR/pdf $TRAVIS_BUILD_DIR/english.cards.svg > $TRAVIS_BUILD_DIR/build/standard.deck.svg