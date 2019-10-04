# activate shared folder
sudo ./VBoxLinuxAdditions.run
sudo gpasswd --add naoya vboxsf

# rename home directories
LANG=C xdg-user-dirs-gtk-update

# add apt repository
sudo add-apt-repository ppa:moka/daily
sudo add-apt-repository ppa:nomacs/stable
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo add-apt-repository ppa:fish-shell/release-2

# update packages database
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get autoremove

# install packages
sudo apt-get install dfc git nkf rar vim vlc zsh curl gimp fish tree xsel dstat gedit unrar whois ffmpeg pandoc vim-gtk p7zip-full imagemagick screenfetch arc-theme moka-icon-theme faba-icon-theme autoconf libappindicator1 golang-go screen tmux neovim zlib1g-dev libssl-dev libreadline-dev libbz2-dev libsqlite3-dev nomacs colordiff texlive-langjapanese texlive-latexextra

# uninstall packages
sudo apt-get purge --auto-remove blueman pidgin gigolo gnome-mines gnome-sudoku ristretto simple-scan xfburn parole libreoffice-core libreoffice-common sgt-puzzles

# install Google Chrome
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo mv /usr/bin/gnome-keyring-daemon /usr/bin/gnome-keyring-daemon-old

# setup theme
git clone https://github.com/horst3180/arc-theme.git
git clone https://github.com/horst3180/arc-icon-theme --depth 1 && cd arc-icon-theme
sudo ./autogen.sh --prefix=/usr
sudo make install

# create directories
mkdir -p $HOME/.fonts $HOME/.icons $HOME/.config/nvim

# install fonts
curl -L https://github.com/miiton/Cica/releases/download/v2.0.4/Cica_v2.0.4.zip -o $HOME/Cica.zip
unzip Cica.zip -d $HOME/.fonts/Cica
rm $HOME/Cica.zip

curl -L https://ja.osdn.net/projects/mix-mplus-ipa/downloads/63545/migu-1c-20150712.zip/ -o $HOME/.fonts/Migu1C.zip
unzip Migu1C.zip -d $HOME/.fonts/Migu1C
rm $HOME Migu1C.zip

# install youtube-dl
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
sudo youtube-dl -U

# apply VLC theme
open https://maverick07x.deviantart.com/art/VLC-MetroX-345256054

# generate ssh key
ssh-keygen -t ed25519
cat $HOME/.ssh/id_ed25519.pub | xsel --clipboard --input

# setup neovim
mkdir -p $HOME/.vim/bundles
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh $HOME/.vim/bundles

# setup zsh

# change default shell
chsh -s /bin/zsh

# setup python virtualenv
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
