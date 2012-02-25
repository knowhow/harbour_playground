/*
 * $Id: dbbrowser.prg 637 2010-06-26 15:56:06Z tfonrouge $
 * DbBrowser: Simple browser
 *
 * (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
 *
 */

#include "wx.ch"
#include "wxharbour.ch"

#include "wxh/filedlg.ch"

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

//REQUEST RDOSENDMESSAGE

FUNCTION Main( ... )
    LOCAL profiler := HBProfile():New()
    LOCAL i
    LOCAL MyApp
    LOCAL csPort,csServerName,csType
    LOCAL p
    LOCAL lRunServer := .F.
    
    SetMode( 40, 120 )

    FOR i:=1 TO PCount()
        p := HB_PValue( i )
        IF ValType( p ) = "C"
            IF Upper( p ) == "--CLIENT"
                csType := "RDO"
            ENDIF
            IF Upper( p ) == "--RUNSERVER"
                lRunServer := .T.
            ENDIF
            IF Upper( p ) = "--PORT="
                csPort := SubStr( p, 8 )
            ENDIF
            IF Upper( p ) = "--SERVER-AT="
                csServerName := SubStr( p, 13 )
            ENDIF
        ENDIF
    NEXT

    /*
        RDO://localhost/main:8000
        RDO_RUNSERVER://localhost/main:8000
    */

    IF Empty( PCount() )
        ? "dbbrowser can be run also as either client or server"
        ?
        ? "if using as server, then the following arguments are allowed:"
        ? "  dbbrowser --runserver [ --port=port ]"
        ? "  'port' defaults to 9000."
        ?
        ? "if using as client, then the following arguments are allowed:"
        ? "  dbbrowser --client [ --server-at=servername ] ][ --port=port ]"
        ? " 'server-at' defaults to 'localhost', 'port' defaults to 9000."
        ?
    ENDIF

    MyApp := MyApp():New()

    IF !Empty( csType )
        MyApp:RDO_TYPE := csType
        IF !Empty( csServerName )
            MyApp:RDO_SERVERNAME := csServerName
        ENDIF
        IF !Empty( csPort )
            MyApp:RDO_PORT := csPort
        ENDIF
    ENDIF

    __setProfiler( .T. )

    IF lRunServer
        MyApp:RDOServer := TRDOServer():New( "localhost", MyApp:RDO_PORT )
        MyApp:RDOServer:Start()
    ENDIF

    IMPLEMENT_APP( MyApp )

    IF lRunServer
        MyApp:RDOServer:Stop()
    ENDIF

    //RDOServerStop()

    //profiler:Gather()
    ? HBProfileReportToString():new( profiler:timeSort() ):generate( {|o| o:nTicks > 10000 } )
    ? Replicate("=",40)
    ? "  Total Calls: " + str( profiler:totalCalls() )
    ? "  Total Ticks: " + str( profiler:totalTicks() )
    ? "Total Seconds: " + str( profiler:totalSeconds() )

RETURN NIL

/*
    MyApp
    Teo. Mexico 2008
*/
CLASS MyApp FROM wxApp
PRIVATE:
PROTECTED:
PUBLIC:
    DATA RDO_PORT 	INIT "9000"
    DATA RDO_SERVERNAME 	INIT "localhost"
    DATA RDO_TYPE 	INIT ""
    DATA RDOServer
    METHOD OnInit
PUBLISHED:
ENDCLASS
/*
    EndClass MyApp
*/

/*
    OnInit
    Teo. Mexico 2008
*/
METHOD FUNCTION OnInit() CLASS MyApp
    LOCAL oWnd
    LOCAL text := ""
    LOCAL textCtrl
    LOCAL b
    LOCAL dbName

    CREATE FRAME oWnd ;
                 WIDTH 800 HEIGHT 600 ;
                 ID 999 ;
                 TITLE "Simple Dbf Browser"

    DEFINE MENUBAR STYLE 1
        DEFINE MENU "&File"
            ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
                    HELPLINE "Quits this sample..."
        ENDMENU
        DEFINE MENU "Help"
            ADD MENUITEM "Fit Grid" ACTION b:Fit()
            ADD MENUSEPARATOR
            ADD MENUITEM "About..."
        ENDMENU
    ENDMENU

    IF Empty( ::RDO_TYPE )
        dbName := "main"
    ELSE
        IF ::RDO_TYPE == "RDO"
            dbName := ::RDO_TYPE + "://" + ::RDO_SERVERNAME + ":" + ::RDO_PORT + "/main"
        ENDIF
    ENDIF

    BEGIN BOXSIZER VERTICAL
        @ BROWSE VAR b DATASOURCE TTable():New( NIL, dbName ) ;
            ONKEY {|b,keyEvent| k_Process( b, keyEvent:GetKeyCode() ) } ;
            SIZERINFO ALIGN EXPAND STRETCH
        BEGIN BOXSIZER VERTICAL "" ALIGN EXPAND
            @ GET text VAR textCtrl MULTILINE SIZERINFO ALIGN EXPAND STRETCH
            BEGIN BOXSIZER HORIZONTAL
                @ BUTTON "GoTop" ACTION b:GoTop()
                @ BUTTON "GoBottom" ACTION b:GoBottom()
                @ BUTTON "PgUp" ACTION b:PageUp()
                @ BUTTON "PgDown" ACTION b:PageDown()
                @ BUTTON "Up" ACTION b:Up()
                @ BUTTON "Down" ACTION b:Down()
                @ BUTTON "RefreshAll" ACTION b:RefreshAll()
            END SIZER
            BEGIN BOXSIZER HORIZONTAL
                @ BUTTON "Stop Server" ACTION wxGetApp():RDOServer:Stop()
            END SIZER
            @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT
        END SIZER
    END SIZER

    b:OnSelectCellBlock := ;
        {|gridEvent| 
            LOCAL oBrw
            oBrw := gridEvent:GetEventObject()
            textCtrl:AppendText( RTrim( oBrw:DataSource:Field_Last:AsString ) + ", " + oBrw:DataSource:Field_First:AsString + E"\n" )
            RETURN NIL
        }
    
    b:AlwaysShowSelectedRow := .T.

    @ STATUSBAR

    SHOW WINDOW oWnd CENTRE

RETURN .T.

/*
    btnTest
    Teo. Mexico 2008
*/
STATIC PROCEDURE btnTest
RETURN

/*
    k_Process
    Teo. Mexico 2008
*/
STATIC FUNCTION k_Process( b, nKey )

    DO CASE
    CASE nKey = 127
        ? "Delete on",b:DataSource:RecNo(),"First",b:DataSource:Field_First:Value
    OTHERWISE
        RETURN .F.
    ENDCASE

    b:RefreshAll()

RETURN .T.
