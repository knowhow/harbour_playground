/*
 * $Id: wx_UpdateUIEvent.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_UpdateUIEvent: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"

#include "wxh.h"

/*
    CanUpdate
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_CANUPDATE )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        hb_retl( updateUIEvent->CanUpdate( (wxWindow *) xho_par_XhoObject( 1 ) ) );
}

/*
    Check
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_CHECK )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        updateUIEvent->Check( hb_parl( 1 ) );
}

/*
    Enable
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_ENABLE )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        updateUIEvent->Enable( hb_parl( 1 ) );
}

/*
    GetChecked
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_GETCHECKED )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        hb_retl( updateUIEvent->GetChecked() );
}

/*
    GetEnabled
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_GETENABLED )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        hb_retl( updateUIEvent->GetEnabled() );
}

/*
    GetMode
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_GETMODE )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        hb_retni( updateUIEvent->GetMode() );
}

/*
    GetSetChecked
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_GETSETCHECKED )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        hb_retl( updateUIEvent->GetSetChecked() );
}

/*
    GetSetEnabled
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_GETSETENABLED )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        hb_retl( updateUIEvent->GetSetEnabled() );
}

/*
    GetSetShown
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_GETSETSHOWN )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        hb_retl( updateUIEvent->GetSetShown() );
}

/*
    GetSetText
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_GETSETTEXT )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        hb_retl( updateUIEvent->GetSetText() );
}

/*
    GetShown
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_GETSHOWN )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        hb_retl( updateUIEvent->GetShown() );
}

/*
    GetText
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_GETTEXT )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        wxh_retc( updateUIEvent->GetText() );
}

/*
    GetUpdateInterval
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_GETUPDATEINTERVAL )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        hb_retnl( updateUIEvent->GetUpdateInterval() );
}

/*
    ResetUpdateTime
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_RESETUPDATETIME )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        updateUIEvent->ResetUpdateTime();
}

/*
    SetMode
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_SETMODE )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        updateUIEvent->SetMode( (wxUpdateUIMode) hb_parni( 1 ) );
}

/*
    SetText
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_SETTEXT )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        updateUIEvent->SetText( wxh_parc( 1 ) );
}

/*
    SetUpdateInterval
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_SETUPDATEINTERVAL )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        updateUIEvent->SetUpdateInterval( hb_parnl( 1 ) );
}

/*
    Show
    Teo. Mexico 2009
*/
HB_FUNC( WXUPDATEUIEVENT_SHOW )
{
    wxUpdateUIEvent * updateUIEvent = (wxUpdateUIEvent *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( updateUIEvent )
        updateUIEvent->Show( hb_parl( 1 ) );
}
