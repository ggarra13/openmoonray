#!/usr/bin/env bash

source install_variables.sh

export LD_LIBRARY_PATH=/home/gga/Qt5/5.15.2/gcc_64/lib:$LD_LIBRARY_PATH

mkdir -p $BUILD
cd $BUILD
cmake $SOURCE/building/Ubuntu22 -D CMAKE_INSTALL_PREFIX=$BUILD_INSTALL
cmake --build . -- -j $PROCS 2>&1 | tee compile.log
cd $SOURCE
