/*
 * $Id: taskBarIcon.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxTaskBarIcon sample
    Teo. Mexico 2009
*/

#include "wxharbour.ch"
#include "wxh/bitmap.ch"
#include "wxh/taskbar.ch"

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
    DATA mainWnd
    DATA taskBarIcon
    DATA trayIcon
    METHOD HideApplication
    METHOD OnCloseMainWnd
    METHOD OnInit
    METHOD RemoveTrayIcon
    METHOD SetTrayIcon
    METHOD ToogleTrayIcon
PUBLISHED:
ENDCLASS

/*
    HideApplication
    Teo. Mexico 2009
*/
METHOD PROCEDURE HideApplication CLASS MyApp

    IF !::taskBarIcon:IsIconInstalled()
        ::SetTrayIcon()
    ENDIF

    ::mainWnd:Hide()

RETURN

/*
    OnCloseMainWnd
    Teo. Mexico 2009
*/
METHOD PROCEDURE OnCloseMainWnd( event ) CLASS MyApp
    LOCAL mainWnd
    LOCAL Result

    mainWnd := event:GetEventObject()

    IF !::taskBarIcon:IsIconInstalled()
        Result := wxMessageBox( "Hide the application ?", "Confirm", HB_BitOr( wxICON_QUESTION, wxYES_NO ), mainWnd )
        IF Result = wxYES
            ::SetTrayIcon()
            mainWnd:Hide()
        ELSE
            ::taskBarIcon:RemoveIcon()
            mainWnd:Destroy()
        ENDIF
        RETURN
    ENDIF

    Result := wxMessageBox( "Quit the application ?", "Confirm", HB_BitOr( wxICON_QUESTION, wxYES_NO ), mainWnd )

    IF Result = wxYES
        ::taskBarIcon:RemoveIcon()
        DESTROY ::taskBarIcon
        mainWnd:Destroy()
        RETURN
    ENDIF

    event:Veto()

RETURN

/*
    OnInit
    Teo. Mexico 2009
*/
METHOD FUNCTION OnInit() CLASS MyApp
    LOCAL bmType

    CREATE FRAME ::mainWnd ;
                 TITLE "TaskBarIcon Sample"

    BEGIN BOXSIZER VERTICAL
        BEGIN BOXSIZER VERTICAL "" ALIGN EXPAND STRETCH
            BEGIN BOXSIZER HORIZONTAL
                @ CHECKBOX LABEL "Tray Icon enabled" NAME "checkBox" WIDTH 300 ACTION {|event| ::ToogleTrayIcon( event ) }
            END SIZER
            @ BUTTON "Hide" ACTION ::HideApplication()
        END SIZER
        @ BUTTON ID wxID_CLOSE DEFAULT ACTION ::mainWnd:Close() SIZERINFO ALIGN RIGHT
    END SIZER

    SHOW WINDOW ::mainWnd FIT CENTRE

    ::mainWnd:ConnectCloseEvt( ::mainWnd:GetId(), wxEVT_CLOSE_WINDOW, {|event| ::OnCloseMainWnd( event ) } )

    ::trayIcon := wxIcon():New() /* loads default xpm (wxwin32x32.xpm) */
#ifdef HB_OS_WIN_32
    bmType := wxBITMAP_TYPE_ICO
#else
    bmType :=wxBITMAP_TYPE_XPM
#endif
    ::trayIcon:LoadFile( "sample.ico", bmType ) /* loads an icon */

    ::taskBarIcon := MyTaskBarIcon():New()

    ::taskBarIcon:ConnectTaskBarIconEvt( wxID_ANY, wxEVT_TASKBAR_LEFT_DCLICK, {|| ::mainWnd:Show( !::mainWnd:IsShown() )  } )

    ::RemoveTrayIcon()

RETURN .T.

/*
    RemoveTrayIcon
    Teo. Mexico 2009
*/
METHOD PROCEDURE RemoveTrayIcon CLASS MyApp

    IF ::taskBarIcon:IsIconInstalled()
        ::mainWnd:FindWindowByName( "checkBox", ::mainWnd ):SetValue( .F. )
        ::taskBarIcon:RemoveIcon()
        IF !::mainWnd:IsShown()
            ::mainWnd:Show( .T. )
        ENDIF
    ENDIF

RETURN

/*
    SetTrayIcon
    Teo. Mexico 2009
*/
METHOD PROCEDURE SetTrayIcon CLASS MyApp

    ::taskBarIcon:SetIcon( ::trayIcon, "This is the TaskBarIcon Sample tooltip" )

    ::mainWnd:FindWindowByName( "checkBox", ::mainWnd ):SetValue( .T. )

RETURN

/*
    ToogleTrayIcon
    Teo. Mexico 2009
*/
METHOD PROCEDURE ToogleTrayIcon( event ) CLASS MyApp
    LOCAL checkBox

    checkBox := event:GetEventObject()

    IF checkBox:IsChecked()
        ::SetTrayIcon()
    ELSE
        ::RemoveTrayIcon()
    ENDIF

RETURN

/*
    EndClass MyApp
*/

/*
    MyTaskBarIcon
    Teo. Mexico 2009

    We need to create subclass to be able to call ::CreatePopupMenu below  
*/
CLASS MyTaskBarIcon FROM wxTaskBarIcon
    METHOD CreatePopupMenu
ENDCLASS

METHOD FUNCTION CreatePopupMenu CLASS MyTaskBarIcon
    LOCAL menu

    DEFINE MENU VAR menu PARENT Self
        ADD MENUITEM "Show TaskBarIcon Sample" ACTION wxGetApp():mainWnd:Show( .T. )
        DEFINE MENU "Sub"
            ADD MENUITEM "Sub-Item"
            ADD MENUITEM "Sub-Item"
            ADD MENUITEM "Sub-Item"
        ENDMENU
        ADD MENUITEM "About" ACTION wxMessageBox("Close","TaskBarIcon",HB_BitOr( wxOK, wxICON_INFORMATION),wxGetApp():mainWnd)
        ADD MENUSEPARATOR
        ADD MENUITEM "Remove Tray Icon" ACTION wxGetApp():RemoveTrayIcon()
        ADD MENUSEPARATOR
        ADD MENUITEM "Hide TaskBarIcon Sample" ACTION wxGetApp():HideApplication()
    ENDMENU

RETURN menu
