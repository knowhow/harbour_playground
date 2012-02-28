/*
 * $Id: combobox.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    combobox sample
    Teo. Mexico 2009
*/

#include "wxharbour.ch"

#define GRANGE  100

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
    LOCAL comboBoxVal1 := ""
    LOCAL comboBoxVal2 := ""
    LOCAL comboBoxVal3 := ""
    LOCAL bAction

    bAction := {|event| wxMessageBox( "Value Selected: " + event:GetEventObject():GetStringSelection(), "Status", HB_BitOr( wxOK, wxICON_INFORMATION ), oWnd ) }

    CREATE FRAME oWnd ;
                 TITLE "ComboBox Sample"

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

        @ COMBOBOX comboBoxVal1 ITEMS {"one","two","three"} ACTION {|event| bAction:Eval( event ) } SIZERINFO ALIGN LEFT

        @ COMBOBOX comboBoxVal2 ITEMS {"Windows","GNU Linux","Mac OS"} ACTION {|event| bAction:Eval( event ) } SIZERINFO ALIGN LEFT

        @ COMBOBOX comboBoxVal3 ITEMS {"FTP","HTTP","RSYNC"} ACTION {|event| bAction:Eval( event ) } SIZERINFO ALIGN LEFT

        @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT

    END SIZER

    SHOW WINDOW oWnd FIT CENTRE

RETURN .T.
