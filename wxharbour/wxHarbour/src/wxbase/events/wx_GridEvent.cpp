/*
 * $Id: wx_GridEvent.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_GridEvent: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"

#include "wxh.h"

/*
    AltDown
    Teo. Mexico 2009
*/
HB_FUNC( WXGRIDEVENT_ALTDOWN )
{
    wxGridEvent *gridEvent = (wxGridEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridEvent )
        hb_retl( gridEvent->AltDown() );
}

/*
    ControlDown
    Teo. Mexico 2009
*/
HB_FUNC( WXGRIDEVENT_CONTROLDOWN )
{
    wxGridEvent *gridEvent = (wxGridEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridEvent )
        hb_retl( gridEvent->ControlDown() );
}

/*
    GetCol
    Teo. Mexico 2009
*/
HB_FUNC( WXGRIDEVENT_GETCOL )
{
    wxGridEvent *gridEvent = (wxGridEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridEvent )
        hb_retni( gridEvent->GetCol() );
}

/*
    GetPosition
    Teo. Mexico 2009
*/
HB_FUNC( WXGRIDEVENT_GETPOSITION )
{
    wxGridEvent *gridEvent = (wxGridEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridEvent )
        wxh_ret_wxPoint( gridEvent->GetPosition() );
}

/*
    GetRow
    Teo. Mexico 2009
*/
HB_FUNC( WXGRIDEVENT_GETROW )
{
    wxGridEvent *gridEvent = (wxGridEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridEvent )
        hb_retni( gridEvent->GetRow() );
    else
        hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 5, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
}

/*
    MetaDown
    Teo. Mexico 2009
*/
HB_FUNC( WXGRIDEVENT_METADOWN )
{
    wxGridEvent *gridEvent = (wxGridEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridEvent )
        hb_retl( gridEvent->MetaDown() );
}

/*
    Selecting
    Teo. Mexico 2009
*/
HB_FUNC( WXGRIDEVENT_SELECTING )
{
    wxGridEvent *gridEvent = (wxGridEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridEvent )
        hb_retl( gridEvent->Selecting() );
}

/*
    ShiftDown
    Teo. Mexico 2009
*/
HB_FUNC( WXGRIDEVENT_SHIFTDOWN )
{
    wxGridEvent *gridEvent = (wxGridEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridEvent )
        hb_retl( gridEvent->ShiftDown() );
}
