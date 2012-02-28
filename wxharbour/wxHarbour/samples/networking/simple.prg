/*
 * $Id: simple.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
 * Simple
 * Teo. Mexico 2008
 */

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"
#include "wxharbour.ch"

FUNCTION Main()
    LOCAL port
    LOCAL ipv4,ipv4_a
    LOCAL socketServer
    LOCAL newConn
    LOCAL s
    
    ? "wxInitialize:", wxInitialize()

    port := "27960"

    ipv4 := wxIPV4Address():New()
    ipv4:AnyAddress()
    ipv4:Service(port)

    socketServer := wxSocketServer():New( ipv4 )

    ipv4:Hostname( "localhost" )

    ? "IP:",ipv4:IPAddress()
    ? "Service:",ipv4:Service()
    ? "IsLocalHost:",ipv4:IsLocalHost()
    ?
    ? "Server OK:",socketServer:IsOk()
    ? "Accepting on port " + port

    newConn := socketServer:Accept( .T. )

    IF newConn != NIL

        ipv4_a := wxIPV4Address():New()

        ? "New Conn Accepted."
        ? "OK:", newConn:IsOk
        ? "GetPeer:",newConn:GetPeer( ipv4_a )
        ? "Hostname/Service:",ipv4_a:Hostname(),ipv4_a:IPAddress,ipv4_a:Service()

        s := "Welcome to this Server..."

        ? "Sending message to the client..."
        newConn:Write( s, Len( s ) )

        s := Space( 10 )
        ? "Waiting for 10 bytes from the client..."
        newConn:Read( @s, 10 )

        ? "Client answer is: " + s

    ELSE
        ? "Accept connection failed..."
    ENDIF

    ? "Saliendo de OnInit..."

RETURN NIL
