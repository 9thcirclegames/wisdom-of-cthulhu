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

tlmgr init-usertree

tlmgr install ptex uptex ptex-base uptex-base ptex-fonts uptex-fonts platex uplatex

# Other contrib packages: done as a block to avoid multiple calls to tlmgr
tlmgr install   \
  chemformula   \
  ctex          \
  unicode-math  \
  adobemapping  \
  cjk           \
  cjkpunct      \
  ctablestack   \
  fandol        \
  filehook      \
  lm-math       \
  lualatex-math \
  luatexbase    \
  luatexja      \
  ucharcat      \
  units         \
  xecjk         \
  zhmetrics     \
  zhnumber      \
  epigraph      \

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0

# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install
