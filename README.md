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
- pi の拡張機能を作りたい
  - OpenRouter WebFetch
  - OpenRouter WebSearch
- Starship の設定を見直す
- VSCode と Zed の設定ファイルのリンク方法を考える
- VSCode の拡張機能の管理方法を考える

## Update

```sh
sudo apt update
sudo apt upgrade
sudo apt autoremove
mise upgrade
```

## References

- [SSH and GPG keys - GitHub.com](https://github.com/settings/keys)
- [yuru7/udev-gothic](https://github.com/yuru7/udev-gothic)
- [Android CLI](https://developer.android.com/tools/agents/android-cli/download)
- [HazAT/pi-openrouter: Pi extension exposing OpenRouter server tools (advisor, subagent, fusion, web search, web fetch) as local tools with live streaming progress](https://github.com/HazAT/pi-openrouter)
