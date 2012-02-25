/*
 * $Id: wx_BitmapButton.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge
 
 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 
 (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
 */

/*
 wx_BitmapButton: Implementation
 Teo. Mexico 2009
 */

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_BitmapButton.h"

/*
 ~wx_BitmapButton
 Teo. Mexico 2009
 */
wx_BitmapButton::~wx_BitmapButton()
{
    xho_itemListDel_XHO( this );
}

/*
    New
    Teo. Mexico 2009
 */
HB_FUNC( WXBITMAPBUTTON_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    
    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxBitmap& bitmap = * (wxBitmap *) xho_par_XhoObject( 3 );
    const wxPoint& pos = wxh_par_wxPoint( 4 );
    const wxSize& size = wxh_par_wxSize( 5 );
    long style = hb_parnl( 6 );
    const wxValidator& validator = ISNIL( 7 ) ? wxDefaultValidator : * ( (wxValidator *) objParams.paramChild( 7 ) );
    const wxString& name = ISNIL( 8 ) ? wxString( _T("bitmapButton") ) : wxh_parc( 8 );
    
    wx_BitmapButton* bitmapButton = new wx_BitmapButton( parent, id, bitmap, pos, size, style, validator, name );
    
    objParams.Return( bitmapButton );
}

/*
 wxBitmapButton:GetBitmapDisabled
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAPBUTTON_GETBITMAPDISABLED )
{
    wxBitmapButton* bitmapButton = (wxBitmapButton *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmapButton )
    {
    const wxBitmap& bitmap = bitmapButton->GetBitmapDisabled();
        xho_itemReturn( (wxObject *) &bitmap );
    }
}

/*
 wxBitmapButton:GetBitmapFocus
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAPBUTTON_GETBITMAPFOCUS )
{
    wxBitmapButton* bitmapButton = (wxBitmapButton *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmapButton )
    {
    const wxBitmap& bitmap = bitmapButton->GetBitmapFocus();
        xho_itemReturn( (wxObject *) &bitmap );
    }
}

/*
 wxBitmapButton:GetBitmapHover
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAPBUTTON_GETBITMAPHOVER )
{
    wxBitmapButton* bitmapButton = (wxBitmapButton *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmapButton )
    {
    const wxBitmap& bitmap = bitmapButton->GetBitmapHover();
        xho_itemReturn( (wxObject *) &bitmap );
    }
}

/*
 wxBitmapButton:GetBitmapLabel
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAPBUTTON_GETBITMAPLABEL )
{
    wxBitmapButton* bitmapButton = (wxBitmapButton *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmapButton )
    {
    const wxBitmap& bitmap = bitmapButton->GetBitmapLabel();
        xho_itemReturn( (wxObject *) &bitmap );
    }
}

/*
 wxBitmapButton:GetBitmapSelected
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAPBUTTON_GETBITMAPSELECTED )
{
    wxBitmapButton* bitmapButton = (wxBitmapButton *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmapButton )
    {
    const wxBitmap& bitmap = bitmapButton->GetBitmapSelected();
        xho_itemReturn( (wxObject *) &bitmap );
    }
}

/*
 wxBitmapButton:SetBitmapDisabled
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAPBUTTON_SETBITMAPDISABLED )
{
    wxBitmapButton* bitmapButton = (wxBitmapButton *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmapButton )
    {
    wxBitmap& bitmap = ( * (wxBitmap *) xho_par_XhoObject( 1 ) );
    bitmapButton->SetBitmapDisabled( bitmap );
    }
}

/*
 wxBitmapButton:SetBitmapFocus
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAPBUTTON_SETBITMAPFOCUS )
{
    wxBitmapButton* bitmapButton = (wxBitmapButton *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmapButton )
    {
    wxBitmap& bitmap = ( * (wxBitmap *) xho_par_XhoObject( 1 ) );
    bitmapButton->SetBitmapFocus( bitmap );
    }
}

/*
 wxBitmapButton:SetBitmapHover
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAPBUTTON_SETBITMAPHOVER )
{
    wxBitmapButton* bitmapButton = (wxBitmapButton *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmapButton )
    {
    wxBitmap& bitmap = ( * (wxBitmap *) xho_par_XhoObject( 1 ) );
    bitmapButton->SetBitmapHover( bitmap );
    }
}

/*
 wxBitmapButton:SetBitmapLabel
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAPBUTTON_SETBITMAPLABEL )
{
    wxBitmapButton* bitmapButton = (wxBitmapButton *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmapButton )
    {
    wxBitmap& bitmap = ( * (wxBitmap *) xho_par_XhoObject( 1 ) );
    bitmapButton->SetBitmapLabel( bitmap );
    }
}

/*
 wxBitmapButton:SetBitmapSelected
 Teo. Mexico 2009
 */
HB_FUNC( WXBITMAPBUTTON_SETBITMAPSELECTED )
{
    wxBitmapButton* bitmapButton = (wxBitmapButton *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( bitmapButton )
    {
    wxBitmap& bitmap = ( * (wxBitmap *) xho_par_XhoObject( 1 ) );
    bitmapButton->SetBitmapSelected( bitmap );
    }
}
