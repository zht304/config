if [ ! -f "/etc/apt/sources.list.bak" ]; then
	cp /etc/apt/sources.list /etc/apt/sources.list.bak
	sed -i s/cn.archive.ubuntu.com/mirrors.163.com/ /etc/apt/sources.list
	sed -i s/security.ubuntu.com/mirrors.163.com/ /etc/apt/sources.list
fi
apt-get update
apt-get install vim
apt-get install git
apt-get install emacs
git clone http://github.com/zht304/config.git ~/config
cd ~/config
cp .spacemacs ~/
cp .vimrc ~/

