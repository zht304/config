if [ ! -f "/etc/apt/sources.list.bak" ]; then
	sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
	sudo sed -i s/cn.archive.ubuntu.com/mirrors.163.com/ /etc/apt/sources.list
	sudo sed -i s/security.ubuntu.com/mirrors.163.com/ /etc/apt/sources.list
fi
sudo apt-get update
sudo apt-get install vim
sudo apt-get install git
sudo apt-get install emacs
git config --global user.email "taocpp@gmail.com"
git config --global user.name "thomaszhang"
if [ ! -d ~/config ]; then
	git clone http://github.com/zht304/config.git ~/config
fi

if [ ! -d ~/emacs.d ]; then
	git clone https://github.com/syl20bnr/spacemacs.git ~/.emacs.d
fi
cd ~/config
cp .spacemacs ~/
cp .vimrc ~/
