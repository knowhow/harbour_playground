/*
 * $Id: wx_FocusEvent.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_FocusEvent: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"

#include "wxh.h"
#include "wxbase/wx_Grid.h"
#include "wxbase/wx_Browse.h"

/*
 wxEvent::GetEventObject
 Teo. Mexico 2010
 */
HB_FUNC( WXFOCUSEVENT_GETEVENTOBJECT )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( event )
    {
        wxObject* wxObj = event->GetEventObject();
        wxWindow* wxWin = ( (wxWindow *) wxObj )->GetParent();

        if( wxWin && wxWin->IsKindOf( CLASSINFO( wxGrid ) ) )
        {
            xho_itemReturn( wxWin );
        }
        else
        {
            xho_itemReturn( wxObj );
        }
    }
}

HB_FUNC( WXFOCUSEVENT_GETWINDOW )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFocusEvent *event = (wxFocusEvent *) xho_itemListGet_XHO( pSelf );

    if( event )
    {
        xho_itemReturn( event->GetWindow() );
    }
}
