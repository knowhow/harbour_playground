/*
 * $Id: wx_GridSizer.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

 (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
 */

/*
 wx_GridSizer: Implementation
 Teo. Mexico 2006
 */

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_GridSizer.h"

/*
 ~wx_GridSizer
 Teo. Mexico 2006
 */
wx_GridSizer::~wx_GridSizer()
{
    xho_itemListDel_XHO( this );
}

HB_FUNC( WXGRIDSIZER_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_GridSizer* gridSizer = new wx_GridSizer( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) );

    objParams.Return( gridSizer );
}

/*
 wxGridSizer:GetCols
 Teo. Mexico 2007
 */
HB_FUNC( WXGRIDSIZER_GETCOLS )
{
    wxGridSizer* gridSizer = (wxGridSizer *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridSizer )
        hb_retni( gridSizer->GetCols() );
}

/*
 wxGridSizer:GetHGap
 Teo. Mexico 2007
 */
HB_FUNC( WXGRIDSIZER_GETHGAP )
{
    wxGridSizer* gridSizer = (wxGridSizer *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridSizer )
        hb_retni( gridSizer->GetHGap() );
}

/*
 wxGridSizer:GetRows
 Teo. Mexico 2007
 */
HB_FUNC( WXGRIDSIZER_GETROWS )
{
    wxGridSizer* gridSizer = (wxGridSizer *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridSizer )
        hb_retni( gridSizer->GetRows() );
}

/*
 wxGridSizer:GetVGap
 Teo. Mexico 2007
 */
HB_FUNC( WXGRIDSIZER_GETVGAP )
{
    wxGridSizer* gridSizer = (wxGridSizer *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridSizer )
        hb_retni( gridSizer->GetVGap() );
}

/*
 wxGridSizer:SetCols
 Teo. Mexico 2007
 */
HB_FUNC( WXGRIDSIZER_SETCOLS )
{
    wxGridSizer* gridSizer = (wxGridSizer *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridSizer )
        gridSizer->SetCols( hb_parni( 1 ) );
}

/*
 wxGridSizer:SetHGap
 Teo. Mexico 2007
 */
HB_FUNC( WXGRIDSIZER_SETHGAP )
{
    wxGridSizer* gridSizer = (wxGridSizer *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridSizer )
        gridSizer->SetHGap( hb_parni( 1 ) );
}

/*
 wxGridSizer:SetRows
 Teo. Mexico 2007
 */
HB_FUNC( WXGRIDSIZER_SETROWS )
{
    wxGridSizer* gridSizer = (wxGridSizer *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridSizer )
        gridSizer->SetRows( hb_parni( 1 ) );
}

/*
 wxGridSizer:SetVGap
 Teo. Mexico 2007
 */
HB_FUNC( WXGRIDSIZER_SETVGAP )
{
    wxGridSizer* gridSizer = (wxGridSizer *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridSizer )
        gridSizer->SetVGap( hb_parni( 1 ) );
}
