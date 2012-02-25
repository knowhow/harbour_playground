/*
 * $Id: wxherrorsys.prg 786 2011-11-28 16:46:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

#include "wxharbour.ch"

#include "common.ch"
#include "error.ch"

PROCEDURE wxhErrorSys()
    ErrorBlock( {|oError| wxhDefError( oError ) } )
RETURN

STATIC FUNCTION wxhDefError( oError )
    LOCAL cMessage
    LOCAL cDOSError
    LOCAL aOptions
    LOCAL nChoice
    LOCAL n

    // By default, division by zero results in zero
//    IF oError:genCode == EG_ZERODIV .AND. ;
//        oError:canSubstitute
//        RETURN 0
//    ENDIF

    // By default, retry on RDD lock error failure */
    IF oError:genCode == EG_LOCK .AND. ;
        oError:canRetry
        // oError:tries++
        RETURN .T.
    ENDIF

    // Set NetErr() of there was a database open error
    IF oError:genCode == EG_OPEN .AND. ;
        oError:osCode == 32 .AND. ;
        oError:canDefault
        NetErr( .T. )
        RETURN .F.
    ENDIF

    // Set NetErr() if there was a lock error on dbAppend()
    IF oError:genCode == EG_APPENDLOCK .AND. ;
        oError:canDefault
        NetErr( .T. )
        RETURN .F.
    ENDIF

    cMessage := ErrorMessage( oError )
    IF ! Empty( oError:osCode )
        cDOSError := "(DOS Error " + hb_NToS( oError:osCode ) + ")"
    ENDIF

    // Build buttons

    aOptions := {}

    AAdd( aOptions, wxhLABEL_QUIT )

    IF oError:canRetry
        AAdd( aOptions, wxhLABEL_RETRY )
    ENDIF

    IF oError:canDefault
        AAdd( aOptions, wxhLABEL_DEFAULT )
    ENDIF

    IF ! HB_ISNIL( cDOSError )
        cMessage += E"\n" + cDOSError
    ENDIF

    nChoice := wxhShowError( cMessage, aOptions, oError )

    IF ! Empty( nChoice )
        DO CASE
        CASE aOptions[ nChoice ] == "Break"
            Break( oError )
        CASE aOptions[ nChoice ] == wxhLABEL_RETRY
            RETURN .T.
        CASE aOptions[ nChoice ] == wxhLABEL_DEFAULT
            RETURN .F.
        ENDCASE
    ENDIF

    OutErr( cMessage )

    IF ValType( oError:cargo ) = "H" .AND. HB_HHasKey( oError:cargo, "ProcLine" )
        n := oError:cargo[ "ProcLine" ]
    ELSE
        n := 1
    ENDIF

    DO WHILE ! Empty( ProcName( ++n ) )

        OutErr( hb_OSNewLine() )
        OutErr( "Called from " + ProcName( n ) + ;
                            "(" + hb_NToS( ProcLine( n ) ) + ")	 " )

    ENDDO

    IF ! wxGetApp() == NIL
        //wxGetApp():GetTopWindow():Close( .T. )
        wxGetApp():ExitMainLoop()
        wxExit() /* TODO: Fix gpf at exit */

        ErrorLevel( 1 )
        wxKill( wxGetProcessId() )
    ENDIF

    QUIT

RETURN .F.

STATIC FUNCTION ErrorMessage( oError )

     // start error message
     LOCAL cMessage := iif( oError:severity > ES_WARNING, "Error", "Warning" ) + " "

     // add subsystem name if available
     IF ISCHARACTER( oError:subsystem )
            cMessage += oError:subsystem()
     ELSE
            cMessage += "???"
     ENDIF

     // add subsystem's error code if available
     IF ISNUMBER( oError:subCode )
            cMessage += "/" + hb_NToS( oError:subCode )
     ELSE
            cMessage += "/???"
     ENDIF

     // add error description if available
     IF ISCHARACTER( oError:description )
            cMessage += "	 " + oError:description
     ENDIF

     // add either filename or operation
     DO CASE
     CASE !Empty( oError:filename )
            cMessage += ": " + oError:filename
     CASE !Empty( oError:operation )
            cMessage += ": " + oError:operation
     ENDCASE

     RETURN cMessage

#include "dialog.ch"

/*
    wxhShowError
    Teo. Mexico 2008
*/
FUNCTION wxhShowError( cMessage, aOptions, oErr )
    LOCAL retVal := 0
    LOCAL dlg
    LOCAL itm
    LOCAL i,id
    LOCAL aErrLst := {}
    LOCAL brwErrObj,brwCallStack
    LOCAL aStack := {}
    LOCAL s

    IF wxGetApp() == NIL
        IF oErr != NIL
            IF Empty( cMessage )
                cMessage := oErr:Description
            ELSE
                cMessage += ";" + oErr:Description
            ENDIF
            cMessage += ": " + oErr:Operation
        ENDIF
        RETURN Alert( cMessage, aOptions )
    ENDIF

    /*
        TODO: Check if we have enough resources to do this
    */

    i := 2
    WHILE ! Empty( s := ProcName( ++i ) )
        AAdd( aStack, { s, ProcLine( i ), ProcFile( i ) } )
    ENDDO

    //aErrLst := __objGetValueList( oErr, .T., 0 )

    IF .T.
        IF cMessage = NIL
            s := oErr:Description + E"\n\n" + oErr:Operation
        ELSE
            s := cMessage + E":\n\n" + oErr:Description + ": " + oErr:Operation
        ENDIF
        
        s += E"\n\n"
        
        i := 3
        WHILE !Empty( ProcName( i ) )
            s += "Called from " + ProcName( i )	 + "(" + NTrim( ProcLine( i ) ) + E")\n"
            ++i
        ENDDO
        ? s
        ?
        //? HB_ValToExp( oErr )
        wxMessageBox( s, "Error", HB_BitOr( wxOK, wxICON_ERROR ), 0 )

        RETURN NIL
        //BREAK oErr

    ENDIF

    IF Empty( cMessage )
        cMessage := oErr:Description + ": " + oErr:Operation
    ENDIF

    CREATE DIALOG dlg ;
        WIDTH 640 HEIGHT 400 ;
        TITLE "Error System" ;
        STYLE HB_BitOr( wxDEFAULT_DIALOG_STYLE, wxSTAY_ON_TOP )

    BEGIN BOXSIZER VERTICAL
        BEGIN BOXSIZER HORIZONTAL "" ALIGN EXPAND
            @ GET cMessage MULTILINE NOEDITABLE SIZERINFO ALIGN EXPAND STRETCH
        END SIZER
        BEGIN NOTEBOOK SIZERINFO ALIGN EXPAND STRETCH
            ADD BOOKPAGE "Call Stack" FROM
                @ BROWSE VAR brwCallStack DATASOURCE aStack //SIZERINFO ALIGN EXPAND STRETCH
            ADD BOOKPAGE "Error Object" FROM
                @ BROWSE VAR brwErrObj DATASOURCE aErrLst
        END NOTEBOOK
        BEGIN BOXSIZER HORIZONTAL
            FOR EACH itm IN aOptions
                i := itm:__enumIndex()
                DO CASE
                CASE itm == wxhLABEL_QUIT
                    id := wxID_CANCEL
                    itm := NIL
                CASE itm == wxhLABEL_RETRY
                    id := wxID_REDO
                    itm := NIL
                CASE itm == wxhLABEL_DEFAULT
                    id := wxID_DEFAULT
                    itm := NIL
                CASE itm == wxhLABEL_ACCEPT
                    id := wxID_OK
                    itm := NIL
                OTHERWISE
                    id := wxID_ANY
                ENDCASE
                @ BUTTON itm ID id ACTION {|| retVal := i, dlg:Close() }
//				 @ BUTTON "Fit" ACTION brwCallStack:Fit()
            NEXT
        END SIZER
    END SIZER

    brwCallStack:DeleteAllColumns()
    ADD BCOLUMN TO brwCallStack TITLE "ProcName" BLOCK {|n| aStack[ n, 1 ] }
    ADD BCOLUMN TO brwCallStack TITLE "ProcLine" BLOCK {|n| aStack[ n, 2 ] } PICTURE "99999"
    ADD BCOLUMN TO brwCallStack TITLE "ProcFile" BLOCK {|n| aStack[ n, 3 ] }

    brwErrObj:DeleteAllColumns()
    ADD BCOLUMN TO brwErrObj "MsgName" BLOCK {|n| brwErrObj:DataSource[ n, 1 ] }
    ADD BCOLUMN TO brwErrObj "Value" BLOCK {|n| brwErrObj:DataSource[ n, 2 ] }

    brwCallStack:AutoSizeColumns( .F. )

    SHOW WINDOW dlg MODAL CENTRE

    DESTROY dlg

RETURN retVal
