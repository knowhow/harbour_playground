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

cp ~/devel/harbour/harbour-3.0.0/contrib/hbpgsql/tests/dbf2pg.prg

