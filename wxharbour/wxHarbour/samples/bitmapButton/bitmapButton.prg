/*
 * $Id: bitmapButton.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    button sample
    Teo. Mexico 2009
*/

#include "wxharbour.ch"
#include "wxh/bitmap.ch"
#include "wxh/filedlg.ch"

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
    LOCAL bmp

    CREATE FRAME oWnd ;
                 WIDTH 800 HEIGHT 600 ;
                 TITLE "BitmapButton Sample"

    DEFINE MENUBAR STYLE 1
        DEFINE MENU "&File"
            ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
                    HELPLINE "Quits this sample..."
        ENDMENU
        DEFINE MENU "Help"
            ADD MENUITEM "About..."
        ENDMENU
    ENDMENU

    bmp := wxBitmap():New()
    bmp:LoadFile("fileopen.xpm", wxBITMAP_TYPE_XPM )

    BEGIN BOXSIZER HORIZONTAL
            @ BUTTON "Open" ID wxID_OPEN BITMAP bmp STYLE wxBU_BOTTOM ACTION { | | fnOpen(oWnd)  }
            @ BUTTON "Void" ID wxID_CLOSE BITMAP "void.xpm"
            @ BUTTON ID wxID_NEW BITMAP "find.xpm"
            @ BUTTON ID wxID_SAVE BITMAP "print.xpm"
            @ BUTTON ID wxID_CANCEL BITMAP "bitmap2.bmp"
            @ BUTTON ID wxID_EXIT BITMAP "quit.xpm" ACTION oWnd:Close() DEFAULT
    END SIZER

    SHOW WINDOW oWnd FIT CENTRE

RETURN .T.

FUNCTION fnOpen(oWnd)
    Local oDlg := wxFileDialog():New( oWnd,NIL,NIL,NIL,NIL,wxFD_OPEN)

     IF	(oDlg:ShowModal() == wxID_OK)
    ENDIF
RETURN .t.
