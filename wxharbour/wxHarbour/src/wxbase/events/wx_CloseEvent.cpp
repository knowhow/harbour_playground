/*
 * $Id: wx_CloseEvent.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_CloseEvent: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"

#include "wxh.h"

/*
    CanVeto
    Teo. Mexico 2009
*/
HB_FUNC( WXCLOSEEVENT_CANVETO )
{
    wxCloseEvent * closeEvent = (wxCloseEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( closeEvent )
        hb_retl( closeEvent->CanVeto() );
}

/*
    GetLoggingOff
    Teo. Mexico 2009
*/
HB_FUNC( WXCLOSEEVENT_GETLOGGINGOFF )
{
    wxCloseEvent * closeEvent = (wxCloseEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( closeEvent )
        hb_retl( closeEvent->GetLoggingOff() );
}

/*
    SetCanVeto
    Teo. Mexico 2009
*/
HB_FUNC( WXCLOSEEVENT_SETCANVETO )
{
    wxCloseEvent * closeEvent = (wxCloseEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( closeEvent )
        closeEvent->SetCanVeto( hb_parl( 1 ) );
}

/*
    SetLoggingOff
    Teo. Mexico 2009
*/
HB_FUNC( WXCLOSEEVENT_SETLOGGINGOFF )
{
    wxCloseEvent * closeEvent = (wxCloseEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( closeEvent )
        closeEvent->SetLoggingOff( hb_parl( 1 ) );
}

/*
    Veto
    Teo. Mexico 2009
*/
HB_FUNC( WXCLOSEEVENT_VETO )
{
    wxCloseEvent * closeEvent = (wxCloseEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( closeEvent )
        closeEvent->Veto( hb_parl( 1 ) );
}
