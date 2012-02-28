/*
 * $Id: wx_Gauge.cpp 743 2011-07-27 18:26:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Gauge: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_Gauge.h"

/*
    ~wx_Gauge
    Teo. Mexico 2009
*/
wx_Gauge::~wx_Gauge()
{
    xho_itemListDel_XHO( this );
}

/*
    wxGauge:New
    Teo. Mexico 2009
*/
HB_FUNC( WXGAUGE_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = HB_ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    int range = hb_parni( 3 );
    const wxPoint& pos = HB_ISNIL( 4 ) ? wxDefaultPosition : wxh_par_wxPoint( 4 );
    const wxSize& size = HB_ISNIL( 5 ) ? wxDefaultSize : wxh_par_wxSize( 5 );
    long style = HB_ISNIL( 6 ) ? 0 : hb_parnl( 6 );
    //const wxValidator& validator =  HB_ISNIL( 7 ) ?  wxDefaultValidator : (wxValidator ) objParams.param( 7 );
    const wxString& name = HB_ISNIL( 8 ) ? wxString( _T("gauge") ) : wxh_parc( 8 );

    objParams.Return( new wx_Gauge( parent, id, range, pos, size, style, wxDefaultValidator, name ) );
}

/*
    wxGauge:GetRange
    Teo. Mexico 2009
*/
HB_FUNC( WXGAUGE_GETRANGE )
{
    wxGauge* gauge = (wxGauge *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gauge )
    {
        hb_retni( gauge->GetRange() );
    }
}

/*
    wxGauge:GetValue
    Teo. Mexico 2009
*/
HB_FUNC( WXGAUGE_GETVALUE )
{
    wxGauge* gauge = (wxGauge *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gauge )
    {
        hb_retni( gauge->GetValue() );
    }
}

/*
    wxGauge:IsVertical
    Teo. Mexico 2009
*/
HB_FUNC( WXGAUGE_ISVERTICAL )
{
    wxGauge* gauge = (wxGauge *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gauge )
    {
        hb_retl( gauge->IsVertical() );
    }
}

/*
    wxGauge:Pulse
    Teo. Mexico 2009
*/
HB_FUNC( WXGAUGE_PULSE)
{
    wxGauge* gauge = (wxGauge *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gauge )
    {
        gauge->Pulse();
    }
}
/*
    wxGauge:SetRange
    Teo. Mexico 2009
*/
HB_FUNC( WXGAUGE_SETRANGE )
{
    wxGauge* gauge = (wxGauge *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gauge )
    {
        gauge->SetRange( hb_parni( 1 ) );
    }
}

/*
    wxGauge:SetShadowWidth
    Teo. Mexico 2009
*/
HB_FUNC( WXGAUGE_SETSHADOWWIDTH )
{
    wxGauge* gauge = (wxGauge *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gauge )
    {
        gauge->SetShadowWidth( hb_parni( 1 ) );
    }
}

/*
    wxGauge:SetValue
    Teo. Mexico 2009
*/
HB_FUNC( WXGAUGE_SETVALUE )
{
    wxGauge* gauge = (wxGauge *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gauge )
    {
        gauge->SetValue( hb_parni( 1 ) );
    }
}
