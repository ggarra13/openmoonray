#!/usr/bin/env bash

find moonray -name 'CMakeFiles' -exec rm -rf {} \; 
find moonray -name 'cmake_install.cmake' -exec rm -rf {} \; 
find moonray -name 'Makefile2' -exec rm -rf {} \;
find moonray -name 'Makefile' -exec rm -rf {} \;
find moonray -name 'build.make' -exec rm -rf {} \;
