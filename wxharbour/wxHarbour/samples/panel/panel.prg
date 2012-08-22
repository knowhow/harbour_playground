/*
 * $Id: panel.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    grid sample
    Teo. Mexico 2009
*/

#include "wxharbour.ch"

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
                 WIDTH 800 HEIGHT 600 ;
                 ID 999 ;
                 TITLE "Panel's Sample"

    DEFINE MENUBAR STYLE 1
        DEFINE MENU "&File"
            ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
                    HELPLINE "Quits this sample..."
        ENDMENU
        DEFINE MENU "Help"
            ADD MENUSEPARATOR
            ADD MENUITEM "About..."
        ENDMENU
    ENDMENU

    BEGIN BOXSIZER HORIZONTAL BORDER 100
        BEGIN PANEL STYLE wxSUNKEN_BORDER SIZERINFO ALIGN EXPAND STRETCH
        END PANEL
        BEGIN PANEL STYLE wxSUNKEN_BORDER SIZERINFO ALIGN EXPAND STRETCH
        END PANEL
    END SIZER

    SHOW WINDOW oWnd CENTRE

RETURN .T.
