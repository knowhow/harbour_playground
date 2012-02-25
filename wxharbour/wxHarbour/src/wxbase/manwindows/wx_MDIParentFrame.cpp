/*
 * $Id: wx_MDIParentFrame.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_MDIParentFrame: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_MDIParentFrame.h"

using namespace std;

/*
    Constructor
    Teo. Mexico 2006
*/
wx_MDIParentFrame::wx_MDIParentFrame( wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos, const wxSize& size, long style, const wxString& name )
{
    Create( parent, id, title, pos, size, style, name );
}

/*
    Constructor: Object
    Teo. Mexico 2006
*/
HB_FUNC( WXMDIPARENTFRAME_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_MDIParentFrame* frame;

    if(hb_pcount())
    {
        wxWindow* parent = (wxFrame *) objParams.paramParent( 1 );
        wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
        wxString title = wxh_parc( 3 );
        wxPoint point = wxh_par_wxPoint(4);
        wxSize size = wxh_par_wxSize(5);
        long style = ISNIL(6) ? wxDEFAULT_FRAME_STYLE : hb_parnl(6);
        wxString name = wxh_parc( 7 );
        frame = new wx_MDIParentFrame( parent, id, title, point, size, style, name );
    }
    else
        frame = new wx_MDIParentFrame( NULL );

    objParams.Return( frame );
}

/*
    Cascade
    Teo. Mexico 2008
*/
HB_FUNC( WXMDIPARENTFRAME_CASCADE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_MDIParentFrame* frame = (wx_MDIParentFrame *) xho_itemListGet_XHO( pSelf );

    if( frame )
        frame->Cascade();
}
