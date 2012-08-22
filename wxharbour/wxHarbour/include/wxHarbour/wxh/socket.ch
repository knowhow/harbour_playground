/*
 * $Id: socket.ch 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

//----------------------------------------------------------------------------
// socket
//----------------------------------------------------------------------------

#ifndef _SOCKET_CH_
#define _SOCKET_CH_

#include "wxh/gsocket.ch"

// ------------------------------------------------------------------------
// Types and constants
// ------------------------------------------------------------------------

#define wxSOCKET_INPUT                  GSOCK_INPUT
#define wxSOCKET_OUTPUT                 GSOCK_OUTPUT
#define wxSOCKET_CONNECTION             GSOCK_CONNECTION
#define wxSOCKET_LOST                   GSOCK_LOST

#define wxSOCKET_INPUT_FLAG             GSOCK_INPUT_FLAG
#define wxSOCKET_OUTPUT_FLAG            GSOCK_OUTPUT_FLAG
#define wxSOCKET_CONNECTION_FLAG        GSOCK_CONNECTION_FLAG
#define wxSOCKET_LOST_FLAG              GSOCK_LOST_FLAG

    // from GSocket
#define wxSOCKET_NOERROR        GSOCK_NOERROR
#define wxSOCKET_INVOP          GSOCK_INVOP
#define wxSOCKET_IOERR          GSOCK_IOERR
#define wxSOCKET_INVADDR        GSOCK_INVADDR
#define wxSOCKET_INVSOCK        GSOCK_INVSOCK
#define wxSOCKET_NOHOST         GSOCK_NOHOST
#define wxSOCKET_INVPORT        GSOCK_INVPORT
#define wxSOCKET_WOULDBLOCK     GSOCK_WOULDBLOCK
#define wxSOCKET_TIMEDOUT       GSOCK_TIMEDOUT
#define wxSOCKET_MEMERR         GSOCK_MEMERR

    // wxSocket-specific (not yet implemented)
#define wxSOCKET_DUMMY

#define wxSOCKET_NONE           0
#define wxSOCKET_NOWAIT         1
#define wxSOCKET_WAITALL        2
#define wxSOCKET_BLOCK          4
#define wxSOCKET_REUSEADDR      8

#define wxSOCKET_UNINIT         0
#define wxSOCKET_CLIENT         1
#define wxSOCKET_SERVER         2
#define wxSOCKET_BASE           3
#define wxSOCKET_DATAGRAM       4

#endif
