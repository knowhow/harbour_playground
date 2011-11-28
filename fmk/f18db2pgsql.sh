#/bin/bash
TABLES="banke fakt_fakt fin_kif fin_nalog fin_suban kalk_kalk partn sifk fakt_doks fin_anal fin_kuf fin_sint kalk_doks konto roba sifv"
F18DBPATH="/mnt/data/fmk_data/cago/f18"
DBF2PG="/mnt/data/harbour/src/harbour-3.0.0/contrib/hbpgsql/tests/dbf2pg"
PSQLDB="cago"
PSQLUSER="admin"
PSQLPWD="admin"
PSQLHOST="localhost"

cd $F18DBPATH
for table in $TABLES
do
$DBF2PG  -h $PSQLHOST -y 5432 -d $PSQLDB -u $PSQLUSER -p $PSQLPWD -e public -f "$table".dbf -t $table -c
done  
