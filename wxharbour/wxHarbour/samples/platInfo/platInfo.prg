/*
 * $Id: panel.prg 459 2010-11-13 21:13:47Z tfonrouge $
 */

/*
    wxPlatformInfo sample
    Teo. Mexico 2010
*/

#include "wxharbour.ch"

FUNCTION Main

    IMPLEMENT_APP( MyApp():New() )

RETURN NIL

/*
    MyApp
    Teo. Mexico 2010
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
    Teo. Mexico 2010
*/
METHOD FUNCTION OnInit() CLASS MyApp
    LOCAL oWnd
    LOCAL platInfo
    
    platInfo := wxPlatformInfo():New()

    CREATE FRAME oWnd ;
                 WIDTH 800 HEIGHT 600 ;
                 TITLE "wxPlatformInfo Sample"

    DEFINE MENUBAR STYLE 1
        DEFINE MENU "&File"
            ADD MENUITEM E"Quit \tCtrl+Q" ID wxID_EXIT ACTION oWnd:Close() ;
                    HELPLINE "Quits this sample..."
        ENDMENU
        DEFINE MENU "Help"
            ADD MENUSEPARATOR
            ADD MENUITEM "About..."
        ENDMENU
    ENDMENU
    
    BEGIN BOXSIZER VERTICAL

        BEGIN FLEXGRIDSIZER COLS 4 GROWABLECOLS 2,4

            @ SAY "GetOperatingSystemFamilyName:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:GetOperatingSystemFamilyName NOEDITABLE SIZERINFO ALIGN LEFT
            @ SAY "IsOk:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:IsOk NOEDITABLE SIZERINFO ALIGN LEFT

            @ SAY "GetOperatingSystemId:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:GetOperatingSystemId NOEDITABLE SIZERINFO ALIGN LEFT
            @ SAY "GetOperatingSystemIdName:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:GetOperatingSystemIdName NOEDITABLE SIZERINFO ALIGN LEFT

            @ SAY "GetOSMajorVersion:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:GetOSMAjorVersion NOEDITABLE SIZERINFO ALIGN LEFT
            @ SAY "GetOSMinorVersion:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:GetOSMinorVersion NOEDITABLE SIZERINFO ALIGN LEFT

            @ SAY "GetArch:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:GetArch NOEDITABLE SIZERINFO ALIGN LEFT
            @ SAY "GetArchName:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:GetArchName NOEDITABLE SIZERINFO ALIGN LEFT
            @ SAY "GetEndianness:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:GetEndianness NOEDITABLE SIZERINFO ALIGN LEFT
            @ SAY "GetEndiannnessName:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:GetEndiannessName NOEDITABLE SIZERINFO ALIGN LEFT

            @ SAY "GetPortId:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:GetPortId NOEDITABLE SIZERINFO ALIGN LEFT
            @ SAY "GetPortIdName:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:GetPortIdName NOEDITABLE SIZERINFO ALIGN LEFT
            @ SAY "GetPortIdShortName:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:GetPortIdShortName NOEDITABLE SIZERINFO ALIGN LEFT
            @ SPACER
                @ SPACER

            @ SAY "GetToolkitMajorVersion:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:GetToolkitMAjorVersion NOEDITABLE SIZERINFO ALIGN LEFT
            @ SAY "GetToolkitMinorVersion:" SIZERINFO ALIGN RIGHT
                @ GET platInfo:GetToolkitMinorVersion NOEDITABLE SIZERINFO ALIGN LEFT

        END SIZER
        
        @ STATICLINE HORIZONTAL SIZERINFO ALIGN EXPAND
        
        @ BUTTON "Close" ACTION oWnd:Close() SIZERINFO ALIGN RIGHT

    END SIZER

    SHOW WINDOW oWnd FIT CENTRE

RETURN .T.
