/*
 * $Id: wx_CommandEvent.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_CommandEvent: Implementation
    Teo. Mexico 2008
*/

#include "wx/wx.h"

#include "wxh.h"

HB_FUNC( WXCOMMANDEVENT_ISCHECKED )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxCommandEvent *event = (wxCommandEvent *) xho_itemListGet_XHO( pSelf );

    if( event  )
        hb_retl( event->IsChecked() );
}
