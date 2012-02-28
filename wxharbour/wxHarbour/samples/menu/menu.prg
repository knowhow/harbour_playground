/*
 * $Id: menu.prg 667 2010-12-03 18:20:53Z tfonrouge $
 */

/*
    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    menu sample
    Teo. Mexico 2009
*/

#include "hbclass.ch"
#include "wxharbour.ch"

/*
    Main
    Teo. Mexico 2009
*/
FUNCTION Main()
    LOCAL MyApp

    MyApp := MyApp():New()

    IMPLEMENT_APP( MyApp )

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
//   LOCAL oWnd
    STATIC oWnd

    CREATE FRAME oWnd ;
                 WIDTH 800 HEIGHT 600 ;
                 TITLE "Menu Sample"

    DEFINE MENUBAR
        DEFINE MENU "&File"
            ADD MENUITEM E"Open \tF1" BITMAP "fileopen.xpm" ACTION {|| Open2( oWnd ) }
            ADD MENUITEM E"Printer" BITMAP "print.xpm" ACTION {|| wxMessageBox( "Printing..." ) }
            ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() HELPLINE "Quits this sample..."
        ENDMENU
        DEFINE MENU "Process"
            ADD MENUITEM "Item1" BITMAP "bitmap2.bmp" ACTION {|| wxMessageBox( "Some action..." ) }
            DEFINE MENU "Sub-Menu"
                ADD MENUITEM "Sub-Item1" ID wxID_OPEN ACTION {|| wxMessageBox( "Some action..." ) }
                DEFINE MENU "Sub-Process"
                    ADD MENUITEM "Item1"
                    DEFINE MENU "Sub-Menu"
                        ADD MENUITEM "Sub-Item1"
                        ADD MENUITEM "Sub-Item2"
                        ADD MENUITEM "Sub-Item3"
                        ADD MENUSEPARATOR
                        ADD MENUITEM "Sub-Item1"
                    ENDMENU
                ENDMENU
                ADD MENUITEM "Sub-Item2"
                ADD MENUITEM "Sub-Item3"
                ADD MENUSEPARATOR
                ADD MENUITEM "Sub-Item4"
            ENDMENU
        ENDMENU
        DEFINE MENU "Help"
            ADD MENUITEM "About..."
        ENDMENU
/*    DEFINE MENU "File"
        ENDMENU*/
    ENDMENU

    @ STATUSBAR

//   oWnd:SetStatusBar( wxStatusBar():New( oWnd ) )

    SHOW WINDOW oWnd

RETURN .T.

/*
    Open a new Dialog MODAL
*/
STATIC PROCEDURE Open( parentWnd )
    LOCAL oDlg
//   parentWnd := NIL

    CREATE DIALOG oDlg ;
                 PARENT parentWnd

    BEGIN BOXSIZER VERTICAL
        @ SPACER
        BEGIN BOXSIZER HORIZONTAL
            @ BUTTON "Cancel" ID wxID_CANCEL // ACTION oDlg:Close()
            @ BUTTON "Ok" ID wxID_OK // ACTION oDlg:Close()
        END SIZER
    END SIZER

    SHOW WINDOW oDlg MODAL

    DESTROY oDlg

RETURN

STATIC PROCEDURE Open2( parentWnd )
    LOCAL oDlg
    
    oDlg := wxDialog():New( parentWnd )

    //oDlg:SetExtraStyle( wxWS_EX_BLOCK_EVENTS )
    
    wxButton():New( oDlg, wxID_CANCEL, "Cancel", -1, -1, 0 )
    
    oDlg:ShowModal()
    
    DESTROY oDlg

RETURN
