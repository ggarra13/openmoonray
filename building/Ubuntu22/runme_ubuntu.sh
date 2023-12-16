#!/usr/bin/env bash

#
# This script to be run on Ubuntu 22.04.3 does everything for you.
# It installs system dependencies, builds cmake dependencies with a
# $BUILD/compile.log to check for errors.
#

source install_packages.sh

mkdir -p $BUILD
cd $BUILD
cmake $SOURCE/building/Ubuntu22 -D CMAKE_INSTALL_PREFIX=$BUILD_INSTALL
cmake --build . -- -j $(nproc) 2>&1 | tee compile.log
cd $SOURCE

#
# @todo: Automate download and Install Optix (user needs to be registered with
#        NVidia)
#
#cd tmp
#wget https://developer.nvidia.com/optix/downloads/7.3.0/linux64
#sudo cp -r NVIDIA-OptiX-SDK-7.3.0-linux64-x86_64/include/* /usr/local/include

#
# Build moonray
#
cd $BUILD
rm -rf *
cmake $SOURCE -DPYTHON_EXECUTABLE=python3 -DBOOST_PYTHON_COMPONENT_NAME=python310 -DABI_VERSION=0
cmake --build . -j $(nproc)
