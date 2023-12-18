#!/bin/env bash

#
# Source this file to set variables
#

export START=$PWD
export PROCS=$(nproc)

ROOT=../../
cd $ROOT

export SOURCE=$PWD                         # source directory
export BUILD=$PWD/BUILD                    # build directory
export BUILD_INSTALL=$PWD/install          # dependencies install
export BUILD_MOONRAY=$PWD/BUILD_moonray    # build moonray directory
export INSTALL=$PWD/install                # final install

echo "BUILD=$BUILD"
echo "DEPS_INSTALL=$BUILD_INSTALL"
echo "BUILD_MOONRAY=$BUILD_MOONRAY"
echo "INSTALL=$INSTALL"
