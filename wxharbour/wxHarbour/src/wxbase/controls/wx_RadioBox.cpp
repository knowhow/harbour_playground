/*
 * $Id: wx_RadioBox.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_RadioBox: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_RadioBox.h"

/*
    ~wx_RadioBox
    Teo. Mexico 2009
*/
wx_RadioBox::~wx_RadioBox()
{
    xho_itemListDel_XHO( this );
}

HB_FUNC( WXRADIOBOX_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxString& label = wxh_parc( 3 );
    const wxPoint& pos = wxh_par_wxPoint( 4 );
    const wxSize& size = wxh_par_wxSize( 5 );
    const wxArrayString& choices = wxh_par_wxArrayString( 6 );
    int majorDimension = hb_parni( 7 );
    long style = hb_parnl( 8 );
    const wxValidator& validator = ISNIL( 9 ) ? wxDefaultValidator : * ( (wxValidator *) objParams.paramChild( 9 ) );
    const wxString& name = wxh_parc( 10 );

    wx_RadioBox* radioBox = new wx_RadioBox( parent, id, label, pos, size, choices, majorDimension, style, validator, name );

    objParams.Return( radioBox );
}

/*
    GetSelection
    Teo. Mexico 2008
*/
HB_FUNC( WXRADIOBOX_GETSELECTION )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_RadioBox* radioBox = (wx_RadioBox *) xho_itemListGet_XHO( pSelf );

    if( radioBox )
    {
        hb_retni( radioBox->GetSelection() + 1 ); /* zero to one based arrays C++ -> HB */
    }
}

/*
    SetSelection
    Teo. Mexico 2008
*/
HB_FUNC( WXRADIOBOX_SETSELECTION )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_RadioBox* radioBox = (wx_RadioBox *) xho_itemListGet_XHO( pSelf );

    if( radioBox )
    {
        radioBox->SetSelection( hb_parni( 1 ) - 1 ); /* zero to one based arrays C++ -> HB */
    }
}
