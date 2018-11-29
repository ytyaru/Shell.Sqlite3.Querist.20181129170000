dbpath=TestDb.sqlite3

tablename=TestTable
sqlite3 ${dbpath} < ${tablename}.sql
sqlite3 ${dbpath} ".mode tabs" ".import ./${tablename}.tsv ${tablename}"
sqlite3 ${dbpath} "select * from ${tablename};"

