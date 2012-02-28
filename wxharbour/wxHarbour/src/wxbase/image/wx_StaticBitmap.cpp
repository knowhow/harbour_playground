/*
 * $Id: wx_StaticBitmap.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

 (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
 */

/*
 wx_StaticBitmap: Implementation
 Teo. Mexico 2009
 */

#include "wx/wx.h"

#include "wxh.h"

#include "wxbase/wx_StaticBitmap.h"

/*
 ~wx_StaticBitmap
 Teo. Mexico 2009
 */
wx_StaticBitmap::~wx_StaticBitmap()
{
    xho_itemListDel_XHO( this );
}

/*
 New
 Teo. Mexico 2009
 */
HB_FUNC( WXSTATICBITMAP_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_StaticBitmap* staticBitmap;

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = HB_ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxBitmap& label = * (wxBitmap *) xho_par_XhoObject( 3 );
    wxPoint pos = wxh_par_wxPoint( 4 );
    wxSize size = wxh_par_wxSize( 5 );
    long style = hb_parnl( 6 );
    wxString name = wxh_parc( 7 );

    staticBitmap = new wx_StaticBitmap( parent, id, label, pos, size, style, name );

    objParams.Return( staticBitmap );
}

/*
 wxStaticBitmap:GetBitmap
 Teo. Mexico 2009
 */
HB_FUNC( WXSTATICBITMAP_GETBITMAP )
{
    wxStaticBitmap* staticBitmap = (wxStaticBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( staticBitmap )
    {
    wxBitmap bitmap = staticBitmap->GetBitmap();
    xho_itemReturn( &bitmap );
    }
}

/*
 wxStaticBitmap:GetIcon
 Teo. Mexico 2009
 */
HB_FUNC( WXSTATICBITMAP_GETICON )
{
    wxStaticBitmap* staticBitmap = (wxStaticBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( staticBitmap )
    {
    wxIcon icon = staticBitmap->GetIcon();
    xho_itemReturn( &icon );
    }
}

/*
 wxStaticBitmap:SetBitmap
 Teo. Mexico 2009
 */
HB_FUNC( WXSTATICBITMAP_SETBITMAP )
{
    wxStaticBitmap* staticBitmap = (wxStaticBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( staticBitmap )
    {
    const wxBitmap& bitmap = * (wxBitmap *) xho_par_XhoObject( 1 );
    staticBitmap->SetBitmap( bitmap );
    }
}

/*
 wxStaticBitmap:SetIcon
 Teo. Mexico 2009
 */
HB_FUNC( WXSTATICBITMAP_SETICON )
{
    wxStaticBitmap* staticBitmap = (wxStaticBitmap *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( staticBitmap )
    {
    const wxIcon& icon = * (wxIcon *) xho_par_XhoObject( 1 );
    staticBitmap->SetIcon( icon );
    }
}
