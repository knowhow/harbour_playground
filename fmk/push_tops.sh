#/bin/bash
TABLES="DOKS POS RNGPLA DOKSRC MESSAGE DINTEG1 DINTEG2 INTEG1 INTEG2 DOKSPF PROMVP"
TABLES_PREFIX="tops"
FMKDBPATH="/mnt/data/fmk_data/tops/kum1"
DBF2PG="/mnt/data/harbour/src/harbour-3.0.0/contrib/hbpgsql/tests/dbf2pg"
PSQLDB="tops1"
PSQLUSER="xxxxxxxx"
PSQLPWD="xxxxxxxxx"
PSQLHOST="localhost"

cd $FMKDBPATH
for table in $TABLES
do
$DBF2PG  -h $PSQLHOST -y 5432 -d $PSQLDB -u $PSQLUSER -p $PSQLPWD -e public -f "$table".DBF -t "$TABLES_PREFIX"_"$table" -c
done  

