/*
 * $Id: choice.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    choice sample
    Teo. Mexico 2009
*/

#include "wxharbour.ch"

FUNCTION Main

    IMPLEMENT_APP( MyApp():New() )

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
    LOCAL choiceVal1 := 3
    LOCAL choiceVal2 := 1
    LOCAL choiceVal3 := "FTP"
    LOCAL choiceVal4 := 1
    LOCAL bAction

    bAction := {|event| wxMessageBox( "Value Selected: " + event:GetEventObject():GetStringSelection(), "Status", HB_BitOr( wxOK, wxICON_INFORMATION ), oDlg ) }

    CREATE DIALOG oDlg ;
                 TITLE "Choice Sample"

    BEGIN BOXSIZER VERTICAL

        @ CHOICE choiceVal1 ITEMS {"one","two","three"} ACTION {|event| bAction:Eval( event ) } SIZERINFO ALIGN EXPAND
        @ CHOICE choiceVal2 ITEMS {"Windows","GNU Linux","Mac OS"} ACTION {|event| bAction:Eval( event ) } SIZERINFO ALIGN EXPAND
        @ CHOICE choiceVal3 ITEMS {"FTP","HTTP","RSYNC"} ACTION {|event| bAction:Eval( event ) } SIZERINFO ALIGN EXPAND
        @ CHOICE choiceVal4 ITEMS {1=>"Number ONE",date()=>"Today",date()-1=>"Yesterday","VA"=>"Virginia","TX"=>"Texas","CA"=>"California"} SIZERINFO ALIGN EXPAND

        @ BUTTON ID wxID_EXIT ACTION oDlg:Close() SIZERINFO ALIGN RIGHT

    END SIZER

    SHOW WINDOW oDlg FIT CENTRE MODAL
    
    ? "choiceVal1:", choiceVal1
    ? "choiceVal2:", choiceVal2
    ? "choiceVal3:", choiceVal3
    ? "choiceVal4:", choiceVal4

RETURN .F.
