/*
 * $Id: wx_MDIChildFrame.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_MDIChildFrame: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wx/docview.h"

#include "wxbase/wx_MDIChildFrame.h"

using namespace std;

/*
    Constructor
    Teo. Mexico 2006
*/
wx_MDIChildFrame::wx_MDIChildFrame( wxMDIParentFrame* parent, wxWindowID id, const wxString& title, const wxPoint& pos, const wxSize& size, long style, const wxString& name )
{
    Create( parent, id, title, pos, size, style, name );
}

/*
    Constructor: Object
    Teo. Mexico 2006
*/
HB_FUNC( WXMDICHILDFRAME_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_MDIChildFrame* frame;

    wxMDIParentFrame* parent = (wxMDIParentFrame *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    wxString title = wxh_parc ( 3 );
    wxPoint point = wxh_par_wxPoint(4);
    wxSize size = wxh_par_wxSize(5);
    long style = ISNIL(6) ? wxDEFAULT_FRAME_STYLE : hb_parnl(6);
    wxString name = wxh_parc( 7 );
    frame = new wx_MDIChildFrame( parent, id, title, point, size, style, name );

    objParams.Return( frame );
}

/*
    Activate
    Teo. Mexico 2008
*/
HB_FUNC( WXMDICHILDFRAME_ACTIVATE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_MDIChildFrame* frame = (wx_MDIChildFrame *) xho_itemListGet_XHO( pSelf );

    if( frame )
        frame->Activate();
}

/*
    Maximize
    Teo. Mexico 2008
*/
HB_FUNC( WXMDICHILDFRAME_MAXIMIZE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_MDIChildFrame* frame = (wx_MDIChildFrame *) xho_itemListGet_XHO( pSelf );

    if( frame )
    {
        bool maximize = hb_parl( 1 );
        frame->Maximize( maximize );
    }
}

/*
    Restore
    Teo. Mexico 2008
*/
HB_FUNC( WXMDICHILDFRAME_RESTORE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_MDIChildFrame* frame = (wx_MDIChildFrame *) xho_itemListGet_XHO( pSelf );

    if( frame )
        frame->Restore();
}
