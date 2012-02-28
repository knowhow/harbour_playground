/*
 * $Id: wx_StaticText.cpp 743 2011-07-27 18:26:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_StaticText: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_StaticText.h"

/*
    ~wx_StaticText
    Teo. Mexico 2009
*/
wx_StaticText::~wx_StaticText()
{
    xho_itemListDel_XHO( this );
}

/*
    wxStaticText:New
    Teo. Mexico 2009
*/
HB_FUNC( WXSTATICTEXT_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = HB_ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxString& label = wxh_parc( 3 );
    const wxPoint& pos = HB_ISNIL( 4 ) ? wxDefaultPosition : wxh_par_wxPoint( 4 );
    const wxSize& size = HB_ISNIL( 5 ) ? wxDefaultSize : wxh_par_wxSize( 5 );
    long style = HB_ISNIL( 6 ) ? 0 : hb_parnl( 6 );
    const wxString& name = wxh_parc( 7 );
    wx_StaticText* staticText = new wx_StaticText( parent, id, label, pos, size, style, name );

    objParams.Return( staticText );
}

/*
    wxStaticText:GetLabel
    Teo. Mexico 2009
*/
HB_FUNC( WXSTATICTEXT_GETLABEL )
{
    wxStaticText* staticText = (wxStaticText *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( staticText )
        wxh_retc( staticText->GetLabel() );
}

/*
    wxStaticText:SetLabel
    Teo. Mexico 2009
*/
HB_FUNC( WXSTATICTEXT_SETLABEL )
{
    wxStaticText* staticText = (wxStaticText *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( staticText )
        staticText->SetLabel( wxh_parc( 1 ) );
}

/*
    wxStaticText:Wrap
    Teo. Mexico 2009
*/
HB_FUNC( WXSTATICTEXT_WRAP )
{
    wxStaticText* staticText = (wxStaticText *) xho_itemListGet_XHO( hb_stackSelfItem() );

    staticText->Wrap( hb_parni( 1 ) );
}
