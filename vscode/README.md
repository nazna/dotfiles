# How to setup on WSL2

以下の拡張機能をインストールする:

- https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl
- https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc
- https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc-icons
- https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig
- https://marketplace.visualstudio.com/items?itemName=tamasfe.even-better-toml
- https://marketplace.visualstudio.com/items?itemName=oderwat.indent-rainbow
- https://marketplace.visualstudio.com/items?itemName=oxc.oxc-vscode

設定とキーマップをリンクする:

```sh
ln -nfs "${DOTFILES}/vscode/settings.json" "${HOME}/.vscode-server/data/Machine/settings.json"
ln -nfs "${DOTFILES}/vscode/keybindings.json" "${HOME}/.vscode-server/data/Machine/keybindings.json"
```
