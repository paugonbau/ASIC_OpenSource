#!/bin/bash

set -e

if [ ! -d "$PDK_ROOT" ]; then
    mkdir -p "$PDK_ROOT"
fi

####################
# INSTALL IHP-SG13G2
####################

PDK_VERSION="ihp-sg13g2"

cd /tmp || exit
#git clone --depth=1 https://github.com/IHP-GmbH/IHP-Open-PDK.git ihp
git clone https://github.com/IHP-GmbH/IHP-Open-PDK.git ihp
#git clone https://github.com/iic-jku/IHP-Open-PDK.git ihp
cd ihp || exit
#FIXME for now uses branch "dev" to get the latest releases
git checkout dev

if [ -d $PDK_VERSION ]; then
	mv $PDK_VERSION "$PDK_ROOT"
fi

# Compile .va models
####################
cd "$PDK_ROOT"/"$PDK_VERSION"/libs.tech/ngspice/openvaf

# Get OpenVAF
#FIXME compile as part of Docker build, instead of pulling executable
OPENFAV_FILE=openvaf.$(arch)
OPENFAV_URL=https://github.com/iic-jku/osic-multitool/raw/main/openvaf/$OPENFAV_FILE.gz
wget "$OPENFAV_URL" && gunzip "$OPENFAV_FILE.gz" && mv "$OPENFAV_FILE" openvaf && chmod +x openvaf

# Compile the PSP model
./openvaf psp103_nqs.va
