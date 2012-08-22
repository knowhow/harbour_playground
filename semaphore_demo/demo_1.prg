#include "common.ch"

#define RDDENGINE "DBFCDX"

static cHostName := "localhost"
static nPort := 5432
static cUser := "admin"
static cPassWord := "admin"
static cDataBase := "demo_db1"
static cDBFDataPath := ""
static cSchema := "public"
static oServer := NIL
static cHome := ""

#define F_SUBAN 1
#define F_PARTN 2
#define F_KONTO 3

procedure Main( p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 )

PUBLIC gTabele:={ ;
  { F_SUBAN, "fin_suban"  ,  "fmk.fin_suban", "fmk.sem_ver_fin_suban"},;
  { F_KONTO, "konto"  ,  "fmk.konto", "fmk.sem_ver__konto"},;
  { F_PARTN, "partn"  ,  "fmk.partn", "fmk_sem_ver__partn"};
}

// ? _sql_quote("ab'cde") => 'ab''cde'

init_app()

set_params( p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 )

// hernad
? "hernad settings"
cHostName :=  "knowhow-erp.bring.out.ba"
nPort := 5432
cDatabase := "hernad"
? "------ brisi ovo na drugom racunaru ----"

cHome := hb_DirSepAdd( GetEnv( "HOME" ) ) 
cHome := hb_DirSepAdd(cHome + ".fmk")

? cHome

? "PostgreSQL konekcija ..."
oServer := TPQServer():New( cHostName, cDatabase, cUser, cPassWord, nPort, cSchema )
IF oServer:NetErr()
      ? oServer:ErrorMsg()
      QUIT
ENDIF



create_partn(cHome)
create_fin_suban(cHome)
close all

use (cHome + "partn") new via "DBFCDX"


for i:=30000 to 30009
   ? "update_partn (dbf/sql)", i
   update_partn( str(i, 5), "naz " + str(i, 5) )
next
? "update_semaphore_version", cUser, update_semaphore_version("konto", cUser)

? "start"
update_partn_from_sql()
? "stop"
? "---------------------------"
? "pritisni nesto"
inkey(10)

// set order to tag "ID"
//dbedit()



// neki kod kojim se update-uje  konto ...


? "neki drugi user update", update_semaphore_version("konto", "neko2")
? "neki treci user update", update_semaphore_version("konto", "neko3")
? "neki cetvrti user update", update_semaphore_version("konto", "neko4")

//for i:=1 to 50
   ? "get_semaphore_version", cUser, get_semaphore_version("konto", cUser)
//next

? "aktuelna verzija na serveru", last_semaphore_version("konto")


use (cHome + "fin_suban") new via "DBFCDX"

/*
for i:=50000 to 60000

 cBrNal := STR(i, 8)
 cBrNal:= STRTRAN(cBrNal, " ", "0") 

 ? cBrNal
 update_fin_suban("10", "10", cBrNal, 1, DATE()-30, "4300", "2", 1500 + i)
 update_fin_suban("10", "10", cBrNal, 2, DATE()-30, "3000", "1", 1000 + i)
 update_fin_suban("10", "10", cBrNal, 3, DATE()-30, "3001", "1", 500 + i)

next
*/

for i:=101 to 500

 cBrNal := STR(i, 8)
 cBrNal:= STRTRAN(cBrNal, " ", "0") 

 ? cBrNal
 update_fin_suban("10", "10", cBrNal, 1, DATE(), "4300", "2", 1500 + i)
 update_fin_suban("10", "10", cBrNal, 2, DATE(), "3000", "1", 1000 + i)
 update_fin_suban("10", "10", cBrNal, 3, DATE(), "3001", "1", 500 + i)

next

use


? "date", "algoritam", DATE()
update_fin_suban_from_sql(DATE())

use (cHome + "fin_suban") via "DBFCDX" NEW
DBEDIT()
use

CLEAR SCREEN
? "----------------"

? TIME()
nTime := SECONDS()


use (cHome + "fin_suban") via "DBFCDX" NEW
? "full", "algoritam"
update_fin_suban_from_sql(NIL)

? TIME(), SECONDS() - nTime
? "----------------"
? "pritisni stone ..."
inkey(10)
use (cHome + "fin_suban") via "DBFCDX" NEW
DBEDIT()
use

oServer:Destroy()
return


//--------------------------
//       update_fin_suban("10", "10", "00000008", 1, DATE(), "4300", "2", 1500)
function update_fin_suban(cIdFirma, cIdVn, cBrNal, nRbr, dDatDok, cKonto, cDP, nIznos)

update_fin_suban_dbf(cIdFirma, cIdVn, cBrNal, nRbr, dDatDok, cKonto, cDP, nIznos)
update_fin_suban_sql(cIdFirma, cIdVn, cBrNal, nRbr, dDatDok, cKonto, cDP, nIznos)

return


function update_fin_suban_dbf(cIdFirma, cIdVn, cBrNal, nRbr, dDatDok, cKonto, cDP, nIznos)
 ? nIznos
 append blank
 replace IdFirma with cIdFirma,;
         IdVn with cIdVn,;
         BrNal with cBrNal,;
         rbr with STR(nRbr, 4),;
         IdKonto with cKonto,;
         D_P with cDP, ;
         IZNOSBHD  with nIznos
return

function update_fin_suban_sql(cIdFirma, cIdVn, cBrNal, nRbr, dDatDok, cKonto, cDP, nIznos)
LOCAL oRet
LOCAL nResult
LOCAL cTmpQry
LOCAL cTable
LOCAL cWhere


cWhere := "idfirma=" + _sql_quote(cIdFirma) + " and idvn=" + _sql_quote(cIdVn) +;
                      " and brnal=" + _sql_quote(cBrNal) +;
                      " and rbr=" + _sql_quote(STR(nRbr,4)); 

cTable := "fmk.fin_suban"

//nResult := table_count(oServer, cTable, "idfirma=" + _sql_quote(cIdFirma) + " and idvn=" + _sql_quite(cIdVn) + " and brnal=" + _sql_quote(cBrNal) ) 

//if nResult == 0

   cTmpQry := "INSERT INTO " + cTable + ;
              "(idfirma, idvn, brnal, rbr, datdok, idkonto, d_P, iznosbhd) " + ;
               "VALUES(" + _sql_quote(cIdFirma)  + "," +;
                         + _sql_quote(cIdVn) + "," +; 
                         + _sql_quote(cBrNal) + "," +; 
                         + _sql_quote(STR(nRbr, 4)) + "," +; 
                         + _sql_quote(DTOS(dDatDok)) + "," +; 
                         + _sql_quote(cKonto) + "," +; 
                         + _sql_quote(cDP) + "," +; 
                         + STR(nIznos, 17, 2) + ")" 


   oRet := _sql_query( oServer, cTmpQry)

//else

//cTmpQry := "UPDATE " + cTable + ;
//              " SET naz = " + _sql_quote(cNaz) + ;
//              " WHERE id =" + _sql_quote(cId) 


/// oRet := _sql_query( oServer, cTmpQry )

//endif

cTmpQry := "SELECT count(*) from " + cTable + " WHERE " + cWhere
oRet := _sql_query( oServer, cTmpQry )

return oRet:Fieldget( oRet:Fieldpos("count") )





// ------------------------------
// ------------------------------
function update_fin_suban_from_sql(dDatDok)
local oQuery
local nCounter
local nRec
local cQuery

   ? "updateujem fin_suban.dbf from sql stanja"

   cQuery :=  "SELECT idfirma, idvn, brnal, rbr, datdok, idkonto, d_p, iznosbhd FROM fmk.fin_suban"  
   if dDatDok != NIL
      cQuery += " WHERE datdok>=" + _sql_quote(DTOS(dDatDok))
   endif
 
   oQuery := oServer:Query(cQuery) 
   
   ? "Fields: ", oQuery:Fcount()

   USE (cHome + "fin_suban") NEW
   SELECT fin_suban

   if dDatDok == NIL
      // "full" algoritam
      ZAP 

   else
      // "date" algoritam  - brisi sve vece od zadanog datuma
      SET ORDER TO TAG "8"
      // tag je "DatDok" nije DTOS(DatDok)
      seek dDatDok
      do while !eof() .and. (datDok >= dDatDok) 
          // otidji korak naprijed
          SKIP
          nRec := RECNO()
          SKIP -1
          DELETE
          GO nRec  
      enddo
 
    endif


   nCounter := 1
   DO WHILE ! oQuery:Eof()
      append blank
      //cQuery :=  "SELECT idfirma, idvn, brnal, rbr, datdok, idkonto, d_p, iznosbhd FROM fmk.fin_suban"  
      replace idfirma with oQuery:FieldGet(1), ;
              idvn with oQuery:FieldGet(2), ;
              brnal with oQuery:FieldGet(3), ;
              rbr with oQuery:FieldGet(4), ;
              datdok with oQuery:FieldGet(5), ;
              idkonto with oQuery:FieldGet(6), ;
              d_p with oQuery:FieldGet(7), ;
              iznosbhd with oQuery:FieldGet(8)

      oQuery:Skip()

      //? nCounter++
   ENDDO

   USE
   oQuery:Destroy()

return 



function update_partn_from_sql()
local oQuery
local nCounter
   ? "updateujem partn.dbf from sql stanja"

   oQuery := oServer:Query( "SELECT id, naz FROM fmk.partn" )

   aStruct := oQuery:Struct()

   FOR i := 1 TO Len( aStruct )
      ? aStruct[ i ][ 1 ], aStruct[ i ][ 2 ]
   NEXT

   ? "Fields: ", oQuery:Fcount()

   SELECT PARTN
   ZAP
  
    
   nCounter := 1
   DO WHILE ! oQuery:Eof()
      append blank
      replace id with oQuery:FieldGet(1), ;
              naz with oQuery:FieldGet(2)

      oQuery:Skip()

      //? nCounter++
   ENDDO

   oQuery:Destroy()

return 



function update_partn(cId, cNaz)
 update_partn_dbf(cId, cNaz)
 update_partn_sql(cId, cNaz)
return


function update_partn_dbf(cId, cNaz)
 append blank
 replace id with cId, naz with cNaz
return

function update_partn_sql(cId, cNaz)
LOCAL oRet
LOCAL nResult
LOCAL cTmpQry
LOCAL cTable

cTable := "fmk.partn"

nResult := table_count(oServer, cTable, "id=" + _sql_quote(cId)) 

if nResult == 0

   cTmpQry := "INSERT INTO " + cTable + ;
              "(id, naz) " + ;
               "VALUES(" + _sql_quote(cId)  + "," + _sql_quote(cNaz) +  ")"

   oRet := _sql_query( oServer, cTmpQry)

else

cTmpQry := "UPDATE " + cTable + ;
              " SET naz = " + _sql_quote(cNaz) + ;
              " WHERE id =" + _sql_quote(cId) 


oRet := _sql_query( oServer, cTmpQry )

endif

cTmpQry := "SELECT count(*) from " + cTable 
oRet := _sql_query( oServer, cTmpQry )

return oRet:Fieldget( oRet:Fieldpos("count") )

 
return


// ------------------------------------
// ------------------------------------
function last_semaphore_version(cTable)
local cTmpQry
local oRet

cTmpQry := "SELECT currval('fmk.sem_ver_" + cTable + "') as val"
oRet := _sql_query( oServer, cTmpQry )

return oRet:Fieldget( oRet:Fieldpos("val") )


/* ------------------------------------------
  get_semaphore_version( "konto", "hernad" )
  -------------------------------------------
*/
function get_semaphore_version(cTable, cUser)
LOCAL oTable
LOCAL nResult
LOCAL cTmpQry

cTable := "fmk.semaphores_" + cTable

nResult := table_count(oServer, cTable, "user_code=" + _sql_quote(cUser)) 

if nResult <> 1
  ? cTable, cUser, "count =", nResult
  return -1
endif


cTmpQry := "SELECT version FROM " + cTable + " WHERE user_code=" + _sql_quote(cUser)
oTable := _sql_query( oServer, cTmpQry )
IF oTable == NIL
      ? "problem sa:", cTmpQry
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("version") )

RETURN nResult

/* ------------------------------------------
  update_semaphore_version( "konto", "hernad" )
  -------------------------------------------
*/
function update_semaphore_version(cTable, cUser)
LOCAL oRet
LOCAL nResult
LOCAL cTmpQry
LOCAL cFullTable

cFullTable := "fmk.semaphores_" + cTable
? "table=", cTable

nResult := table_count(oServer, cFullTable, "user_code=" + _sql_quote(cUser)) 

if nResult == 0

   cTmpQry := "INSERT INTO " + cFullTable + ;
              "(user_code, version) " + ;
               "VALUES(" + _sql_quote(cUser)  + ", nextval('fmk.sem_ver_"+ cTable + "') )"

   oRet := _sql_query( oServer, cTmpQry)

else

cTmpQry := "UPDATE " + cFullTable + ;
              " SET version=nextval('fmk.sem_ver_"+ cTable + "') " + ;
              " WHERE user_code =" + _sql_quote(cUser) 


oRet := _sql_query( oServer, cTmpQry )

endif

cTmpQry := "SELECT version from " + cFullTable + ;
           " WHERE user_code =" + _sql_quote(cUser) 
oRet := _sql_query( oServer, cTmpQry )

return oRet:Fieldget( oRet:Fieldpos("version") )



/* ------------------------------  
  broj redova za tabelu
  --------------------------------
*/
function table_count( oServer, cTable, cCondition)
LOCAL oTable
LOCAL nResult
LOCAL cTmpQry

// provjeri prvo da li postoji uopšte ovaj site zapis
cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE " + cCondition

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      ? "problem sa query-jem: " + cTmpQry 
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult





/*
 */
PROCEDURE help()
   
   ? "semafori  demo"
   ? "parametri"
   ? "-h hostname (default: localhost)"
   ? "-y port (default: 5432)"
   ? "-u user (default: root)"
   ? "-p password (default no password)"
   ? "-d name of database to use"
   ? "-e schema (default: public)"
   ? "-t fmk tables path"
   ? ""

RETURN


/* 
--------------------------
setu parametre
 --------------------------
*/
function set_params()

//IF PCount() < 7
//    help()
//    QUIT
//ENDIF

i := 1

// setuj ulazne parametre
cParams := ""

DO WHILE i <= PCount()

    // ucitaj parametar
    cTok := hb_PValue( i++ )
     
    
    DO CASE

      CASE cTok == "--help"
          help()
          QUIT
      CASE cTok == "-h"
         cHostName := hb_PValue( i++ )
         cParams += SPACE(1) + "hostname=" + cHostName
      CASE cTok == "-y"
         nPort := Val( hb_PValue( i++ ) )
         cParams += SPACE(1) + "port=" + ALLTRIM(STR(nPort))
      CASE cTok == "-d"
         cDataBase := hb_PValue( i++ )
         cParams += SPACE(1) + "database=" + cDatabase
      CASE cTok == "-u"
         cUser := hb_PValue( i++ )
         cParams += SPACE(1) + "user=" + cUser
      CASE cTok == "-p"
         cPassWord := hb_PValue( i++ )
         cParams += SPACE(1) + "password=" + cPassword
      CASE cTok == "-t"
         cDBFDataPath := hb_PValue( i++ )
         cParams += SPACE(1) + "dbf data path=" + cDBFDataPath
      CASE cTok == "-e"
         cSchema := hb_PValue( i++ )
         cParams += SPACE(1) + "schema=" + cSchema
      OTHERWISE
         //help()
         //QUIT
    ENDCASE

ENDDO

// ispisi parametre
? "Ulazni parametri:"
? cParams

return


function init_app()

 REQUEST DBFCDX

 ? "setujem default engine ..." + RDDENGINE
 RDDSETDEFAULT( RDDENGINE )

 REQUEST HB_CODEPAGE_SL852 
 REQUEST HB_CODEPAGE_SLISO

 HB_CDPSELECT("SL852")

return .t.


// pomoćna funkcija za sql query izvršavanje
function _sql_query( oServer, cQuery )
LOCAL oResult
oResult := oServer:Query( cQuery )
IF oResult:NetErr()
      ? oResult:ErrorMsg()
      return NIL
ENDIF
RETURN oResult


// ------------------------
function _sql_quote(xVar)
xVar := STRTRAN(xVar, "'","''")
return "'" + xVar + "'"

