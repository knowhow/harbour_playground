/*
 * $Id: wx_Button.cpp 743 2011-07-27 18:26:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Button: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_Button.h"

/*
    ~wx_Button
    Teo. Mexico 2006
*/
wx_Button::~wx_Button()
{
    xho_itemListDel_XHO( this );
}

HB_FUNC( WXBUTTON_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = HB_ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxString& label = wxh_parc( 3 );
    const wxPoint& pos = wxh_par_wxPoint( 4 );
    const wxSize& size = wxh_par_wxSize( 5 );
    long style = hb_parnl( 6 );
    const wxValidator& validator = HB_ISNIL( 7 ) ? wxDefaultValidator : * ( (wxValidator *) objParams.paramChild( 7 ) );
    const wxString& name = wxh_parc( 8 );

    wx_Button* button = new wx_Button( parent, id, label, pos, size, style, validator, name );

    objParams.Return( button );
}

/*
    wxButton:GetLabel
    Teo. Mexico 2009
*/
HB_FUNC( WXBUTTON_GETLABEL )
{
    wxButton* button = (wxButton *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( button )
        wxh_retc( button->GetLabel() );
}

/*
    wxButton:SetDefault
    Teo. Mexico 2009
*/
HB_FUNC( WXBUTTON_SETDEFAULT )
{
    wxButton* button = (wxButton *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( button )
        button->SetDefault();
}

/*
    wxButton:SetLabel
    Teo. Mexico 2009
*/
HB_FUNC( WXBUTTON_SETLABEL )
{
    wxButton* button = (wxButton *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( button )
        button->SetLabel( wxh_parc( 1 ) );
}
