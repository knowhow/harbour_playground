/*
 * $Id: radiobox.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    radiobox sample
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
    LOCAL radioVal1
    LOCAL radioVal2
    LOCAL radioVal3
    LOCAL bAction

    bAction := {|event| wxMessageBox( event:GetEventObject():GetLabel() + ": " + event:GetEventObject():GetStringSelection(), "Status", HB_BitOr( wxOK, wxICON_INFORMATION ), oWnd ) }

    CREATE FRAME oWnd ;
                 WIDTH 640 HEIGHT 400 ;
                 TITLE "RadioBox Sample"

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

        BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND

            @ RADIOBOX radioVal1 LABEL "Number Selection" ITEMS {"one","two","three"} ACTION {|event| bAction:Eval( event ) } SIZERINFO STRETCH

            @ RADIOBOX radioval2 LABEL "OS Selection" ITEMS {"Windows","GNU Linux","Mac OS"} ACTION {|event| bAction:Eval( event ) } SIZERINFO STRETCH

        END SIZER

        @ RADIOBOX radioval3 LABEL "Upload VIA" COLS 2 ITEMS {"FTP","HTTP","RSYNC"} ACTION {|event| bAction:Eval( event ) } SIZERINFO STRETCH

        @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT

    END SIZER

    SHOW WINDOW oWnd CENTRE

RETURN .T.
