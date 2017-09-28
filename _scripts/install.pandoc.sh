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
export PATH=~/.local/bin:/opt/ghc/7.10.2/bin:~/.cabal/bin:$PATH
if ! command -v pandoc > /dev/null; then
  # Install stack
  travis_retry curl -L https://www.stackage.org/stack/linux-x86_64 | tar xz --wildcards --strip-components=1 -C ~/.local/bin '*/stack'
  stack config set system-ghc --global true

  # Install pandoc
  wget https://hackage.haskell.org/package/pandoc-1.19.2.4/pandoc-1.19.2.4.tar.gz -P $BUILD_DIR/
  tar xvzf $BUILD_DIR/pandoc-1.19.2.4.tar.gz
  cd $BUILD_DIR/pandoc-1.19.2.4
  stack setup
  stack install --test
  cd ..
fi
