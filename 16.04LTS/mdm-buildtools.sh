#!/bin/bash
sudo apt update

sudo apt-get install build-essential chrpath coreutils cvs desktop-file-utils diffstat docbook-utils fakeroot g++-4.8 gawk gcc-4.8 git git-core help2man libgmp3-dev libmpfr-dev libreadline6-dev libtool libxml2-dev make python-pip python-pysqlite2 quilt sed subversion texi2html texinfo unzip wget
sudo apt install  libgtk2.0-bin


sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 10
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 9
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 9



