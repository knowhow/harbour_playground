/*
 * $Id: wx_SpinCtrl.cpp 743 2011-07-27 18:26:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_SpinCtrl: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_SpinCtrl.h"

/*
    ~wx_SpinCtrl
    Teo. Mexico 2009
*/
wx_SpinCtrl::~wx_SpinCtrl()
{
    xho_itemListDel_XHO( this );
}

/*
    wxSpinCtrl:New
    Teo. Mexico 2009
*/
HB_FUNC( WXSPINCTRL_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = HB_ISNIL(2) ? wxID_ANY : hb_parni( 2 );
    const wxString& value = wxh_parc( 3 );
    const wxPoint& pos = wxh_par_wxPoint( 4 );
    const wxSize& size = wxh_par_wxSize( 5 );
    long style = HB_ISNIL( 6 ) ? wxSP_ARROW_KEYS : hb_parnl( 6 );
    int min = hb_parni( 7 );
    int max = HB_ISNIL( 8 ) ? 100 : hb_parni( 8 );
    int initial = hb_parni( 9 );
    const wxString& name = wxh_parc( 10 );
    wx_SpinCtrl* spinCtrl = new wx_SpinCtrl( parent, id, value, pos, size, style, min, max, initial, name );

    objParams.Return( spinCtrl );
}

/*
    wxSpinCtrl:GetMin
    Teo. Mexico 2009
*/
HB_FUNC( WXSPINCTRL_GETMIN )
{
    wxSpinCtrl* spinCtrl = (wxSpinCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( spinCtrl )
        hb_retni( spinCtrl->GetMin() );
}

/*
    wxSpinCtrl:GetMax
    Teo. Mexico 2009
*/
HB_FUNC( WXSPINCTRL_GETMAX )
{
    wxSpinCtrl* spinCtrl = (wxSpinCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( spinCtrl )
        hb_retni( spinCtrl->GetMax() );
}

/*
    wxSpinCtrl:GetValue
    Teo. Mexico 2009
*/
HB_FUNC( WXSPINCTRL_GETVALUE )
{
    wxSpinCtrl* spinCtrl = (wxSpinCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( spinCtrl )
        hb_retni( spinCtrl->GetValue() );
}

/*
    wxSpinCtrl:SetRange
    Teo. Mexico 2009
*/
HB_FUNC( WXSPINCTRL_SETRANGE )
{
    wxSpinCtrl* spinCtrl = (wxSpinCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( spinCtrl )
        spinCtrl->SetRange( hb_parni( 1 ), hb_parni( 2 ) );
}

/*
    wxSpinCtrl:SetSelection
    Teo. Mexico 2009
*/
HB_FUNC( WXSPINCTRL_SETSELECTION )
{
    wxSpinCtrl* spinCtrl = (wxSpinCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( spinCtrl )
        spinCtrl->SetSelection( hb_parni( 1 ), hb_parni( 2 ) );
}

/*
    wxSpinCtrl:SetValue
    Teo. Mexico 2009
*/
HB_FUNC( WXSPINCTRL_SETVALUE )
{
    wxSpinCtrl* spinCtrl = (wxSpinCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( spinCtrl )
    {
        if( HB_ISCHAR( 1 ) )
        {
            spinCtrl->SetValue( wxh_parc( 1 ) );
        }
        else
        {
            spinCtrl->SetValue( hb_parni( 1 ) );
        }
    }
}
