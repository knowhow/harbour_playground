/*
 * $Id: ProcCtrlFuncs.cpp 743 2011-07-27 18:26:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    Process control functions
    Teo. Mexico 2008
*/

#include "wx/wx.h"
#include "wxh.h"

/*
    wxExit
    Teo. Mexico 2008
*/
HB_FUNC( WXEXIT )
{
    wxExit();
}

/*
    wxGetProcessId
    Teo. Mexico 2008
*/
HB_FUNC( WXGETPROCESSID )
{
    hb_retnl( wxGetProcessId() );
}

/*
    wxKill
    Teo. Mexico 2008
*/
HB_FUNC( WXKILL )
{
    long pid = hb_parnl( 1 );
    wxSignal sig = HB_ISNIL( 2 ) ? wxSIGTERM : (wxSignal) hb_parni( 2 );
    wxKillError rc;
    int flags = HB_ISNIL( 4 ) ? 0 : hb_parni( 4 );
    wxKill( pid, sig, &rc, flags );
    if( hb_pcount() > 2 && HB_ISBYREF( 3 ) )
    {
        hb_storni( (int) rc, 3 );
    }
}

/*
    wxShell
    Teo. Mexico 2008
*/
HB_FUNC( WXSHELL )
{
    const wxString &command = wxh_parc( 1 );
    hb_retl( wxShell( command ) );
}
