/*
 * $Id: grid.prg 638 2010-06-28 21:15:32Z tfonrouge $
 */

/*
    grid sample
    Teo. Mexico 2009
*/

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
    LOCAL grid

    CREATE FRAME oWnd ;
                 WIDTH 800 HEIGHT 600 ;
                 ID 999 ;
                 TITLE "Grid Sample"

    DEFINE MENUBAR STYLE 1
        DEFINE MENU "&File"
            ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
                    HELPLINE "Quits this sample..."
        ENDMENU
        DEFINE MENU "Help"
            ADD MENUITEM "Fit Grid" ACTION grid:Fit()
            ADD MENUSEPARATOR
            ADD MENUITEM "About..."
        ENDMENU
    ENDMENU

    BEGIN BOXSIZER VERTICAL
            @ GRID VAR grid ROWS 10 COLS 5
            @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT
    END SIZER

    grid:SetColFormatBool( 4 )

    SHOW WINDOW oWnd FIT CENTRE

RETURN .T.

