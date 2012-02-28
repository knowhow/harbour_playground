/*
 * $Id: checkbox.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    checkbox sample
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
    LOCAL checkVal1 := .T.
    LOCAL checkVal2 := .F.
    LOCAL checkVal3 := .T.
    LOCAL bAction

    bAction := {|event| wxMessageBox( event:GetEventObject():GetLabel() + ": " + iif( event:GetEventObject():GetValue(), "Selected", "Deselected" ), "Status", HB_BitOr( wxOK, wxICON_INFORMATION ), oWnd ) }

    CREATE FRAME oWnd ;
                 WIDTH 200 HEIGHT 100 ;
                 ID 999 ;
                 TITLE "CheckBox Sample"

    DEFINE MENUBAR STYLE 1
        DEFINE MENU "&File"
            ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
                    HELPLINE "Quits this sample..."
        ENDMENU
        DEFINE MENU "Help"
            ADD MENUITEM "About..."
        ENDMENU
    ENDMENU

    BEGIN BOXSIZER VERTICAL

        @ CHECKBOX checkVal1 LABEL "CheckBox 1" ACTION {|event| bAction:Eval( event ) }
        @ CHECKBOX checkVal2 LABEL "CheckBox 2" ACTION {|event| bAction:Eval( event ) }
        @ CHECKBOX checkVal3 LABEL "CheckBox 3" ACTION {|event| bAction:Eval( event ) }

        @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT

    END SIZER
    
    SHOW WINDOW oWnd FIT CENTRE

RETURN .T.
