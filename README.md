# nazna's dotfiles

> nazna's dotfiles and setup scripts

## Usage

```shellscript
curl -sSfL https://raw.githubusercontent.com/nazna/dotfiles/HEAD/scripts/install.sh | bash
```

Then execute commands below

```shellscript
$ ssh-keygen -t ed25519
$ cat ${HOME}/.ssh/id_ed25519.pub | pbcopy
$ open https://github.com/settings/keys
$ git remote set-url origin git@github.com:nazna/dotfiles.git
$ reboot
```

## Reset WSL

```shellscript
$ wsl.exe --unregister Ubuntu
```