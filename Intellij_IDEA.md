# Intellij IDEA 設定

## プロジェクトごとに設定すること

### アノテーションプロセッサーを有効にする

- Preferences > Build, Execution, Deployment > Compiler > Annotation Processors を開く
- Enable annotation processing にチェックをする

## IDE で一度設定すること

### 基本設定

- Preferences > Editor > General を開く
- Remove trailing blank lines at the end of saved files にチェックをする
- Ensure every saved file ends with a line break にチェックをする

### コードスタイル

- Preferences > Editor > Code Style を開く
- Line separator で Unix and macOS を選択する

### 表示設定

- Preferences > Editor > General > Appearance を開く
- Show line number にチェックをする

### コード補完

- Preferences > Editor > General > Code Completion を開く
- All letters を選択する

### ワイルドカードインポートをしない

- Preferences > Editor > Code & Style > Java を開く
- Imports タブを開く
- Use single class import にチェックをする
- Class count to use import with '\*': を 999 にする
- Names count to use static import with '\*': を 999 にする

## 参考

- [IntelliJ IDEA 初期設定（主にエディタ）](https://qiita.com/keitakn/items/5968b9eee4177c302481)
- [IntelliJ Idea でインポートのワイルドカードを無効化する](https://qiita.com/Yuki10/items/9ebb7f1bdf4c800765ac)
