/*
 * $Id: gauge.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    gauge sample
    Teo. Mexico 2009
*/

#include "wxharbour.ch"

#define GRANGE  100

FUNCTION Main
    LOCAL MyApp

    MyApp := MyApp():New()

    IMPLEMENT_APP( MyApp )

RETURN NIL

/*
    MyApp
    Teo. Mexico 2008
*/
CLASS MyApp FROM wxApp
PRIVATE:
PROTECTED:
PUBLIC:
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

    CREATE FRAME oWnd ;
                 WIDTH 200 HEIGHT 100 ;
                 ID 999 ;
                 TITLE "Gauge Sample"

    DEFINE MENUBAR STYLE 1
        DEFINE MENU "&File"
            ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
                    HELPLINE "Quits this sample..."
        ENDMENU
        DEFINE MENU "Help"
            ADD MENUITEM "About..."
        ENDMENU
    ENDMENU

    BEGIN BOXSIZER VERTICAL

        @ GAUGE VERTICAL NAME "Gauge1" RANGE GRANGE SIZERINFO STRETCH
        @ GAUGE HORIZONTAL NAME "Gauge2" RANGE GRANGE WIDTH 400 SIZERINFO ALIGN EXPAND
        @ GAUGE HORIZONTAL NAME "Gauge3" WIDTH 400 SIZERINFO ALIGN EXPAND

        @ BUTTON ID wxID_APPLY ACTION RunGauges( oWnd )

        @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT

    END SIZER

    SHOW WINDOW oWnd FIT CENTRE

RETURN .T.

STATIC PROCEDURE RunGauges( oWnd )
    LOCAL gauge1 := oWnd:FindWindowByName("Gauge1")
    LOCAL gauge2 := oWnd:FindWindowByName("Gauge2")
    LOCAL gauge3 := oWnd:FindWindowByName("Gauge3")
    LOCAL n

    oWnd:FindWindowById( wxID_APPLY ):Disable()
    oWnd:FindWindowById( wxID_EXIT ):Disable()

    FOR n:=1 TO GRANGE
        HB_IdleSleep( 0.1 )
        gauge1:SetValue( n )
        gauge2:SetValue( n )
        gauge3:Pulse()
        wxSafeYield( oWnd )
    NEXT

    oWnd:FindWindowById( wxID_APPLY ):Enable()
    oWnd:FindWindowById( wxID_EXIT ):Enable()

RETURN
