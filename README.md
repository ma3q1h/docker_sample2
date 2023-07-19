# Docker仮想環境 改善版
機械学習向けDocker環境の改善版です  
pip周りでエラーが生じるので、改善していったところ、”サーバー機能”や"pythonバージョン選択機能"まで搭載しました  
解説は現時点では未だ作成していません  
以降アクセスする手元のPCを"クライアントPC"、仮想環境が置かれるサーバーを"ホストPC"、Docker仮想環境を"コンテナ"と呼ぶ

## リポジトリ内容
```
├── Dockerfile
├── README.md
├── compose.yml 
├── .env (mk_envによる生成物)
├── compose_up.sh
├── id_rsa.pub (compose_up生成物)
├── make_env.sh
├── src
│   ├── jupyter_notebook_config.py
│   ├── requirements.txt
│   └── set_jupyter.sh
└── work
    └── test.ipynb
```

## 特徴
* 本サンプルはPytorchを想定した機械学習向け仮想環境 (Ubuntu | CUDA | Python)  
* pyenvによって任意のPythonバージョンの環境を構築できる
* 上記に加えてpythonバージョンのアクティベートは特別必要無し
* 仮想環境はsshサーバーとしても機能する
* jupyter notebook(Lab) のブラウザアクセスと、パスワード設定機能を用意
* 仮想環境内にはホストPCユーザーを引き継いだ一般ユーザーを追加
* docker compose V2 を利用

## 前提
SSH設定：ホストＰＣにsudoユーザーを作成。クライアントＰＣとホストＰＣの公開鍵によるssh接続を完了 (公開鍵の所在: ~/.ssh/authorized_keys)  
ホストＰＣ設定：ホストPCのDockerコマンド、composeコマンドの整備.
dockerグループ: sudo無し実行が出来る用にdockerグループを設定. ホストＰＣユーザーをdockerグループに追加  

# 大まかな流れ
(以降クライアントＰＣのvscodeでホストＰＣのシェルに接続した状態として進める)
1. ホストＰＣユーザーのホームディレクトリ以下にこのレポジトリをクローン (e.g. ~/username/Docker/)
2. 環境変数の設定： make_env.shを編集
3. compose_up.sh を実行して仮想環境のビルド
4. 仮想環境に入る
   
Dockerfileや環境変数の設定によってお好みの環境を構築出来ます

## .envについて
## Dockerfileの読み取り

## 任意のPython環境を設定する
今回の仮想環境にはベースとなるOSにubuntuを使用しています. UbuntuはデフォルトでPythonが入っており、システムの動作に関与していると思われます。それらを汚さない為に、また任意のバージョンを利用する為に pyenvを使ったpython環境の構築を行います.  
pyenvについては[こちら](https://github.com/pyenv/pyenv)をご確認ください. pyenvコマンドを簡単に紹介します.  
```
# インストール出来るバージョンの一覧を確認
$ pyenv list -l
# インストール
$ pyenv install {version name}
# 既にインストールされている環境の一覧(systemがデフォルトのpython, *が現在の環境)
$ pyenv versions
# 環境のアクティベート
$ pyenv local/grobal {version name}
```
'pyenv list -l'で出力される一覧から任意のバージョンを選択します. CPythonだけでなくcondaのpythonなども選択出来るようです.  
環境変数`PYTHON_VERSION`にインストールしたいバージョンを設定してください.  

Dockerfile内で環境のアクティベートはされているのでコンテナ内シェルで特別実行することは必要ありません  
このpython環境内で更に'venv'などを使うことで実験環境を分けることが出来ます

## sshサーバーとしての機能 -4つのアクセス方法-
### 1. プロンプトによるSSHアクセス
### 2. VScodeによる多重SSHアクセス(1の発展版)
### 3. VScodeでのdevContainerでのアクセス
### 4. Remote Container
-未完成-

## jupyter notebook(Lab) の設定とローカルブラウザアクセス
scripts/set_passwd.shを実行することでjupyter notebookの初期設定が行えます  
パスワードが要求されたら任意のパスワードを入力してください (enter二回でのスキップも可, 出力コード："RETRY"失敗。"DONE"成功)  
パスワードはハッシュ化されて保存されます
```shell
# 初期設定(パスワード設定、起動はしない)
$ ~/scripts/set_passwd.sh
>> DONE: run "jupyter notebook" or "jupyter lab" # 成功時
>> RETRY: please run "~/src/set_jupyer.sh" again # 失敗時
```
jupyterデフォルトの8888を解放しています
リモートPCのブラウザから、http://[GPU_IP_adress]:8888, または http://localhost:8888 にアクセス出来ます  
ブラウザでは先ほどのパスワードが要求されます. Enterで飛ばした場合は空白のままで良い

なお、パスワード設定等をしないアドホックな起動方法:  
```shell
$ jupyter notebook --ip=* --no-browser
```

## 課題
- [x] pip周りの問題点
- [ ] ポート関連(ポートフォワーディング等)
- [ ] jupyter設定の不具合
- [ ] Remote Containerによる簡易アクセス
- [ ] compose周り
- [ ] 解説書