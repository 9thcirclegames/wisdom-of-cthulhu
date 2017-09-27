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

# See if there is a cached version of pandoc already available
export PATH=$HOME/.local/bin:$PATH
if ! command -v pandoc > /dev/null; then
# Install stack
  wget https://hackage.haskell.org/package/pandoc-1.19.2.4/pandoc-1.19.2.4.tar.gz -P $BUILD_DIR/
  tar $BUILD_DIR/xvzf pandoc-1.19.2.4.tar.gz
  cd $BUILD_DIR/pandoc-1.19.2.4
  wget -qO- https://get.haskellstack.org/ | sh
  stack setup
  stack install --test
fi
