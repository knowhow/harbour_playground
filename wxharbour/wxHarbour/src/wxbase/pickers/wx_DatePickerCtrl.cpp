/*
 * $Id: wx_DatePickerCtrl.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge
 
 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 
 (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
 */

/*
 wx_DatePickerCtrl: Implementation
 Teo. Mexico 2009
 */

#include "wx/wx.h"
#include "wxh.h"

#include "wx/datetime.h"

#include "wxbase/wx_DatePickerCtrl.h"

/*
 ~wx_DatePickerCtrl
 Teo. Mexico 2009
 */
wx_DatePickerCtrl::~wx_DatePickerCtrl()
{
    xho_itemListDel_XHO( this );
}

/*
 wxDatePickerCtrl:New
 Teo. Mexico 2009
 */
HB_FUNC( WXDATEPICKERCTRL_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    
    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    wxDateTime dt = wxh_par_wxDateTime( 3 );
    const wxPoint& pos = ISNIL( 4 ) ? wxDefaultPosition : wxh_par_wxPoint( 4 );
    const wxSize& size = ISNIL( 5 ) ? wxDefaultSize : wxh_par_wxSize( 5 );
    long style = ISNIL( 6 ) ? 0 : hb_parnl( 6 );
    const wxValidator& validator = ISNIL( 7 ) ? wxDefaultValidator : (*((wxValidator *) objParams.param( 7 ))) ;
    const wxString& name = ISNIL( 8 ) ? wxString( _T("dateCtrl") ) : wxh_parc( 8 );
    
    objParams.Return( new wx_DatePickerCtrl( parent, id, dt, pos, size, style, validator, name ) );
}

/*
 GetValue
 Teo. Mexico 2009
 */
HB_FUNC( WXDATEPICKERCTRL_GETVALUE )
{
    wxDatePickerCtrl* dateCtrl = (wxDatePickerCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( dateCtrl )
    {
        wxDateTime dt = dateCtrl->GetValue();
        hb_retd( dt.GetYear(), dt.GetMonth() + 1, dt.GetDay() );
    }
}

/*
 SetValue
 Teo. Mexico 2009
 */
HB_FUNC( WXDATEPICKERCTRL_SETVALUE )
{
    wxDatePickerCtrl* dateCtrl = (wxDatePickerCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( dateCtrl )
    {
        dateCtrl->SetValue( wxh_par_wxDateTime( 1 ) );
    }
}
