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

onda u ~/devel/harbour/harbour-3.0.0/contrib/hbpgsql/ uraditi hbmk2:

<pre>
~/devel/harbour/harbour-3.0.0/contrib/hbpgsql/$ /opt/harbour/bin/hbmk2 hbpgsql
</pre>

install u lib dir:

<pre>
cp libhbpgsql.a /opt/harbour/lib/harbour/
</pre>

dbf2pg
-------
Kada imamo libhbpgsql.a možemo praviti harbour postgresql podržane aplikacije 

Prvo je potrebno kompajlirati dbf2pg.prg na sljedeći način:

<pre>
~/devel/harbour/harbour-3.0.0/contrib/hbpgsql/tests/$ /opt/harbour/bin/hbmk2 dbf2pg.prg
</pre>

te u istom direktoriju dobijamo izvršni fajl koji naknadno koristimo.

Originalni fajl uzet sa ove lokacije harbour source repozitorija

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

build na linux-u 
-------------------

prerequisites 
<pre>
sudo apt-get install   rcs build-essential ncurses-dev libslang2-dev  unixodbc-dev libncurses-dev libx11-dev libgpm-dev  libfreeimage-dev  libpq-dev libqt3-mt-dev liballegro4.2-dev  zlib1g-dev libpcre3-dev libncurses-dev libslang2-dev libx11-dev libgpmg1-dev unixodbc-dev libcurl4-gnutls-dev 
</pre>

ostatak builda je isti kao i za OSX, koristimo lin_set_envars.sh

