/*
 * $Id: wxhSocketBase.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxSocketBase
    Teo. Mexico 2008
*/

#include "hbclass.ch"
#include "property.ch"

/*
    wxSocketBase
    Teo. Mexico 2008
*/
CLASS wxSocketBase FROM wxObject
PRIVATE:
PROTECTED:
PUBLIC:
    CONSTRUCTOR New
    METHOD Close
    METHOD Destroy
    METHOD Discard
    METHOD Error
    METHOD GetClientData
    METHOD GetLocal( addr )
    METHOD GetFlags
    METHOD GetPeer( addr )
    METHOD InterruptWait
    METHOD IsConnected
    METHOD IsData
    METHOD IsDisconnected
    METHOD LastCount
    METHOD LastError
    METHOD Notify( notify )
    METHOD IsOk
    METHOD RestoreState
    METHOD SaveState
    METHOD SetClientData( data )
    METHOD SetEventHandler( handler, id )
    METHOD SetFlags( flags )
    METHOD SetLocal( local )
    METHOD SetNotify( flags )
    METHOD SetTimeout( seconds )
    METHOD Peek( buffer, nbytes )
    METHOD Read( buffer, nbytes )
    METHOD ReadMsg( buffer, nbytes )
    METHOD Unread( buffer, nbytes )
    METHOD Wait( seconds, millisecond )
    METHOD WaitForLost( seconds, millisecond )
    METHOD WaitForRead( seconds, millisecond )
    METHOD WaitForWrite( seconds, millisecond )
    METHOD Write( buffer, nbytes )
    METHOD WriteMsg( buffer, nbytes )
PUBLISHED:
ENDCLASS

/*
    End Class wxSocketBase
*/
