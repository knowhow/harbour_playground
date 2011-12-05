#/bin/bash
# ver 0.1
# bjasko@bring.out.ba 
# 05.12.2011
# TO OD selektivni odabir tabela
TABLES="banke fakt_doks2 fakt_rugov kalk_doks ld_norsiht ld_rj os_reval sifk trfp2 dopr fakt_doks fakt_ugov kalk_kalk ld_obracuni lokal partn sifv trfp3 epdv_kif fakt_fakt fakt_upl kbenef ld_pk_data ops por tarifa trfp epdv_kuf fin_anal koncij ld_pk_radn os_amort rj tdok valute epdv_pdv fakt_ftxt fin_nalog konto ld_radkr os_k1 roba tippr2 vposla epdv_sg_kif fakt_gen_ug fin_sint kred ld_radn os_os tippr vprih epdv_sg_kuf fakt_gen_ug_p fin_suban ld_ld ld_radsat os_promj sast tnal f18_rules dest"
F18DBPATH="/mnt/data/fmk_data/bout/f18"
DBF2PG="/opt/harbour/bin/dbf2pg"
PSQLDB="bringout"
PSQLUSER="admin"
PSQLPWD="xxxxx"
PSQLHOST="localhost"

cd $F18DBPATH
for table in $TABLES
do
$DBF2PG  -h $PSQLHOST -y 5432 -d $PSQLDB -u $PSQLUSER -p $PSQLPWD -e fmk -f "$table".dbf -t $table 
done  
