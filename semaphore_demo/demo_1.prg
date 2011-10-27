#include "common.ch"

#define RDDENGINE "DBFCDX"

static cHostName := "localhost"
static nPort := 5432
static cUser := "admin"
static cPassWord := "admin"
static cDataBase := "demo"
static cDBFDataPath := ""
static cSchema := "public"


procedure Main( p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 )
LOCAL oPgServer

set_params( p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 )

init_app()

oServer := TPQServer():New( cHostName, cDatabase, cUser, cPassWord, nPort, cSchema )

IF oServer:NetErr()
      ? oServer:ErrorMsg()
      QUIT
ENDIF


return



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



