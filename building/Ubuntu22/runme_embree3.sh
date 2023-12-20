#!/usr/bin/env bash

source install_variables.sh

mkdir -p $BUILD
cd $BUILD
git clone https://github.com/embree/embree embree3 --branch v3.0.0
cd embree3
mkdir build
cd build
cmake .. -D CMAKE_INSTALL_PREFIX=$INSTALL \
      -DEMBREE_ISPC_SUPPORT=OFF \
      -DEMBREE_IGNORE_INVALID_RAYS=ON \
      -DEMBREE_RAY_MASK=ON \
      -DEMBREE_TUTORIALS=OFF \
      -DBUILD_SHARED_LIBS=ON
make -j $(nproc)
make install
cd $START
