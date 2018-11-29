# このソフトウェアについて

　SQLite3のデータベースとテーブルをディレクトリやSQLファイルから作成するスクリプトの試作。

# 開発環境

* [Raspberry Pi](https://ja.wikipedia.org/wiki/Raspberry_Pi) 3 Model B+
    * [Raspbian](https://www.raspberrypi.org/downloads/raspbian/) GNU/Linux 9.0 (stretch) 2018-06-27
        * [SQLite version 3.22.0 2018-01-22 18:45:57](http://ytyaru.hatenablog.com/entry/2019/01/31/000000)
        * Qt 5.7.1

# 使い方

1. データベース定義を作成するルートディレクトリを作成する `$ mkdir -p /tmp/DbDefines`
1. 作成したいデータベースのディレクトリを作成する `$ mkdir -p /tmp/DbDefines/SomeDb`
1. データベースに作成するテーブルを定義したSQLファイルを作成する
1. SQLファイルを出力するディレクトリを用意する `$ mkdir -p /tmp/DbOutput`
1. 本ツールを実行する

```bash
$ ./SqliteDbCreator.sh -i /tmp/DbDefines -o /tmp/DbOutput
```

## 説明

　以下のディレクトリやファイルから、作成するデータベースの情報を読み取る。

* /tmp/DbDefines/
    * SomeDb/
        * SomeTable.sql
        * SomeTable.tsv

SomeTable.sql
```sql
create table SomeTable (...);
```

　以下の出力先へファイルを作る。

* /tmp/DbOutput/
    * SomeDb.sqlite3

　sqlite3コマンドでファイルを確認すると、テーブルがある。

```bash
$ sqlite3 /tmp/DbOutput/SomeDb.sqlite3
>>> .tables
SomeTable
```

# ライセンス

　このソフトウェアはCC0ライセンスである。

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed.ja)

## 利用ライブラリ

ライブラリ|ライセンス|ソースコード
----------|----------|------------
[Qt](http://doc.qt.io/)|[LGPL](http://doc.qt.io/qt-5/licensing.html)|[GitHub](https://github.com/qt)

* [参考1](https://www3.sra.co.jp/qt/licence/index.html)
* [参考2](http://kou-lowenergy.hatenablog.com/entry/2017/02/17/154720)
* [参考3](https://qiita.com/ynuma/items/e8749233677821a81fcc)

