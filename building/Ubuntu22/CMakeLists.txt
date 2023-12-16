# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# These ExternalProject targets can be used to download, build and
# install many of the Moonray dependencies on Ubuntu 22.04.
# The targets are chained using dependencies so that they run
# serially.  But this is really inefficient as it forces recompiles on
# silly dependencies sometimes.
#
# The build should change to take advantage of multithreading, guys!
#

cmake_minimum_required (VERSION 3.23.1)
project(openmoonray_third_party)

include(ExternalProject)

set(THIS_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(InstallRoot ${CMAKE_INSTALL_PREFIX} CACHE FILEPATH "Install root for dependencies")

ExternalProject_Add(JsonCpp
    GIT_REPOSITORY https://github.com/open-source-parsers/jsoncpp.git
    GIT_TAG 5defb4ed1a4293b8e2bf641e16b156fb9de498cc # 1.9.5
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -DBUILD_SHARED_LIBS=1
        -DPYTHON_EXECUTABLE=/usr/bin/python3
        -DJSONCPP_LIB_BUILD_SHARED:BOOL=ON
)
set(CHAIN JsonCpp)

ExternalProject_Add(OpenSubdiv
    GIT_REPOSITORY https://github.com/PixarAnimationStudios/OpenSubdiv
    GIT_TAG 8ffa2b6566be10209529d7a0d1db02a0796b160c # v3_5_0
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}
      -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
      -DCMAKE_BUILDy_TYPE=Release
      -DPYTHON_EXECUTABLE=/usr/bin/python3
      -DNO_PTEX=1 -DNO_OMP=1 -DNO_TBB=1 -DNO_CUDA=1 -DNO_GLFW_X11=1 -DNO_DOC=1
      -DNO_OPENCL=1 -DNO_CLEW=1 -DNO_REGRESSION=1 -DNO_EXAMPLES=1 -DNO_TUTORIALS=1 -DNO_GLTESTS=1 
      -DNO_MACOS_FRAMEWORK=1 -DNO_METAL=1 -DNO_TESTS=1 
    DEPENDS ${CHAIN}
)
set(CHAIN OpenSubdiv)

ExternalProject_Add(OpenEXR
    GIT_REPOSITORY https://github.com/AcademySoftwareFoundation/openexr
    GIT_TAG 8bc3741131db146ad08a5b83af9e6e48f0e94a03 # v2.5.7
    PATCH_COMMAND patch IlmBase/Half/CMakeLists.txt ${THIS_DIR}/../Imath_include_paths.patch
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -DBUILD_SHARED_LIBS=OFF
    DEPENDS ${CHAIN}
)
set(CHAIN OpenEXR)

ExternalProject_Add(Random123
    GIT_REPOSITORY https://github.com/DEShawResearch/random123
    GIT_TAG 726a093cd9a73f3ec3c8d7a70ff10ed8efec8d13 # v1.14.0
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND make install-include prefix=${InstallRoot}
    DEPENDS ${CHAIN}
)
set(CHAIN Random123)

ExternalProject_Add(ISPC
    URL https://github.com/ispc/ispc/releases/download/v1.20.0/ispc-v1.20.0-linux.tar.gz
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND cp bin/ispc ${InstallRoot}/bin
    DEPENDS ${CHAIN}
)
set(CHAIN ISPC)

ExternalProject_Add(TBB
    URL https://github.com/oneapi-src/oneTBB/archive/2020_U2.tar.gz
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND bash -c "cp build/*_release/libtbb*.* ${InstallRoot}/lib"
            COMMAND bash -c "cp -r include/tbb ${InstallRoot}/include"
    DEPENDS ${CHAIN}
)

ExternalProject_Add(OpenVDB
    GIT_REPOSITORY https://github.com/AcademySoftwareFoundation/openvdb
    GIT_TAG v9.1.0
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
      -DOPENVDB_CORE_SHARED=OFF
      -DCMAKE_CXX_STANDARD=17
      -DTBB_LIBRARYDIR=${CMAKE_PREFIX_PATH}/lib
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}
      -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
      -DBLOSC_ROOT=/usr
    DEPENDS TBB
)
set(CHAIN OpenVDB)

ExternalProject_Add(embree
    GIT_REPOSITORY https://github.com/embree/embree
    GIT_TAG 0fcb306c9176221219dd15e27fe0527ed334948f # v4.1.0
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
	-DTBB_DIR=${CMAKE_PREFIX_PATH}
        -DEMBREE_ISPC_EXECUTABLE=<INSTALL_DIR>/bin/ispc
        -DEMBREE_ISPC_SUPPORT=ON
        -DEMBREE_IGNORE_INVALID_RAYS=ON
        -DEMBREE_RAY_MASK=ON
        -DEMBREE_MAX_ISA=AVX512
        -DEMBREE_TUTORIALS=OFF
        -DBUILD_SHARED_LIBS=ON
    DEPENDS TBB
)

ExternalProject_Add(OpenColorIO
    GIT_REPOSITORY https://github.com/AcademySoftwareFoundation/OpenColorIO
    GIT_TAG 056b7b0cb0d087961e9dba75104820e44faf52a1 # v2.0.2
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -DBUILD_SHARED_LIBS=ON
        -DOCIO_BUILD_STATIC=OFF
        -DCMAKE_CXX_STANDARD=17
)
set(CHAIN OpenColorIO)

ExternalProject_Add(OpenImageIO
    GIT_REPOSITORY https://github.com/OpenImageIO/oiio
    GIT_TAG 331a323468928c8017ad048b26d47c4e57a724a7 # 2.3.20.0
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${THIS_DIR}/patches/OpenImageIO/FindJPEGTurbo.cmake ${THIS_DIR}/../../build/OpenImageIO-prefix/src/OpenImageIO/src/cmake/modules/
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=Release
        -DBoost_ROOT:PATH=/usr/
        -DOpenEXR_ROOT=<INSTALL_DIR>
        -DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
	-DBUILD_TESTING=OFF
        -DUSE_QT=0
        -DUSE_PYTHON=0
    DEPENDS OpenColorIO OpenVDB
)

ExternalProject_Add(OpenImageDenoise
    URL https://github.com/OpenImageDenoise/oidn/releases/download/v2.0.1/oidn-2.0.1.src.tar.gz
    INSTALL_DIR ${InstallRoot}
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${THIS_DIR}/patches/OpenImageDenoise/CMakeLists.txt devices/cpu/CMakeLists.txt
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -DISPC_EXECUTABLE=<INSTALL_DIR>/bin/ispc
        -DTBB_DIR=<INSTALL_DIR>
        -DTBB_ROOT=<INSTALL_DIR>
        -DOIDN_APPS=OFF
    DEPENDS TBB
)
set(CHAIN OpenImageDenoise)

ExternalProject_Add(USD
    GIT_REPOSITORY https://github.com/PixarAnimationStudios/USD
    GIT_TAG v23.11  # same as mrv2
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${THIS_DIR}/patches/USD/FindTBB.cmake ${THIS_DIR}/../../build/USD-prefix/src/USD/cmake/modules/
    INSTALL_DIR ${InstallRoot}
    CMAKE_ARGS
	-DCMAKE_VERBOSE_MAKEFILE=ON
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_CXX_FLAGS=-DTBB_ALLOCATOR_TRAITS_BROKEN
	-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_PREFIX_PATH=<INSTALL_DIR>
        -DPXR_ENABLE_PYTHON_SUPPORT=ON
        -DPXR_USE_PYTHON_3=ON
        -DTBB_USE_DEBUG_BUILD=OFF
        -DTBB_ROOT_DIR=<INSTALL_DIR>
        -DTBB_LIBRARIES=<INSTALL_DIR>/lib
        -DTBB_INCLUDE_DIRS=<INSTALL_DIR>/include ..
        -DPYTHON_LIBRARIES=/usr/lib/x86_64-linux-gnu
        -DPYTHON_INCLUDE_DIRS=/usr/include
        -DBoost_LIBRARY_DIR=/usr/lib/x86_64-linux-gnu
        -DBoost_INCLUDE_DIR=/usr/include
        -DPXR_BUILD_TESTS=OFF
        -DPXR_BUILD_EXAMPLES=OFF
        -DPXR_BUILD_TUTORIALS=OFF
        -DPXR_BUILD_USD_TOOLS=OFF
        -DPXR_ENABLE_PTEX_SUPPORT=OFF
        -DPXR_ENABLE_OPENVDB_SUPPORT=OFF  # Should this be on?
        -DPXR_BUILD_USDVIEW=OFF
        -DBoost_NO_BOOST_CMAKE=ON
        -DBoost_NO_SYSTEM_PATHS=ON
        -DTBB_SUPPRESS_DEPRECATED_MESSAGES=1
    DEPENDS TBB OpenVDB
)
set(CHAIN USD)

