/*
 * $Id: treectrl.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    treectrl sample
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
    LOCAL treeCtrl
    LOCAL treeItemId
    LOCAL i

    CREATE FRAME oWnd ;
                 TITLE "TreeCtrl Sample"

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

        @ TREECTRL VAR treeCtrl SIZERINFO STRETCH ALIGN EXPAND

        BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
            @ BUTTON "Expand" ACTION treeCtrl:ExpandAll()
            @ BUTTON "Collapse" ACTION treeCtrl:CollapseAll()
        END SIZER

        @ BUTTON ID wxID_EXIT ACTION oWnd:Close() SIZERINFO ALIGN RIGHT

    END SIZER

    treeItemId := treeCtrl:AddRoot("Root")
    FOR i:=1 TO 10
        treeCtrl:AppendItem( treeItemId, "Item " + LTrim(Str(i)) )
    NEXT
    treeCtrl:AppendItem( treeCtrl:AppendItem( treeItemId, "Item2" ), "SubItem1" )
    treeCtrl:AppendItem( treeCtrl:AppendItem( treeCtrl:AppendItem( treeItemId, "Item3" ), "SubItem2" ), "SubSubItem1" )
    treeCtrl:AppendItem( treeItemId, "Item4" )

    SHOW WINDOW oWnd FIT CENTRE

RETURN .T.
