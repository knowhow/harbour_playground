/*
 * $Id: TRDOServer.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    TRDOServer
    Teo. Mexico 2008
*/

#include "hbclass.ch"
#include "property.ch"
#include "raddox.ch"
#include "xerror.ch"

REQUEST __RDOSENDMESSAGE

STATIC FSocketServer := NIL

/*
    TRDOSocketBase
    Teo. Mexico 2008
*/
CLASS TRDOSocketBase FROM wxSocketBase
PRIVATE:
PROTECTED:
PUBLIC:

    METHOD ProcessClientRequests

PUBLISHED:
ENDCLASS

/*
    EndClass TRDOSocketBase
*/

/*
    TRDOServer
    Teo. Mexico 2008
*/
CLASS TRDOServer FROM wxSocketServer
PRIVATE:

    DATA FMapTable	INIT {=>}
    DATA FThreadServerId

PROTECTED:
PUBLIC:

    DATA DefaultTimeOut INIT 10
    DATA StopRequest INIT .F.

    CONSTRUCTOR New( address, port )

    METHOD Accept( flag ) /* returns an TRDOSocketBase object */
    METHOD AddTable( table )
    METHOD Start
    METHOD Stop

PUBLISHED:
ENDCLASS

/*
    New
    Teo. Mexico 2008
*/
METHOD New( address, port ) CLASS TRDOServer
    LOCAL ipv4

    IF FSocketServer != NIL
        ::Error_RDO_Server_Already_Created()
    ENDIF

    ipv4 := wxIPV4address():New()
    ipv4:HostName( address )
    ipv4:Service( port )

    Super:New( ipv4 )

    ::SetTimeOut( ::DefaultTimeOut )

    IF !::IsOk
        ::Error_Could_Not_Create_RDO_Server()
    ENDIF

    IF !HB_MTVM()
        ::Error_Not_VM_MT()
    ENDIF

    FSocketServer := Self

RETURN Self

/*
    AddTable
    Teo. Mexico 2008
*/
METHOD FUNCTION AddTable( table ) CLASS TRDOServer

    IF HB_HHasKey( ::FMapTable, table:TableFileName )
        ::Error_TableFileName_Already_Exists()
    ENDIF

    ::FMapTable[ table:TableFileName ] := table

RETURN .T.

/*
    RDO_DataBaseThread
    Teo. Mexico 2008
*/
STATIC FUNCTION RDO_DataBaseThread
    LOCAL ipv4Addr := wxIPV4Address():New()
    LOCAL socketServer
    LOCAL s

    socketServer := FSocketServer:Accept( .F. )

    IF socketServer == NIL
        RETURN .F.
    ENDIF

    socketServer:GetPeer( ipv4Addr )

    s := "Connected to this Server."

    socketServer:WriteMsg( s, len( s ) )

    /* loop here until client disconnects */
    socketServer:ProcessClientRequests()

    socketServer:Destroy()

RETURN .T.

/*
    RDO_ServerStart
    Teo. Mexico 2008
*/
STATIC FUNCTION RDO_ServerStart

    WHILE ! FSocketServer == NIL .AND. FSocketServer:StopRequest == .F.

        IF FSocketServer:WaitForAccept()

            HB_ThreadStart( @RDO_DataBaseThread() )

        ENDIF

    ENDDO

RETURN .T.

/*
    Start : Start a Thread to listen for clients
    Teo. Mexico 2008
*/
METHOD FUNCTION Start CLASS TRDOServer

    IF ::FThreadServerId != NIL
        RETURN .F. /* Server already started */
    ENDIF

    ::FThreadServerId := HB_ThreadStart( @RDO_ServerStart() )

RETURN .T.

/*
    Stop
    Teo. Mexico 2008
*/
METHOD FUNCTION Stop CLASS TRDOServer

    ::Destroy()

    ::StopRequest := .T.

RETURN .T.

/*
    EndClass TRDOServer
*/
