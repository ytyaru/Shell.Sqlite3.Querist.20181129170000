dbpath=TestDb.sqlite3

tablename=TestTable

function IsExistTable() {
    echo "tables: "`$(sqlite3 ${dbpath} ".tables")`
    for tblnm in $(sqlite3 ${dbpath} ".tables"); do
        echo "  ${tblnm}"
        [ $1 = $tblnm ] && return 1
    done
    return 0;
}
IsExistTable ${tablename}
IsExist=$?
echo "IsExistTable: ${IsExist}"
[ 0 -lt $IsExist ] && { echo "テーブルが既存のため処理を中断します。"; exit 1; }

sqlite3 ${dbpath} < ${tablename}.sql
sqlite3 ${dbpath} ".mode tabs" ".import ./${tablename}.tsv ${tablename}"
sqlite3 ${dbpath} "select * from ${tablename};"

