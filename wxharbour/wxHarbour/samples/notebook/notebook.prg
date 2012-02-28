/*
 * $Id: notebook.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    notebook sample
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
    DATA statusBar
    DATA wnd
    METHOD OnNotebookPageChanging( noteBookEvt )
    METHOD OnSubNotebookPageChanged( noteBookEvt )
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
    LOCAL text := ""

    CREATE FRAME ::wnd ;
                 TITLE "Notebook Sample"

    DEFINE MENUBAR STYLE 1
        DEFINE MENU "&File"
            ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION ::wnd:Close() ;
                    HELPLINE "Quits this sample..."
        ENDMENU
        DEFINE MENU "Help"
            ADD MENUITEM "About..."
        ENDMENU
    ENDMENU

    BEGIN BOXSIZER VERTICAL

        BEGIN NOTEBOOK ON PAGE CHANGING {|noteBookEvt| ::OnNotebookPageChanging( noteBookEvt ) } SIZERINFO ALIGN EXPAND STRETCH

            ADD BOOKPAGE "Button" FROM
                BEGIN PANEL
                    @ SAY "Enter your name:" GET text
                END PANEL

            ADD BOOKPAGE "Grid" FROM
                @ GRID ROWS 10 COLS 5

            ADD BOOKPAGE "Sub-Notebook" FROM
                BEGIN NOTEBOOK ON PAGE CHANGED {|noteBookEvt| ::OnSubNotebookPageChanged( noteBookEvt ) }
                    ADD BOOKPAGE "Page1" FROM
                        @ BUTTON
                    ADD BOOKPAGE "Page2" FROM
                        @ BUTTON
                END NOTEBOOK
        END NOTEBOOK

        @ BUTTON ID wxID_EXIT ACTION ::wnd:Close() SIZERINFO ALIGN RIGHT

    END SIZER
    
    @ STATUSBAR VAR ::statusBar

    SHOW WINDOW ::wnd FIT CENTRE

RETURN .T.

/*
    OnNotebookPageChanging
    Teo. Mexico 2010
*/
METHOD PROCEDURE OnNotebookPageChanging( noteBookEvt ) CLASS MyApp

    IF noteBookEvt:GetOldSelection() = 1 .AND. noteBookEvt:GetSelection() = 2
        IF wxMessageBox( "Allow change from tab1 to tab2 ?", "Confirm", wxYES_NO, ::wnd ) != wxYES
            noteBookEvt:Veto()
        ENDIF
    ENDIF

RETURN

/*
    OnSubNotebookPageChanged
    Teo. Mexico 2010
*/
METHOD PROCEDURE OnSubNotebookPageChanged( noteBookEvt ) CLASS MyApp

    IF ::statusBar != NIL
        ::statusBar:SetStatusText( "SubNotebook Selected Page: " + NTrim( noteBookEvt:GetSelection() ) )
    ENDIF

    /* TODO: Why is needed this call on Mac/Windows */
    noteBookEvt:Skip()

RETURN
