#!/bin/bash
set -x

wget https://github.com/lifelike/countersheetsextension/archive/2.0.zip -P /tmp/countersheetsextension/
unzip -j "/tmp/countersheetsextension/2.0.zip" "countersheet.py" -d $TRAVIS_BUILD_DIR/



