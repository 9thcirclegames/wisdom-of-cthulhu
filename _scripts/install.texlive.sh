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

# See if there is a cached version of TL available
export PATH=$HOME/texlive/bin/x86_64-linux:$PATH
if ! command -v texlua > /dev/null; then
  # Obtain TeX Live
  wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz -P $BUILD_DIR/
  tar -xzf $BUILD_DIR/install-tl-unx.tar.gz
  $BUILD_DIR/install-tl-20*/install-tl --profile=$BUILD_DIR/texlive.profile
fi

tlmgr init-usertree

# Required to build plain and LaTeX formats:
tlmgr install luatex cm etex knuth-lib latex-bin tex tex-ini-files unicode-data xetex

# Additional requirements for (u)pLaTeX
tlmgr install babel ptex uptex ptex-base uptex-base ptex-fonts uptex-fonts platex uplatex

# Assuming a 'basic' font set up, metafont is required to avoid
# warnings with some packages and errors with others
tlmgr install metafont mfware

# Set up graphics: nowadays split over a few places and requiring
# HO's bundle
tlmgr install graphics graphics-cfg graphics-def oberdiek

# Other contrib packages: done as a block to avoid multiple calls to tlmgr
# Dependencies other than the core l3build set up, metafont, fontspec and the
# 'graphics stack' (itself needed by fontspec) are listed below
tlmgr install --no-depends cjk

tlmgr install   \
  adobemapping  \
  amsfonts      \
  amsmath       \
  chemgreek     \
  cjkpunct      \
  ctablestack   \
  ec            \
  environ       \
  etoolbox      \
  fandol        \
  filehook      \
  ifxetex       \
  lm-math       \
  lualatex-math \
  luatexbase    \
  luatexja      \
  ms            \
  pgf           \
  tools         \
  trimspaces    \
  ucharcat      \
  ulem          \
  units         \
  xcolor        \
  xecjk         \
  xkeyval       \
  xunicode      \
  zhmetrics     \
  zhnumber      \
  inputenc      \
  fixltx2e      \
  epigraph      \
  fancyhdr

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0

# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install
