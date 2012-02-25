/*
 * $Id: staticBitmap.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    staticBitmap sample
    Teo. Mexico 2009
*/

#include "wxharbour.ch"
#include "wxh/bitmap.ch"

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
//  LOCAL bmp

    CREATE FRAME oWnd ;
                 WIDTH 800 HEIGHT 600 ;
                 TITLE "StaticBitmap Sample"

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
    @ STATICBITMAP "kids.bmp"
    END SIZER

    SHOW WINDOW oWnd FIT CENTRE

RETURN .T.
