/*
 * $Id: TRDOClient.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    TRDOClient
    Teo. Mexico 2008
*/

#include "hbclass.ch"
#include "property.ch"
#include "raddox.ch"
#include "xerror.ch"

CLASS TRDOClient FROM wxSocketClient
PRIVATE:

    DATA FIPV4

PROTECTED:
PUBLIC:

    DATA DefaultTimeOut INIT 10

    CONSTRUCTOR New( address, port )

    METHOD Connect

PUBLISHED:
ENDCLASS

/*
    New
    Teo. Mexico 2008
*/
METHOD New( address, port ) CLASS TRDOClient

    ::FIPV4 := wxIPV4address():New()
    ::FIPV4:HostName( address )
    ::FIPV4:Service( port )

    Super:New()

    ::SetTimeOut( ::DefaultTimeOut )

RETURN Self

/*
    Connect
    Teo. Mexico 2008
*/
METHOD FUNCTION Connect CLASS TRDOClient
    LOCAL Result
    LOCAL s := Space( 100 )

    Result := Super:Connect( ::FIPV4 )

    IF !::IsOk
        ::Error_Could_Not_Create_RDO_Client()
    ENDIF

    ::ReadMsg( @s, 100 )

RETURN Result

/*
    EndClass TRDOClient
*/
