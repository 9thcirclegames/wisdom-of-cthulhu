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

mkdir -p $HOME/Rlib
echo 'R_LIBS=~/Rlib' > $HOME/.Renviron
echo 'options(repos = "http://cran.rstudio.com")' > $HOME/.Rprofile
echo '.travis.yml' > $HOME/.Rbuildignore
Rscript -e 'if(!"tidyverse" %in% rownames(installed.packages())) { install.packages("tidyverse", dependencies = TRUE) }'
Rscript -e 'if(!"pacman" %in% rownames(installed.packages())) { install.packages("pacman", dependencies = TRUE) }'
Rscript -e 'update.packages(ask = FALSE, instlib = "~/Rlib")'
