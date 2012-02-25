/*
 * $Id: wx_Window.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Window: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"

#include "wxh.h"

#include "wxbase/wx_Window.h"
#include "wxbase/wx_Menu.h"
#include "wxbase/wx_Font.h"

HB_FUNC_EXTERN( WXFONT );

/*
    Constructor
    Jamaj Brazil 2009
*/

wx_Window::wx_Window( wxWindow* parent, wxWindowID id, const wxPoint& pos, const wxSize& size, long style, const wxString& name )
{
    Create( parent, id, pos, size, style, name );
}

/*
    New
    Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_Window* window;

    if( hb_pcount() > 0 )
    {
        wxWindow* parent = (wxFrame *) objParams.paramParent( 1 );
        wxWindowID id = HB_ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
        wxPoint point = wxh_par_wxPoint( 3 );
        wxSize size = wxh_par_wxSize( 4 );
        long style = HB_ISNIL( 5 ) ? wxDEFAULT_FRAME_STYLE : hb_parnl( 5 );
        wxString name = wxh_parc( 6 );
        window = new wx_Window( parent, id, point, size, style, name );
    }
    else
        window = new wx_Window( NULL );

    objParams.Return( window );

}

/*
 Centre
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_CENTRE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        int direction = HB_ISNIL( 1 ) ? wxBOTH : hb_parni( 1 );
        wnd->Centre( hb_parni( direction ) );
    }
}

/*
 Close
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_CLOSE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        hb_retl( wnd->Close( hb_parl( 1 ) ) );
}

/*
 DestroyChildren
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_DESTROYCHILDREN )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        wnd->DestroyChildren();
}

/*
 Disable
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_DISABLE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        hb_retl( wnd->Disable() );
}

/*
 Destroy
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_DESTROY )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        hb_retl( wnd->Destroy() );
}

/*
 DragAcceptFiles
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_DRAGACCEPTFILES )
{
/*
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        wnd->DragAcceptFiles( hb_parl( 1 ) );
*/
}

/*
    wxWindow:Enable
    Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_ENABLE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        bool enable = HB_ISNIL( 1 ) ? true : hb_parl( 1 );
        hb_retl( wnd->Enable( enable ) );
    }
}

/*
    wxWindow:FindFocus
    Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_FINDFOCUS )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        xho_itemReturn( wnd->FindFocus() );
}

/*
 FindWindowById
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_FINDWINDOWBYID )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wxWindow* wnd = (wxWindow *) objParams.Get_xhoObject();

    if( wnd )
    {
        long id = hb_parnl(1);
        wxWindow* parent = (wxWindow *) objParams.param( 2 );
        wxWindow* result = wnd->FindWindowById( id, parent );
        xho_itemReturn( result );
    }
}

/*
 FindWindowByLabel
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_FINDWINDOWBYLABEL )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wxWindow* wnd = (wxWindow *) objParams.Get_xhoObject();

    if( wnd )
    {
        const wxString& label = wxh_parc( 1 );
        wxWindow* parent = (wxWindow *) objParams.param( 2 );
        wxWindow* result =	wnd->FindWindowByLabel( label, parent );
        xho_itemReturn( result );
    }
}

/*
 FindWindowByName
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_FINDWINDOWBYNAME )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wxWindow* wnd = (wxWindow *) objParams.Get_xhoObject();

    if( wnd )
    {
        const wxString& name = wxh_parc( 1 );
        wxWindow* parent = (wxWindow *) objParams.param( 2 );
        wxWindow* result =	wnd->FindWindowByName( name, parent );
        xho_itemReturn( result );
    }
}

/*
 FitInside
 Teo. Mexico 2010
 */
HB_FUNC( WXWINDOW_FITINSIDE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        wnd->FitInside();
}

/*
    Freeze
    Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_FREEZE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        wnd->Freeze();
}

/*
 GetClientSize
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETCLIENTSIZE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        wxSize size = wnd->GetClientSize();
        wxh_ret_wxSize( &size );
    }
}

/*
 GetChildren
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETCHILDREN )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        wxWindowList windowList = wnd->GetChildren();
        wxWindowList::iterator iter;
        wxWindow* window;
        PHB_ITEM pList = hb_itemArrayNew( windowList.GetCount() );
        PHB_ITEM pItm;
        HB_UINT index = 0;
        for( iter = windowList.begin(); iter != windowList.end(); ++iter )
        {
            window = *iter;
            pItm = xho_itemListGet_HB( window );
            if( pItm )
                hb_arraySet( pList, ++index, pItm );
        }
        hb_itemReturnRelease( pList );
    }
}

/*
 GetExtraStyle
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETEXTRASTYLE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        hb_retnl( wnd->GetExtraStyle() );
}

/*
    GetFont
    Teo. Mexico 2008
*/
HB_FUNC( WXWINDOW_GETFONT )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        wxFont *font = new wxFont( wnd->GetFont() );
        HB_FUNC_EXEC( WXFONT );
        PHB_ITEM pFont = hb_stackReturnItem();
        xho_ObjParams objParams = xho_ObjParams( pFont );
        objParams.Return( font, true );
    }
}

/*
 GetGrandParent
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETGRANDPARENT )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        xho_itemReturn( wnd->GetGrandParent() );
}

/*
 GetId
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETID )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        hb_retnl( wnd->GetId() );
}

/*
 GetLabel
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETLABEL )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        wxh_retc( wnd->GetLabel() );
}

/*
 GetName
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETNAME )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        wxh_retc( wnd->GetName() );
}

/*
 GetParent
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETPARENT )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        wxWindow* parent =	wnd->GetParent();
        if( parent )
        {
            xho_itemReturn( parent );
        }
    }
}

/*
 GetPointSize
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETPOINTSIZE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        hb_retni( wnd->GetFont().GetPointSize() );
}

/*
 GetSize
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETSIZE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        wxSize size = wnd->GetSize();
        wxh_ret_wxSize( &size );
    }
}

/*
 GetSizer
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETSIZER )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        wxSizer* sizer =	wnd->GetSizer();
        if( sizer )
        {
            xho_itemReturn( sizer );
        }
    }
}

/*
 GetValidator
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_GETVALIDATOR )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        xho_itemReturn( wnd->GetValidator() );
    }
}

/*
 Hide
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_HIDE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        hb_retl( wnd->Hide() );
}

/*
    wxWindow:IsEnabled
    Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_ISENABLED )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        hb_retl( wnd->IsEnabled() );
}

/*
 IsShown
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_ISSHOWN )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        hb_retl( wnd->IsShown() );
}

/*
 Layout
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_LAYOUT )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        wnd->Layout();
}

/*
 MakeModal
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_MAKEMODAL )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        wnd->MakeModal( hb_parl( 1 ) );
}

/*
 PopupMenu
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_POPUPMENU )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* wnd = (wxWindow *) objParams.Get_xhoObject();

    wx_Menu* menu = (wx_Menu *) objParams.paramParent( 1 );

    if( !( wnd && menu ) )
    {
        return;
    }

    if( hb_pcount() == 1 )
    {
        hb_retl( wnd->PopupMenu( menu ) );
        return;
    }

    if( hb_pcount() == 2 )
    {
        hb_retl( wnd->PopupMenu( menu, wxh_par_wxPoint( 2 ) ) );
        return;
    }

    hb_retl( wnd->PopupMenu( menu, hb_parni( 2 ), hb_parni( 3 ) ) );

}

/*
 Raise
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_RAISE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        wnd->Raise();
}

/*
 Refresh
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_REFRESH )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        wnd->Refresh();
}

/*
 SetExtraStyle
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SETEXTRASTYLE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        wnd->SetExtraStyle( hb_parnl( 1 ) );
}

/*
 SetFocus
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SETFOCUS )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        wnd->SetFocus();
}

/*
 SetId
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SETID )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        wnd->SetId( hb_parni( 1 ) );
}

/*
 SetLabel
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SETLABEL )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        const wxString& label = wxh_parc( 1 );
        wnd->SetLabel( label );
    }
}

/*
    SetMaxSize
    Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_SETMAXSIZE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        wnd->SetMaxSize( wxh_par_wxSize( 1 ) );
    }
}

/*
    SetMinSize
    Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_SETMINSIZE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        wnd->SetMinSize( wxh_par_wxSize( 1 ) );
    }
}

/*
 SetName
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SETNAME )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        const wxString& name = wxh_parc( 1 );
        wnd->SetName( name );
    }
}

/*
 SetSizer
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SETSIZER )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wxWindow* wnd = (wxWindow *) objParams.Get_xhoObject();

    if( wnd )
    {
        wxSizer* sizer = (wxSizer *) objParams.paramChild( 1 );
        if( sizer )
        {
            wnd->SetSizer( sizer, hb_parl( 2 ) );
        }
    }
}

/*
 SetToolTip
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SETTOOLTIP )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        wnd->SetToolTip( wxh_parc( 1 ) );
    }
}

/*
 SetValidator
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SETVALIDATOR )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        wxValidator* val = (wxValidator *) xho_par_XhoObject( 1 );
        if( val )
        {
            const wxValidator& validator = *val;
            wnd->SetValidator( validator );
        }
    }
}

/*
 Show
 Teo. Mexico 2009
 */
HB_FUNC( WXWINDOW_SHOW )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        bool show = hb_pcount() > 0 ? hb_parl( 1 ) : FALSE;
        hb_retl( wnd->Show( show ) );
    }
}

/*
    Thaw
    Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_THAW )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
        wnd->Thaw();
}

/*
    TransferDataToWindow
    Teo. Mexico 2009
*/
HB_FUNC( WXWINDOW_TRANSFERDATATOWINDOW )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        hb_retl( wnd->TransferDataToWindow() );
    }
}

/*
    Validate
    Teo. Mexico 2010
 */
HB_FUNC( WXWINDOW_VALIDATE )
{
    wxWindow* wnd = (wxWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( wnd )
    {
        hb_retl( wnd->wxWindow::Validate() );

    }
}
