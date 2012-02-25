/*
 * $Id: wx_ListCtrl.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_ListCtrl
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_ListCtrl.h"

/*
    ~wx_ListCtrl
    Teo. Mexico 2009
*/
wx_ListCtrl::~wx_ListCtrl()
{
    xho_itemListDel_XHO( this );
}

/*
    New
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTCTRL_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxPoint& pos = wxh_par_wxPoint( 3 );
    const wxSize& size = wxh_par_wxSize( 4 );
    long style = ISNIL( 5 ) ? wxLC_ICON : hb_parnl( 5 );
    const wxValidator& validator = ISNIL( 6 ) ? wxDefaultValidator : (*((wxValidator *) objParams.param( 6 ))) ;
    const wxString& name = wxh_parc( 7 );
    wx_ListCtrl* listCtrl = new wx_ListCtrl( parent, id, pos, size, style, validator, name );

    objParams.Return( listCtrl );
}

/*
    Arrange
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTCTRL_ARRANGE )
{
    wxListCtrl* listCtrl = (wxListCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listCtrl )
    {
        hb_retl( listCtrl->Arrange( hb_parni( 1 ) ) );
    }
}

/*
    AssignImageList
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTCTRL_ASSIGNIMAGELIST )
{
    wxListCtrl* listCtrl = (wxListCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listCtrl )
    {
        wxImageList* imageList = (wxImageList *) xho_par_XhoObject( 1 );
        listCtrl->AssignImageList( imageList, hb_parni( 1 ) );
    }
}

/*
    ClearAll
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTCTRL_CLEARALL )
{
    wxListCtrl* listCtrl = (wxListCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listCtrl )
    {
        listCtrl->ClearAll();
    }
}

/*
    DeleteAllItems
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTCTRL_DELETEALLITEMS )
{
    wxListCtrl* listCtrl = (wxListCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listCtrl )
    {
        hb_retl( listCtrl->DeleteAllItems() );
    }
}

/*
    DeleteColumn
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTCTRL_DELETECOLUMN )
{
    wxListCtrl* listCtrl = (wxListCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listCtrl )
    {
        hb_retl( listCtrl->DeleteColumn( hb_parni( 1 ) ) );
    }
}

/*
    DeleteItem
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTCTRL_DELETEITEM )
{
    wxListCtrl* listCtrl = (wxListCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listCtrl )
    {
        hb_retl( listCtrl->DeleteItem( hb_parnl( 1 ) ) );
    }
}

/*
    EditLabel
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTCTRL_EDITLABEL )
{
    wxListCtrl* listCtrl = (wxListCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listCtrl )
    {
        listCtrl->EditLabel( hb_parnl( 1 ) );
    }
}

/*
    EnsureVisible
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTCTRL_ENSUREVISIBLE )
{
    wxListCtrl* listCtrl = (wxListCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listCtrl )
    {
        hb_retl( listCtrl->EnsureVisible( hb_parnl( 1 ) ) );
    }
}

/*
    FindItem
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTCTRL_FINDITEM )
{
    wxListCtrl* listCtrl = (wxListCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( listCtrl )
    {
        hb_retnl( listCtrl->FindItem( hb_parnl( 1 ), wxh_parc( 2 ), hb_parl( 3 ) ) );
    }
}
