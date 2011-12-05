#!/bin/bash
# ver 0.1
# bjasko@bring.out.ba 
# 05.12.2011
# TO DO selektivno odabir tabela 
# podesenja
###########################################
KUMDIR=KUM1
SIFDIR=SIF1
FMKDBPATH=/mnt/data/fmk_data/bout
F18DBPATH=/mnt/data/fmk_data/bout/f18/
###########################################
# provjeri dalis u lokacije OK

if [ -d $F18DBPATH ]; then
	echo "$F18DBPATH je OK, nastavljam ......."
else
        echo "$F18DBPATH ne postoji kreiram $F18DBPATH"

        mkdir -p $F18DBPATH
fi

if [ -d $FMKDBPATH ]; then
	cd $FMKDBPATH
else
        echo "$FMKDBPATH ne postoji provjerite podešenja"
    
fi

# copy FMK DB to F18
echo "kopiram fmk db to f18" 
echo "FIN tabele"
FINTB="SUBAN ANAL SINT NALOG"
cd $FMKDBPATH/FIN/$KUMDIR
for table in $FINTB
do 
cp $table.DBF $F18DBPATH/fin_$table.dbf 
done

cd $F18DBPATH

for i in $( ls | grep [A-Z] ); do mv -i $i `echo $i | tr 'A-Z' 'a-z'`;done

echo "lista kopiranih fajlova"
ls $F18DBPATH 

pause 


echo "...OK nastavljam ................."


# copy FMK DB to F18
echo "kopiram fmk db to f18" 
echo "FAKT tabele"
FAKTB="FAKT DOKS DOKS2 GEN_UG GEN_UG_P RUGOV UGOV UPL"
cd $FMKDBPATH/FAKT/$KUMDIR
for table in $FAKTB
do 
cp $table.DBF $F18DBPATH/fakt_$table.dbf 
cp $table.FPT $F18DBPATH/fakt_$table.fpt

done

cd $F18DBPATH

for i in $( ls | grep [A-Z] ); do mv -i $i `echo $i | tr 'A-Z' 'a-z'`;done

echo "lista kopiranih fajlova"
ls $F18DBPATH 

echo "...OK nastavljam ................."

pause


# copy FMK DB to F18
echo "kopiram fmk db to f18" 
echo "KALK tabele"
KALKTB="KALK DOKS"
cd $FMKDBPATH/KALK/$KUMDIR
for table in $KALKTB
do
cp $table.DBF $F18DBPATH/kalk_$table.dbf

done

cd $F18DBPATH

for i in $( ls | grep [A-Z] ); do mv -i $i `echo $i | tr 'A-Z' 'a-z'`;done

echo "lista kopiranih fajlova"
ls $F18DBPATH

pause 

# copy EPDV FMK DB to F18
echo "kopiram fmk db to f18" 
echo "EPDV tabele"
EPTB="KIF KUF PDV SG_KIF SG_KUF"
cd $FMKDBPATH/EPDV/$KUMDIR
for table in $EPTB
do
cp $table.DBF $F18DBPATH/epdv_$table.dbf

done

cd $F18DBPATH

for i in $( ls | grep [A-Z] ); do mv -i $i `echo $i | tr 'A-Z' 'a-z'`;done

echo "lista kopiranih fajlova"
ls $F18DBPATH

pause


# copy OS FMK DB to F18
echo "kopiram fmk db to f18" 
echo "OS tabele"
OSTB="K1 OS PROMJ"
cd $FMKDBPATH/OS/$KUMDIR
for table in $OSTB
do
cp $table.DBF $F18DBPATH/os_$table.dbf

done

cd $F18DBPATH

for i in $( ls | grep [A-Z] ); do mv -i $i `echo $i | tr 'A-Z' 'a-z'`;done
echo "lista kopiranih fajlova"
ls $F18DBPATH


pause 

# copy FMK LD DB to F18
echo "kopiram fmk db to f18" 
echo "LD tabele"
LDTB="LD NORSIHT OBRACUNI PK_DATA PK_RADN RADKR RADN RADSAT RJ"
cd $FMKDBPATH/LD/$KUMDIR
for table in $LDTB
do
cp $table.DBF $F18DBPATH/ld_$table.dbf

done

cd $F18DBPATH

for i in $( ls | grep [A-Z] ); do mv -i $i `echo $i | tr 'A-Z' 'a-z'`;done

echo "lista kopiranih fajlova"
ls $F18DBPATH


pause

# copy FMK DB to F18
echo "kopiram fmk db to f18" 
echo "SIF tabele"
SIFTB="ROBA SIFK SIFV PARTN BANKE KONTO POR RJ SAST TARIFA TDOK TIPPR TIPPR2 TNAL TRFP TRFP2 TRFP3 VALUTE VPOSLA VPRIH OPS KBENEF KONCIJ KRED DOPR LOKAL AMORT REVAL FMKRULES DEST FTXT"
cd $FMKDBPATH/SIF1
for table in $SIFTB
do
cp $table.DBF $F18DBPATH/$table.dbf
cp $table.FPT $F18DBPATH/$table.fpt

done

cd $F18DBPATH

for i in $( ls | grep [A-Z] ); do mv -i $i `echo $i | tr 'A-Z' 'a-z'`;done
mv amort.dbf os_amort.dbf
mv reval.dbf os_reval.dbf
mv ftxt.dbf  fakt_ftxt.dbf
mv fmkrules.dbf f18_rules.dbf

echo "lista kopiranih fajlova"
ls $F18DBPATH



echo "gotovo................."

