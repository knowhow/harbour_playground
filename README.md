harbour
=======


build na mac os x
------------------

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


/opt/harbour/lib/harbour/libhbpgsql.a
-------------------------------------
out-of-box se ovaj drajver ne kreira. 

iz ovog repozitorija uzeti hbp i hbc:

<pre>
cp pgsql/hbpgsql.hb?  ~/devel/harbour/harbour-3.0.0/contrib/hbpgsql/
</pre>

onda u ~/devel/harbour/harbour-3.0.0/contrib/hbpgsql/ uraditi make:

make i install u lib dir:
<pre>
cp libhbpgsql.a /opt/harbour/lib/harbour/
</pre>

dbf2pg
-------

Kada imamo libhbpgsql.a možemo praviti harbour postgresql podržane aplikacije 

originalni fajl uzet sa ove lokacije harbour source repozitorija
<pre>
 cp ~/devel/harbour/harbour-3.0.0/contrib/hbpgsql/tests/dbf2pg.prg
</pre>

a onda dodata podrška za DBFCDX:

kreiraj u ranije kreiranoj fin1 PostgreSQL bazi (localhost, port 5433, user admin, password admin, u public shema) tabelu

fin_suban na osnovu fmk/SUBAN.DBF

<pre>
./dbf2pg -h localhost -y 5433 -d fin1 -u admin -p admin -e public -f fmk/SUBAN  -t fin_suban -c
./dbf2pg -h localhost -y 5433 -d fin1 -u admin -p admin -e public -f fmk/ANAL  -t fin_suban -c
</pre>
