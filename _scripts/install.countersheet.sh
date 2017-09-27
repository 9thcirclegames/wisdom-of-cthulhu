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

#wget -N https://github.com/lifelike/countersheetsextension/archive/master.zip -P /tmp/countersheetsextension/
#unzip -o -j "/tmp/countersheetsextension/master.zip" "countersheetsextension-master/countersheet.py" -d "$BUILD_DIR/"
#rm /tmp/countersheetsextension/master.zip

#wget -N https://github.com/lifelike/countersheetsextension/archive/6845bda4c0cdfc887a1d82a02f00755ab241590c.zip -P /tmp/countersheetsextension/
#tar xzf /tmp/countersheetsextension/6845bda4c0cdfc887a1d82a02f00755ab241590c.zip -C $BUILD_DIR/ --strip-components 1 countersheetsextension-6845bda4c0cdfc887a1d82a02f00755ab241590c/countersheet.py
#wget -N https://github.com/lifelike/countersheetsextension/archive/2.0.tar.gz -P /tmp/countersheetsextension/
#tar xzf /tmp/countersheetsextension/2.0.tar.gz -C $BUILD_DIR/ --strip-components 1 countersheetsextension-2.0/countersheet.py
#rm /tmp/countersheetsextension/*.*
