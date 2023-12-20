# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

#
# Create directories
#
mkdir -p $BUILD_INSTALL
mkdir -p $INSTALL/{bin,lib,include}


if [[ ! -d $INSTALL/cmake-3.23.1-linux-x86_64/bin ]]; then
    cd $INSTALL
    wget https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-linux-x86_64.tar.gz
    tar xzf cmake-3.23.1-linux-x86_64.tar.gz
fi

cd $SOURCE



install_qt=1
install_cuda=1
for i in "$@" 
do
case ${i,,} in
    --noqt|-noqt)
        install_qt=0
    ;;
    --nocuda|-nocuda)
        install_cuda=0
    ;;
    *)
        echo "Unknown option: $i"
        return 1
    ;;
esac
done


# not required if you are not building with GPU support
if [ $install_cuda -eq 1 ] 
then
    sudo apt -y install nvidia-cuda-toolkit
fi

sudo apt -y install libglvnd-dev

sudo apt -y install -y build-essential

sudo apt -y install bison flex wget git python3 python3-dev patch \
            libgif-dev libmng-dev libtiff-dev libjpeg-turbo8-dev \
            libatomic1 uuid-dev openssl libcurl4-openssl-dev \
            libfreetype-dev zlib1g-dev


sudo apt -y install libcgroup-dev
sudo apt -y install libblosc-dev
sudo apt -y install libboost-atomic-dev \
                    libboost-date-time-dev \
                    libboost-chrono-dev \
		    libboost-program-options-dev \
                    libboost-thread-dev \
		    libboost-system-dev \
		    libboost-filesystem-dev #1.75.0 -- Ubuntu 22.04 uses 1.74.0
sudo apt -y install lua5.4 liblua5.4-dev #5.4.4

# These two are newer than what moonray expects, so we build from source
# sudo apt -y install libopenvdb-dev # On ubuntu, this installs old libtbb-dev

# libtbb is a mess, as it conflicts and some dependencies of moonray expect
# libtbb-dev while others require libtbb2-dev
# sudo apt -y install libtbb-dev #2020.3 -- Ubuntu ships 2021.5.0-7ubuntu2

pip3 install tbb
sudo apt -y install liblog4cplus-dev #2.0.5
sudo apt -y install libcppunit-dev #1.15.1
sudo apt -y install libmicrohttpd-dev #0.9.72

# not required if you are not building the GUI apps
if [ $install_qt -eq 1 ]
then
    sudo apt -y install qtbase5-dev libqt5script5  # should be -dev
fi

cd $START

