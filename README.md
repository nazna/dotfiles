# dotfiles

> nazna's dotfiles (v3)

## Usage

```sh
curl -sSfL https://raw.githubusercontent.com/nazna/dotfiles/HEAD/install.sh | bash
```

インストールが完了したら以下のコマンドを実行する:

```sh
ssh-keygen -t ed25519
cat ${HOME}/.ssh/id_ed25519.pub | pbcopy
```

## Notes

- `pi update` や `agy update` は実行しない
- WSL2 をリセットするには `wsl.exe --unregister Ubuntu` を PowerShell で実行する

## Update

```sh
sudo apt update
sudo apt upgrade
sudo apt autoremove
mise upgrade
```

## References

- [SSH and GPG keys - GitHub.com](https://github.com/settings/keys)
- [Bootstrap | mise-en-place](https://mise.jdx.dev/bootstrap.html)
- [yuru7/udev-gothic](https://github.com/yuru7/udev-gothic)
