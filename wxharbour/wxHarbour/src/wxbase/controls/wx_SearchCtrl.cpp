/*
 * $Id: wx_SearchCtrl.cpp 743 2011-07-27 18:26:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_SearchCtrl: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_SearchCtrl.h"

/*
    ~wx_SearchCtrl
    Teo. Mexico 2009
*/
wx_SearchCtrl::~wx_SearchCtrl()
{
    xho_itemListDel_XHO( this );
}

/*
    wxSearchCtrl:New
    Teo. Mexico 2009
*/
HB_FUNC( WXSEARCHCTRL_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = HB_ISNIL(2) ? wxID_ANY : hb_parni( 2 );
    const wxString& value = wxh_parc( 3 );
    const wxPoint& pos = wxh_par_wxPoint( 4 );
    const wxSize& size = wxh_par_wxSize( 5 );
    long style = hb_parnl( 6 );
    const wxValidator& validator = HB_ISNIL( 7 ) ? wxDefaultValidator : * ( (wxValidator *) objParams.paramChild( 7 ) );
    const wxString& name = wxh_parc( 8 );
    wx_SearchCtrl* searchCtrl = new wx_SearchCtrl( parent, id, value, pos, size, style, validator, name );

    objParams.Return( searchCtrl );
}

/*
    GetMenu
    Teo. Mexico 2009
*/
HB_FUNC( WXSEARCHCTRL_GETMENU )
{
    wxSearchCtrl* searchCtrl = (wxSearchCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( searchCtrl )
    {
        xho_itemReturn( searchCtrl->GetMenu() );
    }
}

/*
    IsCancelButtonVisible
    Teo. Mexico 2009
*/
HB_FUNC( WXSEARCHCTRL_ISCANCELBUTTONVISIBLE )
{
    wxSearchCtrl* searchCtrl = (wxSearchCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( searchCtrl )
    {
        hb_retl( searchCtrl->IsCancelButtonVisible() );
    }
}

/*
    IsSearchButtonVisible
    Teo. Mexico 2009
*/
HB_FUNC( WXSEARCHCTRL_ISSEARCHBUTTONVISIBLE )
{
    wxSearchCtrl* searchCtrl = (wxSearchCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( searchCtrl )
    {
        hb_retl( searchCtrl->IsSearchButtonVisible() );
    }
}

/*
    SetMenu
    Teo. Mexico 2009
*/
HB_FUNC( WXSEARCHCTRL_SETMENU )
{
    wxSearchCtrl* searchCtrl = (wxSearchCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( searchCtrl )
    {
        wxMenu* menu = (wxMenu *) xho_par_XhoObject( 1 );
        searchCtrl->SetMenu( menu );
    }
}

/*
    ShowCancelButton
    Teo. Mexico 2009
*/
HB_FUNC( WXSEARCHCTRL_SHOWCANCELBUTTON )
{
    wxSearchCtrl* searchCtrl = (wxSearchCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( searchCtrl )
    {
        searchCtrl->ShowCancelButton( hb_parl( 1 ) );
    }
}

/*
    ShowSearchButton
    Teo. Mexico 2009
*/
HB_FUNC( WXSEARCHCTRL_SHOWSEARCHBUTTON )
{
    wxSearchCtrl* searchCtrl = (wxSearchCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( searchCtrl )
    {
        searchCtrl->ShowSearchButton( hb_parl( 1 ) );
    }
}
