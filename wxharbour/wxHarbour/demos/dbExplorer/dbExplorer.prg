/*
 * $Id: dbExplorer.prg 731 2011-06-10 14:02:01Z tfonrouge $
 */

/*
    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    DbBrowser: Simple browser
    Teo. Mexico 2008
*/

#include "error.ch"
#include "wxharbour.ch"

#include "wxh/filedlg.ch"

#include "dbinfo.ch"

#ifdef __HBDEBUG
    #pragma debuginfo=on
    #ifdef HB_OS_UNIX
        REQUEST HB_GT_XWC_DEFAULT
    #endif
    #ifdef HB_OS_WINDOWS
        REQUEST HB_GT_WVT_DEFAULT
    #endif
#else
    REQUEST HB_GT_NUL_DEFAULT
#endif

//REQUEST RDOSENDMESSAGE
REQUEST DBFCDX
REQUEST DBFFPT

REQUEST WXH_L2BEBIN,L2BIN
REQUEST HB_NUMTOHEX

FUNCTION Main( ... )

    SetMode( 40, 100 )

    rddSetDefault("DBFCDX")

    IMPLEMENT_APP( MyApp():New() )

RETURN NIL

/*
    MyApp
    Teo. Mexico 2008
*/
CLASS MyApp FROM wxApp
PRIVATE:

    DATA curDirectory
    DATA recNo INIT 0

    METHOD Configure
    METHOD GetBrw
    METHOD OpenDB()

PROTECTED:
    METHOD GoToRecord()
    METHOD OnSelectCell( gridEvent )
PUBLIC:

    DATA auiNotebook
    DATA oWnd

    METHOD OnInit

PUBLISHED:
ENDCLASS

/*
    EndClass MyApp
*/

METHOD PROCEDURE GoToRecord() CLASS MyApp
    LOCAL oBrw
    LOCAL oDlg
    
    oBrw := ::GetBrw()
    
    IF oBrw = NIL .OR. oBrw:DataSource:Eof()
        RETURN
    ENDIF
    
    CREATE DIALOG oDlg ;
        PARENT ::oWnd ;
        TITLE "Go to record"
        
    BEGIN BOXSIZER VERTICAL
        @ SAY "# record:" GET ::recNo
        BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
            @ BUTTON ID wxID_CANCEL
            @ BUTTON ID wxID_OK DEFAULT
        END SIZER
    END SIZER
    
    SHOW WINDOW oDlg MODAL FIT CENTRE
    
    IF oDlg:GetReturnCode() != wxID_OK
        DESTROY oDlg
        RETURN
    ENDIF
    
    DESTROY oDlg
    
    oBrw:DataSource:DbGoTo( ::recNo )
    
    oBrw:RefreshAll()

RETURN

/*
    OnInit
    Teo. Mexico 2008
*/
METHOD FUNCTION OnInit() CLASS MyApp

    CREATE FRAME ::oWnd ;
                 WIDTH 800 HEIGHT 600 ;
                 TITLE "dbExplorer"

    BEGIN FRAME TOOLBAR
    END TOOLBAR

    DEFINE MENUBAR
        DEFINE MENU "&File"
            ADD MENUITEM E"Open database \tCtrl+O" ID wxID_OPEN ACTION ::OpenDB()
            ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION ::oWnd:Close() ;
                    HELPLINE "Quits this sample..."
        ENDMENU
        DEFINE MENU E"&Preferences"
            ADD MENUITEM "Configure dbExplorer" ACTION ::Configure()
        ENDMENU
        DEFINE MENU E"Move"
            ADD MENUITEM E"Go to record \tCtrl+l" ACTION ::GoToRecord()
        ENDMENU
        DEFINE MENU "Help"
            ADD MENUITEM "Fit Grid" ACTION ::GetBrw():AutoSizeColumns( .F. ) ENABLED ::GetBrw() != NIL
            ADD MENUSEPARATOR
            ADD MENUITEM "About..."
        ENDMENU
    ENDMENU

    BEGIN BOXSIZER VERTICAL
        BEGIN AUINOTEBOOK VAR ::auiNotebook SIZERINFO ALIGN EXPAND STRETCH
        END AUINOTEBOOK
    END SIZER

    @ STATUSBAR

    SHOW WINDOW ::oWnd CENTRE

RETURN .T.

/*
    Configure
    Teo. Mexico 2009
*/
METHOD PROCEDURE Configure CLASS MyApp
    LOCAL oDlg
    LOCAL rddName := rddSetDefault()
    LOCAL oErr

    CREATE DIALOG oDlg ;
                 PARENT ::oWnd ;
                 TITLE "Configure"

    BEGIN BOXSIZER VERTICAL
        BEGIN BOXSIZER HORIZONTAL
            @ SAY "RDD Default:"
            @ COMBOBOX rddName ITEMS rddList()
        END SIZER
        BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
            @ BUTTON ID wxID_CANCEL ACTION oDlg:EndModal( wxID_CANCEL )
            @ BUTTON ID wxID_OK ACTION oDlg:EndModal( wxID_OK )
        END SIZER
    END SIZER

    SHOW WINDOW oDlg MODAL FIT CENTRE

    IF oDlg:GetReturnCode() = wxID_OK

        BEGIN SEQUENCE WITH {|oErr| Break( oErr ) }

            rddSetDefault( rddName )

        RECOVER USING oErr

            wxMessageBox( oErr:description, "Error", HB_BitOr( wxOK, wxICON_ERROR ), oDlg )

        END SEQUENCE

    ENDIF

    DESTROY oDlg

RETURN

/*
    GetBrw
    Teo. Mexico 2009
*/
METHOD FUNCTION GetBrw CLASS MyApp

    IF ::auiNotebook == NIL .OR. ::auiNotebook:GetSelection() < 0
        RETURN NIL
    ENDIF

RETURN ::auiNotebook:GetPage( ::auiNotebook:GetSelection() ):GetPage( 1 ):FindWindowByName("table")

/*
    OpenDB
    Teo. Mexico 2009
*/
METHOD PROCEDURE OpenDB() CLASS MyApp
    LOCAL fileDlg
    LOCAL noteBook
    LOCAL oBrw
    LOCAL table
//    LOCAL oErr
    LOCAL hIndex,aStruDbf
    LOCAL oBrwStruct,oBrwIndexList
    LOCAL n,l
    LOCAL ordNumber
    LOCAL keyVal
    LOCAL btnUpdate

    fileDlg := wxFileDialog():New( ::oWnd, "Choose a Dbf...", NIL, NIL, ;
    "dbf files (*.dbf;*.DBF)|*.dbf;*.DBF| all files (*.*)|*.*" )

    IF ::curDirectory != NIL
        fileDlg:SetDirectory( ::curDirectory )
    ENDIF

    IF ! fileDlg:ShowModal() == wxID_OK
//		 DESTROY fileDlg
        RETURN
    ENDIF

    ::curDirectory := fileDlg:GetDirectory()

//    BEGIN SEQUENCE WITH {|oErr| Break( oErr ) }

        table := TTable():New( NIL, fileDlg:GetPath() )
        table:autoEdit := .T.

        aStruDbf := table:DbStruct

        hIndex := {=>}

        l := dbOrderInfo( DBOI_ORDERCOUNT )

        IF l > 0

            FOR n := 1 TO l
                hIndex[ dbOrderInfo( DBOI_NAME, NIL, n ) ]:= ;
                    { ;
                        "Expression" => dbOrderInfo( DBOI_EXPRESSION, NIL, n ),;
                        "Condition" => dbOrderInfo( DBOI_CONDITION, NIL, n ),;
                        "IsDesc" => dbOrderInfo( DBOI_ISDESC, NIL, n ),;
                        "Unique" => dbOrderInfo( DBOI_UNIQUE, NIL, n ) ;
                    }
            NEXT
            
            IF ordNumber( "Primary" ) > 0
                ordSetFocus( "Primary" )
            ELSE
                ordSetFocus( 1 )
            ENDIF
            
            ordNumber := HB_HPos( hIndex, ordName() )

            keyVal := ordKeyVal()

        ENDIF

//    RECOVER USING oErr
//
//        wxMessageBox( oErr:description + " : " + oErr:Operation, "Error", HB_BitOr( wxOK, wxICON_ERROR ), ::oWnd )
//
////	 DESTROY fileDlg
//        RETURN
//
//    END SEQUENCE
    
    BEGIN AUINOTEBOOK VAR noteBook PARENT ::auiNotebook STYLE wxAUI_NB_BOTTOM
        ADD BOOKPAGE "Data Grid" FROM
            BEGIN PANEL SIZERINFO ALIGN EXPAND STRETCH
                BEGIN BOXSIZER VERTICAL
                    @ BROWSE VAR oBrw NAME "table" DATASOURCE table ;
                        ONKEY {|b,keyEvent| k_Process( b, keyEvent ) } ;
                        ONSELECTCELL {|gridEvent| ::OnSelectCell( gridEvent ) } ;
                        SIZERINFO ALIGN EXPAND STRETCH
                    @ STATICLINE HORIZONTAL SIZERINFO ALIGN EXPAND
                    BEGIN FLEXGRIDSIZER COLS 2 GROWABLECOLS 2 ALIGN EXPAND
                        @ SAY "Index:" SIZERINFO ALIGN RIGHT
                            @ CHOICE ordNumber ITEMS HB_HKeys( hIndex ) NAME "choice" WIDTH 200 ;
                                ACTION {|| table:Alias:OrdSetFocus( HB_HKeys( hIndex )[ ordNumber ] ), oBrw:GoTop() } ;
                                SIZERINFO ALIGN LEFT
                        @ SAY "Key:" SIZERINFO ALIGN RIGHT
                            @ STATICTEXT NAME "key" SIZERINFO ALIGN EXPAND
                        @ SAY "ForKey:" SIZERINFO ALIGN RIGHT
                            @ STATICTEXT NAME "for" SIZERINFO ALIGN EXPAND
                        @ SAY "KeyVal:" SIZERINFO ALIGN RIGHT
                            @ GET keyVal NAME "keyval" SIZERINFO ALIGN EXPAND
                    END SIZER
                END SIZER
            END PANEL
        ADD BOOKPAGE "Indexes" FROM
            @ BROWSE VAR oBrwIndexList DATASOURCE hIndex
        ADD BOOKPAGE "Structure" FROM
            BEGIN PANEL
                BEGIN BOXSIZER HORIZONTAL
                    @ BROWSE VAR oBrwStruct NAME "structDBf" DATASOURCE aStruDbf SIZERINFO ALIGN EXPAND// STRETCH
                END SIZER
            END PANEL
    END AUINOTEBOOK

    oBrwIndexList:DeleteAllColumns()
    ADD BCOLUMN ZERO TO oBrwIndexList "Tag" BLOCK {|key| key }
    ADD BCOLUMN TO oBrwIndexList "Expression" BLOCK {|key| hIndex[ key, "Expression" ] }
    ADD BCOLUMN TO oBrwIndexList "Condition" BLOCK {|key| hIndex[ key, "Condition" ] }
    ADD BCOLUMN TO oBrwIndexList "IsDesc" BLOCK {|key| hIndex[ key, "IsDesc" ] }
    ADD BCOLUMN TO oBrwIndexList "Unique" BLOCK {|key| hIndex[ key, "Unique" ] }

    oBrwIndexList:AutoSizeColumns( .F. )

    oBrwStruct:DeleteAllColumns()
    ADD BCOLUMN TO oBrwStruct "Fieldname" BLOCK {|n,val| iif( PCount() > 1, aStruDbf[ n, 1 ] := val, aStruDbf[ n, 1 ] ) } ONSETVALUE {|| btnUpdate:Enable() }
    ADD BCOLUMN TO oBrwStruct "Type" BLOCK {|n,val| iif( PCount() > 1, aStruDbf[ n, 2 ] := val, aStruDbf[ n, 2 ] ) } ONSETVALUE {|| btnUpdate:Enable() }
    ADD BCOLUMN TO oBrwStruct "Size" BLOCK {|n,val| iif( PCount() > 1, aStruDbf[ n, 3 ] := Val( val ), aStruDbf[ n, 3 ] ) } PICTURE "99999" AS NUMBER ONSETVALUE {|| btnUpdate:Enable() }
    ADD BCOLUMN TO oBrwStruct "Dec" BLOCK {|n,val| iif( PCount() > 1, aStruDbf[ n, 4 ] := Val( val ), aStruDbf[ n, 4 ] ) } PICTURE "99" AS NUMBER ONSETVALUE {|| btnUpdate:Enable() }

    oBrwStruct:AutoSizeColumns( .F. )

    noteBook:SetSelection( 0 )
//	 noteBook:ChangeSelection( 1 )

    ::auiNotebook:AddPage( noteBook, fileDlg:GetFileName(), .T. )
    
    noteBook:FindWindowByName( "choice" ):SetSelection( ordNumber )

    noteBook:FindWindowByName( "table" ):AutoSizeColumns( .F. )

//	 DESTROY fileDlg

RETURN

/*
    OnSelectCell
    Teo. Mexico 2009
*/
METHOD PROCEDURE OnSelectCell( gridEvent ) CLASS MyApp
    LOCAL oBrw
    oBrw := gridEvent:GetEventObject()
    oBrw:GetBrowseParent():FindWindowByName( "key", oBrw:GetBrowseParent() ):SetLabel( ordKey() )
    oBrw:GetBrowseParent():FindWindowByName( "for", oBrw:GetBrowseParent() ):SetLabel( ordFor() )
    oBrw:GetBrowseParent():FindWindowByName( "keyval", oBrw:GetBrowseParent() ):SetValue( ordKeyVal() )
RETURN

/*
    k_Process
    Teo. Mexico 2008
*/
STATIC FUNCTION k_Process( b, keyEvent )
    LOCAL nKey := keyEvent:GetKeyCode()

    DO CASE
    CASE nKey = WXK_DELETE .AND. !b:DataSource:Alias:Eof()
        IF !keyEvent:HasModifiers()
            IF b:DataSource:Alias:RecLock()
                IF b:DataSource:Alias:Deleted()
                    b:DataSource:Alias:DbRecall()
                ELSE
                    b:DataSource:Alias:DbDelete()
                ENDIF
                b:DataSource:Alias:RecUnLock()
            ENDIF
        ELSEIF keyEvent:ControlDown() .AND. wxMessageBox( "Delete the selected record ?", "Please confirm", HB_BitOr( wxYES_NO, wxICON_EXCLAMATION ) ) = wxYES
            b:DataSource:Delete()
        ENDIF
    OTHERWISE
        RETURN .F.
    ENDCASE

    b:RefreshAll()

RETURN .T.
