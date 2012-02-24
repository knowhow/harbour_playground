// FileXLS automatic error generation

#include "Error.ch"
#include "XLSError.ch"

external ProcName, ErrorSys

#define _SUBSYS_       "FileXLS"

#define ERR_MESSAGE    1
#define ERR_SEVERITY   2
#define ERR_SUBSYS     3
#define ERR_ERR_NO     4

//----------------------------------------------------------------------------//

FUNCTION _XLSGenError( nError, cOperation )

 local aErr := { { "Non defined XLS function", ES_CATASTROPHIC,, },;
                 { "Formula syntactic error", ES_CATASTROPHIC,, },;
                 { "Data type XLS no support", ES_WARNING,, } }

 local oError

 if nError > 0 .and. nError <= MAX_DEFINED_ERRORS

    oError = ErrorNew()

    oError:Severity    = aErr[ nError ][ ERR_SEVERITY ]
    oError:CanDefault  = oError:Severity < ES_CATASTROPHIC
    oError:SubSystem   = If( aErr[ nError ][ ERR_SUBSYS ] == nil,;
                        _SUBSYS_ ,;
                        aErr[ nError ][ ERR_SUBSYS ] )
    oError:SubCode     = If( aErr[ nError ][ ERR_ERR_NO ] == nil,;
                        nError,;
                        aErr[ nError ][ ERR_ERR_NO ] )
    oError:Description = aErr[ nError ][ ERR_MESSAGE ]
    oError:Operation   = cOperation

 endif

return oError
