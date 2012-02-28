/*
 * $Id: wx_Font.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Font: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_Font.h"

/*
    ~wx_Font
    Teo. Mexico 2008
*/
wx_Font::~wx_Font()
{
    xho_itemListDel_XHO( this );
}

/*
    Constructor: wxFont Object
    Teo. Mexico 2008
*/
HB_FUNC( WXFONT_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_Font* font = new wx_Font();

    objParams.Return( font );
}

/*
    GetFaceName
    Teo. Mexico 2008
*/
HB_FUNC( WXFONT_GETFACENAME )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_Font* font = (wx_Font *) xho_itemListGet_XHO( pSelf );

    if( font )
        wxh_retc( font->GetFaceName() );
}

/*
    GetPointSize
    Teo. Mexico 2008
*/
HB_FUNC( WXFONT_GETPOINTSIZE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_Font* font = (wx_Font *) xho_itemListGet_XHO( pSelf );

    if( font )
        hb_retni( font->GetPointSize() );
}
