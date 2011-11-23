#/bin/bash
TABLES="KUF KIF SUBAN ANAL SINT NALOG RJ FUNK BUDZET PAREK FOND KONIZ IZVJE ZAGLI KOLIZ BUIZ"
TABLES_PREFIX="fin"
FMKDBPATH="/mnt/data/fmk_data/rg/fin/kum1"
DBF2PG="/mnt/data/harbour/src/harbour-3.0.0/contrib/hbpgsql/tests/dbf2pg"
PSQLDB="fin1"
PSQLUSER="xxxxxxxx"
PSQLPWD="xxxxxxxxx"
PSQLHOST="localhost"

cd $FMKDBPATH
for table in $TABLES
do
$DBF2PG  -h $PSQLHOST -y 5432 -d $PSQLDB -u $PSQLUSER -p $PSQLPWD -e public -f "$table".DBF -t "$TABLES_PREFIX"_"$table" -c
done  

