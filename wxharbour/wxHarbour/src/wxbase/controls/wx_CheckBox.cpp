/*
 * $Id: wx_CheckBox.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_CheckBox: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_CheckBox.h"

/*
    ~wx_CheckBox
    Teo. Mexico 2009
*/
wx_CheckBox::~wx_CheckBox()
{
    xho_itemListDel_XHO( this );
}

HB_FUNC( WXCHECKBOX_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxString& label = wxh_parc( 3 );
    const wxPoint& pos = wxh_par_wxPoint( 4 );
    const wxSize& size = wxh_par_wxSize( 5 );
    long style = hb_parnl( 6 );
    const wxValidator& validator = ISNIL( 7 ) ? wxDefaultValidator : * ( (wxValidator *) objParams.paramChild( 7 ) );
    const wxString& name = wxh_parc( 8 );

    wx_CheckBox* checkBox = new wx_CheckBox( parent, id, label, pos, size, style, validator, name );

    objParams.Return( checkBox );
}

/*
    Get3StateValue
    Teo. Mexico 2008
*/
HB_FUNC( WXCHECKBOX_GET3STATEVALUE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_CheckBox* checkBox = (wx_CheckBox *) xho_itemListGet_XHO( pSelf );

    if( checkBox )
    {
        wxCheckBoxState cbs = checkBox->Get3StateValue();
        int value = 0;

        switch( cbs )
        {
            case wxCHK_UNCHECKED : value = 0; break;
            case wxCHK_CHECKED : value = 1; break;
            case wxCHK_UNDETERMINED : value = 2; break;
        }

        hb_retnl( value );
    }
}

/*
    Is3rdStateAllowedForUser
    Teo. Mexico 2008
*/
HB_FUNC( WXCHECKBOX_IS3RDSTATEALLOWEDFORUSER )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_CheckBox* checkBox = (wx_CheckBox *) xho_itemListGet_XHO( pSelf );

    if( checkBox )
    {
        hb_retl( checkBox->Is3rdStateAllowedForUser() );
    }
}

/*
    Is3State
    Teo. Mexico 2008
*/
HB_FUNC( WXCHECKBOX_IS3STATE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_CheckBox* checkBox = (wx_CheckBox *) xho_itemListGet_XHO( pSelf );

    if( checkBox )
    {
        hb_retl( checkBox->Is3State() );
    }
}

/*
    IsChecked
    Teo. Mexico 2008
*/
HB_FUNC( WXCHECKBOX_ISCHECKED )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_CheckBox* checkBox = (wx_CheckBox *) xho_itemListGet_XHO( pSelf );

    if( checkBox )
    {
        hb_retl( checkBox->IsChecked() );
    }
}

/*
    Set3StateValue
    Teo. Mexico 2008
*/
HB_FUNC( WXCHECKBOX_SET3STATEVALUE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_CheckBox* checkBox = (wx_CheckBox *) xho_itemListGet_XHO( pSelf );

    if( checkBox )
    {
        wxCheckBoxState cbs = wxCHK_UNDETERMINED;

        switch ( hb_parni( 1 ) )
        {
            case 0 : cbs = wxCHK_UNCHECKED; break;
            case 1 : cbs = wxCHK_CHECKED; break;
        }
        checkBox->Set3StateValue( cbs );
    }
}

/*
    SetValue
    Teo. Mexico 2008
*/
HB_FUNC( WXCHECKBOX_SETVALUE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_CheckBox* checkBox = (wx_CheckBox *) xho_itemListGet_XHO( pSelf );

    if( checkBox )
    {
        checkBox->SetValue( hb_parl( 1 ) );
    }
}
