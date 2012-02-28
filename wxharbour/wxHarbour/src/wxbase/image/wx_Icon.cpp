/*
 * $Id: wx_Icon.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Icon: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"

#include "wxh.h"

#include "wxbase/wx_Icon.h"

/*
    ~wx_Icon
    Teo. Mexico 2009
*/
wx_Icon::~wx_Icon()
{
    xho_itemListDel_XHO( this );
}

/*
    New
    Teo. Mexico 2009
*/
HB_FUNC( WXICON_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_Icon* icon;

    /* TODO: Check & solve why this fails on mingw-windows */
    switch( hb_pcount() )
    {
    case 0 :
        {
            icon = new wx_Icon();
        }
        break;
    case 1 :
        {
            const char* bits = hb_parc( 1 );
            icon = new wx_Icon( &bits );
        }
        break;
    case 2:
        {
            const wxString& name = wxh_parc( 1 );
            wxBitmapType type = wxBitmapType( hb_parni( 2 ) );
            int desiredWidth = hb_parni( 3 );
            int desiredHeight = hb_parni( 4 );

            icon = new wx_Icon( name, type, desiredWidth, desiredHeight );
        }
        break;
    default :
        icon = new wx_Icon();
        break;
    }

    objParams.Return( icon );
}

/*
 wxIcon:CopyFromBitmap
 Teo. Mexico 2009
 */
HB_FUNC( WXICON_COPYFROMBITMAP )
{
    wxIcon* icon = (wxIcon *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( icon )
    {
    const wxBitmap& bitmap = *(wxBitmap *) xho_par_XhoObject( 1 );
        icon->CopyFromBitmap( bitmap );
    }
}

/*
 wxIcon:GetDepth
 Teo. Mexico 2009
 */
HB_FUNC( WXICON_GETDEPTH )
{
    wxIcon* icon = (wxIcon *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( icon )
    {
        hb_retni( icon->GetDepth() );
    }
}

/*
 wxIcon:GetHeight
 Teo. Mexico 2009
 */
HB_FUNC( WXICON_GETHEIGHT )
{
    wxIcon* icon = (wxIcon *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( icon )
    {
        hb_retni( icon->GetHeight() );
    }
}

/*
 wxIcon:GetWidth
 Teo. Mexico 2009
 */
HB_FUNC( WXICON_GETWIDTH )
{
    wxIcon* icon = (wxIcon *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( icon )
    {
        hb_retni( icon->GetWidth() );
    }
}

/*
 wxIcon:IsOk
 Teo. Mexico 2009
 */
HB_FUNC( WXICON_ISOK )
{
    wxIcon* icon = (wxIcon *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( icon )
    {
        hb_retl( icon->IsOk() );
    }
}

/*
    wxIcon:LoadFile
    Teo. Mexico 2009
*/
HB_FUNC( WXICON_LOADFILE )
{
    wxIcon* icon = (wxIcon *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( icon )
    {
        if( HB_ISNIL( 2 ) )
            hb_retl( icon->LoadFile( wxh_parc( 1 ) ) );
        else
            hb_retl( icon->LoadFile( wxh_parc( 1 ), wxBitmapType( hb_parni( 2 ) ) ) );
    }
}

/*
 wxIcon:SetDepth
 Teo. Mexico 2009
 */
HB_FUNC( WXICON_SETDEPTH )
{
    wxIcon* icon = (wxIcon *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( icon )
    {
        icon->SetDepth( hb_parni( 1 ) );
    }
}

/*
 wxIcon:SetHeight
 Teo. Mexico 2009
 */
HB_FUNC( WXICON_SETHEIGHT )
{
    wxIcon* icon = (wxIcon *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( icon )
    {
        icon->SetHeight( hb_parni( 1 ) );
    }
}

/*
 wxIcon:SetWidth
 Teo. Mexico 2009
 */
HB_FUNC( WXICON_SETWIDTH )
{
    wxIcon* icon = (wxIcon *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( icon )
    {
        icon->SetWidth( hb_parni( 1 ) );
    }
}
