#/bin/bash
TABLES="RADKR RADN RADSIHT RJ NORSIHT TPRSIHT PK_RADN PK_DATA OBRACUNI RADSAT"
TABLES_PREFIX="ld"
FMKDBPATH="/mnt/data/fmk_data/rg/ld/kum1"
DBF2PG="/mnt/data/harbour/src/harbour-3.0.0/contrib/hbpgsql/tests/dbf2pg"
PSQLDB="ld1"
PSQLUSER="xxxxxxxx"
PSQLPWD="xxxxxxxxx"
PSQLHOST="localhost"

cd $FMKDBPATH
for table in $TABLES
do
$DBF2PG  -h $PSQLHOST -y 5432 -d $PSQLDB -u $PSQLUSER -p $PSQLPWD -e public -f "$table".DBF -t "$TABLES_PREFIX"_"$table" -c
done  

