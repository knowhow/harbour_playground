/*
 * $Id: gsocket.ch 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

//----------------------------------------------------------------------------
// gsocket
//----------------------------------------------------------------------------

#ifndef _GSOCKET_CH_
#define _GSOCKET_CH_

#define GSOCK_NOERROR           0
#define GSOCK_INVOP             1
#define GSOCK_IOERR             2
#define GSOCK_INVADDR           3
#define GSOCK_INVSOCK           4
#define GSOCK_NOHOST            5
#define GSOCK_INVPORT           6
#define GSOCK_WOULDBLOCK        7
#define GSOCK_TIMEDOUT          8
#define GSOCK_MEMERR            9
#define GSOCK_OPTERR            10

/* See below for an explanation on how events work.
 */
#define GSOCK_INPUT             0
#define GSOCK_OUTPUT            1
#define GSOCK_CONNECTION        2
#define GSOCK_LOST              3
#define GSOCK_MAX_EVENT         4

#define GSOCK_INPUT_FLAG        HB_BitShift( 1, GSOCK_INPUT )
#define GSOCK_OUTPUT_FLAG       HB_BitShift( 1, GSOCK_OUTPUT )
#define GSOCK_CONNECTION_FLAG   HB_BitShift( 1, GSOCK_CONNECTION )
#define GSOCK_LOST_FLAG         HB_BitShift( 1, GSOCK_LOST )

#endif
