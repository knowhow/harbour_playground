/*
 * $Id: wx_Timer.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Timer: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"

#include "wxh.h"

#include "wxbase/wx_Timer.h"

/*
    ~wx_Timer
    Teo. Mexico 2009
*/
wx_Timer::~wx_Timer()
{
    xho_itemListDel_XHO( this );
}

/*
    Notify
    Teo. Mexico 2009
*/
void wx_Timer::Notify()
{
    PHB_ITEM pTimer = xho_itemListGet_HB( this );

    if( pTimer )
    {
        hb_objSendMsg( pTimer, "Notify", 0  );
    }
}

/*
    New
    Teo. Mexico 2009
*/
HB_FUNC( WXTIMER_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxEvtHandler* owner = (wxEvtHandler *) objParams.paramParent( 1 );
    int id = ISNIL( 2 ) ? -1 : hb_parni( 2 );

    const char* clsName = hb_clsName( hb_objGetClass( objParams.pSelf ) );

    wxTimer* timer;

    if( strcmp( clsName, "WXTIMER" ) == 0 )
    {

        if( hb_pcount() )
        {
            timer = new wxTimer( owner, id );
        }
        else
            timer = new wxTimer();

        objParams.Return( timer );

    }
    else
    {

        if( hb_pcount() )
        {
            timer = new wx_Timer( owner, id );
        }
        else
            timer = new wx_Timer();

        objParams.Return( timer );

    }
}


/*
    GetInterval
    Teo. Mexico 2009
*/
HB_FUNC( WXTIMER_GETINTERVAL )
{
    wx_Timer *timer = (wx_Timer *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( timer )
    {
        hb_retni( timer->GetInterval() );
    }
}

/*
    IsOneShot
    Teo. Mexico 2009
*/
HB_FUNC( WXTIMER_ISONESHOT )
{
    wx_Timer *timer = (wx_Timer *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( timer )
    {
        hb_retl( timer->IsOneShot() );
    }
}

/*
    IsRunning
    Teo. Mexico 2009
*/
HB_FUNC( WXTIMER_ISRUNNING )
{
    wx_Timer *timer = (wx_Timer *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( timer )
    {
        hb_retl( timer->IsRunning() );
    }
}

/*
    SetOwner
    Teo. Mexico 2009
*/
HB_FUNC( WXTIMER_SETOWNER )
{
    wx_Timer *timer = (wx_Timer *) xho_itemListGet_XHO( hb_stackSelfItem() );
    wxEvtHandler* evtHandler = (wxEvtHandler *) xho_par_XhoObject( 1 );

    if( timer && evtHandler )
    {
        int id = ISNIL( 2 ) ? -1 : hb_parni( 2 );
        timer->SetOwner( evtHandler, id );
    }
}

/*
    Start
    Teo. Mexico 2009
*/
HB_FUNC( WXTIMER_START )
{
    wx_Timer *timer = (wx_Timer *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( timer )
    {
        int milliseconds = ISNIL( 1 ) ? -1 : hb_parni( 1 );
        bool oneShot = ISNIL( 2 ) ? false : hb_parnl( 2 );
        hb_retl( timer->Start( milliseconds, oneShot ) );
    }
}

/*
    Stop
    Teo. Mexico 2009
*/
HB_FUNC( WXTIMER_STOP )
{
    wx_Timer *timer = (wx_Timer *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( timer )
    {
        timer->Stop();
    }
}
