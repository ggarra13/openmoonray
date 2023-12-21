#!/usr/bin/env bash
# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

cd building/Ubuntu22

source install_variables.sh

cd $SOURCE
source $PWD/install/openmoonray/scripts/setup.sh


#hd_usd2rdl -in $HOME/assets/Kitchen_set/Kitchen_set.usd -out Kitchen_st.rdlb
#moonray_gui -in Kitchen_st.rdlb -out test.exr

#hd_render -in $HOME/assets/Kitchen_set/Kitchen_set.usd -out test.exr
echo hd_usd2rdl -in $HOME/assets/ALab/entry.usda -out ALab.rdlb


echo hd_render -in $HOME/assets/ALab/entry.usda -out ALab.exr
