#/bin/bash
TABLES="KALK KALKS DOKS DOKS2 KONIZ IZVJE ZAGLI KOLIZ LOGK LOGKD RJ UPL FAKT UGOV RUGOV GEN_UG GEN_UG_P DOKS DOKS2 KALPOS"
TABLES_PREFIX="fakt"
FMKDBPATH="/mnt/data/fmk_data/rg_2011/sigma/FAKT/KUM1"
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

