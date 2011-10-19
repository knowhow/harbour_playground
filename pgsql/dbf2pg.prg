/*
 * $Id: dbf2pg.prg 15174 2010-07-25 08:45:50Z vszakats $
 */

/*
 * Harbour Project source code:
 * dbf2pg.prg - converts a .dbf file into a Postgres table
 *
 * Copyright 2000 Maurilio Longo <maurilio.longo@libero.it>
 * (The Original file was ported from Mysql and changed by Rodrigo Moreno rodrigo_moreno@yahoo.com)
 * * www - http://harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

#include "inkey.ch"
#include "common.ch"

PROCEDURE Main( ... )

   LOCAL cTok
   LOCAL cHostName := "localhost"
   LOCAL nPort := 5432
   LOCAL cUser := "postgres"
   LOCAL cPassWord := ""
   LOCAL cDataBase, cTable, cFile
   LOCAL aDbfStruct, i
   LOCAL lCreateTable := .F.
   LOCAL oServer, oTable, oRecord
   LOCAL cField
   LOCAL sType
   LOCAL dType
   LOCAL cValue
   LOCAL nCommit := 100
   LOCAL nHandle
   LOCAL nCount := 0
   LOCAL nRecno := 0
   LOCAL lTruncate := .F.
   LOCAL lUseTrans := .F.
   LOCAL cPath := "public"

   SET CENTURY ON
   SET DATE ANSI
   SET EPOCH TO 1960
   SET DELETE ON

#define RDDENGINE "DBFCDX"

 REQUEST DBFCDX

 ? "setujem default engine ..." + RDDENGINE
  RDDSETDEFAULT( RDDENGINE )


   REQUEST HB_CODEPAGE_SL852 
   REQUEST HB_CODEPAGE_SLISO

   HB_CDPSELECT("SL852")

   //hb_setCodePage( "SL852" )
   //hb_setTermCP("SLISO")
   
   // REQUEST HB_CODEPAGE_SL852 
   // REQUEST HB_CODEPAGE_SLISO

   // hb_setCodePage( "SL852" )
   // hb_setTermCP("SLISO")


   // rddSetDefault( "DBFDBT" )

   IF PCount() < 6
      help()
      QUIT
   ENDIF

   i := 1
   /* Scan parameters and setup workings */
   ? PCount()

   DO WHILE i <= PCount()

      cTok := hb_PValue( i++ )

      ? "cTok=", cTok
      DO CASE
      CASE cTok == "-h"
         cHostName := hb_PValue( i++ )
         ? "hostname=", cHostName
      CASE cTok == "-y"
         nPort := Val( hb_PValue( i++ ) )
         ? "port=", nPort
      CASE cTok == "-d"
         cDataBase := hb_PValue( i++ )
         ? "database=", cDatabase
      CASE cTok == "-t"
         cTable := hb_PValue( i++ )
         ? "table=", cTable
      CASE cTok == "-f"
         cFile := hb_PValue( i++ )
         ? "file=", cFile
      CASE cTok == "-u"
         cUser := hb_PValue( i++ )
         ? "user=", cUser
      CASE cTok == "-p"
         cPassWord := hb_PValue( i++ )
         ? "password=", cPassword
      
      CASE cTok == "-c"
         lCreateTable := .T.
       
      CASE cTok == "-x"
         lTruncate := .T.

      CASE cTok == "-s"
         lUseTrans := .T.

      CASE cTok == "-m"
         nCommit := Val( hb_PValue( i++ ) )
         ? "commit=", nCommit
      CASE cTok == "-r"
         nRecno := Val( hb_PValue( i++ ) )
         ? "recno=", nRecno
      CASE cTok == "-e"
         cPath := hb_PValue( i++ )
         ? "path=", cPath

      OTHERWISE
         help()
         QUIT
      ENDCASE
   ENDDO

   // create log file
   ? cTable

   IF ( nHandle := FCreate( RTrim( cTable ) + ".log" ) ) == -1
      ? "Cannot create log file"
      QUIT
   ENDIF

   
   ? "USE ( " + cFile +")" 
   USE (cFile) SHARED 
   aDbfStruct := DBStruct()

   oServer := TPQServer():New( cHostName, cDatabase, cUser, cPassWord, nPort, cPath )
   IF oServer:NetErr()
      ? oServer:ErrorMsg()
      QUIT
   ENDIF

   oServer:lallCols := .F.

   IF lCreateTable
      IF oServer:TableExists( cTable )
         oServer:DeleteTable( cTable )
         IF oServer:NetErr()
            ? oServer:ErrorMsg()
            FWrite( nHandle, "Error: " + oServer:ErrorMsg() + hb_eol() )
            FClose( nHandle )
            QUIT
         ENDIF
      ENDIF
      oServer:CreateTable( cTable, aDbfStruct )

      IF oServer:NetErr()
         ? oServer:ErrorMsg()
         FWrite( nHandle, "Error: " + oServer:ErrorMsg() + hb_eol() )
         FClose( nHandle )
         QUIT
      ENDIF
   ENDIF

   IF lTruncate
      oServer:Execute( "truncate table " + cTable )
      IF oServer:NetErr()
         ? oServer:ErrorMsg()
         FWrite( nHandle, "Error: " + oServer:ErrorMsg() + hb_eol() )
         FClose( nHandle )
         QUIT
      ENDIF
   ENDIF

   oTable := oServer:Query( "SELECT * FROM " + cTable + " LIMIT 1" )
   IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      FWrite( nHandle, "Error: " + oTable:ErrorMsg() + hb_eol() )
      FClose( nHandle )
      QUIT
   ENDIF

   IF lUseTrans
      oServer:StartTransaction()
   ENDIF

   FWrite( nHandle, "Start: " + Time() + hb_eol() )

   ? "Start: ", Time()
   ?

   IF ! Empty( nRecno )
      dbGoto( nRecno )
   ENDIF

   DO WHILE ! Eof() .AND. Inkey() != K_ESC .AND. ( Empty( nRecno ) .OR. nRecno == RecNo() )
      oRecord := oTable:GetBlankRow()
      
      FOR i := 1 TO oTable:FCount()
         cField := Lower( oTable:FieldName( i ) )
         // field type
         sType := FieldType( FieldPos( cField ) )
         // data type
         dType := oRecord:Fieldtype( i )
         cValue := FieldGet( FieldPos( cField ) )
        
         IF UPPER(cField) == "SIFRA"       
            loop
         ENDIF

         IF cValue != NIL
            IF dType != sType
               IF dType == "C" .AND. sType == "N"
                 cValue := Str( cValue )
               ELSEIF dType == "C" .AND. sType == "D"
                 cValue := DToC( cValue )
               ELSEIF dType == "C" .AND. sType == "L"
                 cValue := iif( cValue, "S", "N" )
               ELSEIF dType == "N" .AND. sType == "C"
                 cValue := Val( cValue )
               ELSEIF dType == "N" .AND. sType == "D"
                 cValue := Val( DToS( cValue ) )
               ELSEIF dType == "N" .AND. sType == "L"
                 cValue := iif( cValue, 1, 0 )
               ELSEIF dType == "D" .AND. sType == "C"
                 cValue := CToD( cValue )
               ELSEIF dType == "D" .AND. sType == "N"
                 cValue := SToD( Str( cValue ) )
               ELSEIF dType == "L" .AND. sType == "N"
                 cValue := ! Empty( cValue )
               ELSEIF dType == "L" .AND. sType == "C"
                 cValue := iif( AllTrim( cValue ) $ "YySs1", .T., .F. )
               ENDIF
            ENDIF
			

            IF cValue != NIL
               IF oRecord:Fieldtype( i ) == "C"
                  oRecord:FieldPut( i, strkznutf8(hb_oemtoansi(cValue), "h8") )
               ELSEIF oRecord:Fieldtype( i ) == "M"
                  oRecord:FieldPut( i, hb_oemtoansi( cValue ) )
               ELSE
                  oRecord:FieldPut( i, cValue )
               ENDIF
            ENDIF
         ENDIF
      NEXT

      oTable:Append(oRecord)

      IF oTable:NetErr()
  	     ? "LANG:", hb_langName()
         ? "CP:", hb_cdpInfo()
         ?
         ? "Error Record: ", RecNo(), Left( oTable:ErrorMsg(), 70 )
         ?
         FWrite( nHandle, "Error at record: " + Str( RecNo() ) + " Description: " + oTable:ErrorMsg() + hb_eol() )
      ELSE
         nCount++
      ENDIF

      dbSkip()

      IF ( nCount % nCommit ) == 0
         DevPos( Row(), 1 )
         DevOut( "imported recs: " + Str( nCount ) )

         IF lUseTrans
            oServer:commit()
            oServer:StartTransaction()
         ENDIF
      ENDIF
   ENDDO

   IF ( nCount % nCommit ) != 0
      IF lUseTrans
         oServer:commit()
      ENDIF
   ENDIF

   FWrite( nHandle, "End: " + Time() + ", records in dbf: " + hb_ntos( RecNo() ) + ", imported recs: " + hb_ntos( nCount ) + hb_eol() )

   ? "End: ", Time()
   ?

   FClose( nHandle )

   CLOSE ALL
   oTable:Destroy()
   oServer:Destroy()

   RETURN

PROCEDURE Help()

   ? "dbf2pg - dbf file to PostgreSQL table conversion utility"
   ? "-h hostname (default: localhost)"
   ? "-u user (default: root)"
   ? "-p password (default no password)"
   ? "-d name of database to use"
   ? "-t name of table to add records to"
   ? "-c delete existing table and create a new one"
   ? "-f name of .dbf file to import"
   ? "-x truncate table before append records"
   ? "-s use transaction"
   ? "-m commit interval"
   ? "-r insert only record number"
   ? "-e search path"

   ? ""

RETURN


// ---------------------------------------------------
// convert and return string in utf-8
// ---------------------------------------------------
FUNCTION strkznutf8( cInput, cIz )
local aWin := {} 
local aUTF := {}
local a852 := {}
local ahb852 := {}
local aTmp := {}
local cRet
local i

// windows codes...
AADD( aWin, "&" ) 
AADD( aWin, "Š" )
AADD( aWin, "Ð" )
AADD( aWin, "Æ" )
AADD( aWin, "È" )
AADD( aWin, "Ž" )
AADD( aWin, "š" )
AADD( aWin, "ð" )
AADD( aWin, "æ" )
AADD( aWin, "è" )
AADD( aWin, "ž" )
AADD( aWin, "!" ) 
AADD( aWin, '"' ) 
AADD( aWin, "'" ) 
AADD( aWin, "," ) 

// 852 codes...
AADD( a852, "&" ) // feature
AADD( a852, "æ" ) // SS
AADD( a852, "Ñ" ) // DJ
AADD( a852, "¬" ) // CC
AADD( a852, "¬" ) // CH
AADD( a852, "¦" ) // ZZ
AADD( a852, "ç" ) // ss
AADD( a852, "Ð" ) // dj
AADD( a852, "Ÿ" ) // cc
AADD( a852, "†" ) // ch
AADD( a852, "§" ) // zz
AADD( a852, "!" ) // uzvicnik
AADD( a852, '"' ) // navodnici
AADD( a852, "'" ) // jedan navodnik
AADD( a852, "," ) // zarez

//  ƒ å º τ ╨ - ¼ Å ª µ ╤
//  č ć ž š đ - Č Ć Ž Š Đ

// hb852 codes (harbour)...
AADD( ahb852, "&" ) // feature
AADD( ahb852, "µ" ) // SS
AADD( ahb852, "╤" ) // DJ
AADD( ahb852, "Å" ) // CC
AADD( ahb852, "¼" ) // CH
AADD( ahb852, "ª" ) // ZZ
AADD( ahb852, "τ" ) // ss
AADD( ahb852, "╨" ) // dj
AADD( ahb852, "å" ) // cc
AADD( ahb852, "ƒ" ) // ch
AADD( ahb852, "º" ) // zz
AADD( ahb852, "!" ) // uzvicnik
AADD( ahb852, '"' ) // navodnici
AADD( ahb852, "'" ) // jedan navodnik
AADD( ahb852, "," ) // zarez

// UTF codes...
AADD( aUTF, "&#38;" ) 
AADD( aUTF, "&#352;" )
AADD( aUTF, "&#272;" )
AADD( aUTF, "&#268;" )
AADD( aUTF, "&#262;" )
AADD( aUTF, "&#381;" )
AADD( aUTF, "&#353;" )
AADD( aUTF, "&#273;" )
AADD( aUTF, "&#269;" )
AADD( aUTF, "&#263;" )
AADD( aUTF, "&#382;" )
AADD( aUTF, "&#33;" ) 
AADD( aUTF, "&#34;" ) 
AADD( aUTF, "&#39;" ) 
AADD( aUTF, "&#44;" ) 


if cIz == "8"
	aTmp := a852
elseif cIz == "h8"
    aTmp := ahb852
elseif cIz == "W"
	aTmp := aWin
endif

for i := 1 to LEN( aUtf )
    cInput := STRTRAN( cInput, aTmp[i], aUtf[i] )
next

cRet := cInput

return cRet

