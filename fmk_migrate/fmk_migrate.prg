#include "inkey.ch"
#include "common.ch"


// site
STATIC __site_name := ""
// matična firma
STATIC __comp_name := ""
STATIC __comp_addr := ""
STATIC __comp_postalcode := ""
STATIC __comp_city := ""
STATIC __comp_email := ""
STATIC __comp_tel1 := ""
STATIC __comp_tel2 := ""
STATIC __comp_fax := ""
STATIC __comp_id_number := ""
STATIC __comp_pdv_number := ""
// porezi
STATIC __taxzone_bih := "FBIH"
STATIC __taxzone_ino := "INO"
STATIC __taxauth := "UIO"
STATIC __taxtype := "OSTALO"
// ostale varijable
STATIC __currency := "KM"

// glavna procedura aplikcije
PROCEDURE Main( ... )

LOCAL cTok
LOCAL cHostName := "localhost"
LOCAL nPort := 5432
LOCAL cUser := "admin"
LOCAL cPassWord := ""
LOCAL cDataBase := ""
LOCAL cDBFDataPath := ""
LOCAL cSchema := "public"
LOCAL i
LOCAL cParams
LOCAL nHandle
LOCAL oPgServer
LOCAL lStatus := .f.

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

// ocisti ekran
CLEAR SCREEN

IF PCount() < 7
	help()
    QUIT
ENDIF

i := 1

// setuj ulazne parametre
cParams := ""

DO WHILE i <= PCount()

	// ucitaj parametar
    cTok := hb_PValue( i++ )
      
	DO CASE
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
         help()
         QUIT
	ENDCASE

ENDDO

// ispisi parametre
? "Ulazni parametri:"
? cParams

// daj mi parametre firme
cParams := set_company_params()

@ 16, 2 SAY ""
? cParams

// ostvari konekciju na server
oPgServer := db_server_connect(cHostName, cDatabase, cUser, cPassword, nPort, cSchema)

// setuj osnovne postavke na sql serveru (jmj, tarife, ...)
lStatus := set_db_main_params( oPgServer )

// prebaci šifrarnike robe
lStatus := migrate_sif_articles( oPgServer, cDBFDataPath )


RETURN


// setuj osnovne postavke na bazi
FUNCTION set_db_main_params( oServer )
LOCAL lStatus := .t.
LOCAL lBaseCurrency := .t.

// setuj valutu
__set_currency( oServer, "KM", "Konvertibilna marka", lBaseCurrency )

// setuj jedinice mjere, tabela "UOM"
__set_uom( oServer, "KOM", "Komad" )
__set_uom( oServer, "LIT", "Litar" )
__set_uom( oServer, "PAK", "Paket" )
__set_uom( oServer, "SAT", "Sat" )
__set_uom( oServer, "GR", "Gram" )

// setuj tarife i tarifne skupine
__configure_tax( oServer )

// set site - organizaciona jedinca
// __set_site( oServer )


RETURN lStatus


STATIC FUNCTION __get_item_type( cValue )
LOCAL cType := "Purchased"

IF cValue == "U"
	cType := "Referenced"
ENDIF

RETURN cType 



// setuj itemsite
STATIC FUNCTION __set_itemsite( oServer, cValue, cSite, cNotes )
LOCAL oTable
LOCAL cTable := "api.itemsite"
LOCAL cTmpQry
LOCAL cCostMethod := "Average"
LOCAL cCtrlMethod := "Regular"
LOCAL cPlanner := "P1"
LOCAL cCostCateg := "C1"

IF ( cNotes == nil )
	cNotes := ""
ENDIF

// provjeri prvo da li postoji uopšte ovaj UOM zapis
IF ( __get_itemsite( oServer, cValue, cSite ) > 0 )
	// postoji već ovaj zapis
	? "ITEMSITE stavka " + cValue + " vec postoji !"
	RETURN
ENDIF

// ne postoji, ubaci zapis
cTmpQry := "INSERT INTO " + cTable + ;
		" ( item_number, site, active, po_supplied_at_site, sold_from_site, ranking, cost_method, control_method, " + ;
		"planner_code, cost_category, notes ) VALUES (" + ;
		_sql_value( cValue ) + "," + ;
		_sql_value( cSite ) + "," + ;
		_sql_value( "TRUE" ) + "," + ;
		_sql_value( "TRUE" ) + "," + ;
		_sql_value( "TRUE" ) + "," + ;
		ALLTRIM(STR( 1 )) + "," + ;
		_sql_value( cCostMethod ) + "," + ;
		_sql_value( cCtrlMethod ) + "," + ;
		_sql_value( cPlanner ) + "," + ;
		_sql_value( cCostCateg ) + "," + ;
		_sql_value( cNotes ) + ")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
    QUIT
ENDIF

RETURN


STATIC FUNCTION __get_itemsite( oServer, cValue, cSite )
LOCAL oTable
LOCAL cTable := "api.itemsite"
LOCAL nResult
LOCAL cTmpQry

// provjeri prvo da li postoji uopšte ovaj site zapis
cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE item_number = '" + cValue + "'" + ;
	" AND site = '" + cSite + "'"
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult



// setuj site
STATIC FUNCTION __set_item( oServer, cValue, cDescription, cType, cUom, nPrice, cUpc_code, cNotes )
LOCAL oTable
LOCAL cTable := "api.item"
LOCAL cTmpQry
LOCAL cItemType
LOCAL cClassCode := "OSTALO"
LOCAL cProdCateg := "OSTALO"
LOCAL lReturn := .f.

IF (cNotes == nil)
	cNotes := ""
ENDIF

cUom := UPPER(cUom)
// ubaci jedinicu mjere
__set_uom( oServer, cUom, "" )

// vrati tip na osnovu tipa iz FMK
cItemType := __get_item_type( cType )

// provjeri prvo da li postoji uopšte ovaj UOM zapis
IF ( __get_item( oServer, cValue ) > 0 )
	// postoji već ovaj zapis
	? "ITEM " + cValue + " vec postoji !"
	RETURN lReturn
ENDIF

// ne postoji, ubaci zapis
cTmpQry := "INSERT INTO " + cTable + ;
		" ( item_number, active, description1, item_type, class_code, inventory_uom, product_category, " + ;
		"list_price, list_price_uom, upc_code, notes ) VALUES (" + ;
		_sql_value( cValue ) + "," + ;
		_sql_value( "TRUE" ) + "," + ;
		_sql_value( cDescription ) + "," + ;
		_sql_value( cItemType ) + "," + ;
		_sql_value( cClassCode ) + "," + ;
		_sql_value( cUom ) + "," + ;
		_sql_value( cProdCateg ) + "," + ;
		ALLTRIM(STR( nPrice )) + "," + ;
		_sql_value( cUom ) + "," + ;
		_sql_value( cUpc_code ) + "," + ;
		_sql_value( cNotes ) + ;
		")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
    QUIT
ENDIF

lReturn := .t.

RETURN lReturn


STATIC FUNCTION __get_item( oServer, cValue )
LOCAL oTable
LOCAL cTable := "api.item"
LOCAL nResult
LOCAL cTmpQry

// provjeri prvo da li postoji uopšte ovaj site zapis
cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE item_number = '" + cValue +"'"
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult





// setuj site
STATIC FUNCTION __set_site( oServer )
LOCAL oTable
LOCAL cTable := "api.site"
LOCAL cTmpQry
LOCAL cValue := __site_name

// provjeri prvo da li postoji uopšte ovaj UOM zapis
IF ( __get_site( oServer, cValue ) > 0 )
	// postoji već ovaj zapis
	? "SITE " + cValue + " vec postoji !"
	RETURN
ENDIF

// ne postoji, ubaci zapis
cTmpQry := "INSERT INTO " + cTable + ;
		" ( code, type, active, description, address1, city, state, postal_code, country, taxzone ) VALUES (" + ;
		_sql_value( __site_name ) + "," + ;
		_sql_value( "WHSE") + "," + ;
		_sql_value( "TRUE" ) + "," + ;
		_sql_value( __comp_name ) + "," + ;
		_sql_value( __comp_addr ) + "," + ;
		_sql_value( __comp_city ) + "," + ;
		_sql_value( __comp_state ) + "," + ;
		_sql_value( __comp_postalcode ) + "," + ;
		_sql_value( __comp_country ) + "," + ;
		_sql_value( __taxzone ) + "," + ;
		")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
    QUIT
ENDIF

RETURN


// vrati mi code po traženom site_name
STATIC FUNCTION __get_site( oServer, cValue )
LOCAL oTable
LOCAL cTable := "api.site"
LOCAL nResult
LOCAL cTmpQry

// provjeri prvo da li postoji uopšte ovaj site zapis
cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE code = '" + cValue +"'"
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult



// konfigurisi poreze
STATIC FUNCTION __configure_tax( oServer )
LOCAL oTable
LOCAL cTable := "tax"
LOCAL cTmpQry
LOCAL nIzlPdv 
LOCAL nTaxAuth
LOCAL nCurr
LOCAL nTax
LOCAL nTaxZoneBih
LOCAL nTaxZoneIno
LOCAL nTaxTypeBih
LOCAL nTaxTypeIno

// daj mi valutu
nCurr := __get_currency( oServer, __currency )

// daj mi konto 4700
nIzlPdv := __get_account( oServer, "4700" )

// setuj poreznu upravu
__set_taxauth( oServer, __taxauth, "Uprava za indirektno oporezivanje", nCurr, "Bosna i Hercegovina" )
// vrati mi defaultnu poreznu upravu
nTaxAuth := __get_taxauth( oServer, __taxauth )

// setuj poreznu zonu
__set_taxzone( oServer, __taxzone_bih, "Federacija Bosne i Hercegovine")
nTaxZoneBih := __get_taxzone( oServer, __taxzone_bih )
__set_taxzone( oServer, __taxzone_ino, "INO export/import")
nTaxZoneIno := __get_taxzone( oServer, __taxzone_ino )
__set_taxzone( oServer, "RS", "Republika Srpska")

// setuj tip poreza
__set_taxtype( oServer, __taxtype, "Ostalo")
nTaxTypeBih := __get_taxtype( oServer, __taxtype )
__set_taxtype( oServer, "PREHRANA", "Prehrambeni artikli")
__set_taxtype( oServer, "TEHNIKA", "Tehnika")
__set_taxtype( oServer, "INO", "Inostranstvo")
nTaxTypeIno := __get_taxtype( oServer, "INO" )

// setuj stope

// stopa T1 - 17%
__set_tax( oServer, "T1", "T1", nIzlPdv, nTaxAuth )
nTax := __get_tax( oServer, "T1" )
// setuj iznos za T1
__set_taxrate( oServer, nTax, 17, nCurr )
// poveži tax zonu i tax tip
__set_taxass( oServer, nTaxZoneBih, nTaxTypeBih, nTax )


// stopa TINO - 0%
__set_tax( oServer, "TINO", "Tarifa inostranstvno", nIzlPdv, nTaxAuth )
nTax := __get_tax( oServer, "TINO" )
// setuj iznos za TINO
__set_taxrate( oServer, nTax, 0, nCurr )
// poveži tax zonu i tax tip
__set_taxass( oServer, nTaxZoneIno, nTaxTypeIno, nTax )


// dodaj terms

__set_terms( oServer, "DEFAULT", "DEFAULT" )


RETURN



STATIC FUNCTION __set_tax( oServer, cValue, cDescription, nAccount, nTaxAuth )
LOCAL oTable
LOCAL cTable := "tax"
LOCAL cTmpQry

IF ( __get_tax( oServer, cValue ) > 0 )  
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
		" ( tax_code, tax_descrip, tax_sales_accnt_id, tax_taxauth_id ) VALUES (" + ;
		_sql_value( cValue ) + "," + ;
		_sql_value( cDescription ) + "," + ;
		ALLTRIM(STR( nAccount )) + "," + ;
		ALLTRIM(STR( nTaxAuth )) + ")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
    QUIT
ENDIF

RETURN


STATIC FUNCTION __get_tax( oServer, cValue )
LOCAL oTable
LOCAL cTable := "tax"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT tax_id FROM " + cTable + " WHERE tax_code = '" + cValue + "'"
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("tax_id") )

RETURN nResult


STATIC FUNCTION __set_taxauth( oServer, cValue, cDescription, nCurrency, cCountry )
LOCAL oTable
LOCAL cTable := "taxauth"
LOCAL cTmpQry

IF ( __get_taxauth( oServer, cValue ) > 0 )  
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
		" ( taxauth_code, taxauth_name, taxauth_curr_id, taxauth_county ) VALUES (" + ;
		_sql_value( cValue ) + "," + ;
		_sql_value( cDescription ) + "," + ;
		ALLTRIM(STR( nCurrency )) + "," + ;
		_sql_value( nCountry ) + ;
		")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
    QUIT
ENDIF

RETURN


STATIC FUNCTION __get_taxauth( oServer, cValue )
LOCAL oTable
LOCAL cTable := "taxauth"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT taxauth_id FROM " + cTable + " WHERE taxauth_code = '" + cValue + "'"
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("taxauth_id") )

RETURN nResult


STATIC FUNCTION __set_taxzone( oServer, cValue, cDescription )
LOCAL oTable
LOCAL cTable := "taxzone"
LOCAL cTmpQry

IF ( __get_taxzone( oServer, cValue ) > 0 )  
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
		" ( taxzone_code, taxzone_descrip ) VALUES (" + ;
		_sql_value( cValue ) + "," + ;
		_sql_value( cDescription ) + ;
		")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
    QUIT
ENDIF

RETURN


STATIC FUNCTION __get_taxzone( oServer, cValue )
LOCAL oTable
LOCAL cTable := "taxzone"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT taxzone_id FROM " + cTable + " WHERE taxzone_code = '" + cValue + "'"
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("taxzone_id") )

RETURN nResult


STATIC FUNCTION __set_taxtype( oServer, cValue, cDescription )
LOCAL oTable
LOCAL cTable := "taxtype"
LOCAL cTmpQry

IF ( __get_taxtype( oServer, cValue ) > 0 )  
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
		" ( taxtype_name, taxtype_descrip ) VALUES (" + ;
		_sql_value( cValue ) + "," + ;
		_sql_value( cDescription ) + ;
		")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
    QUIT
ENDIF

RETURN


STATIC FUNCTION __get_taxtype( oServer, cValue )
LOCAL oTable
LOCAL cTable := "taxtype"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT taxtype_id FROM " + cTable + " WHERE taxtype_name = '" + cValue + "'"
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("taxtype_id") )

RETURN nResult


STATIC FUNCTION __set_itemtaxtype( oServer, cValue, cTaxZone, cTaxType )
LOCAL oTable
LOCAL cTable := "api.itemtaxtype"
LOCAL cTmpQry

IF ( __get_itemtaxtype( oServer, cValue, cTaxZone, cTaxType ) > 0 )  
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
		" ( item_number, tax_zone, tax_type ) VALUES (" + ;
		_sql_value( cValue ) + "," + ;
		_sql_value( cTaxZone ) + "," + ;
		_sql_value( cTaxType ) + ;
		")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
    QUIT
ENDIF

RETURN


STATIC FUNCTION __get_itemtaxtype( oServer, cValue, cTaxZone, cTaxType )
LOCAL oTable
LOCAL cTable := "api.itemtaxtype"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE " + ;
			"item_number = " + _sql_value(cValue) + ;
			" AND tax_zone = " + _sql_value(cTaxZone) + ;
			" AND tax_type = " + _sql_value(cTaxType)

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult





STATIC FUNCTION __set_taxrate( oServer, nTax, nAmount, nCurrency )
LOCAL oTable
LOCAL cTable := "taxrate"
LOCAL cTmpQry

IF ( __get_taxrate( oServer, nTax ) > 0 )  
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
		" ( taxrate_tax_id, taxrate_percent, taxrate_curr_id ) VALUES (" + ;
		ALLTRIM(STR( nTax )) + "," + ;
		ALLTRIM(STR( nAmount )) + "," + ;
		ALLTRIM(STR( nCurrency )) + ;
		")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
    QUIT
ENDIF

RETURN


STATIC FUNCTION __get_taxrate( oServer, nValue )
LOCAL oTable
LOCAL cTable := "taxrate"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT taxrate_id FROM " + cTable + " WHERE taxrate_tax_id = " + ALLTRIM(STR(nValue)) 
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("taxrate_id") )

RETURN nResult


STATIC FUNCTION __set_taxass( oServer, nTaxZone, nTaxType, nTax )
LOCAL oTable
LOCAL cTable := "taxass"
LOCAL cTmpQry

IF ( __get_taxass( oServer, nTaxZone, nTaxType, nTax ) > 0 )  
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
		" ( taxass_taxzone_id, taxass_taxtype_id, taxass_tax_id ) VALUES (" + ;
		ALLTRIM(STR( nTaxZone )) + "," + ;
		ALLTRIM(STR( nTaxType )) + "," + ;
		ALLTRIM(STR( nTax )) + ;
		")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
    QUIT
ENDIF

RETURN


STATIC FUNCTION __get_taxass( oServer, nTaxZone, nTaxType, nTax )
LOCAL oTable
LOCAL cTable := "taxass"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT taxass_id FROM " + cTable + " WHERE " + ;
		"taxass_taxzone_id = " + ALLTRIM(STR(nTaxZone)) + " AND " + ; 
		"taxass_taxtype_id = " + ALLTRIM(STR(nTaxType)) + " AND " + ; 
		"taxass_tax_id = " + ALLTRIM(STR(nTax)) 
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("taxass_id") )

RETURN nResult


STATIC FUNCTION __set_terms( oServer, cValue, cDescription )
LOCAL oTable
LOCAL cTable := "terms"
LOCAL cTmpQry

IF ( __get_terms( oServer, cValue ) > 0 )  
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
		" ( terms_code, terms_descrip, terms_type, terms_duedays, terms_discdays, " + ;
		"terms_discprcnt, terms_cutoffday, terms_ap, terms_ar ) VALUES (" + ;
		_sql_value( cValue ) + "," + ;
		_sql_value( cDescription ) + "," + ;
		_sql_value( "D" ) + "," + ;
		ALLTRIM(STR( 0 )) + "," + ;
		ALLTRIM(STR( 0 )) + "," + ;
		ALLTRIM(STR( 0 )) + "," + ;
		ALLTRIM(STR( 0 )) + "," + ;
		_sql_value( TRUE ) + "," + ;
		_sql_value( TRUE ) + ;
		")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
    QUIT
ENDIF

RETURN


STATIC FUNCTION __get_terms( oServer, cValue )
LOCAL oTable
LOCAL cTable := "terms"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT terms_id FROM " + cTable + " WHERE terms_code = '" + cValue + "'"
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("terms_id") )

RETURN nResult


STATIC FUNCTION __set_account( oServer, cValue, cDescription, cType, cSubType )
LOCAL oTable
LOCAL cTable := "api.glaccount"
LOCAL cTmpQry

IF ( __get_account( oServer, cValue ) > 0 )  
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
		" ( account_number, description, type, sub_type ) VALUES (" + ;
		_sql_value( cValue ) + "," + ;
		_sql_value( cDescription ) + "," + ;
		_sql_value( cType ) + "," + ;
		_sql_value( cSubType ) + ;
		")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
    QUIT
ENDIF

RETURN


STATIC FUNCTION __get_account( oServer, cValue )
LOCAL oTable
LOCAL cTable := "accnt"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT accnt_id FROM " + cTable + " WHERE accnt_number = '" + cValue + "'"
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("accnt_id") )

RETURN nResult







// setuj jedince mjere
STATIC FUNCTION __set_uom( oServer, cValue, cDescription )
LOCAL oTable
LOCAL cTable := "uom"
LOCAL cTmpQry

// provjeri prvo da li postoji uopšte ovaj UOM zapis
IF ( __get_uom( oServer, cValue ) > 0 )
	// postoji već ovaj zapis
	? "UOM " + cValue + " vec postoji !"
	RETURN
ENDIF

// ne postoji, ubaci zapis
cTmpQry := "INSERT INTO " + cTable + ;
		" ( uom_name, uom_descrip ) VALUES (" + ;
		_sql_value(cValue) + "," + _sql_value(cDescription) + ")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
    QUIT
ENDIF

RETURN

// vrati mi uom_id po traženom uom_name
STATIC FUNCTION __get_uom( oServer, cValue )
LOCAL oTable
LOCAL cTable := "uom"
LOCAL nResult
LOCAL cTmpQry

// provjeri prvo da li postoji uopšte ovaj UOM zapis
cTmpQry := "SELECT uom_id FROM " + cTable + " WHERE uom_name = '" + cValue +"'"
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("uom_id") )

RETURN nResult


// setuj valutu
STATIC FUNCTION __set_currency( oServer, cValue, cDescription, lBase )
LOCAL oTable
LOCAL cTable := "curr_symbol"
LOCAL cTmpQry
LOCAL cBase := "FALSE"

// provjeri prvo da li postoji uopšte ovaj UOM zapis
IF ( __get_currency( oServer, cValue ) > 0 )
	// postoji već ovaj zapis
	? "CURRENCY " + cValue + " vec postoji !"
	RETURN
ENDIF

IF lBase
	cBase := "TRUE"
ENDIF

// ne postoji, ubaci zapis
cTmpQry := "INSERT INTO " + cTable + ;
		" ( curr_base, curr_name, curr_symbol, curr_abbr ) VALUES (" + ;
		_sql_value(cBase) + "," + ;
		_sql_value(cDescription) + "," + ;
		_sql_value(cValue) + "," + ;
		_sql_value("") + ; 
		")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
    QUIT
ENDIF

RETURN

// vrati mi valutu iz valuta
STATIC FUNCTION __get_currency( oServer, cValue )
LOCAL oTable
LOCAL cTable := "curr_symbol"
LOCAL nResult
LOCAL cTmpQry

// provjeri prvo da li postoji uopšte ovaj UOM zapis
cTmpQry := "SELECT curr_id FROM " + cTable + " WHERE curr_symbol = " + _sql_value( cValue )
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
      Alert( oTable:ErrorMsg() )
      QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("curr_id") )

RETURN nResult





// pomoćna funkcija za sql query izvršavanje
STATIC FUNCTION _sql_query( oServer, cQuery )
LOCAL oResult
oResult := oServer:Query( cQuery )
IF oResult:NetErr()
      Alert( oResult:ErrorMsg() )
      QUIT
ENDIF
RETURN oResult



// konvertuje neku vrijednost za sql value
STATIC FUNCTION _sql_value( cValue )
RETURN "'" + cValue + "'"


// migracija šifrarnika robe
FUNCTION migrate_sif_articles( oServer, cDBPath )
LOCAL lStatus := .t.
LOCAL cFileName := cDBPath + "ROBA.DBF"
LOCAL cNotes := ""

// koristimo funkciju __set_item()
// __set_item( oServer, cValue, cDescription, cType, cUom, nPrice, cUpc_code, cNotes )


USE (cFileName) ALIAS "ROBA"
SET ORDER TO TAG "1"

GO TOP

DO WHILE !EOF()

	// provjeri sta ces preskociti
	IF EMPTY( field->id )
		SKIP
		LOOP
	ENDIF

	IF EMPTY( field->naz )
		? "Artikal " + field->id + ", je bez naziva ! Preskacem..."
        SKIP
		LOOP
	ENDIF

	? "Ubacujem " + field->id + ", " + field->naz

	// ubaci stavku na server u tabelu item
	if __set_item( oServer, ;
				field->id, ;
				field->naz, ;
				field->tip, ;
				UPPER(field->jmj), ;
				field->vpc, ;
				field->barkod, ;
				cNotes )

		// ubaci stavku na server u tabelu itemsite
		__set_itemsite( oServer, ;
					field->id, ;
					__site_name )

		// setuj porezne tipove za artikal
		__set_itemtaxtype( oServer, field->id, ;
					__taxzone_bih, ;
					__taxtype )
	
	endif

	SKIP

ENDDO

RETURN lStatus



// setuje static varijable, parametri matične firme
FUNCTION set_company_params()
LOCAL x := 5
LOCAL cInfo

__site_name := PADR( __site_name, 50 )
__comp_name := PADR( __comp_name, 200 )
__comp_addr := PADR( __comp_addr, 200 )
__comp_city := PADR( __comp_city, 50 )
__comp_postalcode := PADR( __comp_postalcode, 10 )
__comp_tel1 := PADR( __comp_tel1, 20 )
__comp_fax := PADR( __comp_fax, 20 )
__comp_email := PADR( __comp_email, 50 )
__comp_id_number := PADR( __comp_id_number, 13 )
__comp_pdv_number := PADR( __comp_pdv_number, 12 )

@ x + 1, 4 SAY "Unesi maticne podatke firme:"
@ x + 2, 4 SAY "Naziv organizacione jedince (site):" GET __site_name VALID !EMPTY(__site_name)
@ x + 3, 4 SAY "Naziv:" GET __comp_name VALID !EMPTY(__comp_name) PICT "@S60"
@ x + 4, 4 SAY "Adresa:" GET __comp_addr
@ x + 5, 4 SAY "Grad:" GET __comp_city
@ x + 6, 4 SAY "PTT broj:" GET __comp_postalcode
@ x + 7, 4 SAY "Telefon:" GET __comp_tel1
@ x + 7, 40 SAY "Fax:" GET __comp_fax
@ x + 8, 4 SAY "Email:" GET __comp_email
@ x + 9, 4 SAY "ID broj:" GET __comp_id_number
@ x + 9, 40 SAY "PDV broj:" GET __comp_pdv_number

READ

// escape hendler
if LastKey() == 27
	QUIT
	RETURN
endif

// sredi parametre
__site_name := ALLTRIM(__site_name)
__comp_name := ALLTRIM(__comp_name)
__comp_addr := ALLTRIM(__comp_addr)
__comp_city := ALLTRIM(__comp_city)
__comp_postalcode := ALLTRIM(__comp_postalcode)
__comp_tel1 := ALLTRIM(__comp_tel1)
__comp_fax := ALLTRIM(__comp_fax)
__comp_email := ALLTRIM(__comp_email)
__comp_id_number := ALLTRIM(__comp_id_number)
__comp_pdv_number := ALLTRIM(__comp_pdv_number)

cInfo := ""
cInfo += __comp_name
cInfo += ", " + __comp_addr
cInfo += ", " + __comp_city 
cInfo += "..."

RETURN cInfo



// zakači se na psql server i vrati objekat
FUNCTION db_server_connect(cHostName, cDatabase, cUser, cPassword, nPort, cSchema)
LOCAL oServer
 
oServer := TPQServer():New( cHostName, cDatabase, cUser, cPassWord, nPort, cSchema )

IF oServer:NetErr()
      ? oServer:ErrorMsg()
      QUIT
ENDIF

RETURN oServer



PROCEDURE help()
   
   ? "fmk_migrate - migriranje podataka iz FMK u xtuple bazu"
   ? "--- uslovi"
   ? "-h hostname (default: localhost)"
   ? "-y port (default: 5432)"
   ? "-u user (default: root)"
   ? "-p password (default no password)"
   ? "-d name of database to use"
   ? "-e schema (default: public)"
   ? "-t fmk tables path"
   ? ""

RETURN


