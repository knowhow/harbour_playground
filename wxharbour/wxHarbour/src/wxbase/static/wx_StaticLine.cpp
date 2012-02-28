/*
 * $Id: wx_StaticLine.cpp 743 2011-07-27 18:26:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_StaticLine: Implementation
    Teo. Mexico 2008
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_StaticLine.h"

/*
    ~wx_StaticLine
    Teo. Mexico 2008
*/
wx_StaticLine::~wx_StaticLine()
{
    xho_itemListDel_XHO( this );
}

/*
    wxStaticLine:New
    Teo. Mexico 2008
*/
HB_FUNC( WXSTATICLINE_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = HB_ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxPoint& pos = HB_ISNIL( 3 ) ? wxDefaultPosition : wxh_par_wxPoint( 3 );
    const wxSize& size = HB_ISNIL( 4 ) ? wxDefaultSize : wxh_par_wxSize( 4 );
    long style = HB_ISNIL( 5 ) ? 0 : hb_parnl( 5 );
    const wxString& name = wxh_parc( 6 );
    wx_StaticLine* staticLine = new wx_StaticLine( parent, id, pos, size, style, name );

    objParams.Return( staticLine );
}

/*
    wxStaticLine:IsVertical
    Teo. Mexico 2008
*/
HB_FUNC( WXSTATICLINE_ISVERTICAL )
{
    wxStaticLine* staticLine = (wxStaticLine *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( staticLine )
    {
        hb_retl( staticLine->IsVertical() );
    }
}

/*
    wxStaticLine:GetDefaultSize
    Teo. Mexico 2008
*/
HB_FUNC( WXSTATICLINE_GETDEFAULTSIZE )
{
    wxStaticLine* staticLine = (wxStaticLine *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( staticLine )
    {
        hb_retni( staticLine->GetDefaultSize() );
    }
}
