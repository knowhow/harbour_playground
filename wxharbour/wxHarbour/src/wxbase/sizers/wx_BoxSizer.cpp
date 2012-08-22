/*
 * $Id: wx_BoxSizer.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_BoxSizer: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_BoxSizer.h"

/*
    ~wx_BoxSizer
    Teo. Mexico 2006
*/
wx_BoxSizer::~wx_BoxSizer()
{
    xho_itemListDel_XHO( this );
}

HB_FUNC( WXBOXSIZER_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_BoxSizer* boxSizer = new wx_BoxSizer( hb_parni( 1 ) );

    objParams.Return( boxSizer );
}

/*
    wxBoxSizer:GetValue
    Teo. Mexico 2007
*/
HB_FUNC( WXBOXSIZER_GETORIENTATION )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxBoxSizer* boxSizer = (wxBoxSizer *) xho_itemListGet_XHO( pSelf );

    if( boxSizer )
    {
        hb_retni( boxSizer->GetOrientation() );
    }
}
