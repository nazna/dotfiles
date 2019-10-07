<div align="center">
  <img src=".github/dot.png" width="150px">
  <h1 align="center">Naoya's dotfiles</h1>
  <sup align="center">These configuration dotfiles assume macOS.</sup>
</div>

## Bootstrap

```sh
bash -c "$(curl -L https://raw.githubusercontent.com/naoya3e/dotfiles/master/scripts/bootstrap.sh)"
```

## Apply updates

```sh
cd $HOME/workspace/ghq/github.com/naoya3e/dotfiles
git pull --rebase
./scripts/deploy.sh
```

Maybe last line is unnecessary.

## Fonts

- Cica
- Montserrat
- M+ 1p
- M+ 1m
