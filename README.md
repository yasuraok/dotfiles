# dotfiles
主にdevcontainerで使う用途でdotfilesをメンテしてみる。

## VSCodeで使う
Userのsettings.jsonで以下を書き込む。一台で設定したら後の端末では[Setting Sync](https://qiita.com/Nuits/items/6204a6b0576b7a4e37ea)で同期すればよい。

```
{
    "dotfiles.repository": "yasuraok/dotfiles",
    "dotfiles.targetPath": "~/dotfiles",
    "dotfiles.installCommand": "~/dotfiles/install.sh",
}
```



Setting Syncで
