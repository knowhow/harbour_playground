#!/bin/bash
# ver 0.1
# bjasko@bring.out.ba 
# 24.11.2011
# podesenja
###########################################
KUMDIR=KUM1
SIFDIR=SIF1
FMKDBPATH=/mnt/data/fmk_data/cago
F18DBPATH=/mnt/data/fmk_data/cago/f18/
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
FINTB="KUF KIF SUBAN ANAL SINT NALOG"
cd $FMKDBPATH/FIN/$KUMDIR
for table in $FINTB
do 
cp $table.DBF $F18DBPATH/fin_$table.dbf 
done

cd $F18DBPATH

for i in $( ls | grep [A-Z] ); do mv -i $i `echo $i | tr 'A-Z' 'a-z'`;done

echo "lista kopiranih fajlova"
ls $F18DBPATH 

echo "...OK nastavljam ................."


# copy FMK DB to F18
echo "kopiram fmk db to f18" 
echo "FAKT tabele"
FAKTB="FAKT DOKS"
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

# copy FMK DB to F18
echo "kopiram fmk db to f18" 
echo "SIF tabele"
SIFTB="ROBA SIFK SIFV PARTN BANKE KONTO"
cd $FMKDBPATH/SIF1
for table in $SIFTB
do
cp $table.DBF $F18DBPATH/$table.dbf
cp $table.FPT $F18DBPATH/$table.fpt

done

cd $F18DBPATH

for i in $( ls | grep [A-Z] ); do mv -i $i `echo $i | tr 'A-Z' 'a-z'`;done

echo "lista kopiranih fajlova"
ls $F18DBPATH



echo "gotovo................."

