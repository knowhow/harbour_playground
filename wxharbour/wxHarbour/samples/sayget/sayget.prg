/*
 * $Id: sayget.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    sayget sample
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
    LOCAL oDlg
    LOCAL name
    LOCAL cURL
    LOCAL comm

    name := "Juana la Cubana"
    cURL := ""
    comm := ""

    CREATE DIALOG oDlg ;
                 TITLE "Say/Get Sample"

    BEGIN BOXSIZER VERTICAL

        @ SAY "Name:" GET name
        @ SAY ABOVE "URL:" GET cURL WIDTH 400

        @ SAY ABOVE "Comment:" GET comm MULTILINE

        @ BUTTON ID wxID_APPLY ACTION wxMessageBox( E"Values entered:\n\nName: " + name + E"\n\nURL: " + cURL + E"\n\nComment:\n" + comm, "Values", HB_BitOr( wxOK, wxICON_INFORMATION ), oDlg )

        @ BUTTON ID wxID_EXIT ACTION oDlg:Close() SIZERINFO ALIGN RIGHT

    END SIZER

    SHOW WINDOW oDlg FIT CENTRE MODAL

RETURN .F. // If main window is a wxDialog, we need to return false on OnInit
