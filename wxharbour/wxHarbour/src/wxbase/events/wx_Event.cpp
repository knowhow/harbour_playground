/*
 * $Id: wx_Event.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Event: Implementation
    Teo. Mexico 2008
*/

#include "wx/wx.h"

#include "wxh.h"

/*
    wxEvent::GetEventObject
    Teo. Mexico 2008
*/
HB_FUNC( WXEVENT_GETEVENTOBJECT )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( event )
    {
        xho_itemReturn( event->GetEventObject() );
    }
}

/*
    wxEvent::GetEventType
    Teo. Mexico 2008
*/
HB_FUNC( WXEVENT_GETEVENTTYPE )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( event )
        hb_retni( event->GetEventType() );
}

/*
 wxEvent::GetId
 Teo. Mexico 2008
 */
HB_FUNC( WXEVENT_GETID )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( event )
        hb_retni( event->GetId() );
}

/*
 wxEvent::GetSkipped
 Teo. Mexico 2008
 */
HB_FUNC( WXEVENT_GETSKIPPED )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( event )
        hb_retl( event->GetSkipped() );
}

/*
 wxEvent::GetTimestamp
 Teo. Mexico 2008
 */
HB_FUNC( WXEVENT_GETTIMESTAMP )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( event )
        hb_retnl( event->GetTimestamp() );
}

/*
 wxEvent::IsCommandEvent
 Teo. Mexico 2008
 */
HB_FUNC( WXEVENT_ISCOMMANDEVENT )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( event )
        hb_retl( event->IsCommandEvent() );
}

/*
 wxEvent::SetEventObject
 Teo. Mexico 2008
 */
HB_FUNC( WXEVENT_SETEVENTOBJECT )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( event )
        event->SetEventObject( xho_par_XhoObject( 1 ) );
}

/*
 wxEvent::SetEventType
 Teo. Mexico 2008
 */
HB_FUNC( WXEVENT_SETEVENTTYPE )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( event )
        event->SetEventType( (wxEventType) hb_parni( 1 ) );
}

/*
 wxEvent::SetId
 Teo. Mexico 2008
 */
HB_FUNC( WXEVENT_SETID )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( event )
        event->SetId( hb_parni( 1 ) );
}

/*
 wxEvent::SetTimestamp
 Teo. Mexico 2008
 */
HB_FUNC( WXEVENT_SETTIMESTAMP )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( event )
        event->SetTimestamp( hb_parnl( 1 ) );
}

/*
 wxEvent::ShouldPropagate
 Teo. Mexico 2008
 */
HB_FUNC( WXEVENT_SHOULDPROPAGATE )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( event )
        hb_retl( event->ShouldPropagate() );
}

/*
 wxEvent::Skip
 Teo. Mexico 2008
 */
HB_FUNC( WXEVENT_SKIP )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    bool skip = ISNIL( 1 ) ? true : hb_parl( 1 );
    
    if( event )
        event->Skip( skip );
}

HB_FUNC( WXEVENT_STOPPROPAGATION )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( event )
            hb_retni(event->StopPropagation());
}

HB_FUNC( WXEVENT_RESUMEPROPAGATION )
{
    wxEvent *event = (wxEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( event )
            event->ResumePropagation(hb_parni(1));
}

