/*
 * $Id: searchCtrl.prg 637 2010-06-26 15:56:06Z tfonrouge $
 *
 * Teo. Mexico 2009
 *
 */

#include "wxharbour.ch"

/*
    Main : Needed in all wx* apps
    Teo. Mexico 2009
*/
FUNCTION Main()

    IMPLEMENT_APP( MyApp():New() )

RETURN NIL

/*
    MyApp
    Teo. Mexico 2009
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
    Teo. Mexico 2009
*/
METHOD FUNCTION OnInit() CLASS MyApp
    LOCAL oDlg
    LOCAL edtNombre, s1, s2

    edtNombre := wxGetUserId()
    s1 := ""
    s2 := ""

    CREATE DIALOG oDlg ;
                 WIDTH 640 HEIGHT 400 ;
                 TITLE "SearchCtrl Sample"

    BEGIN BOXSIZER VERTICAL

        @ SEARCHCTRL edtNombre ON SEARCH {|| wxMessageBox( "Searching...", "", HB_BitOr( wxOK, wxICON_INFORMATION ) ) }
        @ SEARCHCTRL s1 ON SEARCH {|| wxMessageBox( "Searching...", "", HB_BitOr( wxOK, wxICON_INFORMATION ) ) }
        @ SEARCHCTRL s2 ON SEARCH {|| wxMessageBox( "Searching...", "", HB_BitOr( wxOK, wxICON_INFORMATION ) ) }

        @ BUTTON ID wxID_OK ACTION oDlg:Close() SIZERINFO ALIGN RIGHT

    END SIZER

    SHOW WINDOW oDlg MODAL FIT CENTRE

    oDlg:Destroy()

    ? "edtNombre:", edtNombre

RETURN .T.
