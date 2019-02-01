#!/bin/sh

if [ ! -f "/etc/apt/sources.list.bak" ]; then
	sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
	sudo sed -i s/cn.archive.ubuntu.com/mirrors.163.com/ /etc/apt/sources.list
	sudo sed -i s/security.ubuntu.com/mirrors.163.com/ /etc/apt/sources.list
fi
sudo apt-get update
sudo apt-get install vim
sudo apt-get install git
git config --global user.email "taocpp@gmail.com"
git config --global user.name "thomaszhang"

#sudo apt-get install emacs-25
sudo apt install wget
sudo apt install fcitx fcitx-googlepinyin fcitx-ui-classic fcitx-frontend-gtk3
sudo apt-get remove fcitx-frontend-qt4 fcitx-frontend-qt5 fcitx-qimpanel

sudo apt-get install gedit
sudo apt-get install android-tools-adb android-tools-fastboot

sudo apt-get install libncurses5-dev
sudo apt-get install build-essential texinfo libx11-dev libxpm-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev libgtk2.0-dev  libgtk-3-dev

which emacs
if [ $? -ne 0 ]; then
	cd ~
	if [ ! -d emacs-source ]; then
		mkdir emacs-source
		cd emacs-source
		wget http://mirrors.ustc.edu.cn/gnu/emacs/emacs-25.3.tar.gz
		tar -xzf emacs-25.3.tar.gz
	fi
	cd ~/emacs-source/emacs-25.3
	./configure
	make
	sudo make install
fi

sudo apt-get install samba

cd ~
if [ ! -d config ];then
	git clone http://github.com/zht304/config.git
fi
ln -s config/.emacs.d .emacs.d
ln -s config/.vimrc .vimrc

if [ ! -d tools ]; then
	git clone http://github.com/zht304/tools.git
    sudo ln -s /home/thomas/tools/myp4 /usr/bin/myp4
fi

sudo cat >> /etc/locale.gen <<EOF
zh_CN
zh_CN.gb18030
zh_CN.gb2312
zh_CN.gbk
zh_CN.utf8
en_US
en_US.iso88591
en_US.utf8
EOF
sudo locale-gen

cat >> ~/.bashrc <<EOF
export PATH=$PATH:/home/thomas/p4/bin
source /home/thomas/tools/p4env
alias ec='emacsclient -nw'
export LC_CTYPE=zh_CN.UTF-8
EOF

if [ ! -f ~/.xsessionrc ];then
    cat >> ~/.xsessionrc <<EOF
export PATH=$PATH:/home/thomas/p4/bin
source /home/thomas/tools/p4env n
alias ec='emacsclient -nw'
export LC_CTYPE=zh_CN.UTF-8
EOF
fi
