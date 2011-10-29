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
STATIC __comp_state := ""
STATIC __comp_country := ""
// porezi
STATIC __taxzone_bih := "FBIH"
STATIC __taxzone_ino := "INO"
STATIC __taxauth := "UIO"
STATIC __taxtype := "OSTALO"
// ostale varijable
STATIC __currency := "KM"
STATIC __verbosed := .f.
STATIC __sezona := ""

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
LOCAL nRecords


SET CENTURY ON
SET DATE ANSI
SET EPOCH TO 1960
SET DELETE ON

// setuj tekucu sezonu
__sezona := ALLTRIM(STR(YEAR(DATE())))

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
	CASE cTok == "-v"
		__verbosed := .t.
	OTHERWISE
		help()
		QUIT
	ENDCASE

ENDDO

// ispisi parametre
? "Ulazni parametri:"
? cParams

// ostvari konekciju na server
oPgServer := db_server_connect(cHostName, cDatabase, cUser, cPassword, nPort, cSchema)

// daj mi parametre firme
cParams := set_company_params( oPgServer )

@ 16, 2 SAY ""

verbosed( cParams )

? "Start time: ", TIME()

// prvo setuj valutu u bazi
__set_currency( oPgServer, "KM", "Konvertibilna marka", .t. ) 

? "1) Import konta u toku, sacekajte trenutak..."
// prebaci šifrarnike konta
nRecords := migrate_sif_accounts( oPgServer, cDBFDataPath )

? "  - Importovao " + ALLTRIM(STR(nRecords)) + " konta..."

? "2) setujem glavne parametre baze..."
// setuj osnovne postavke na sql serveru (jmj, tarife, ...)
lStatus := set_db_main_params( oPgServer )
? "   - setovao"

? "3) Import artkala u toku, sacekajte trenutak..."
// prebaci šifrarnike robe
nRecords := migrate_sif_articles( oPgServer, cDBFDataPath )

? "  - Importovao " + ALLTRIM(STR(nRecords)) + " artikala..."

? "4) Import partnera u toku, sacekajte trenutak"
// prebaci šifrarnike partnera
nRecords := migrate_sif_partners( oPgServer, cDBFDataPath )

? "  - Importovao " + ALLTRIM(STR(nRecords)) + " partnera..."

? "5) Import podataka modula FAKT, sacekajte trenutak"
// prebaci fakturne podatke
nRecords := migrate_fakt_data( oPgServer, cDBFDataPath )

? "  - Importovao " + ALLTRIM(STR(nRecords)) + " podataka..."

?
? "End time: ", TIME()

RETURN


// setuj osnovne postavke na bazi
FUNCTION set_db_main_params( oServer )
LOCAL lStatus := .t.

// setuj parametre...
// konta proširi na 7 mjesta
__set_metric( oServer, "GLMainSize", "7" )
// isključi company, subtype
__set_metric( oServer, "GLCompanySize", "0" )
__set_metric( oServer, "GLProfitSize", "0" )
__set_metric( oServer, "GLSubaccountSize", "0" )
__set_metric( oServer, "GLFFSubaccounts", "f" )
__set_metric( oServer, "GLFFProfitCenters", "f" )


// setuj jedinice mjere, tabela "UOM"
__set_uom( oServer, "KOM", "Komad" )
__set_uom( oServer, "LIT", "Litar" )
__set_uom( oServer, "PAK", "Paket" )
__set_uom( oServer, "SAT", "Sat" )
__set_uom( oServer, "GR", "Gram" )

// setuj tarife i tarifne skupine
__configure_tax( oServer )

// set site - organizaciona jedinca
__set_sitetype( oServer, "WHSE", "Warehouse" )
__set_site( oServer )


RETURN lStatus


FUNCTION __set_metric( oServer, cParam, cValue )
LOCAL oTable
LOCAL cTmpQry

cTmpQry := "SELECT setmetric( " + _sql_value( cParam ) + ", " + _sql_value( cValue) + ")" ;

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

RETURN



STATIC FUNCTION __set_crm( oServer, cValue, cDescription, cTel, cFax, cAddr, cCity, cPostal, cIdBroj, cNotes )
LOCAL oTable
LOCAL cTable := "api.account"
LOCAL cTmpQry
LOCAL lReturn := .f.

IF ( __get_crm( oServer, cValue ) > 0 )
	verbosed( "CRM " + cValue + " vec postoji !" )
	RETURN lReturn
ENDIF

IF cNotes == nil
	cNotes := ""
ENDIF

// prvo insertuj u CRM

cTmpQry := "INSERT INTO " + cTable + ;
	" ( account_number, active, account_name, type, " + ;
	"primary_contact_honorific, primary_contact_first, primary_contact_voice, " + ;
	"primary_contact_fax, primary_contact_address1, primary_contact_city, " + ;
	"primary_contact_state, primary_contact_postalcode, notes ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( "TRUE" ) + "," + ;
	_sql_value( cDescription ) + "," + ;
	_sql_value( "Organization" ) + "," + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cDescription ) + "," + ;
	_sql_value( cTel ) + "," + ;
	_sql_value( cFax ) + "," + ;
	_sql_value( cAddr ) + "," + ;
	_sql_value( cCity ) + "," + ;
	_sql_value( cCity ) + "," + ;
	_sql_value( cPostal ) + "," + ;
	_sql_value( cNotes ) + ;
	")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

// zatim insert istog u CUSTOMER
cTable := "api.customer"

cTmpQry := "INSERT INTO " + cTable + ;
	" ( customer_number, active, customer_name, customer_type, " + ;
	"sales_rep, ship_form, default_tax_zone, default_terms, billing_contact_honorific, " + ;
	"billing_contact_first, billing_contact_voice, billing_contact_fax, " + ;
	"billing_contact_address1, billing_contact_city, billing_contact_state, " + ;
	"billing_contact_postalcode, notes ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( "TRUE" ) + "," + ;
	_sql_value( cDescription ) + "," + ;
	_sql_value( "KD" ) + "," + ;
	_sql_value( "DEFAULT" ) + "," + ;
	_sql_value( "KUPCI" ) + "," + ;
	_sql_value( __taxzone_bih ) + "," + ;
	_sql_value( "DEFAULT" ) + "," + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cDescription ) + "," + ;
	_sql_value( cTel ) + "," + ;
	_sql_value( cFax ) + "," + ;
	_sql_value( cAddr ) + "," + ;
	_sql_value( cCity ) + "," + ;
	_sql_value( cCity ) + "," + ;
	_sql_value( cPostal ) + "," + ;
	_sql_value( cNotes ) + ;
	")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

// zatim insert istog u CUSTSHIPTO
cTable := "api.custshipto"

cTmpQry := "INSERT INTO " + cTable + ;
	" ( customer_number, shipto_number, active, name, " + ;
	"address1, city, state, postal_code, sales_rep, " + ;
	"tax_zone, ship_via, " + ;
	"ship_form ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( "TRUE" ) + "," + ;
	_sql_value( cDescription ) + "," + ;
	_sql_value( cAddr ) + "," + ;
	_sql_value( cCity ) + "," + ;
	_sql_value( cCity ) + "," + ;
	_sql_value( cPostal ) + "," + ;
	_sql_value( "DEFAULT" ) + "," + ;
	_sql_value( __taxzone_bih ) + "," + ;
	_sql_value( "DEFAULT" ) + "," + ;
	_sql_value( "KUPCI" ) + ;
	")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF


// zatim insert registracije u CUSTOMERTAXREG
cTable := "api.customertaxreg"

cTmpQry := "INSERT INTO " + cTable + ;
	" ( customer_number, tax_zone, tax_authority, " + ;
	"registration_number, start_date, end_date ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( __taxzone_bih ) + "," + ;
	_sql_value( __taxauth ) + "," + ;
	_sql_value( cIdBroj ) + "," + ;
	_sql_value( "Always" ) + "," + ;
	_sql_value( "Never" ) + ;
	")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

// zatim insert istog u VENDOR
cTable := "api.vendor"

cTmpQry := "INSERT INTO " + cTable + ;
	" ( vendor_number, active, vendor_name, vendor_type, " + ;
	"address1, city, state, postalcode, default_terms, default_tax_zone, " + ;
	"contact1_honorific, contact1_first, contact1_voice, contact1_fax, " + ;
	"allow_email_po_delivery ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( "TRUE" ) + "," + ;
	_sql_value( cDescription ) + "," + ;
	_sql_value( "DD" ) + "," + ;
	_sql_value( cAddr ) + "," + ;
	_sql_value( cCity ) + "," + ;
	_sql_value( cCity ) + "," + ;
	_sql_value( cPostal ) + "," + ;
	_sql_value( "DEFAULT" ) + "," + ;
	_sql_value( __taxzone_bih ) + "," + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cDescription ) + "," + ;
	_sql_value( cTel ) + "," + ;
	_sql_value( cFax ) + "," + ;
	_sql_value( "TRUE" ) + ;
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

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE item_number = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult


STATIC FUNCTION __get_item_data( oServer, cValue )
LOCAL oTable
LOCAL cTable := "api.item"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT * FROM " + cTable + " WHERE item_number = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

RETURN oTable




STATIC FUNCTION __get_item_type( cValue )
LOCAL cType := "Purchased"

IF cValue == "U"
	cType := "Reference"
ENDIF

IF cValue == "S"
	cType := "Manufactured"
ENDIF

RETURN cType 



	// setuj itemsite
STATIC FUNCTION __set_itemsite( oServer, cValue, cSite, cNotes, cTip )
LOCAL oTable
LOCAL cTable := "api.itemsite"
LOCAL cTmpQry
//LOCAL cCostMethod := "Average"
LOCAL cCostMethod := "Standard"
LOCAL cCtrlMethod := "Regular"
LOCAL cPlanner := "P1"
LOCAL cCostCateg := "C1"

IF cTip == "U"
	cCostMethod := "None"
	cCtrlMethod := "None"
ENDIF

IF ( cNotes == nil )
	cNotes := ""
ENDIF

// provjeri prvo da li postoji uopšte ovaj UOM zapis
IF ( __get_itemsite( oServer, cValue, cSite ) > 0 )
	// postoji već ovaj zapis
	verbosed( "ITEMSITE stavka " + cValue + " vec postoji !" )
	RETURN
ENDIF

// ne postoji, ubaci zapis
cTmpQry := "INSERT INTO " + cTable + ;
	" ( item_number, site, active, po_supplied_at_site, sold_from_site, ranking, cost_method, control_method, " + ;
	"planner_code, cost_category, notes, enforce_on_manual_orders, planning_system, group_mps_mrp_orders ) VALUES (" + ;
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
	_sql_value( cNotes ) + "," + ;
	_sql_value( "FALSE" ) + "," + ;
	_sql_value( "MRP" ) + "," + ;
	ALLTRIM(STR( 1 )) + ;
	")"

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

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE item_number = " + _sql_quote(cValue) +  ;
	" AND site = " + _sql_quote(cSite)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult



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

IF EMPTY(cUom)
	cUom := "KOM"
ENDIF

cUom := UPPER(cUom)
// ubaci jedinicu mjere
__set_uom( oServer, cUom, "" )

// vrati tip na osnovu tipa iz FMK
cItemType := __get_item_type( cType )

// provjeri prvo da li postoji uopšte ovaj UOM zapis
IF ( __get_item( oServer, cValue ) > 0 )
	// postoji već ovaj zapis
	verbosed( "ITEM " + cValue + " vec postoji !" )
	RETURN lReturn
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( item_number, active, fractional, description1, item_type, class_code, inventory_uom, product_category, " + ;
	"list_price, list_price_uom, upc_code, notes ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( "TRUE" ) + "," + ;
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


STATIC FUNCTION __get_crm( oServer, cValue )
LOCAL oTable
LOCAL cTable := "crmacct"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE crmacct_number = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult



STATIC FUNCTION __set_site( oServer )
LOCAL oTable
LOCAL cTable := "api.site"
LOCAL cTmpQry
LOCAL cValue := __site_name

IF ( __get_site( oServer, cValue ) > 0 )
	verbosed( "SITE " + cValue + " vec postoji !" )
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( code, active, type, description, post_unassigned_transactions_to, " + ;
	"address1, city, state, postal_code, country, honorific, first, phone, fax, email ) VALUES (" + ;
	_sql_value( __site_name ) + "," + ;
	"TRUE" + "," + ;
	_sql_value( "WHSE" ) + "," + ;
	_sql_value( __comp_name ) + "," + ;
	_sql_value( "1320" ) + "," + ;
	_sql_value( __comp_addr ) + "," + ;
	_sql_value( __comp_city ) + "," + ;
	_sql_value( __comp_state ) + "," + ;
	_sql_value( __comp_postalcode ) + "," + ;
	_sql_value( __comp_country ) + "," + ;
	_sql_value( __site_name ) + "," + ;
	_sql_value( __comp_name ) + "," + ;
	_sql_value( __comp_tel1 ) + "," + ;
	_sql_value( __comp_fax ) + "," + ;
	_sql_value( __comp_email ) + ")" 

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( "set_site: " + oTable:ErrorMsg() )
	QUIT
ENDIF

RETURN


STATIC FUNCTION __get_site( oServer, cValue )
LOCAL oTable
LOCAL cTable := "api.site"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE code = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult



STATIC FUNCTION __get_site_data( oServer, cValue )
LOCAL oTable
LOCAL cTable := "api.site"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT * FROM " + cTable + " WHERE code = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

RETURN oTable



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
nCurr := __get_currency_id( oServer, __currency )

// daj mi konto 4700
nIzlPdv := __get_account_id( oServer, "4700" )

// setuj poreznu upravu
__set_taxauth( oServer, __taxauth, "Uprava za indirektno oporezivanje", nCurr, "Bosna i Hercegovina" )
// vrati mi defaultnu poreznu upravu
nTaxAuth := __get_taxauth_id( oServer, __taxauth )

// setuj poreznu zonu
__set_taxzone( oServer, __taxzone_bih, "Federacija Bosne i Hercegovine")
nTaxZoneBih := __get_taxzone_id( oServer, __taxzone_bih )
__set_taxzone( oServer, __taxzone_ino, "INO export/import")
nTaxZoneIno := __get_taxzone_id( oServer, __taxzone_ino )
__set_taxzone( oServer, "RS", "Republika Srpska")

// setuj tip poreza
__set_taxtype( oServer, __taxtype, "Ostalo")
nTaxTypeBih := __get_taxtype_id( oServer, __taxtype )
__set_taxtype( oServer, "PREHRANA", "Prehrambeni artikli")
__set_taxtype( oServer, "TEHNIKA", "Tehnika")
__set_taxtype( oServer, "INO", "Inostranstvo")
nTaxTypeIno := __get_taxtype_id( oServer, "INO" )

// setuj stope

// stopa T1 - 17%
__set_tax( oServer, "T1", "T1", nIzlPdv, nTaxAuth )
nTax := __get_tax_id( oServer, "T1" )
// setuj iznos za T1
__set_taxrate( oServer, nTax, 17.00, nCurr )
// poveži tax zonu i tax tip
__set_taxass( oServer, nTaxZoneBih, nTaxTypeBih, nTax )


// stopa TINO - 0%
__set_tax( oServer, "TINO", "Tarifa inostranstvno", nIzlPdv, nTaxAuth )
nTax := __get_tax_id( oServer, "TINO" )
// setuj iznos za TINO
__set_taxrate( oServer, nTax, 0, nCurr )
// poveži tax zonu i tax tip
__set_taxass( oServer, nTaxZoneIno, nTaxTypeIno, nTax )


// dodaj terms

__set_terms( oServer, "DEFAULT", "DEFAULT" )


RETURN


STATIC FUNCTION __set_classcode( oServer, cValue, cDescription )
	LOCAL oTable
	LOCAL cTable := "classcode"
	LOCAL cTmpQry

IF ( __get_classcode( oServer, cValue ) > 0 )  
	verbosed( "Class code " + cValue + " vec postoji!"  )
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( classcode_code, classcode_descrip ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cDescription ) + ")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

RETURN


STATIC FUNCTION __get_classcode( oServer, cValue )
LOCAL oTable
LOCAL cTable := "classcode"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE classcode_code = " + _sql_quote(cValue) 
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult



STATIC FUNCTION __get_classcode_id( oServer, cValue )
LOCAL oTable
LOCAL cTable := "classcode"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT classcode_id FROM " + cTable + " WHERE classcode_code = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("classcode_id") )

RETURN nResult



STATIC FUNCTION __set_costcat( oServer, cValue, cDescription )
LOCAL oTable
LOCAL cTable := "costcat"
LOCAL cTmpQry
LOCAL nAcc1, nAcc2, nAcc3, nAcc4, nAcc5, nAcc6, nAcc7, nAcc8, nAcc9, nAcc10, nAcc11, nAcc12

IF ( __get_costcat( oServer, cValue ) > 0 )  
	verbosed( "Cost category " + cValue + " vec postoji!"  )
	RETURN
ENDIF

nAcc1 := __get_account( oServer, "1320" )
nAcc2 := nAcc1
nAcc3 := nAcc1
nAcc4 := nAcc1
nAcc5 := nAcc1
nAcc6 := nAcc1
nAcc7 := nAcc1
nAcc8 := nAcc1
nAcc9 := nAcc1
nAcc10 := nAcc1
nAcc11 := nAcc1
nAcc12 := nAcc1


cTmpQry := "INSERT INTO " + cTable + ;
	" ( costcat_code, costcat_descrip, costcat_asset_accnt_id, costcat_liability_accnt_id, " + ;
	"costcat_adjustment_accnt_id, costcat_purchprice_accnt_id, costcat_scrap_accnt_id, " + ;
	"costcat_invcost_accnt_id, costcat_wip_accnt_id, costcat_shipasset_accnt_id, " + ;
	"costcat_mfgscrap_accnt_id, costcat_freight_accnt_id, costcat_toliability_accnt_id, costcat_exp_accnt_id ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cDescription ) + "," + ;
	ALLTRIM(STR( nAcc1 )) + "," + ;
	ALLTRIM(STR( nAcc2 )) + "," + ;
	ALLTRIM(STR( nAcc3 )) + "," + ;
	ALLTRIM(STR( nAcc4 )) + "," + ;
	ALLTRIM(STR( nAcc5 )) + "," + ;
	ALLTRIM(STR( nAcc6 )) + "," + ;
	ALLTRIM(STR( nAcc7 )) + "," + ;
	ALLTRIM(STR( nAcc8 )) + "," + ;
	ALLTRIM(STR( nAcc9 )) + "," + ;
	ALLTRIM(STR( nAcc10 )) + "," + ;
	ALLTRIM(STR( nAcc11 )) + "," + ;
	ALLTRIM(STR( nAcc12 )) + ")" 

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

RETURN


STATIC FUNCTION __get_costcat( oServer, cValue )
LOCAL oTable
LOCAL cTable := "costcat"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE costcat_code = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult


STATIC FUNCTION __get_costcat_id( oServer, cValue )
LOCAL oTable
LOCAL cTable := "costcat"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT costcat_id FROM " + cTable + " WHERE costcat_code = " + _sql_quote(cValue) 
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("costcat_id") )

RETURN nResult



STATIC FUNCTION __set_custtype( oServer, cValue, cDescription )
LOCAL oTable
LOCAL cTable := "api.customertype"
LOCAL cTmpQry

IF ( __get_custtype( oServer, cValue ) > 0 )  
	verbosed( "Customer category " + cValue + " vec postoji!"  )
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( code, description ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cDescription ) + ")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

RETURN


STATIC FUNCTION __get_custtype( oServer, cValue )
LOCAL oTable
LOCAL cTable := "api.customertype"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE code = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult


STATIC FUNCTION __set_vendtype( oServer, cValue, cDescription )
LOCAL oTable
LOCAL cTable := "api.vendortype"
LOCAL cTmpQry

IF ( __get_vendtype( oServer, cValue ) > 0 )  
	verbosed( "Vendor category " + cValue + " vec postoji!"  )
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( code, description ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cDescription ) + ")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

RETURN


STATIC FUNCTION __get_vendtype( oServer, cValue )
LOCAL oTable
LOCAL cTable := "api.vendortype"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE code = " + _sql_quote(cValue) 
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult


STATIC FUNCTION __set_sitetype( oServer, cValue, cDescription )
LOCAL oTable
LOCAL cTable := "sitetype"
LOCAL cTmpQry

IF ( __get_sitetype( oServer, cValue ) > 0 )  
	verbosed( "Warehous " + cValue + " vec postoji!"  )
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( sitetype_name, sitetype_descrip ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cDescription ) + ")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

RETURN


STATIC FUNCTION __get_sitetype( oServer, cValue )
LOCAL oTable
LOCAL cTable := "sitetype"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE sitetype_name = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult



STATIC FUNCTION __set_salesrep( oServer, cValue, cDescription )
LOCAL oTable
LOCAL cTable := "api.salesrep"
LOCAL cTmpQry

IF ( __get_salesrep( oServer, cValue ) > 0 )  
	verbosed( "Sales representative " + cValue + " vec postoji!"  )
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( number, active, name ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( "TRUE" ) + "," + ;
	_sql_value( cDescription ) + ")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

RETURN


STATIC FUNCTION __get_salesrep( oServer, cValue )
LOCAL oTable
LOCAL cTable := "api.salesrep"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE number = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult


STATIC FUNCTION __set_shipform( oServer, cValue, cDescription )
LOCAL oTable
LOCAL cTable := "shipform"
LOCAL cTmpQry

IF ( __get_shipform( oServer, cValue ) > 0 )  
	verbosed( "Shipform " + cValue + " vec postoji!"  )
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( shipform_name, shipform_report_name ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cDescription ) + ")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

RETURN


STATIC FUNCTION __get_shipform( oServer, cValue )
LOCAL oTable
LOCAL cTable := "shipform"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE shipform_name = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult


STATIC FUNCTION __get_shipform_id( oServer, cValue )
LOCAL oTable
LOCAL cTable := "shipform"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT shipform_id FROM " + cTable + " WHERE shipform_name = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("shipform_id") )

RETURN nResult


STATIC FUNCTION __set_salescat( oServer, cValue, cDescription )
LOCAL oTable
LOCAL cTable := "salescat"
LOCAL cTmpQry
LOCAL nAccnt1 := 0 
LOCAL nAccnt2 := 0

__set_account( oServer, "6000", "Test", get_accnt_type("6000"), ;
		get_accnt_subtype( "6000" ) )
nAccnt1 := __get_account_id( oServer, "6000" ) 

__set_account( oServer, "2003", "Test", get_accnt_type("2003"), ;
		get_accnt_subtype( "2003" ) )
nAccnt2 := __get_account_id( oServer, "2003" ) 

IF ( __get_salescat( oServer, cValue ) > 0 )  
	verbosed( "Sales category " + cValue + " vec postoji!"  )
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( salescat_active, salescat_name, salescat_descrip, salescat_sales_accnt_id, " + ;
	"salescat_prepaid_accnt_id, salescat_ar_accnt_id ) VALUES (" + ;
	_sql_value( "TRUE" ) + "," + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cDescription ) + "," + ;
	ALLTRIM(STR( nAccnt1 )) + "," + ;
	ALLTRIM(STR( nAccnt1 )) + "," + ;
	ALLTRIM(STR( nAccnt2 )) + ")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

RETURN




STATIC FUNCTION __get_salescat( oServer, cValue )
LOCAL oTable
LOCAL cTable := "salescat"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT count(*) FROM " + cTable + " WHERE salescat_name = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult



STATIC FUNCTION __get_salescat_id( oServer, cValue )
LOCAL oTable
LOCAL cTable := "salescat"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT salescat_id FROM " + cTable + " WHERE salescat_name = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("salescat_id") )

RETURN nResult





STATIC FUNCTION __set_prodcat( oServer, cValue, cDescription )
LOCAL oTable
LOCAL cTable := "prodcat"
LOCAL cTmpQry

IF ( __get_prodcat( oServer, cValue ) > 0 )  
	verbosed( "Product category " + cValue + " vec postoji!"  )
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( prodcat_code, prodcat_descrip ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cDescription ) + ")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

RETURN




STATIC FUNCTION __get_prodcat( oServer, cValue )
LOCAL oTable
LOCAL cTable := "prodcat"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT count(*) FROM " + cTable + " WHERE prodcat_code = " + _sql_quote(cValue) 
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult



STATIC FUNCTION __get_prodcat_id( oServer, cValue )
LOCAL oTable
LOCAL cTable := "prodcat"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT prodcat_id FROM " + cTable + " WHERE prodcat_code = " + _sql_quote( cValue )
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("prodcat_id") )

RETURN nResult




STATIC FUNCTION __set_plcode( oServer, cValue, cDescription )
LOCAL oTable
LOCAL cTable := "plancode"
LOCAL cTmpQry

IF ( __get_plcode( oServer, cValue ) > 0 )  
	verbosed( "Planner code " + cValue + " vec postoji!"  )
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( plancode_code, plancode_name, plancode_mpsexplosion ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cDescription ) + "," + ;
	_sql_value( "N" ) + ")" 

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

RETURN


STATIC FUNCTION __get_plcode( oServer, cValue )
LOCAL oTable
LOCAL cTable := "plancode"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE plancode_code = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult



STATIC FUNCTION __get_plcode_id( oServer, cValue )
LOCAL oTable
LOCAL cTable := "plancode"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT plancode_id FROM " + cTable + " WHERE plancode_code = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("plancode_id") )

RETURN nResult



STATIC FUNCTION __set_tax( oServer, cValue, cDescription, nAccount, nTaxAuth )
LOCAL oTable
LOCAL cTable := "tax"
LOCAL cTmpQry

IF ( __get_tax( oServer, cValue ) > 0 )  
	verbosed( "TAX code " + cValue + " vec postoji!"  )
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

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE tax_code = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult



STATIC FUNCTION __get_tax_id( oServer, cValue )
LOCAL oTable
LOCAL cTable := "tax"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT tax_id FROM " + cTable + " WHERE tax_code = " + _sql_quote(cValue)
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
	verbosed( "TAX auth " + cValue + " vec postoji!"  )
	RETURN
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( taxauth_code, taxauth_name, taxauth_curr_id, taxauth_county ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cDescription ) + "," + ;
	ALLTRIM(STR( nCurrency )) + "," + ;
	_sql_value( cCountry ) + ;
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

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE taxauth_code = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult



STATIC FUNCTION __get_taxauth_id( oServer, cValue )
LOCAL oTable
LOCAL cTable := "taxauth"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT taxauth_id FROM " + cTable + " WHERE taxauth_code = " + _sql_quote(cValue)
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
	verbosed( "TAX zone " + cValue + " vec postoji!"  )
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

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE taxzone_code = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult


STATIC FUNCTION __get_taxzone_id( oServer, cValue )
LOCAL oTable
LOCAL cTable := "taxzone"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT taxzone_id FROM " + cTable + " WHERE taxzone_code = " + _sql_quote(cValue)
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
	verbosed( "TAX type " + cValue + " vec postoji!"  )
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

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE taxtype_name = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult


STATIC FUNCTION __get_taxtype_id( oServer, cValue )
LOCAL oTable
LOCAL cTable := "taxtype"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT taxtype_id FROM " + cTable + " WHERE taxtype_name = " + _sql_quote(cValue)
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
	verbosed( "ITEMTAXTYPE " + cValue + " vec postoji!"  )
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
	verbosed( "TAX rate " + ALLTRIM(STR(nTax)) + " vec postoji!"  )
	RETURN
ENDIF

// prekalkuliši iznos poreza
// definiše se kao 17, a u bazu se mora unjeti kao 0.17
nAmount := nAmount / 100

cTmpQry := "INSERT INTO " + cTable + ;
	" ( taxrate_tax_id, taxrate_percent, taxrate_curr_id, taxrate_amount, " + ;
	"taxrate_effective, taxrate_expires ) VALUES (" + ;
	ALLTRIM(STR( nTax )) + "," + ;
	ALLTRIM(STR( nAmount )) + "," + ;
	ALLTRIM(STR( nCurrency )) + "," + ;
	ALLTRIM(STR(0)) + "," + ;
	format_sql_date(CTOD("70/01/01")) + "," + ;
	format_sql_date(CTOD("30/01/01")) + ;
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

	cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE taxrate_tax_id = " + ALLTRIM(STR(nValue)) 
	oTable := _sql_query( oServer, cTmpQry )
	IF oTable:NetErr()
Alert( oTable:ErrorMsg() )
	QUIT
	ENDIF

	nResult := oTable:Fieldget( oTable:Fieldpos("count") )

	RETURN nResult


STATIC FUNCTION __get_taxrate_id( oServer, nValue )
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
	verbosed( "TAX ass vec postoji!"  )
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

	cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE " + ;
	"taxass_taxzone_id = " + ALLTRIM(STR(nTaxZone)) + " AND " + ; 
	"taxass_taxtype_id = " + ALLTRIM(STR(nTaxType)) + " AND " + ; 
	"taxass_tax_id = " + ALLTRIM(STR(nTax)) 
	oTable := _sql_query( oServer, cTmpQry )
	IF oTable:NetErr()
Alert( oTable:ErrorMsg() )
	QUIT
	ENDIF

	nResult := oTable:Fieldget( oTable:Fieldpos("count") )

	RETURN nResult


STATIC FUNCTION __get_taxass_id( oServer, nTaxZone, nTaxType, nTax )
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
	verbosed( "TERMS " + cValue + " vec postoji!"  )
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
	_sql_value( "TRUE" ) + "," + ;
	_sql_value( "TRUE" ) + ;
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

	cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE terms_code = " + _sql_quote(cValue)
	oTable := _sql_query( oServer, cTmpQry )
	IF oTable:NetErr()
Alert( oTable:ErrorMsg() )
	QUIT
	ENDIF

	nResult := oTable:Fieldget( oTable:Fieldpos("count") )

	RETURN nResult



STATIC FUNCTION __get_terms_id( oServer, cValue )
	LOCAL oTable
	LOCAL cTable := "terms"
	LOCAL nResult
	LOCAL cTmpQry

	cTmpQry := "SELECT terms_id FROM " + cTable + " WHERE terms_code = " + _sql_quote(cValue)
	oTable := _sql_query( oServer, cTmpQry )
	IF oTable:NetErr()
Alert( oTable:ErrorMsg() )
	QUIT
	ENDIF

	nResult := oTable:Fieldget( oTable:Fieldpos("terms_id") )

	RETURN nResult




STATIC FUNCTION __set_account( oServer, cValue, cDescription, cType, cSubType )
LOCAL oTable
LOCAL cTable := "accnt"
LOCAL cTmpQry
LOCAL lReturn := .f.

IF ( __get_account( oServer, cValue ) > 0 )  
	verbosed( "ACCOUNT " + cValue + " vec postoji!"  )
	RETURN lReturn
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( accnt_number, accnt_descrip, accnt_type, accnt_subaccnttype_code, " + ;
	"accnt_closedpost, accnt_forwardupdate ) VALUES (" + ;
	_sql_value( cValue ) + "," + ;
	_sql_value( cDescription ) + "," + ;
	_sql_value( cType ) + "," + ;
	_sql_value( cSubType ) + "," + ;
	"FALSE" + "," + ;
	"FALSE" + ")" 

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

lReturn := .t.

RETURN lReturn 


STATIC FUNCTION __get_account( oServer, cValue )
LOCAL oTable
LOCAL cTable := "accnt"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE accnt_number = " + _sql_quote(cValue)
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult


STATIC FUNCTION __get_account_id( oServer, cValue )
LOCAL oTable
LOCAL cTable := "accnt"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT accnt_id FROM " + cTable + " WHERE accnt_number = " + _sql_quote(cValue)
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
	verbosed( "UOM " + cValue + " vec postoji !" )
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
	cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE uom_name = " + _sql_quote(cValue)
	oTable := _sql_query( oServer, cTmpQry )
	IF oTable:NetErr()
Alert( oTable:ErrorMsg() )
	QUIT
	ENDIF

	nResult := oTable:Fieldget( oTable:Fieldpos("count") )

	RETURN nResult

// vrati mi uom_id po traženom uom_name
STATIC FUNCTION __get_uom_id( oServer, cValue )
	LOCAL oTable
	LOCAL cTable := "uom"
	LOCAL nResult
	LOCAL cTmpQry

	// provjeri prvo da li postoji uopšte ovaj UOM zapis
	cTmpQry := "SELECT uom_id FROM " + cTable + " WHERE uom_name = " + _sql_quote(cValue)
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
	verbosed( "CURRENCY " + cValue + " vec postoji !" )
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
cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE curr_symbol = " + _sql_quote( cValue )
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult

// vrati mi valutu iz valuta
STATIC FUNCTION __get_currency_id( oServer, cValue )
LOCAL oTable
LOCAL cTable := "curr_symbol"
LOCAL nResult
LOCAL cTmpQry

// provjeri prvo da li postoji uopšte ovaj UOM zapis
cTmpQry := "SELECT curr_id FROM " + cTable + " WHERE curr_symbol = " + _sql_quote( cValue )
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
RETURN _sql_quote(cValue)


// migracija šifrarnika robe
FUNCTION migrate_sif_articles( oServer, cDBPath )
LOCAL cNotes := ""
LOCAL nCount := 0
LOCAL cRobaNaziv
LOCAL cTblName := "ROBA.dbf"
LOCAL cFileName := cDBPath + cTblName
LOCAL cBarKod := ""

IF !FILE( cFileName )
	? "Fajl " + cFileName + " ne postoji, prekidam operaciju !"
	QUIT
ENDIF

// ako ne postoji fajl cdx, napravi indeks
IF !FILE( STRTRAN( cFileName, ".dbf", ".cdx" ) )
	CREATE_INDEX("ID", "ID", cDBPath + "ROBA")
ENDIF

// ubaci class code
__set_classcode( oServer, "OSTALO", "OSTALO" )
// ubaci prod category
__set_prodcat( oServer, "OSTALO", "OSTALO" )
// ubaci planne code
__set_plcode( oServer, "P1", "Plan 1" )
// ubaci cost category
__set_costcat( oServer, "C1", "Kategorija 1" )

// zakači se na tabelu robe
SELECT 100
USE (cFileName) ALIAS "ROBA"
SET ORDER TO TAG "ID"

GO TOP

DO WHILE !EOF()

	// provjeri sta ces preskociti
	IF EMPTY( field->id ) .OR. EMPTY( field->naz )
		SKIP
		LOOP
	ENDIF

	cRobaNaziv := field->naz

	IF roba->(FIELDPOS("BARKOD")) <> 0
		cBarKod := roba->barkod
	ENDIF

	verbosed( "- Ubacujem: " + ALLTRIM(roba->id) + ", " + ALLTRIM(roba->naz) )

	// ubaci stavku na server u tabelu item
	if __set_item( oServer, ;
		ALLTRIM( hb_strtoutf8( UPPER(roba->id) ) ), ;
		ALLTRIM( hb_strtoutf8( cRobaNaziv ) ), ;
		roba->tip, ;
		ALLTRIM( hb_strtoutf8( UPPER(field->jmj) ) ), ;
		field->vpc, ;
		cBarKod, ;
		hb_strtoutf8( cNotes ) ) = .t.

		verbosed( "item ubacen" )

		++ nCount

		// ubaci stavku na server u tabelu itemsite
		__set_itemsite( oServer, ;
			ALLTRIM( hb_strtoutf8(UPPER(roba->id)) ), ;
			__site_name, roba->tip )

		verbosed( "itemsite ubacen" )

		// setuj porezne tipove za artikal
		__set_itemtaxtype( oServer, ALLTRIM( hb_strtoutf8( UPPER(roba->id) ) ), ;
			__taxzone_bih, ;
			__taxtype )

		verbosed( "itemtaxtype ubacen" )

	endif

	SKIP

ENDDO

RETURN nCount



FUNCTION migrate_sif_accounts( oServer, cDBPath )
LOCAL nCount := 0
LOCAL cTblName := "KONTO.dbf"
LOCAL cFileName := cDBPath + cTblName
LOCAL cAccType
LOCAL cAccSubType
LOCAL cKto

IF !FILE( cFileName )
	? "Fajl " + cFileName + " ne postoji, prekidam operaciju !"
	QUIT
ENDIF

// ako ne postoji fajl cdx, napravi indeks
IF !FILE( STRTRAN( cFileName, ".dbf", ".cdx" ) )
	CREATE_INDEX("ID", "ID", cDBPath + "KONTO")
ENDIF

// zakači se na tabelu robe
USE (cFileName) ALIAS "KONTO"
SET ORDER TO TAG "ID"

GO TOP

DO WHILE !EOF()

	// provjeri sta ces preskociti
	IF EMPTY( field->id )
		SKIP
		LOOP
	ENDIF

	cKto := ALLTRIM( field->id )

	// krenut ćemo od sintetičkih konta, sve ostalo izbaciti
	IF LEN( cKto ) < 3
		SKIP
		LOOP
	ENDIF

	// preskoci ova konta, klase...
	IF LEFT( cKto, 1 ) $ "8#"
		SKIP
		LOOP
	ENDIF

	// preskoči ova konta, grupe
	IF LEFT( cKto, 2 ) $ "63#08#25#26#37"
		SKIP
		LOOP
	ENDIF

	verbosed( "- ubacujem: " + ALLTRIM(konto->id) + ", " + ALLTRIM(konto->naz) )

	// daj mi tip i subtip konta
	cAccType := get_accnt_type( cKto )
	cAccSubType := get_accnt_subtype( cKto )
	
	// ubaci stavku na server u tabelu item
	if __set_account( oServer, ;
			ALLTRIM( hb_strtoutf8( konto->id ) ), ;
			ALLTRIM( hb_strtoutf8( konto->naz ) ), ;
			cAccType, ;
			cAccSubType ) = .t.

		++ nCount

	endif

	SKIP

ENDDO	

RETURN nCount


STATIC FUNCTION get_accnt_type( cKto )
LOCAL cType := ""

// daj mi tip	
DO CASE

	CASE LEFT(cKto, 1) $ "0#1#2"
		// Assets
		cType := "A"
	CASE LEFT(cKto, 1) $ "4#"
		// Liabilities
		cType := "L"
	CASE LEFT(cKto, 1) $ "5#9#"
		// Expense
		cType := "E"
	CASE LEFT(cKto, 1) $ "6#"
		// Revenue
		cType := "R"
	OTHERWISE 
		// Equity
		cType := "Q"

ENDCASE

RETURN cType


STATIC FUNCTION get_accnt_subtype( cKto )
LOCAL cSubType := ""

// daj mi subtip
DO CASE

	CASE LEFT(cKto, 2) $ "21#"
		cSubType := "AD"
	CASE LEFT(cKto, 2) $ "01#02#03#04#05"
		cSubType := "FA"
	CASE LEFT(cKto, 2) $ "10#11#12#13#14#15#20"
		cSubType := "CAS"
	CASE LEFT(cKto, 2) $ "06#07#09#21#22#23#24#27#28#29"
		cSubType := "AR"
	CASE LEFT(cKto, 2) $ "40#41#"
		cSubType := "LTL"
	CASE LEFT(cKto, 2) $ "43#44#45#47#48#49"
		cSubType := "AP"
	CASE LEFT(cKto, 2) $ "42#"
		cSubType := "CL"
	CASE LEFT(cKto, 1) $ "5#9#"
		cSubType := "EXP"
	CASE LEFT(cKto, 2) $ "50#"
		cSubType := "COGS"
	CASE LEFT(cKto, 2) $ "66#"
		cSubType := "II"
	CASE LEFT(cKto, 2) $ "64#65#67"
		cSubType := "IV"
	CASE LEFT(cKto, 2) $ "68#69#"
		cSubType := "RT"
	CASE LEFT(cKto, 2) $ "60#61#62"
		cSubType := "SI"
	CASE LEFT(cKto, 2) $ "30#31#32#35#36#70#71#72#73"
		cSubType := "EC"
	CASE LEFT(cKto, 2) $ "33#"
		cSubType := "EDC"
	CASE LEFT(cKto, 2) $ "34#"
		cSubType := "ERE"
	OTHERWISE
		cSubType := "?"	

ENDCASE

RETURN cSubType


FUNCTION get_sifv_value( cModul, cOznaka, cPartner )
LOCAL nTArea := SELECT()
LOCAL cValue := ""

SELECT SIFV
SET ORDER TO TAG "ID"
GO TOP

SEEK cModul + cOznaka + cPartner

IF FOUND() .AND. ( sifv->id == cModul .AND. sifv->oznaka == cOznaka .AND. sifv->idsif == cPartner )
	cValue := ALLTRIM( sifv->naz )
ENDIF

SELECT (nTArea)
RETURN cValue



FUNCTION migrate_sif_partners( oServer, cDBPath )
LOCAL nCount := 0
LOCAL cTblPName := "PARTN.dbf"
LOCAL cTblSName := "SIFV.dbf"
LOCAL cPFileName := cDBPath + cTblPName
LOCAL cSFileName := cDBPath + cTblSName
LOCAL cId
LOCAL cPartIdBroj := ""

IF !FILE( cPFileName )
	? "Fajl " + cPFileName + " ne postoji, prekidam operaciju !"
	QUIT
ENDIF
IF !FILE( cSFileName )
	? "Fajl " + cSFileName + " ne postoji, prekidam operaciju !"
	QUIT
ENDIF

// ako ne postoji fajl cdx, napravi indeks
IF !FILE( STRTRAN( cPFileName, ".dbf", ".cdx" ) )
	CREATE_INDEX("ID", "ID", cDBPath + "PARTN")
ENDIF

IF !FILE( STRTRAN( cSFileName, ".dbf", ".cdx" ) )
	CREATE_INDEX("ID", "id+oznaka+IdSif+Naz", cDBPath + "SIFV")
ENDIF

// prvo ubaci podešenja potrebna za partnere
__set_custtype( oServer, "KD", "Domaci kupci" )
__set_vendtype( oServer, "DD", "Domaci dobavljaci" )
__set_salesrep( oServer, "DEFAULT", "DEFAULT" )
__set_shipform( oServer, "KUPCI", "Kupci" )

// zakači se na tabelu partnera
SELECT 50	
USE (cPFileName) ALIAS "PARTN"
SET ORDER TO TAG "ID"
	
// zakači se na tebelu sifv
SELECT 51
USE (cSFileName) ALIAS "SIFV"
SET ORDER TO TAG "ID"

SELECT PARTN
GO TOP

DO WHILE !EOF()

	// provjeri sta ces preskociti
	IF EMPTY( field->id ) .OR. EMPTY( field->naz )
		SKIP
		LOOP
	ENDIF

	cId := ALLTRIM( field->id )
	cPartIdBroj := get_sifv_value( "PARTN", "REGB", cId )

	SELECT partn
	
	// ubaci stavku na server u tabelu item
	if __set_crm( oServer, ;
			ALLTRIM( hb_strtoutf8( UPPER(partn->id) ) ), ;
			ALLTRIM( hb_strtoutf8( partn->naz ) ), ;
			ALLTRIM( hb_strtoutf8( partn->telefon ) ), ;
			ALLTRIM( hb_strtoutf8( partn->fax ) ), ;
			ALLTRIM( hb_strtoutf8( partn->adresa ) ), ;
			ALLTRIM( hb_strtoutf8( partn->mjesto ) ), ;
			ALLTRIM( hb_strtoutf8( partn->ptt ) ), ;
			cPartIdBroj, ;
			"" ) = .t.

		++ nCount

	endif
	
	SKIP

ENDDO	

RETURN nCount



// sredi broj dokumenta za xtuple
FUNCTION fix_fakt_broj( cIdTipDok, cNumber )
LOCAL cResult := ""
LOCAL cGodina := __sezona

cResult := ALLTRIM( cNumber )

IF cIdTipDok == "11"
	cResult += "-MP"
ENDIF

IF ALLTRIM( STR( YEAR( DATE() ) )) <> __sezona
	cResult += "/" + __sezona
ENDIF

RETURN cResult



// migracija podataka modula FAKT
FUNCTION migrate_fakt_data( oServer, cDBPath )
LOCAL cNotes := ""
LOCAL nCount := 0
LOCAL cTblFakt := "FAKT.dbf"
LOCAL cTblDoks := "DOKS.dbf"
LOCAL cTblRoba := "ROBA.dbf"
LOCAL cTblPartn := "PARTN.dbf"
LOCAL cTblSifV := "SIFV.dbf"
LOCAL cFFileName := cDBPath + cTblFakt
LOCAL cDFileName := cDBPath + cTblDoks
LOCAL cRFileName := cDBPath + cTblRoba
LOCAL cPFileName := cDBPath + cTblPartn
LOCAL cSFileName := cDBPath + cTblSifV
LOCAL cIdFirma
LOCAL cIdTipDok
LOCAL cBrDok
LOCAL cSO_number
LOCAL cUOM
LOCAL oTable

IF !FILE( cFFileName )
	? "Fajl " + cFFileName + " ne postoji, prekidam operaciju !"
	RETURN
ENDIF

IF !FILE( cDFileName )
	? "Fajl " + cDFileName + " ne postoji, prekidam operaciju !"
	RETURN
ENDIF

IF !FILE( STRTRAN( cFFileName, ".dbf", ".cdx" ) )
	CREATE_INDEX("1","IdFirma+idtipdok+brdok+rbr+podbr", cDBPath+"FAKT")
ENDIF

IF !FILE( STRTRAN( cDFileName, ".dbf", ".cdx" ) )
	CREATE_INDEX("1","IdFirma+idtipdok+brdok",cDBPath+"DOKS")
ENDIF

CLOSE ALL

// zakači se na tabele
USE (cFFileName) ALIAS "FAKT" NEW
SET ORDER TO TAG "1"

USE (cDFileName) ALIAS "DOKS" NEW
SET ORDER TO TAG "1"

USE (cRFileName) ALIAS "ROBA" NEW
SET ORDER TO TAG "ID"

USE (cPFileName) ALIAS "PARTN" NEW
SET ORDER TO TAG "ID"

USE (cSFileName) ALIAS "SIFV" NEW
SET ORDER TO TAG "ID"

SELECT doks
GO TOP

// prvo ćemo odraditi fakture
DO WHILE !EOF()

	cIdFirma := doks->idfirma

	IF EMPTY( cIdFirma )
		SKIP
		LOOP
	ENDIF

	DO WHILE !EOF() .AND. doks->idfirma == cIdFirma
		
		cIdTipDok := doks->idtipdok
		cBrDok := doks->brdok

		// vidi ima li karaktera, kreiraj broj
		cSO_number := fix_fakt_broj( cIdTipDok, cBrDok )

		// ako nije ništa od računa, preskoči...
		// treba predvidjeti i dokumente "11"
		IF cIdTipDok <> "10"
			SKIP
			LOOP
		ENDIF

		// dobro, ovo je neki račun
		? "Obradjujem dokument:", cIdFirma + "-" + cIdTipDok + "-" + cBrDok + " / " + cSO_number 

		cIdPartner := ALLTRIM( UPPER( hb_strtoutf8(doks->idpartner) ) )
		
		// da vidimo ima li partnera...	
		IF __get_crm( oServer, cIdPartner ) = 0
			
			SELECT partn
			APPEND BLANK
			REPLACE field->id WITH doks->idpartner
			REPLACE field->naz WITH "NEMA NAZIVA"	

			// dodaj ga i u crm
			__set_crm( oServer, ;
				cIdPartner, ;
				ALLTRIM( hb_strtoutf8( partn->naz ) ), ;
				ALLTRIM( hb_strtoutf8( partn->telefon ) ), ;
				ALLTRIM( hb_strtoutf8( partn->fax ) ), ;
				ALLTRIM( hb_strtoutf8( partn->adresa ) ), ;
				ALLTRIM( hb_strtoutf8( partn->mjesto ) ), ;
				ALLTRIM( hb_strtoutf8( partn->ptt ) ), ;
				"", ;
				"" )

			? " - ubacio nepostojeceg partnera: " + cIdPartner

			SELECT doks

		ENDIF

		// provjeri mi robu !
		SELECT fakt
		GO TOP
		SEEK cIdFirma + cIdTipDok + cBrDok
		
		// uzmi fakt->txt
		aMemo := parsmemo( fakt->txt )
		
		IF LEN( aMemo ) > 1
			cMemo := hb_strtoutf8( ALLTRIM( aMemo[2] ) )
		ENDIF

		lNoArticle := .f.

		DO WHILE !EOF() .AND. fakt->idfirma == cIdFirma ;
			.AND. fakt->idtipdok == cIdTipDok ;
			.AND. fakt->brdok == cBrDok
			
			cIdRoba := ALLTRIM( UPPER( hb_strtoutf8(fakt->idroba) ))
			cBarKod := ""

			SELECT roba
			GO TOP
			SEEK fakt->idroba

			IF roba->(FIELDPOS("BARKOD")) <> 0
				cBarKod := roba->barkod
			ENDIF

			SELECT fakt
			
		 	// provjeri da li postoji artikal koji je predmet fakturisanja
			IF __get_item( oServer, cIdRoba ) = 0
	
				SELECT roba
				APPEND BLANK
				REPLACE field->id WITH cIdRoba
				REPLACE field->naz WITH cIdRoba
				REPLACE field->idtarifa WITH "PDV17"
				REPLACE field->vpc WITH fakt->cijena
				REPLACE field->jmj WITH "KOM"

				if __set_item( oServer, ;
						ALLTRIM( hb_strtoutf8( UPPER(roba->id) ) ), ;
						ALLTRIM( hb_strtoutf8( roba->naz ) ), ;
						roba->tip, ;
						ALLTRIM( hb_strtoutf8( UPPER(roba->jmj) ) ), ;
						roba->vpc, ;
						cBarKod, ;
						"" ) = .t.

						__set_itemsite( oServer, ;
								ALLTRIM( hb_strtoutf8(UPPER(roba->id)) ), ;
								__site_name, roba->tip )

						__set_itemtaxtype( oServer, ALLTRIM( hb_strtoutf8( UPPER(roba->id) ) ), ;
								__taxzone_bih, ;
								__taxtype )

				endif


				SELECT fakt
					
				? " - dodao nepostojeci artikal: " + cIdRoba + " !"
				
				//lNoArticle := .t.
	
			ENDIF
			
			SELECT FAKT
			SKIP

		ENDDO

		// provjeri još memo...
		IF EMPTY( cMemo )
			cMemo := ""
		ENDIF
	
		SELECT doks

		// ubaci podatke u ponude
		// provjeri prvo da li postoji, ako postoji preskoči na sljedeći dokument
		if __insert_so( oServer, ;
				cSO_number, ;
				doks->datdok, ;
				ALLTRIM( hb_strtoutf8( doks->idpartner )), ;
				cMemo ) = .f.

			// ponuda postoji, preskoči

			?? " - vec postoji"

			SELECT doks
			SKIP
			LOOP

		endif
		
		++ nCount

		// ubaci podatke u račune
		__insert_inv( oServer, ;
				cSO_number, ;
				doks->datdok, ;
				ALLTRIM( hb_strtoutf8( doks->idpartner)), ;
				cMemo )

		SELECT fakt
		GO TOP
		SEEK cIdFirma + cIdTipDok + cBrDok

		DO WHILE !EOF() .AND. fakt->idfirma == cIdFirma ;
			.AND. fakt->idtipdok == cIdTipDok ;
			.AND. fakt->brdok == cBrDok
			
			cIdRoba := fakt->idroba

			SELECT roba
			GO TOP
			SEEK cIdRoba

			SELECT fakt

			// ovo radi rabata postavi...
			nCijena := fakt->cijena
			nCijena2 := nCijena
			nRabat := fakt->rabat

			if ( nRabat > 0 )
				nTmp := nCijena * ( nRabat / 100 )
				nCijena2 := nCijena - nTmp
			endif

			// uzmi sa artikla pojedina polja
			oTable := __get_item_data( oServer, ALLTRIM( hb_strtoutf8( UPPER(cIdRoba)) ) )
			cUOM := oTable:Fieldget( oTable:Fieldpos("list_price_uom") )
		
			// dodaj stavke ponude
			__insert_so_line( oServer, ;
							cSO_number, ;
							ALLTRIM( fakt->rbr ), ;
							ALLTRIM( hb_strtoutf8( UPPER(fakt->idroba) )), ;
							fakt->kolicina, ;
							cUOM, ; 
							nCijena2, ;
							doks->datdok, ;
							roba->idtarifa, ;
							nRabat, ;
							roba->tip, ;
							fakt->txt )

			// dodaj stavke fakture
			__insert_inv_line( oServer, ;
							cSO_number, ;
							ALLTRIM( fakt->rbr ), ;
							ALLTRIM( hb_strtoutf8( UPPER(fakt->idroba) )), ;
							fakt->kolicina, ;
							cUOM, ; 
							nCijena2, ;
							doks->datdok, ;
							roba->idtarifa, ;
							nRabat, ;
							roba->tip, ;
							fakt->txt )


			SKIP
		
		ENDDO

		SELECT doks
		SKIP

	ENDDO

ENDDO

RETURN nCount


FUNCTION format_sql_date( dDate )
LOCAL cDate := ""

cDate := "'"
cDate += ALLTRIM(STR(YEAR(dDate)))
cDate += "-"
cDate += ALLTRIM(STR(MONTH(dDate)))
cDate += "-"
cDate += ALLTRIM(STR(DAY(dDate)))
cDate += "'"

RETURN cDate


STATIC FUNCTION __insert_so( oServer, cOrderNumber, dOrderDate, cPartner, cNotes )
LOCAL oTable
LOCAL cTable := "api.salesorder"
LOCAL cTmpQry
LOCAL lReturn := .f.

IF ( __get_so( oServer, cOrderNumber ) > 0 )  
	verbosed( "SO " + cOrderNumber + " vec postoji!"  )
	RETURN lReturn
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( order_number, order_date, pack_date, originated_by, sales_rep, " + ;
	"tax_zone, terms, customer_number, billto_contact_name, shipto_contact_honorific, " + ;
	"ship_via, shipping_form, order_notes ) VALUES (" + ;
	_sql_value( cOrderNumber ) + "," + ;
	format_sql_date( dOrderDate ) + "," + ;
	format_sql_date( dOrderDate ) + "," + ;
	_sql_value( "Customer" ) + "," + ;
	_sql_value( "DEFAULT" ) + "," + ;
	_sql_value( __taxzone_bih ) + "," + ;
	_sql_value( "DEFAULT" ) + "," + ;
	_sql_value( cPartner ) + "," + ;
	_sql_value( cPartner ) + "," + ;
	_sql_value( cPartner ) + "," + ;
	_sql_value( "DEFAULT" ) + "," + ;
	_sql_value( "KUPCI" ) + "," + ;
	_sql_value( cNotes ) + ;
	")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( "insert cohead: " + oTable:ErrorMsg() )
	QUIT
ENDIF

cTable := "cohead"
cTmpQry := "UPDATE " + cTable + ;
	"SET  cohead_status = 'C' WHERE cohead_number = " + _sql_quote( cOrderNumber )
	
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( "Update cohead status: " + oTable:ErrorMsg() )
	QUIT
ENDIF

lReturn := .t.

RETURN lReturn 


STATIC FUNCTION __get_so( oServer, cValue )
LOCAL oTable
LOCAL cTable := "api.salesorder"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE order_number = " + _sql_quote( cValue )
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult



STATIC FUNCTION __insert_so_line( oServer, cOrderNumber, cItemLine, ;
			cItem, nQty, cUom, nPrice, ;
			dDate, cTax, nDiscount, cTip, cMemo )

LOCAL oTable
LOCAL cTable := "api.salesline"
LOCAL cTmpQry
LOCAL lReturn := .f.

cTmpQry := "INSERT INTO " + cTable + ;
	" ( order_number, line_number, item_number, sold_from_site, status, " + ;
	"qty_ordered, qty_uom, net_unit_price, price_uom, scheduled_date, " + ;
	"promise_date, tax_type, discount_pct_from_list ) VALUES (" + ;
	_sql_value( cOrderNumber ) + "," + ;
	_sql_value( cItemLine ) + "," + ;
	_sql_value( cItem ) + "," + ;
	_sql_value( __site_name ) + "," + ;
	_sql_value( "C" ) + "," + ;
	ALLTRIM(STR( nQty )) + "," + ;
	_sql_value( cUom ) + "," + ;
	ALLTRIM(STR( nPrice )) + "," + ;
	_sql_value( cUom ) + "," + ;
	format_sql_date( dDate ) + "," + ;
	format_sql_date( dDate ) + "," + ;
	_sql_value( "OSTALO" ) + "," + ;
	_sql_value( ALLTRIM(STR( nDiscount )) ) + ;
	")"


oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( "insert so_line: " + oTable:ErrorMsg() )
	QUIT
ENDIF

lReturn := .t.

RETURN lReturn 



STATIC FUNCTION __insert_inv( oServer, cInvNumber, dOrderDate, cPartner, cNotes )
LOCAL oTable
LOCAL cTable := "api.invoice"
LOCAL cTmpQry
LOCAL lReturn := .f.

IF ( __get_inv( oServer, cInvNumber ) > 0 )  
	verbosed( "INV " + cInvNumber + " vec postoji!"  )
	RETURN lReturn
ENDIF

cTmpQry := "INSERT INTO " + cTable + ;
	" ( invoice_number, order_number, invoice_date, ship_date, sales_rep, " + ;
	"tax_zone, terms, customer_number, " + ;
	"ship_via, notes ) VALUES (" + ;
	_sql_value( cInvNumber ) + "," + ;
	_sql_value( cInvNumber ) + "," + ;
	format_sql_date( dOrderDate ) + "," + ;
	format_sql_date( dOrderDate ) + "," + ;
	_sql_value( "DEFAULT" ) + "," + ;
	_sql_value( __taxzone_bih ) + "," + ;
	_sql_value( "DEFAULT" ) + "," + ;
	_sql_value( cPartner ) + "," + ;
	_sql_value( "DEFAULT" ) + "," + ;
	_sql_value( cNotes ) + ;
	")"

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( "insert invoice: " + oTable:ErrorMsg() )
	QUIT
ENDIF

lReturn := .t.

RETURN lReturn 


STATIC FUNCTION __get_inv( oServer, cValue )
LOCAL oTable
LOCAL cTable := "api.invoice"
LOCAL nResult
LOCAL cTmpQry

cTmpQry := "SELECT COUNT(*) FROM " + cTable + " WHERE invoice_number = " + _sql_quote( cValue )
oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( oTable:ErrorMsg() )
	QUIT
ENDIF

nResult := oTable:Fieldget( oTable:Fieldpos("count") )

RETURN nResult



function TokToNiz(cTok,cSE)
local aNiz:={}
local nE:=0
local i:=0
local cE:=""

if cSE==NIL
	cSE := "."
endif

nE := NUMTOKEN(cTok,cSE)

for i:=1 to nE
cE := TOKEN(cTok,cSE,i)
     AADD(aNiz,cE)
next

return (aNiz)



function ParsMemo(cTxt)

// Struktura cTxt-a je: Chr(16) txt1 Chr(17) Chr(16) txt2 Chr(17) ...
local aMemo:={}
local i,cPom,fPoc

 fPoc:=.f.
 cPom:=""
 for i:=1 to len(cTxt)
   if substr(cTxt,i,1)==Chr(16)
     fPoc:=.t.
   elseif substr(cTxt,i,1)==Chr(17)
     fPoc:=.f.
     AADD(aMemo,cPom)
     cPom:=""
   elseif fPoc
      cPom:=cPom+substr(cTxt,i,1)
   endif
 next

return aMemo




STATIC FUNCTION __insert_inv_line( oServer, cInvNumber, cItemLine, cItem, ;
			nQty, cUom, nPrice, dDate, ;
			cTax, nDiscount, cTip, cMemo )

LOCAL oTable
LOCAL cTable := "api.invoiceline"
LOCAL cTmpQry
LOCAL lReturn := .f.
LOCAL cSalesCateg := ""
LOCAL cMiscItem := "NULL"
LOCAL cMiscItemDescr := "NULL"
LOCAL aMemo := {}


// provjeri o kojem se tipu artikla radi
IF cTip == "U"

	// robu nećemo unositi
	// koristi ćemo opis iz memo polja

	// parsiraj memo polje
	aMemo := parsmemo(cMemo)
	
	IF LEN( aMemo ) > 0 .and. !EMPTY( aMemo[1] )
		cMiscItem := _sql_quote( hb_strtoutf8( aMemo[1] ) )
		cMiscItemDescr := cMiscItem
	ELSE
		cMiscItem := _sql_quote( "NEMA NAZIVA" )
		cMiscItemDescr := _sql_quote( "NEMA OPISA" )
	ENDIF

	// ubaci sales kategoriju ako ne postoji
	__set_salescat( oServer, ALLTRIM( cItem ), ALLTRIM( cItem ) )
	
	cSalesCateg := ALLTRIM( cItem )

	// ovaj artikal finalno resetujemo
	cItem := "NULL"

ELSE

	cItem := _sql_quote( cItem )

ENDIF


cTmpQry := "INSERT INTO " + cTable + ;
	" ( invoice_number, line_number, item_number, misc_item_number, misc_item_description, site, " + ;
	"sales_category, qty_ordered, qty_billed, net_unit_price, " + ;
	"tax_type ) VALUES (" + ;
	_sql_value( cInvNumber ) + "," + ;
	_sql_value( cItemLine ) + "," + ;
	cItem + "," + ;
	cMiscItem + "," + ;
	cMiscItemDescr + "," + ;
	_sql_value( __site_name ) + "," + ;
	_sql_value( cSalesCateg ) + "," + ;
	ALLTRIM(STR( nQty )) + "," + ;
	ALLTRIM(STR( nQty )) + "," + ;
	ALLTRIM(STR( nPrice )) + "," + ;
	_sql_value( "OSTALO" ) + ")" 

oTable := _sql_query( oServer, cTmpQry )
IF oTable:NetErr()
	Alert( "insert invc_line: " + oTable:ErrorMsg() )
	QUIT
ENDIF

lReturn := .t.

RETURN lReturn 




// setuje static varijable, parametri matične firme
FUNCTION set_company_params(oServer)
LOCAL x := 5
LOCAL cInfo
LOCAL oTable
LOCAL cNastaviti := "D"
LOCAL lDefineSite := .t.

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

@ x + 1, 4 SAY "****** Unesi maticne podatke firme:"
@ x + 2, 4 SAY "Naziv organizacione jedince (site):" GET __site_name VALID !EMPTY(__site_name)

READ

IF __get_site( oServer, ALLTRIM(__site_name) ) > 0
	
	// daj mi podatke site-a
	oTable := __get_site_data( oServer, ALLTRIM( __site_name ) )
	
	__comp_name := PADR( oTable:Fieldget( oTable:Fieldpos("description") ), 200)
	__comp_addr := PADR( oTable:Fieldget( oTable:Fieldpos("address1") ), 200)
	__comp_city := PADR( oTable:Fieldget( oTable:Fieldpos("city") ), 50)
	__comp_postalcode := PADR( oTable:Fieldget( oTable:Fieldpos("postal_code") ), 10)
	__comp_tel1 := PADR( oTable:Fieldget( oTable:Fieldpos("phone") ), 20)
	__comp_fax := PADR( oTable:Fieldget( oTable:Fieldpos("fax") ), 20)
	__comp_email := PADR( oTable:Fieldget( oTable:Fieldpos("email") ), 50)
	
	lDefineSite := .f.

ENDIF

@ x + 3, 4 SAY "Naziv:" GET __comp_name WHEN lDefineSite VALID !EMPTY(__comp_name) PICT "@S60"
@ x + 4, 4 SAY "Adresa:" GET __comp_addr WHEN lDefineSite
@ x + 5, 4 SAY "Grad:" GET __comp_city WHEN lDefineSite
@ x + 5, 60 SAY "PTT broj:" GET __comp_postalcode WHEN lDefineSite
@ x + 6, 4 SAY "Telefon:" GET __comp_tel1 WHEN lDefineSite
@ x + 6, 40 SAY "Fax:" GET __comp_fax WHEN lDefineSite
@ x + 7, 4 SAY "Email:" GET __comp_email WHEN lDefineSite
@ x + 8, 4 SAY "ID broj:" GET __comp_id_number WHEN lDefineSite
@ x + 8, 40 SAY "PDV broj:" GET __comp_pdv_number WHEN lDefineSite
@ x + 9, 4 SAY "Importujem podatke za koju sezonu ? (2010, 2011, ...)" GET __sezona
@ x + 10, 4 SAY "Nastaviti sa procedurom importa podataka (D/N):" GET cNastaviti VALID cNastaviti $ "DN" PICT "@!"

READ

// escape hendler
if LastKey() == 27 .OR. cNastaviti == "N"
	QUIT
	RETURN
endif

// sredi parametre
__site_name := ALLTRIM(__site_name)
__comp_name := ALLTRIM(__comp_name)
__comp_addr := ALLTRIM(__comp_addr)
__comp_city := ALLTRIM(__comp_city)
__comp_state := ALLTRIM(__comp_city)
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


// ispis poruku na konzoli
FUNCTION verbosed( cMsg )
IF __verbosed
	? cMsg
ENDIF
RETURN


PROCEDURE help()
   
   ? "fmk_migrate - migriranje podataka iz FMK u xtuple bazu"
   ? 
   ? ":: uslovi"
   ? 
   ? "-h hostname (default: localhost)"
   ? "-y port (default: 5432)"
   ? "-u user (default: root)"
   ? "-p password (default no password)"
   ? "-d name of database to use"
   ? "-e schema (default: public)"
   ? "-t fmk tables path"
   ? "-v verbose rezim"
   ? 

RETURN

// ------------------------
function _sql_quote(xVar)
xVar := STRTRAN(xVar, "'","''")
return "'" + xVar + "'"

