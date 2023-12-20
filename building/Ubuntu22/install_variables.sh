#!/bin/env bash

#
# Source this file to set variables
#
export PROCS=$(nproc)

for i in $@; do
    case $i in
	-j)
	    shift
	    export PROCS=$1
	    break
    esac
done
export START=$PWD

ROOT=../../
cd $ROOT

export SOURCE=$PWD                         # source directory
export BUILD=$PWD/BUILD                    # build directory
export BUILD_INSTALL=$PWD/install          # dependencies install
export BUILD_MOONRAY=$PWD/BUILD_moonray    # build moonray directory
export INSTALL=$PWD/install                # final install
export PATH=$INSTALL/cmake-3.23.1-linux-x86_64/bin:${PATH}

echo "BUILD=$BUILD"
echo "BUILD_INSTALL (deps)=$BUILD_INSTALL"
echo "BUILD_MOONRAY=$BUILD_MOONRAY"
echo "INSTALL=$INSTALL"
echo "PATH=$PATH"

