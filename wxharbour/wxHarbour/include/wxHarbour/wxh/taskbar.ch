/*
 * $Id: taskbar.ch 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

//----------------------------------------------------------------------------
// taskbar
//----------------------------------------------------------------------------

#ifndef _TASKBARICON_CH_
#define _TASKBARICON_CH_

// ----------------------------------------------------------------------------
// wxTaskBarIcon events
// ----------------------------------------------------------------------------

#undef  WXDLLIMPEXP_ADV

#define WXDLLIMPEXP_ADV         __WXH_WXDLLIMPEXP_ADV()

#xcommand DECLARE_EXPORTED_EVENT_TYPE( <evtBase>, <evt>, <value> ) ;
                    => ;
                    #define <evt>         <evtBase> + <value>

        DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV,wxEVT_TASKBAR_MOVE,1550)
        DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV,wxEVT_TASKBAR_LEFT_DOWN,1551)
        DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV,wxEVT_TASKBAR_LEFT_UP,1552)
        DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV,wxEVT_TASKBAR_RIGHT_DOWN,1553)
        DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV,wxEVT_TASKBAR_RIGHT_UP,1554)
        DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV,wxEVT_TASKBAR_LEFT_DCLICK,1555)
        DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV,wxEVT_TASKBAR_RIGHT_DCLICK,1556)


#endif
