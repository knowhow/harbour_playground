/*
 * $Id: arrbrowser.prg 647 2010-09-27 20:17:26Z tfonrouge $
 */

/*
    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    DbBrowser: Simple browser
    Teo. Mexico 2008
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"
#include "wxharbour.ch"

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

FUNCTION Main()
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
    LOCAL text := ""
    LOCAL textCtrl
    LOCAL a,nCols,nRows,x,y
    LOCAL b

    a := {}

    nCols := HB_Random( 100 )
    nRows := HB_Random( 1000 )

    FOR x := 1 TO nRows
        AAdd( a, {} )
        FOR y := 1 TO nCols
            AAdd( ATail( a ), HB_Random( 1000 ) )
        NEXT
    NEXT

    CREATE FRAME oWnd ;
                 WIDTH 800 HEIGHT 600 ;
                 ID 999 ;
                 TITLE "Array Browser Sample"

    DEFINE MENUBAR STYLE 1
        DEFINE MENU "&File"
            ADD MENUSEPARATOR
            ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close();
                    HELPLINE "Quits this sample..."
        ENDMENU
        DEFINE MENU "Help"
            ADD MENUITEM "Fit Grid" ACTION b:Fit()
            ADD MENUSEPARATOR
            ADD MENUITEM "About..."
        ENDMENU
    ENDMENU

    BEGIN BOXSIZER VERTICAL
        @ BROWSE VAR b DATASOURCE a ;
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
            @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT
        END SIZER
    END SIZER

    b:OnSelectCellBlock := {|gridEvent| textCtrl:AppendText( "GetCol" + NTrim( gridEvent:GetCol() ) + ", RecNo: " + NTrim( b:RecNo ) + ", Row: " + NTrim( b:RowPos ) + ", Col: " + NTrim( b:ColPos ) + ", Value: " + NTrim( b:DataSource[ b:RecNo, b:ColPos ] ) + E"\n" ) }

    @ STATUSBAR
    SHOW WINDOW oWnd CENTRE

RETURN .T.
