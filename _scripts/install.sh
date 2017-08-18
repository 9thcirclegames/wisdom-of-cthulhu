#!/bin/bash
set -x

sudo apt-get update -q
sudo apt-get install wget python3.6 inkscape libxml2-dev libxslt-dev python-dev zlib1g-dev pkg-config python-pip

easy_install lxml

wget https://github.com/lifelike/countersheetsextension/archive/2.0.zip -P /tmp/countersheetsextension/
unzip /tmp/countersheetsextension/2.0.zip -d ~/.config/inkscape/extensions/

