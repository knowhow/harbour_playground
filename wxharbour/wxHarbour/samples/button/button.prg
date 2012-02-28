/*
 * $Id: button.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    button sample
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
                 TITLE "Button Sample"

    DEFINE MENUBAR STYLE 1
        DEFINE MENU "&File"
            ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
                    HELPLINE "Quits this sample..."
        ENDMENU
        DEFINE MENU "Help"
            ADD MENUITEM "About..."
        ENDMENU
    ENDMENU

    BEGIN BOXSIZER HORIZONTAL
            @ BUTTON ID wxID_OPEN
            @ BUTTON ID wxID_CLOSE
            @ BUTTON ID wxID_NEW
            @ BUTTON ID wxID_SAVE
            @ BUTTON ID wxID_CANCEL
            @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT
    END SIZER

    SHOW WINDOW oWnd FIT CENTRE

RETURN .T.
