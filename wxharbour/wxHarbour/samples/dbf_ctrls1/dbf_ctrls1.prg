/*
 * $Id: dbf_ctrls1.prg 459 2010-11-13 21:13:47Z tfonrouge $
 */

/*
    dbf_ctrls1 sample
    Teo. Mexico 2010
*/

#ifdef _DEBUG_
#ifdef HB_OS_UNIX
    REQUEST HB_GT_XWC_DEFAULT
#endif
#ifdef HB_OS_WINDOWS
    REQUEST HB_GT_WVT_DEFAULT
#endif
#else
    REQUEST HB_GT_NUL_DEFAULT
#endif

#include "wxharbour.ch"

#include "dbinfo.ch"

FUNCTION Main

#ifdef _DEBUG_
    SetMode( 40, 80 )
#endif

    IMPLEMENT_APP( MyApp():New() )

RETURN NIL

/*
    MyApp
    Teo. Mexico 2010
*/
CLASS MyApp FROM wxApp
PRIVATE:
PROTECTED:

    DATA locked
    DATA brw
    DATA btnRLock
    DATA dlg
    DATA FHtmlEasyPrinting

    METHOD GetHtmlData
    METHOD GetHtmlEasyPrinting
    METHOD Print()
    METHOD Preview()
    METHOD ToogleBtn()
    METHOD UnLock( recNo )
    
    PROPERTY htmlData READ GetHtmlData
    
PUBLIC:
    METHOD OnInit()
    PROPERTY htmlEasyPrinting READ GetHtmlEasyPrinting
PUBLISHED:
ENDCLASS

/*
    OnInit
    Teo. Mexico 2010
*/
METHOD FUNCTION OnInit() CLASS MyApp

    USE test NEW SHARED

    CREATE DIALOG ::dlg ;
        TITLE "Browse/GET sample"

    BEGIN BOXSIZER VERTICAL
    
        BEGIN BOXSIZER HORIZONTAL "Printing" ALIGN EXPAND
            @ BUTTON "Page Setup" ID wxID_PAGE_SETUP ACTION ::htmlEasyPrinting:PageSetup()
            @ BUTTON ID wxID_PREVIEW ACTION ::Preview()
            @ BUTTON ID wxID_PRINT ACTION ::Print()
        END SIZER
    
        @ BUTTON "Fit" ACTION ::brw:AutoSizeColumns( .F. )
    
        @ BROWSE VAR ::brw DATASOURCE "test" ;
            ONSELECTCELL {|| ::UnLock( RecNo() ), ::dlg:TransferDataToWindow() } ;
            MINSIZE 600,400 ;
            SIZERINFO ALIGN EXPAND STRETCH
            
            ADD BCOLUMN TO ::brw "First"  BLOCK {|| TEST->first }
            ADD BCOLUMN TO ::brw "Last"   BLOCK {|| TEST->last }
            ADD BCOLUMN TO ::brw "Street" BLOCK {|| TEST->street }
    
        BEGIN FLEXGRIDSIZER COLS 6 GROWABLECOLS 2,4,6 ALIGN EXPAND
            @ SAY "First:" SIZERINFO ALIGN RIGHT
                @ GET TEST->first ENABLED {|| DbRecordInfo( DBRI_LOCKED ) } ;
                    SIZERINFO ALIGN EXPAND
            @ SAY "Last:" SIZERINFO ALIGN RIGHT
                @ GET TEST->last ENABLED {|| DbRecordInfo( DBRI_LOCKED ) } ;
                    SIZERINFO ALIGN EXPAND
            @ SAY "Street:" SIZERINFO ALIGN RIGHT
                @ GET TEST->street ENABLED {|| DbRecordInfo( DBRI_LOCKED ) } ;
                    SIZERINFO ALIGN EXPAND
        END SIZER
        
        @ BUTTON "RLock" VAR ::btnRLock ACTION ::ToogleBtn()

        @ STATICLINE HORIZONTAL SIZERINFO ALIGN EXPAND
        
        BEGIN BOXSIZER HORIZONTAL ALIGN CENTER
            @ BUTTON "Up" ACTION TEST->( ::UnLock(), ::brw:Up() )
            @ BUTTON "Down" ACTION TEST->( ::UnLock(), ::brw:Down() )
        END SIZER

        @ BUTTON ID wxID_EXIT ACTION ::dlg:Close() SIZERINFO ALIGN RIGHT

    END SIZER
    
    ::brw:AutoSizeColumns( .F. )

    ::brw:ConnectGridEvt( ::brw:GetId(), wxEVT_GRID_LABEL_LEFT_DCLICK, {|gridEvent| gridEvent:GetEventObject():AutoSizeColumns( .F. )  } )

    SHOW WINDOW ::dlg FIT CENTRE MODAL

RETURN .F. // If main window is a wxDialog, we need to return false on OnInit

/*
    GetHtmlData
    Teo. Mexico 2010
*/
METHOD FUNCTION GetHtmlData() CLASS MyApp
    LOCAL html,table,cell,node,row,col,bin,nrecs,text,nrec

    html := THtmlDocument():New()

    node := html:Head + "meta"
    node:Name := "Generator"
    node:Content := "THtmlDocument"

    node := html:Body:H1
    node:Text := "Printing with wxHarbour"

    node := node + "hr"

    HB_SYMBOL_UNUSED( node )

    table := html:Body:Table

    table:Attr := 'border="1" width="0" cellspacing="1" cellpadding="1"'

    row := table + 'tr bgcolor="lightcyan"'

    FOR EACH col IN ::brw:ColumnList
        cell := row + "th"
        cell:Text := col:Heading
        cell := cell - "th"
        HB_SYMBOL_UNUSED( cell )
    NEXT

    row := row - "tr"
    HB_SYMBOL_UNUSED( row )

    bin := .T.
    
    nrec := RecNo()
    
    DbGoTop()

    nrecs := 0

    WHILE !Eof()
    
        ++nrecs

        row := table + "tr"
        row:bgColor := iif( ( bin := ! bin ), "lightgrey", "white" )

        FOR col := 1 TO ::brw:ColCount
            cell := row + "td"
            text := ::brw:GetTable():GetCellValueAtCol( col )
            cell:Text := text
            cell := cell - "td"
            HB_SYMBOL_UNUSED( cell )
        NEXT
        
        row := row - "tr"
        HB_SYMBOL_UNUSED( row )

        DbSkip()

    ENDDO
    
    DbGoTo( nrec )

    node := html:Body + "hr"
    HB_SYMBOL_UNUSED( node )
    node := html:Body + "p"
    
    node:Text :=  NTrim( nrecs ) + " records from database "

RETURN html:toString()

/*
    GetHtmlEasyPrinting
    Teo. Mexico 2010
*/
METHOD FUNCTION GetHtmlEasyPrinting() CLASS MyApp
    IF ::FHtmlEasyPrinting = NIL
        ::FHtmlEasyPrinting := wxHtmlEasyPrinting():New( "My Printing way", ::dlg )
        ::FHtmlEasyPrinting:SetHeader( "Printing with wxHarbour.  Page @PAGENUM@ of @PAGESCNT@<hr>" )
    ENDIF
RETURN ::FHtmlEasyPrinting

/*
    Preview
    Teo. Mexico 2010
*/
METHOD FUNCTION Preview() CLASS MyApp
RETURN ::htmlEasyPrinting:PreviewText( ::htmlData )

/*
    Print
    Teo. Mexico 2010
*/
METHOD FUNCTION Print() CLASS MyApp
RETURN ::htmlEasyPrinting:PrintText( ::htmlData )

/*
    ToogleBtn
    Teo. Mexico 2010
*/
METHOD PROCEDURE ToogleBtn() CLASS MyApp
    IF ::locked = NIL
        IF RLock()
            ::locked := RecNo()
            ::btnRLock:SetLabel( "UnLock" )
        ENDIF
    ELSE
        ::UnLock()
    ENDIF
RETURN

/*
    UnLock
    Teo. Mexico 2010
*/
METHOD PROCEDURE UnLock( recNo ) CLASS MyApp
    IF ::locked != NIL
        IF recNo = NIL .OR. recNo != ::locked
            DbUnLock()
            ::btnRLock:SetLabel( "RLock" )
            ::locked := NIL
            ::brw:RefreshAll()
        ENDIF
    ENDIF
RETURN

/*
    EndClass MyApp
*/
