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

procedure Main( p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 )

// ? _sql_quote("ab'cde") => 'ab''cde'

set_params( p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 )

// hernad
? "hernad settings"
nPort := 5433
cDatabase := "quick38"
? "------ brisi ovo na drugom racunaru ----"

init_app()

oServer := TPQServer():New( cHostName, cDatabase, cUser, cPassWord, nPort, cSchema )
IF oServer:NetErr()
      ? oServer:ErrorMsg()
      QUIT
ENDIF

// neki kod kojim se update-uje  konto ...

? "update_semaphore_version", update_semaphore_version("konto", cUser)

? "get_semaphore_version", get_semaphore_version("konto", cUser)



return

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
              " WHERE user =" + _sql_quote(cUser) 


oRet := _sql_query( oServer, cTmpQry )

endif

cTmpQry := "SELECT currval('fmk.sem_ver_" + cTable + "') as val"
oRet := _sql_query( oServer, cTmpQry )

return oRet:Fieldget( oRet:Fieldpos("val") )



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
IF oTable == NIL
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

