/*
 * $Id: socketSrv.prg 637 2010-06-26 15:56:06Z tfonrouge $
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
    socket Server test
    Teo. Mexico 2009
*/

#define HOSTPORT        9000

STATIC sMutex

FUNCTION Main

    sMutex := HB_MutexCreate()

    IMPLEMENT_APP( MyApp():New() )

RETURN NIL

CLASS MyApp FROM wxApp

    DATA logCtrl
    DATA oWnd
    DATA socket
    DATA active INIT .T.

    METHOD CloseApp

    METHOD OnConnectSocket
    METHOD OnExit
    METHOD OnInit

ENDCLASS

METHOD PROCEDURE CloseApp CLASS MyApp

    ::active := .F.

    HB_ThreadWaitForAll()

    ::oWnd:Close()

RETURN

METHOD PROCEDURE OnConnectSocket( event ) CLASS MyApp
    LOCAL sktServer
    LOCAL socket

    ? "OnConnectSocket"

    SWITCH event:GetSocketEvent()
    CASE wxSOCKET_CONNECTION

        sktServer := event:GetSocket()

        socket := sktServer:Accept( .F. )

        IF socket != NIL
            HB_ThreadStart( @ProcessClient(), socket, Self )
        ENDIF

        EXIT

    END

RETURN

METHOD FUNCTION OnExit CLASS MyApp

    ::active := .F.

    HB_ThreadTerminateAll()

RETURN 0

METHOD FUNCTION OnInit CLASS MyApp
    LOCAL ipv4

    IF !HB_MTVM()
        wxMessageBox( "This program requieres an Multithread VM.", "Error", HB_BitOr( wxOK, wxICON_WARNING ) )
        RETURN .F.
    ENDIF

    ipv4 := wxIPV4address():New()
    ipv4:AnyAddress()
    ipv4:Service( HOSTPORT )

    ::socket := wxSocketServer():New( ipv4 )

    IF !::socket:IsOk()
        wxMessageBox( "Cannot create socket", "Error", HB_BitOr( wxOK, wxICON_ERROR ), )
        RETURN .F.
    ENDIF

    CREATE FRAME ::oWnd ;
                 TITLE "Socket Server"

    BEGIN BOXSIZER VERTICAL
        @ GET VAR ::logCtrl MULTILINE STYLE wxTE_READONLY SIZERINFO ALIGN EXPAND STRETCH
        @ BUTTON ID wxID_CLOSE ACTION ::CloseApp()
    END SIZER

    SHOW WINDOW ::oWnd CENTRE

    ::socket:SetEventHandler( ::oWnd, wxID_ANY )
    ::socket:SetNotify( wxSOCKET_CONNECTION_FLAG )
    ::socket:Notify( .T. )

    ::oWnd:ConnectSocketEvt( wxID_ANY, wxEVT_SOCKET, {|event| ::OnConnectSocket( event ) } )

RETURN .T.

FUNCTION ProcessClient( socket, Self )
    LOCAL ipv4
    LOCAL buffer := ""

    ipv4 := wxIPV4address():New()
    socket:GetPeer( ipv4 )

    socket:ReadMsg( @buffer, 100 )

    wxMutexGuiEnter()
    ::logCtrl:AppendText( E"\nNew Client from '" + ipv4:Hostname() +"': " )
    ::logCtrl:AppendText( E"\n" + buffer )
    wxMutexGuiLeave()

    socket:WriteMsg( "Welcome to this Server, " + buffer )

    WHILE ::active .AND. socket:IsConnected()
        ? "active",::active
        IF socket:WaitForRead( 1 )
            ? "IsData"
            ? "ReadMsg 1"
            socket:ReadMsg( @buffer, 100 )
            ? "ReadMsg 2"
            wxMutexGuiEnter()
            ::logCtrl:AppendText( E"\n>" + buffer )
            wxMutexGuiLeave()
            socket:WriteMsg( "Ok. Message received " + buffer )
        ENDIF
    ENDDO

    ? "Destroy"
    socket:Destroy()

RETURN NIL
