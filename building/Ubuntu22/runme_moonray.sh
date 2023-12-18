#!/usr/bin/env bash
# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

source install_variables.sh

#
# Build moonray
#
mkdir -p $BUILD_MOONRAY
cd $BUILD_MOONRAY
cmake $SOURCE -DPYTHON_EXECUTABLE=python3 -DBOOST_PYTHON_COMPONENT_NAME=python310 -DABI_VERSION=0 -D CMAKE_PREFIX_PATH=$BUILD_INSTALL -D CMAKE_INSTALL_PREFIX=$INSTALL -D CUDAToolkit_INCLUDE_DIR=/usr/include -D Mkl_INCLUDE_DIR=/usr
cmake --build . -j $PROCS
