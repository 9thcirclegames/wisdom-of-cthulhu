#!/bin/bash
set -x

wget https://github.com/lifelike/countersheetsextension/archive/2.0.tar.gz -P /tmp/countersheetsextension/
tar -xzf /tmp/countersheetsextension/2.0.tar.gz --strip-components 1 countersheetsextension-2.0/countersheet.py -C /target/directory $TRAVIS_BUILD_DIR/



