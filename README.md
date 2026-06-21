# dotfiles

> nazna's dotfiles

## Usage

### Setup

```sh
curl -sSfL https://raw.githubusercontent.com/nazna/dotfiles/HEAD/install.sh | bash
```

### Update

```sh
./scripts/update.sh
```

## Notes

- ./install.sh は何度実行しても問題ないようにする
- `pi update` は実行しない
- Homebrew を mise に集約できるか検討する

### Choosing installation method

1. 公式インストールスクリプトを使う
2. 安定性があればよい場合: `apt`
3. その他の場合: `brew`

### Setup SSH key

```sh
ssh-keygen -t ed25519
cat ${HOME}/.ssh/id_ed25519.pub | pbcopy
open https://github.com/settings/keys
git remote set-url origin git@github.com:nazna/dotfiles.git
```

### How to check Homebrew installed packages

```sh
brew leaves
```

### How to reset WSL2

```sh
wsl.exe --unregister Ubuntu
```

## References

- [yuru7/udev-gothic](https://github.com/yuru7/udev-gothic)
