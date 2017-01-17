# Shared folder activate
sudo gpasswd --add naoya vboxsf

# Home directory rename
LANG=C xdg-user-dirs-gtk-update

# Add apt repository
sudo add-apt-repository ppa:numix/ppa
sudo add-apt-repository ppa:neovim-ppa/unstable

# Update packages database
sudo apt-get update
sudo apt-get upgrade

# Install packages
sudo apt-get install dfc gcc git nkf rar vim vlc w3m zip zsh a2ps curl gimp tree wget dstat gedit unrar unzip whois xclip ffmpeg neovim pandoc gnuplot latexmk vim-gtk xdvik-ja arc-theme colordiff p7zip-full gnuplot-x11 imagemagick screenfetch ghostscript-x texlive-lang-japanese texlive-latex-extra numix-icon-theme-circle fcitx fcitx-mozc python3-dev python3-pip libssl-dev libreadline-dev zlib1g-dev

# Uninstall packages
sudo apt-get purge --auto-remove blueman pidgin gigolo gnome-mines gnome-sudoku ristretto simple-scan xfburn parole

# Install fonts
mkdir $HOME/.fonts
curl -L https://github.com/miiton/Cica/releases/download/v1.0.3/Cica_v1.0.3.7z -o $HOME/Cica.7z
7z x -o$HOME/.fonts/Cica Cica.7z
rm $HOME/Cica.7z

mkdir $HOME/.fonts/Migu1C
curl -L https://ja.osdn.net/projects/mix-mplus-ipa/downloads/63545/migu-1c-20150712.zip/ -o $HOME/.fonts/Migu1C.zip
unzip Migu1C.zip -d Migu1C/

# Setup Z Shell
curl -sL zplug.sh/installer | zsh

cat << EOS > .zshrc
source $HOME/.zplug/init.zsh

zplug "modules/prompt", from:prezto

if ! zplug check; then
  zplug install
fi

zplug load
EOS

chsh -s /bin/zsh

# Stop, reboot
sudo reboot

# Setup Z Shell
ln -s $HOME/.zplug/repos/sorin-ionescu/prezto $HOME/.zprezto
rm .zshrc
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# Install Anyenv
git clone https://github.com/riywo/anyenv $HOME/.anyenv
echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> $HOME/.zshrc
echo 'eval "$(anyenv init -)"' >> $HOME/.zshrc
exec $SHELL -l

# Install ruby, python and node
anyenv install rbenv
anyenv install pyenv
anyenv install ndenv
exec $SHELL -l

rbenv install 2.3.3
rbenv global 2.3.3

pyenv install anaconda3-4.2.0
pyenv global anaconda3-4.2.0

ndenv install 7.2.1
ndenv global 7.2.1

# Install gibo
sudo curl -L https://raw.github.com/simonwhitaker/gibo/master/gibo -o /usr/local/bin/gibo
sudo chmod a+rx /usr/local/bin/gibo
sudo gibo -u

# Install youtube-dl
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
sudo youtube-dl -U

# Setup Google Chrome
sudo mv /usr/bin/gnome-keyring-daemon /usr/bin/gnome-keyring-daemon-old

# Apply arc-theme to Google Chrome
git clone https://github.com/horst3180/arc-theme.git

# Install terminal color scheme
git clone https://github.com/chriskempson/base16-xfce4-terminal
cd base16-xfce4-terminal
./install base16-tomorrow.dark.terminalrc
cd
rm -rf base16-xfce4-terminal

ln -s $XDG_CONFIG_HOME $HOME/.nvimrc
dein、ホ・、・ケ・ネゥ`・jlistings、ホ・、・ケ・ネゥ`・pipでNeovim秘れないとダメっぽい
ssh-keygen
システムフォントにMigu-1C
