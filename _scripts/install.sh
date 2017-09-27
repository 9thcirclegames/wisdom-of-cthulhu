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

# See if there is a cached version of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
if ! command -v texlua > /dev/null; then
  # Obtain TeX Live
  wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz -P $BUILD_DIR/
  tar -xzf $BUILD_DIR/install-tl-unx.tar.gz
  $BUILD_DIR/install-tl-20*/install-tl --profile=$BUILD_DIR/texlive.profile

  cd ..
fi

# Needed for any use of texlua even if not testing LuaTeX
tlmgr install luatex

# The test framework itself
tlmgr install l3build

# Required to build plain and LaTeX formats:
# TeX90 plain for unpacking, pdfLaTeX, LuaLaTeX and XeTeX for tests
tlmgr install cm etex knuth-lib latex-bin tex tex-ini-files unicode-data \
  xetex

# Additional requirements for (u)pLaTeX, done with no dependencies to
# avoid large font payloads
tlmgr install babel ptex uptex ptex-base uptex-base ptex-fonts \
  uptex-fonts platex uplatex

# Assuming a 'basic' font set up, metafont is required to avoid
# warnings with some packages and errors with others
tlmgr install metafont mfware


# Set up graphics: nowadays split over a few places and requiring
# HO's bundle
tlmgr install graphics graphics-cfg graphics-def oberdiek

# Other contrib packages: done as a block to avoid multiple calls to tlmgr
# Dependencies other than the core l3build set up, metafont, fontspec and the
# 'graphics stack' (itself needed by fontspec) are listed below
tlmgr install --no-depends \
  chemformula \
  ctex        \
  mhchem      \
  siunitx     \
  unicode-math
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
  zhnumber

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0

# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install
