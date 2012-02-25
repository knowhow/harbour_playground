/*
 * $Id: wx_Validator.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Validator: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_Validator.h"

/*
    wx_Validator()
    Teo. Mexico 2009
*/
wx_Validator::wx_Validator( const wx_Validator& validator ) : wxValidator()
{
    Copy( validator );
    xho_itemListSwap( (wxObject *) &validator, this );
}

/*
    TransferFromWindow
    Teo. Mexico 2009
*/
bool wx_Validator::TransferFromWindow()
{
    PHB_ITEM pSelf = xho_itemListGet_HB( this );
    bool result = false;

    if( pSelf )
    {
        hb_objSendMsg( pSelf, "TransferFromWindow", 0 );
        result = hb_itemGetL( hb_stackReturnItem() );
    }
    return result;
}

/*
    TransferToWindow
    Teo. Mexico 2009
*/
bool wx_Validator::TransferToWindow()
{
    PHB_ITEM pSelf = xho_itemListGet_HB( this );
    bool result = false;
    
    if( pSelf )
    {
        hb_objSendMsg( pSelf, "TransferToWindow", 0 );
        result = hb_itemGetL( hb_stackReturnItem() );
    }
    return result;
}

/*
    Validate
    Teo. Mexico 2009
*/
bool wx_Validator::Validate( wxWindow* parent )
{
    PHB_ITEM pSelf = xho_itemListGet_HB( this );

    if( pSelf )
    {
        PHB_ITEM pParent = xho_itemListGet_HB( parent );
        if( pParent )
        {
            hb_objSendMsg( pSelf, "Validate", 1, pParent );
            return hb_itemGetL( hb_stackReturnItem() );
        }
    }
    return true;
}

/*
    ~wx_Validator
    Teo. Mexico 2006
*/
wx_Validator::~wx_Validator()
{
    xho_itemListDel_XHO( this );
}

/*
    New
    Teo. Mexico 2009
*/
HB_FUNC( WXVALIDATOR_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_Validator* validator = new wx_Validator;
    
    objParams.Return( validator );
}

/*
    GetWindow()
    Teo. Mexico 2009
*/
HB_FUNC( WXVALIDATOR_GETWINDOW )
{
    wx_Validator* validator = (wx_Validator *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( validator )
    {
        xho_itemReturn( validator->GetWindow() );
    }
}

/*
    SetWindow()
    Teo. Mexico 2009
*/
HB_FUNC( WXVALIDATOR_SETWINDOW )
{
    wxValidator* validator = (wxValidator *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( validator )
    {
        validator->SetWindow( (wxWindow *) xho_par_XhoObject( 1 ) );
    }
}
