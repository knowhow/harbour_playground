#/bin/bash
TABLES="DOCS DOC_IT DOC_IT2 DOC_OPS DOC_LOG DOC_LIT"
TABLES_PREFIX="rnal"
FMKDBPATH="/mnt/data/fmk_data/rg_new"
DBF2PG="/mnt/data/harbour/src/harbour-3.0.0/contrib/hbpgsql/tests/dbf2pg"
PSQLDB="test1"
PSQLUSER="postgres"
PSQLPWD="xxxxxxxxx"
PSQLHOST="localhost"

cd $FMKDBPATH
for table in $TABLES
do
$DBF2PG  -h $PSQLHOST -y 5432 -d $PSQLDB -u $PSQLUSER -p $PSQLPWD -e fmk -f "$table".DBF -t "$TABLES_PREFIX"_"$table" -c
done  

