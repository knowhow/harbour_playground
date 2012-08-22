/*
 * $Id: wx_Listbook.cpp 743 2011-07-27 18:26:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Listbook: Implementation
    Teo. Mexico 2008
*/

#include "wx/wx.h"
#include "wxh.h"
#include "wx/listbook.h"

#include "wxbase/wx_Listbook.h"

/*
    ~wx_Listbook
    Teo. Mexico 2008
*/
wx_Listbook::~wx_Listbook()
{
    xho_itemListDel_XHO( this );
}

/*
    wxListbook:New
    Teo. Mexico 2009
*/
HB_FUNC( WXLISTBOOK_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_Listbook* listBook;

    if( hb_pcount() )
    {
        wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
        wxWindowID id = HB_ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
        const wxPoint& pos = HB_ISNIL( 3 ) ? wxDefaultPosition : wxh_par_wxPoint( 3 );
        const wxSize& size = HB_ISNIL( 4 ) ? wxDefaultSize : wxh_par_wxSize( 4 );
        long style = HB_ISNIL( 5 ) ? 0 : hb_parnl( 5 );
        const wxString& name = HB_ISNIL( 6 ) ? wxString( _T("Listbook") ) : wxh_parc( 6 );
        listBook = new wx_Listbook( parent, id, pos, size, style, name );
    }
    else
        listBook = new wx_Listbook();

    objParams.Return( listBook );
}

/*
    wxListbook:AddPage
    Teo. Mexico 2007
*/
HB_FUNC( WXLISTBOOK_ADDPAGE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wxListbook* Listbook = (wxListbook *) objParams.Get_xhoObject();

    wxNotebookPage* page = (wxNotebookPage *) objParams.paramParent( 1 );

    if( Listbook && page )
    {
        bool select = HB_ISNIL( 3 ) ? false : hb_parl( 3 );
        int imageld = HB_ISNIL( 4 ) ? -1 : hb_parni( 4 );
        Listbook->AddPage( page, wxh_parc( 2 ), select, imageld );
    }
}
