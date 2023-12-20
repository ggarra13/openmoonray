#!/usr/bin/env bash

find moonray -name 'CMakeFiles' -exec rm -rf {} \; 
find moonray -name 'cmake_install.cmake' -exec rm -rf {} \; 
find moonray -name 'Makefile2' -exec rm -rf {} \;
