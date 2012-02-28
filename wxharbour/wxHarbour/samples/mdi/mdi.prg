/*
 * $Id: text.prg 459 2009-11-13 21:13:47Z tfonrouge $
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
    DATA frame
    
    METHOD OnInit
    
    METHOD ChildMDI( parent )
    
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

    CREATE MDIPARENT FRAME ::frame ;
            WIDTH 800 HEIGHT 600 ;
            TITLE "Mdi Parent"

    DEFINE MENUBAR
        DEFINE MENU "File"
            ADD MENUITEM "Child" ACTION ::ChildMDI()
            ADD MENUITEM "Close" ID wxID_CLOSE ACTION ::frame:Close()
        ENDMENU
    ENDMENU

    SHOW WINDOW ::frame CENTRE


RETURN .T.

/*
    ChildMDI
*/
METHOD PROCEDURE ChildMdi() CLASS MyApp
    LOCAL frame
    LOCAL edtNombre,edtMemo,edtPassword

    edtNombre := wxGetUserId()
    edtMemo := ""
    edtPassword := "password"

    CREATE MDICHILD FRAME frame ;
            PARENT ::frame ;
            WIDTH 640 HEIGHT 400 ;
            TITLE "Mdi Child"
            
    BEGIN BOXSIZER VERTICAL

        @ SAY "Single Line:" WIDTH 70 GET edtNombre
        @ SAY "Multi Line:" WIDTH 70 GET edtMemo MULTILINE
        @ SAY "Password:" WIDTH 70 GET edtPassword WIDTH 200 STYLE wxTE_PASSWORD

        @ BUTTON ID wxID_OK ACTION frame:Close() SIZERINFO ALIGN RIGHT

    END SIZER

    SHOW WINDOW frame FIT CENTRE

RETURN
