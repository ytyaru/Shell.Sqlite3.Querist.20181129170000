# SQLiteファイル作成スクリプト
# $ start -i /tmp/DatabasesDefine -o /tmp/DatabaseOutput
# -i: DBディレクトリとsqlファイルが存在するルートディレクトリパス
# -o: .sqlite3ファイルを出力するディレクトリパス

InputDir=`pwd`
OutputDir=`pwd`
while getopts "i:o:" OPT
do
  case $OPT in
    i) InputDir="$OPTARG"; echo "InputDir: ${InputDir}"; ;;
    o) OutputDir="$OPTARG"; echo "OutputDir: ${OutputDir}"; ;;
    h) echo  "Help";;
  esac
done

# ディレクトリ名一覧
# $1: 一覧したいディレクトリパス
# http://8ttyan.hatenablog.com/entry/2016/01/25/162456
# http://yuyunko.hatenablog.com/entry/20110304/1299218939
function DirNames() {
    local path=`pwd`
    cd "${1}"
    local names=`echo $(ls -d */) | sed 's/\///g'`
    cd $path
    echo $names
}

# Sqlite3ファイル存在確認
# $1: テーブル名
function IsExistDbFile() {
    [ -f "${OutputDir%/}/${1}" ] && return 1 || return 0
}

# テーブル存在確認
# $1: 存在を確認したいテーブルがあるDBファイルパス
# $1: 存在を確認したいテーブル名
# return: 0:存在しない, 1:存在する
function IsExistTable() {
    echo "tables: "
    for tblnm in $(sqlite3 "${1}" ".tables"); do
        echo "  ${tblnm}"
        [ "${2}" = "${tblnm}" ] && return 1
    done
    return 0;
}

# テーブル作成
function CreateTable() {
    local currentpath=`pwd`
    echo "databases: "
    # データベース名一覧取得
    for dbnm in $(DirNames "${InputDir}"); do
        echo "  ${dbnm}"
        local dbfilename="${dbnm}.sqlite3"
        local dbpath="${OutputDir%/}/${dbfilename}"
        cd "${InputDir%/}/${dbnm}"
        # SQLファイル名一覧取得
        for flnm in $(ls -F | grep -v / | grep *.sql); do
            local tablename=`basename ${flnm} ".sql"`
            local sqlpath="${InputDir%/}/${dbnm}/${flnm}"
            local tsvpath="${InputDir%/}/${dbnm}/${tablename}.tsv"
            echo "    ${sqlpath}"
            echo "tablename: ${tablename}"
            echo "sqlpath: ${sqlpath}"
            echo "tsvpath: ${tsvpath}"

            IsExistTable ${dbpath} ${tablename}
            local IsExist=$?
            echo "IsExistTable: ${IsExist}"
            [ 0 -lt $IsExist ] && { echo "テーブルが既存のため処理をスキップします。"; continue; }

            sqlite3 ${dbpath} < "${sqlpath}"
            [ -f "${tsvpath}" ] && sqlite3 ${dbpath} ".mode tabs" ".import \"${tsvpath}\" ${tablename}"
            sqlite3 ${dbpath} "select * from ${tablename};"
        done
    done
    cd "${currentpath}"
}

CreateTable

