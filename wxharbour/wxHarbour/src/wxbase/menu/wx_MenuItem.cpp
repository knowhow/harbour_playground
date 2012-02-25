/*
 * $Id: wx_MenuItem.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_MenuItem: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_MenuItem.h"

/*
    ~wx_MenuItem
    Teo. Mexico 2006
*/
wx_MenuItem::~wx_MenuItem()
{
    xho_itemListDel_XHO( this );
}

/*
    New
    Teo. Mexico 2008
*/
HB_FUNC( WXMENUITEM_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxMenu* parentMenu = (wxMenu *) objParams.paramParent( 1 );
    int id = hb_parni( 2 );
    const wxString& text = wxh_parc( 3 );
    const wxString& helpString = wxh_parc( 4 );
    wxItemKind kind = (wxItemKind) hb_parni( 5 );
    wxMenu* subMenu = (wxMenu *) objParams.paramChild( 6 );

    wx_MenuItem* menuItem = new wx_MenuItem( parentMenu, id, text, helpString, kind, subMenu );

    objParams.Return( menuItem );
}

/*
    Enable
    Teo. Mexico 2008
*/
HB_FUNC( WXMENUITEM_ENABLE )
{
    wx_MenuItem* menuItem = (wx_MenuItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( menuItem )
        menuItem->Enable( hb_parl( 1 ) );
}

/*
    wxMenuItem:GetItemLabel
    Teo. Mexico 2008
*/
HB_FUNC( WXMENUITEM_GETITEMLABEL )
{
#if wxVERSION > 20804
    wx_MenuItem* menuItem = (wx_MenuItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( menuItem )
        wxh_retc( menuItem->GetItemLabel() );
#endif
}

/*
    wxMenuItem:GetItemLabelText
    Teo. Mexico 2008
*/
HB_FUNC( WXMENUITEM_GETITEMLABELTEXT )
{
#if wxVERSION > 20804
    wx_MenuItem* menuItem = (wx_MenuItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( menuItem )
        wxh_retc( menuItem->GetItemLabelText() );
#endif
}

/*
    SetBitmap
 Teo. Mexico 2009
 */
HB_FUNC( WXMENUITEM_SETBITMAP )
{
    wx_MenuItem* menuItem = (wx_MenuItem *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( menuItem )
    {
        const wxBitmap& bitmap = * (wxBitmap *) xho_par_XhoObject( 1 );
        menuItem->SetBitmap( bitmap );
    }
}
