#/bin/bash
TABLES="KALK KALKS DOKS DOKS2 KONIZ IZVJE ZAGLI KOLIZ DOKSRC LOGK LOGKD OBJEKTI PRODNC K1"
TABLES_PREFIX="kalk"
FMKDBPATH="/mnt/data/fmk_data/rg/kalk/kum1"
DBF2PG="/mnt/data/harbour/src/harbour-3.0.0/contrib/hbpgsql/tests/dbf2pg"
PSQLDB="kalk1"
PSQLUSER="xxxxxxxx"
PSQLPWD="xxxxxxxxx"
PSQLHOST="localhost"

cd $FMKDBPATH
for table in $TABLES
do
$DBF2PG  -h $PSQLHOST -y 5432 -d $PSQLDB -u $PSQLUSER -p $PSQLPWD -e public -f "$table".DBF -t "$TABLES_PREFIX"_"$table" -c
done  

