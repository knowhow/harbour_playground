#/bin/bash
F18DBPATH="/mnt/data/fmk_data/cago/f18"
DBF2PG="/mnt/data/harbour/src/harbour-3.0.0/contrib/hbpgsql/tests/dbf2pg"
PSQLDB="cago"
PSQLUSER="admin"
PSQLPWD="admin"
PSQLHOST="localhost"

cd $F18DBPATH
for table in *.dbf 
do
$DBF2PG  -h $PSQLHOST -y 5432 -d $PSQLDB -u $PSQLUSER -p $PSQLPWD -e fmk -f $table -t $table -c
done  

