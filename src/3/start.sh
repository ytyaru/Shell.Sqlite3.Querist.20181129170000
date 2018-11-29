dbpath=TestDb.sqlite3

tablename=TestTable

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

CreateTable ${tablename}

