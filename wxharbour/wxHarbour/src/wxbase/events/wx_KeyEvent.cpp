/*
 * $Id: wx_KeyEvent.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_KeyEvent: Implementation
    Teo. Mexico 2008
*/

#include "wx/wx.h"

#include "wxh.h"

/*
 AltDown
 Teo. Mexico 2009
 */
HB_FUNC( WXKEYEVENT_ALTDOWN )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxKeyEvent * keyEvent = (wxKeyEvent *) xho_itemListGet_XHO( pSelf );

    if( keyEvent )
        hb_retl( keyEvent->AltDown() );
}
/*
 CmdDown
 Teo. Mexico 2009
 */
HB_FUNC( WXKEYEVENT_CMDDOWN )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxKeyEvent * keyEvent = (wxKeyEvent *) xho_itemListGet_XHO( pSelf );

    if( keyEvent )
        hb_retl( keyEvent->CmdDown() );
}
/*
 ControlDown
 Teo. Mexico 2008
 */
HB_FUNC( WXKEYEVENT_CONTROLDOWN )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxKeyEvent * keyEvent = (wxKeyEvent *) xho_itemListGet_XHO( pSelf );

    if( keyEvent )
        hb_retl( keyEvent->ControlDown() );
}
/*
    GetKeyCode
    Teo. Mexico 2008
*/
HB_FUNC( WXKEYEVENT_GETKEYCODE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxKeyEvent * keyEvent = (wxKeyEvent *) xho_itemListGet_XHO( pSelf );

    if( keyEvent )
        hb_retni( keyEvent->GetKeyCode() );
}

/*
    GetModifiers
    Teo. Mexico 2008
*/
HB_FUNC( WXKEYEVENT_GETMODIFIERS )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxKeyEvent * keyEvent = (wxKeyEvent *) xho_itemListGet_XHO( pSelf );

    if( keyEvent )
        hb_retni( keyEvent->GetModifiers() );
}

/*
 GetPosition
 Teo. Mexico 2009
 */
HB_FUNC( WXKEYEVENT_GETPOSITION )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxKeyEvent * keyEvent = (wxKeyEvent *) xho_itemListGet_XHO( pSelf );

    if( keyEvent )
        wxh_ret_wxPoint( keyEvent->GetPosition() );
}
#ifdef _UNICODE
/*
    GetUnicodeKey
    jamaj Brazil 2009
*/
HB_FUNC( WXKEYEVENT_GETUNICODEKEY )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxKeyEvent * keyEvent = (wxKeyEvent *) xho_itemListGet_XHO( pSelf );

    if( keyEvent )
        hb_retni( keyEvent->GetUnicodeKey() );
}
#endif

/*
 GetX
 Teo. Mexico 2009
 */
HB_FUNC( WXKEYEVENT_GETX )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxKeyEvent * keyEvent = (wxKeyEvent *) xho_itemListGet_XHO( pSelf );

    if( keyEvent )
        hb_retnl( keyEvent->GetX() );
}

/*
 GetY
 Teo. Mexico 2009
 */
HB_FUNC( WXKEYEVENT_GETY )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxKeyEvent * keyEvent = (wxKeyEvent *) xho_itemListGet_XHO( pSelf );

    if( keyEvent )
        hb_retnl( keyEvent->GetY() );
}
/*
 HasModifiers
 Teo. Mexico 2009
 */
HB_FUNC( WXKEYEVENT_HASMODIFIERS )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxKeyEvent * keyEvent = (wxKeyEvent *) xho_itemListGet_XHO( pSelf );

    if( keyEvent )
        hb_retl( keyEvent->HasModifiers() );
}
/*
 MetaDown
 Teo. Mexico 2009
 */
HB_FUNC( WXKEYEVENT_METADOWN )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxKeyEvent * keyEvent = (wxKeyEvent *) xho_itemListGet_XHO( pSelf );

    if( keyEvent )
        hb_retl( keyEvent->MetaDown() );
}

/*
 ShiftDown
 Teo. Mexico 2009
 */
HB_FUNC( WXKEYEVENT_SHIFTDOWN )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxKeyEvent * keyEvent = (wxKeyEvent *) xho_itemListGet_XHO( pSelf );

    if( keyEvent )
        hb_retl( keyEvent->ShiftDown() );
}
