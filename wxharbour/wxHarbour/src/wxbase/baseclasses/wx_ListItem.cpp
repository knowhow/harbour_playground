/*
 * $Id: wx_ListItem.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_ListItem
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_ListItem.h"

/*
    ~wx_ListItem
    Teo. Mexico 2009
*/
wx_ListItem::~wx_ListItem()
{
    xho_itemListDel_XHO( this );
}

/*
    New
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_ListItem* listItem = new wx_ListItem();

    objParams.Return( listItem );
}

/*
    Clear
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_CLEAR )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        listItem->Clear();
    }
}

/*
    GetColumn
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_GETCOLUMN )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        hb_retni( listItem->GetColumn() );
    }
}

/*
    GetId
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_GETID )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        hb_retnl( listItem->GetId() );
    }
}

/*
    GetImage
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_GETIMAGE )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        hb_retni( listItem->GetImage() );
    }
}

/*
    GetMask
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_GETMASK )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        hb_retnl( listItem->GetMask() );
    }
}

/*
    GetState
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_GETSTATE )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        hb_retnl( listItem->GetState() );
    }
}

/*
    GetText
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_GETTEXT )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        wxh_retc( listItem->GetText() );
    }
}

/*
    GetWidth
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_GETWIDTH )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        hb_retni( listItem->GetWidth() );
    }
}

/*
    SetColumn
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_SETCOLUMN )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        listItem->SetColumn( hb_parni( 1 ) );
    }
}

/*
    SetId
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_SETID )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        listItem->SetId( hb_parnl( 1 ) );
    }
}

/*
    SetImage
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_SETIMAGE )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        listItem->SetImage( hb_parnl( 1 ) );
    }
}

/*
    SetMask
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_SETMASK )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        listItem->SetMask( hb_parnl( 1 ) );
    }
}

/*
    SetState
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_SETSTATE )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        listItem->SetState( hb_parnl( 1 ) );
    }
}

/*
    SetStateMask
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_SETSTATEMASK )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        listItem->SetStateMask( hb_parnl( 1 ) );
    }
}

/*
    SetText
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_SETTEXT )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        listItem->SetText( wxh_parc( 1 ) );
    }
}

/*
    SetWidth
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTITEM_SETWIDTH )
{
    wxListItem* listItem = (wxListItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listItem )
    {
        listItem->SetWidth( hb_parni( 1 ) );
    }
}
