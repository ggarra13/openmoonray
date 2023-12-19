#!/usr/bin/env bash

source install_variables.sh

mkdir -p $BUILD
cd $BUILD
cmake $SOURCE/building/Ubuntu22 -D CMAKE_INSTALL_PREFIX=$BUILD_INSTALL
cmake --build . -- -j $PROCS 2>&1 | tee compile.log
cd $SOURCE
