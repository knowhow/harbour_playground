harbour
=======


build na mac os x
=================

http://redmine.bring.out.ba/issues/24717

otpakuj harbour 3 source
 
```$ source mac_set_envars.sh```

make 

mkdir /opt/harbour
chown hernad /opt/harbour

make install

nakon toga u /opt/harbour imamo:
 #  bin/harbour, hbmk2
 #  lib/harbour => harbour libs
 #  include/harbour



pgsql
-----

originalni fajl uzet sa ove lokacije harbour source repozitorija
# cp ~/devel/harbour/harbour-3.0.0/contrib/hbpgsql/tests/dbf2pg.prg

a onda dodata podrška za DBFCDX:

kreiraj u ranije kreiranoj fin1 PostgreSQL bazi (localhost, 5433, user admon, password admin, u public shema) tabelu

fin_suban na osnovu fmk/SUBAN.DBF

<pre>
./dbf2pg -h localhost -x 5433 -d fin1 -u admin -p admin -e public -f fmk/SUBAN  -t fin_suban -c
./dbf2pg -h localhost -x 5433 -d fin1 -u admin -p admin -e public -f fmk/ANAL  -t fin_suban -c
</pre>



