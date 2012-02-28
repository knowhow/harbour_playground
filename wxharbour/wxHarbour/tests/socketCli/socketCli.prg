/*
 * $Id: socketCli.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wxharbour.ch"
#include "wxh/socket.ch"

/*
    socket Clien test
    Teo. Mexico 2009
*/

#define HOSTPORT        9000

FUNCTION Main

    IMPLEMENT_APP( MyApp():New() )

RETURN NIL

CLASS MyApp FROM wxApp

    DATA logCtrl
    DATA oWnd
    DATA socket
    DATA serverName INIT "localhost"

    METHOD CloseSocket
    METHOD ConnectToServer
    METHOD OnConnectSocket
    METHOD OnExit
    METHOD OnInit

    METHOD SendToServer

ENDCLASS

METHOD PROCEDURE CloseSocket CLASS MyApp

    IF ::socket != NIL
        ::socket:Destroy()
        ::oWnd:FindWindowByName("msg"):Disable()
        DESTROY ::socket
    ENDIF

RETURN

METHOD PROCEDURE ConnectToServer CLASS MyApp
    LOCAL oDlg
    LOCAL ipv4
    LOCAL s

    CREATE DIALOG oDlg ;
                 TITLE "Connect to Server"

    BEGIN BOXSIZER VERTICAL
        @ SAY "Server:" GET ::serverName
        BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
            @ BUTTON ID wxID_CANCEL ACTION oDlg:EndModal( wxID_CANCEL )
            @ BUTTON ID wxID_OK DEFAULT ACTION oDlg:EndModal( wxID_OK )
        END SIZER
    END SIZER

    SHOW WINDOW oDlg MODAL FIT CENTRE

    IF oDlg:GetReturnCode = wxID_OK

        ipv4 := wxIPV4address():New()
        ipv4:Hostname( ::serverName )
        ipv4:Service( HOSTPORT )

        ::socket := wxSocketClient():New()

        ::socket:SetEventHandler( ::oWnd, wxID_ANY )
        ::socket:SetNotify( HB_BitOr( wxSOCKET_CONNECTION_FLAG,;
                                                                     wxSOCKET_INPUT_FLAG,;
                                                                     wxSOCKET_LOST_FLAG ) )
        ::socket:Notify( .T. )

        IF !::socket:Connect( ipv4, .T. )
            wxMessageBox( "Cannot connect to server '" + ::serverName + "'", "Error", HB_BitOr( wxOK, wxICON_ERROR ), ::oWnd )
            DESTROY ::socket
            DESTROY oDlg
            RETURN
        ENDIF

        s := "Hello from " + wxGetFullHostName()
        ? "WriteMsg 1"
        ::socket:WriteMsg( s, Len( s ) )
        ? "WriteMsg 2"
        ::oWnd:FindWindowByName("msg"):Enable()

    ENDIF

    DESTROY oDlg

RETURN

METHOD PROCEDURE OnConnectSocket( event ) CLASS MyApp
    LOCAL buffer

    SWITCH event:GetSocketEvent()
    CASE wxSOCKET_INPUT
        ::logCtrl:AppendText( E"\nSocket Input: " )
        buffer := Space( 100 )
        ::socket:ReadMsg( @buffer )
        ::logCtrl:AppendText( buffer )
        ::logCtrl:AppendText( "(" + NTrim( ::socket:LastCount() ) + ")" )
        //::logCtrl:AppendText( "(" + NTrim( ::socket:LastCount() ) + ")" + buffer )
        EXIT
    CASE wxSOCKET_CONNECTION
        ::logCtrl:AppendText( E"\nSocket Connection" )
        EXIT
    CASE wxSOCKET_LOST
        ::logCtrl:AppendText( E"\nSocket Lost" )
        EXIT
    END

RETURN

METHOD FUNCTION OnExit CLASS MyApp

    HB_ThreadTerminateAll()

RETURN 0

METHOD FUNCTION OnInit CLASS MyApp
    LOCAL msg := ""

    CREATE FRAME ::oWnd ;
                 TITLE "Socket Client"

    BEGIN FRAME TOOLBAR HEIGHT 20
        @ TOOL BUTTON ID 100 BITMAP "network.xpm" ACTION ::ConnectToServer()
        @ GET ::serverName
    END TOOLBAR

    DEFINE MENUBAR
        DEFINE MENU "&File"
            ADD MENUITEM E"Quit\tCtrl+X" ACTION ::oWnd:Close()
        ENDMENU
        DEFINE MENU "&Server"
            ADD MENUITEM E"Connect\tCtrl+C" ID 100 ACTION ::ConnectToServer() ENABLED {|| ::socket == NIL }
            ADD MENUITEM "Disconnect" ACTION ::ConnectToServer ENABLED {|| ::socket != NIL }
        ENDMENU
    ENDMENU

    BEGIN BOXSIZER VERTICAL
        @ GET VAR ::logCtrl MULTILINE STYLE wxTE_READONLY SIZERINFO ALIGN EXPAND STRETCH
        @ SAY "Send:" GET msg NAME "msg" ACTION {|getCtrl| ::SendToServer( getCtrl ) }
        @ BUTTON ID wxID_CLOSE ACTION ::oWnd:Close()
    END SIZER

    ::oWnd:FindWindowByName("msg"):Disable()

    SHOW WINDOW ::oWnd CENTRE

    ::oWnd:ConnectSocketEvt( wxID_ANY, wxEVT_SOCKET, {|event| ::OnConnectSocket( event ) } )

RETURN .T.

METHOD PROCEDURE SendToServer( getCtrl ) CLASS MyApp
    LOCAL msg

    msg := getCtrl:GetValue()

    IF !Empty( msg )
        ::logCtrl:AppendText( E"\nSended: " + msg )
        ::socket:WriteMsg( msg )
        getCtrl:Clear()
    ENDIF
RETURN
