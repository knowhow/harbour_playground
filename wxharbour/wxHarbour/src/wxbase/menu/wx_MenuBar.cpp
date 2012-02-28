/*
 * $Id: wx_MenuBar.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_MenuBar: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_Menu.h"
#include "wxbase/wx_MenuBar.h"

/*
    ~wx_MenuBar
    Teo. Mexico 2006
*/
wx_MenuBar::~wx_MenuBar()
{
    xho_itemListDel_XHO( this );
}

/*
    Constructor: wxMenuBar Object
    Teo. Mexico 2006
*/
HB_FUNC( WXMENUBAR_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_MenuBar* menuBar = new wx_MenuBar( hb_parnl( 1 ) );

    objParams.Return( menuBar );
}

HB_FUNC( WXMENUBAR_APPEND )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wx_MenuBar* menuBar = (wx_MenuBar *) objParams.Get_xhoObject();

    wx_Menu* menu = (wx_Menu *) objParams.paramChild( 1 );

    if( menuBar && menu )
    {
        menuBar->Append( menu, wxh_parc( 2 ) );
    }
}
