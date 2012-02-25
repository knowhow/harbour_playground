/*
 * $Id: wx_Panel.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Panel: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_Panel.h"

/*
    ~wx_Panel
    Teo. Mexico 2009
*/
wx_Panel::~wx_Panel()
{
    xho_itemListDel_XHO( this );
}

/*
    New
    Teo. Mexico 2009
*/
HB_FUNC( WXPANEL_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_Panel* panel;

    if( hb_pcount() )
    {
        wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
        wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
        const wxPoint& pos = ISNIL( 3 ) ? wxDefaultPosition : wxh_par_wxPoint( 3 );
        const wxSize& size = ISNIL( 4 ) ? wxDefaultSize : wxh_par_wxSize( 4 );
        long style = ISNIL( 5 ) ? wxTAB_TRAVERSAL : hb_parnl( 5 );
        const wxString& name = ISNIL( 6 ) ? wxString( _T("panel") ) : wxh_parc( 6 );
        panel = new wx_Panel( parent, id, pos, size, style, name );
    }
    else
        panel = new wx_Panel();

    objParams.Return( panel );
}
