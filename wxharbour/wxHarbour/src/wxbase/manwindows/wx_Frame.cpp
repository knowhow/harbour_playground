/*
 * $Id: wx_Frame.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Frame: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_StatusBar.h"
#include "wxbase/wx_MenuBar.h"
#include "wxbase/wx_Frame.h"

/*
    Constructor
    Teo. Mexico 2009
*/
wx_Frame::wx_Frame( wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos, const wxSize& size, long style, const wxString& name )
{
    Create( parent, id, title, pos, size, style, name );
}

/*
    wx_Frame::OnCreateToolBar
    Teo. Mexico 2009
 */
wx_ToolBar* wx_Frame::OnCreateToolBar( long style, wxWindowID id, const wxString& name )
{
    PHB_ITEM pStyle = hb_itemPutNL( NULL, style );
    PHB_ITEM pId = hb_itemPutNI( NULL, id );
    PHB_ITEM pName = hb_itemPutC( NULL, wxh_wxStringToC( name ) );

    hb_objSendMsg( xho_itemListGet_HB( this ), "OnCreateToolBar", 3, pStyle, pId, pName );

    wx_ToolBar* toolBar = (wx_ToolBar *) xho_itemListGet_XHO( hb_stackReturnItem() );

    hb_itemRelease( pStyle );
    hb_itemRelease( pId );
    hb_itemRelease( pName );

    return toolBar;
}

/*
    Constructor: Object
    Teo. Mexico 2009
*/
HB_FUNC( WXFRAME_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_Frame* frame;

    if( hb_pcount() > 0 )
    {
        wxWindow* parent = (wxFrame *) objParams.paramParent( 1 );
        wxWindowID id = HB_ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
        const wxString& title = wxh_parc( 3 );
        wxPoint point = wxh_par_wxPoint( 4 );
        wxSize size = wxh_par_wxSize( 5 );
        long style = HB_ISNIL( 6 ) ? wxDEFAULT_FRAME_STYLE : hb_parnl( 6 );
        wxString name = wxh_parc( 7 );
        frame = new wx_Frame( parent, id, title, point, size, style, name );
    }
    else
        frame = new wx_Frame( NULL );

    objParams.Return( frame );

}

/*
 wxFrame::Centre( int direction = wxBOTH )
 Teo. Mexico 2009
 */
HB_FUNC( WXFRAME_CENTRE )
{
    wx_Frame* frame = (wx_Frame*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( frame )
    {
        int direction = HB_ISNIL( 1 ) ? wxBOTH : hb_parni( 1 );
        frame->Centre( direction );
    }
}

/*
 wxFrame:CreateToolBar
 Teo. Mexico 2009
 */
HB_FUNC( WXFRAME_CREATETOOLBAR )
{
    wx_Frame* frame = (wx_Frame*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( frame )
    {
        long style = HB_ISNIL( 1 ) ? wxTB_FLAT | wxTB_HORIZONTAL : hb_parnl( 1 );
        wxWindowID id = HB_ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
        const wxString& name = HB_ISNIL( 3 ) ? wxString( _T("toolBar") ) : wxh_parc( 3 );
        xho_itemReturn( frame->CreateToolBar( style, id, name ) );
    }
}

/*
    SetMenuBar
    Teo. Mexico 2009
*/
HB_FUNC( WXFRAME_SETMENUBAR )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wx_Frame* frame = (wx_Frame *) objParams.Get_xhoObject();

    if( frame )
    {
        wx_MenuBar* menuBar = (wx_MenuBar *) objParams.paramChild( 1 );
        if( menuBar )
        {
            frame->SetMenuBar( menuBar );
        }
    }
}

/*
    SetStatusBar
    Teo. Mexico 2009
*/
HB_FUNC( WXFRAME_SETSTATUSBAR )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wx_Frame* frame = (wx_Frame *) objParams.Get_xhoObject();

    if( frame )
    {
        wx_StatusBar* statusBar = (wx_StatusBar *) objParams.paramChild( 1 );
        if( statusBar )
        {
            frame->SetStatusBar( statusBar );
        }
    }
}
