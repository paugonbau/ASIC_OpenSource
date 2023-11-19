#!/bin/bash

set -e

if [ ! -d "$PDK_ROOT" ]; then
    mkdir -p "$PDK_ROOT"
fi

####################
# INSTALL IHP-SG13G2
####################

MYPDK="ihp-sg13g2"

cd /tmp || exit
#git clone --depth=1 https://github.com/IHP-GmbH/IHP-Open-PDK.git ihp
git clone https://github.com/IHP-GmbH/IHP-Open-PDK.git ihp
#git clone https://github.com/iic-jku/IHP-Open-PDK.git ihp
cd ihp || exit
#FIXME for now uses branch "dev" to get the latest releases
git checkout dev

# Some modifications/cleanup needed of stock IHP PDK
# 1) Remove the `pre_osdi` line from the examples
find . -name "*.sch" -exec sed -i '/pre_osdi/d' {} \;

# Now move to proper location
if [ -d $MYPDK ]; then
	mv $MYPDK "$PDK_ROOT"
fi

####################
# Compile .va models
####################
cd "$PDK_ROOT"/"$MYPDK"/libs.tech/ngspice/openvaf

# Compile the PSP model
OPENVAF_VERSION=$(ls "$TOOLS/$OPENVAF_NAME")
"$TOOLS/$OPENVAF_NAME/$OPENVAF_VERSION"/bin/openvaf psp103_nqs.va
