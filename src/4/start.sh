dbpath=TestDb.sqlite3

tablename=TestTable

# ディレクトリ名一覧
# $1: 一覧したいディレクトリパス
function DirNames() {
    local path=`pwd`
    cd "${1}"
    local names=`echo $(ls -d */) | sed 's/\///g'`
    cd $path
    echo $names
}

# テーブル存在確認
# $1: 存在を確認したいテーブル名
# return: 0:存在しない, 1:存在する
function IsExistTable() {
    echo "tables: "`$(sqlite3 ${dbpath} ".tables")`
    for tblnm in $(sqlite3 ${dbpath} ".tables"); do
        echo "  ${tblnm}"
        [ $1 = $tblnm ] && return 1
    done
    return 0;
}

# テーブル作成
# $1: 作成するテーブル名
function CreateTable() {
    IsExistTable ${1}
    local IsExist=$?
    echo "IsExistTable: ${IsExist}"
    [ 0 -lt $IsExist ] && { echo "テーブルが既存のため処理を中断します。"; exit 1; }

    sqlite3 ${dbpath} < ${1}.sql
    sqlite3 ${dbpath} ".mode tabs" ".import ./${1}.tsv ${1}"
    sqlite3 ${dbpath} "select * from ${1};"
}

echo `pwd`
dirnames=`DirNames /tmp`
echo $dirnames
echo `pwd`

# 実行するとエラー: TestTable.sql: そのようなファイルやディレクトリはありません
# 相対パスなせいで参照できないのが原因。このスクリプトの引数で入出力ディレクトリパスを渡してもらう必要がある。
# $ start -i 入力元パス -o 出力先パス
CreateTable ${tablename}

