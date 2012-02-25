/*
 * $Id: text.prg 637 2010-06-26 15:56:06Z tfonrouge $
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
    LOCAL edtNombre,edtMemo,edtPassword

    edtNombre := wxGetUserId()
    edtMemo := ""
    edtPassword := "password"

    CREATE DIALOG oDlg ;
                 WIDTH 640 HEIGHT 400 ;
                 TITLE "Text Sample"

    BEGIN BOXSIZER VERTICAL

        @ SAY "Single Line:" WIDTH 70 GET edtNombre
        @ SAY "Multi Line:" WIDTH 70 GET edtMemo MULTILINE
        @ SAY "Password:" WIDTH 70 GET edtPassword WIDTH 200 STYLE wxTE_PASSWORD

        @ BUTTON ID wxID_OK ACTION oDlg:Close() SIZERINFO ALIGN RIGHT

    END SIZER

    SHOW WINDOW oDlg MODAL FIT CENTRE

    oDlg:Destroy()

    ? "edtNombre:", edtNombre
    ? "edtMemo:", edtMemo
    ? "edtPassword:", edtPassword

RETURN .T.
