#!/bin/bash
set -x

mkdir $TRAVIS_BUILD_DIR/build
python $TRAVIS_BUILD_DIR/countersheet.py -d $TRAVIS_BUILD_DIR/english.cards.csv $TRAVIS_BUILD_DIR/english.cards.svg > test.svg