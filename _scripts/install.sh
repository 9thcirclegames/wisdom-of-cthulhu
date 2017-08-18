#!/bin/bash
set -x

wget https://github.com/lifelike/countersheetsextension/archive/2.0.zip -P /tmp/countersheetsextension/
unzip /tmp/countersheetsextension/2.0.zip -d $TRAVIS_BUILD_DIR/

export PYTHONPATH /usr/local/lib/python:/usr/share/inkscape/extensions/:$PYTHONPATH



