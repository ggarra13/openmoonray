#!/usr/bin/env bash
# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

cd building/Ubuntu22

source install_variables.sh

cd $SOURCE
source $PWD/install/openmoonray/scripts/setup.sh

hd_render -in $HOME/assets/Kitchen_set/Kitchen_set.usd -out test.exr
