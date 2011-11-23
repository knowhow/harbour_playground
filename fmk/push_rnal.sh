#/bin/bash
TABLES="DOCS DOC_IT DOC_IT2 DOC_OPS DOC_LOG DOC_LIT"
TABLES_PREFIX="rnal"
FMKDBPATH="/mnt/data/fmk_data/rg/rnal/kum1"
DBF2PG="/mnt/data/harbour/src/harbour-3.0.0/contrib/hbpgsql/tests/dbf2pg"
PSQLDB="rnal1"
PSQLUSER="xxxxxxxx"
PSQLPWD="xxxxxxxxx"
PSQLHOST="localhost"

cd $FMKDBPATH
for table in $TABLES
do
$DBF2PG  -h $PSQLHOST -y 5432 -d $PSQLDB -u $PSQLUSER -p $PSQLPWD -e public -f "$table".DBF -t "$TABLES_PREFIX"_"$table" -c
done  

