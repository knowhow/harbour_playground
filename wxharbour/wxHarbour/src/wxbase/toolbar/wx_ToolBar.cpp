/*
 * $Id: wx_ToolBar.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_ToolBar: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_ToolBar.h"

/*
    ~wx_ToolBar
    Teo. Mexico 2009
*/
wx_ToolBar::~wx_ToolBar()
{
    xho_itemListDel_XHO( this );
}

HB_FUNC( WXTOOLBAR_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxPoint& pos = wxh_par_wxPoint( 3 );
    const wxSize& size = wxh_par_wxSize( 4 );
    long style = ISNIL( 5 ) ? wxTB_HORIZONTAL | wxNO_BORDER : hb_parnl( 5 );
    const wxString& name = wxh_parc( 6 );

    wx_ToolBar* toolBar = new wx_ToolBar( parent, id, pos, size, style, name );

    objParams.Return( toolBar );
}

/*
    wxToolBar:AddControl
    Teo. Mexico 2009
*/
HB_FUNC( WXTOOLBAR_ADDCONTROL )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( toolBar )
    {
        wxToolBarToolBase* tbtb = toolBar->AddControl( (wxControl *) xho_par_XhoObject( 1 ) );
        xho_itemNewReturn( "wxToolBarToolBase", tbtb, toolBar );
    }
}

/*
 wxToolBar:AddSeparator
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_ADDSEPARATOR )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    toolBar->AddSeparator();
}

/*
 wxToolBar:AddTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_ADDTOOL )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
        wxToolBarToolBase* tbtb;
    if( hb_pcount() == 1 )
    {
        tbtb = toolBar->AddTool( (wxToolBarToolBase *) xho_par_XhoObject( 1 ) );
    }
    else if( hb_pcount() > 5 || ISOBJECT( 4 ) )
    {
        const wxBitmap& bitmap1 = * (wxBitmap *) xho_par_XhoObject( 3 );
        const wxBitmap& bitmap2 = ISNIL( 4 ) ? wxNullBitmap : * (wxBitmap *) xho_par_XhoObject( 4 );
        wxItemKind kind = ISNIL( 5 ) ? wxITEM_NORMAL : (wxItemKind) hb_parni( 5 );
        tbtb = toolBar->AddTool( hb_parni( 1 ), wxh_parc( 2 ), bitmap1, bitmap2, kind, wxh_parc( 6 ), wxh_parc( 7 ), xho_par_XhoObject( 8 ) );
    }
    else
    {
        const wxBitmap& bitmap1 = * (wxBitmap *) xho_par_XhoObject( 3 );
        wxItemKind kind = ISNIL( 5 ) ? wxITEM_NORMAL : (wxItemKind) hb_parni( 5 );
        tbtb = toolBar->AddTool( hb_parni( 1 ), wxh_parc( 2 ), bitmap1, wxh_parc( 4 ), kind );
    }
        xho_itemNewReturn( "wxToolBarToolBase", tbtb, toolBar );
    }
}

/*
 wxToolBar:AddCheckTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_ADDCHECKTOOL )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    const wxBitmap& bitmap2 = ISNIL( 4 ) ? wxNullBitmap : * (wxBitmap *) xho_par_XhoObject( 4 );
    wxToolBarToolBase* tbtb = toolBar->AddCheckTool( hb_parni( 1 ), wxh_parc( 2 ), * (wxBitmap *) xho_par_XhoObject( 3 ), bitmap2, wxh_parc( 5 ), wxh_parc( 6 ), xho_par_XhoObject( 7 ) );
        xho_itemNewReturn( "wxToolBarToolBase", tbtb, toolBar );
    }
}

/*
 wxToolBar:AddRadioTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_ADDRADIOTOOL )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    const wxBitmap& bitmap2 = ISNIL( 4 ) ? wxNullBitmap : * (wxBitmap *) xho_par_XhoObject( 4 );
    wxToolBarToolBase* tbtb = toolBar->AddRadioTool( hb_parni( 1 ), wxh_parc( 2 ), * (wxBitmap *) xho_par_XhoObject( 3 ), bitmap2, wxh_parc( 5 ), wxh_parc( 6 ), xho_par_XhoObject( 7 ) );
        xho_itemNewReturn( "wxToolBarToolBase", tbtb, toolBar );
    }
}

/*
 wxToolBar:ClearTools
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_CLEARTOOLS )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    toolBar->ClearTools();
}

/*
 wxToolBar:DeleteTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_DELETETOOL )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    hb_retl( toolBar->DeleteTool( hb_parni( 1 ) ) );
}

/*
 wxToolBar:DeleteToolByPos
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_DELETETOOLBYPOS )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    hb_retl( toolBar->DeleteToolByPos( hb_parnl( 1 ) ) );
}

/*
 wxToolBar:EnableTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_ENABLETOOL )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    toolBar->EnableTool( hb_parni( 1 ), hb_parl( 2 ) );
}

/*
 wxToolBar:FindById
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_FINDBYID )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    xho_itemReturn( toolBar->FindById( hb_parni( 1 ) ) );
    }
}

/*
 wxToolBar:FindControl
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_FINDCONTROL )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    xho_itemReturn( toolBar->FindControl( hb_parni( 1 ) ) );
    }
}

/*
 wxToolBar:FindToolForPosition
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_FINDTOOLFORPOSITION )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    xho_itemReturn( toolBar->FindToolForPosition( hb_parni( 1 ), hb_parni( 2 ) ) );
    }
}

/*
 wxToolBar:GetToolsCount
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLSCOUNT )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    hb_parni( toolBar->GetToolsCount() );
}

/*
 wxToolBar:GetToolSize
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLSIZE )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    wxSize size = toolBar->GetToolSize();
    wxh_ret_wxSize( &size );
    }
}

/*
 wxToolBar:GetToolBitmapSize
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLBITMAPSIZE )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    wxSize size = toolBar->GetToolBitmapSize();
    wxh_ret_wxSize( &size );
    }
}

/*
 wxToolBar:GetMargins
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETMARGINS )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    wxSize size = toolBar->GetMargins();
    wxh_ret_wxSize( &size );
    }
}

/*
 wxToolBar:GetToolClientData
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLCLIENTDATA )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    xho_itemReturn( toolBar->GetToolClientData( hb_parni( 1 ) ) );
    }
}

/*
 wxToolBar:GetToolEnabled
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLENABLED )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    hb_retl( toolBar->GetToolEnabled( hb_parni( 1 ) ) );
    }
}

/*
 wxToolBar:GetToolLongHelp
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLLONGHELP )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    wxh_retc( toolBar->GetToolLongHelp( hb_parni( 1 ) ) );
    }
}

/*
 wxToolBar:GetToolPacking
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLPACKING )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    hb_retni( toolBar->GetToolPacking() );
    }
}

/*
 wxToolBar:GetToolPos
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLPOS )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    hb_retni( toolBar->GetToolPos( hb_parni( 1 ) ) );
    }
}

/*
 wxToolBar:GetToolSeparation
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLSEPARATION )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    hb_retni( toolBar->GetToolSeparation() );
    }
}

/*
 wxToolBar:GetToolShortHelp
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLSHORTHELP )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    wxh_retc( toolBar->GetToolShortHelp( hb_parni( 1 ) ) );
    }
}

/*
 wxToolBar:GetToolState
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_GETTOOLSTATE )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    hb_retl( toolBar->GetToolState( hb_parni( 1 ) ) );
    }
}

/*
 wxToolBar:InsertControl
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_INSERTCONTROL )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    wxToolBarToolBase* tbtb = toolBar->InsertControl( hb_parnl( 1 ), (wxControl *) xho_par_XhoObject( 2 ) );
        xho_itemNewReturn( "wxToolBarToolBase", tbtb, toolBar );
    }
}

/*
 wxToolBar:InsertSeparator
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_INSERTSEPARATOR )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    wxToolBarToolBase* tbtb = toolBar->InsertSeparator( hb_parnl( 1 ) );
        xho_itemNewReturn( "wxToolBarToolBase", tbtb, toolBar );
    }
}

/*
 wxToolBar:Realize
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_REALIZE )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    hb_retl( toolBar->Realize() );
    }
}

/*
 wxToolBar:RemoveTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_REMOVETOOL )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    xho_itemReturn( toolBar->RemoveTool( hb_parni( 1 ) ) );
    }
}

/*
 wxToolBar:SetBitmapResource
 Teo. Mexico 2009
 */
#ifdef __WXWINCE__
HB_FUNC( WXTOOLBAR_SETBITMAPRESOURCE )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    toolBar->SetBitmapResource( hb_parni( 1 ) );
    }
}
#endif

/*
 wxToolBar:SetMargins
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETMARGINS )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    if( hb_pcount() == 2 )
    {
        toolBar->SetMargins( hb_parni( 1 ), hb_parni( 2 ) );
    }
#if 0   // Compiles on MacOS, doesn't in Linux (wx 2.8.10)
    else if( hb_pcount() == 1 )
    {
        toolBar->SetMargins( wxh_par_wxSize( 1 ) );
    }
#endif
    }
}

/*
 wxToolBar:SetToolBitmapSize
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLBITMAPSIZE )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    toolBar->SetToolBitmapSize( wxh_par_wxSize( 1 ) );
    }
}

/*
 wxToolBar:SetToolClientData
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLCLIENTDATA )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    toolBar->SetToolClientData( hb_parni( 1 ), xho_par_XhoObject( 1 ) );
    }
}

/*
 wxToolBar:SetToolDisabledBitmap
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLDISABLEDBITMAP )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    toolBar->SetToolDisabledBitmap( hb_parni( 1 ), * (wxBitmap *) xho_par_XhoObject( 1 ) );
    }
}

/*
 wxToolBar:SetToolLongHelp
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLLONGHELP )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    toolBar->SetToolLongHelp( hb_parni( 1 ), wxh_parc( 2 ) );
    }
}

/*
 wxToolBar:SetToolPacking
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLPACKING )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    toolBar->SetToolPacking( hb_parni( 1 ) );
    }
}

/*
 wxToolBar:SetToolShortHelp
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLSHORTHELP )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    toolBar->SetToolShortHelp( hb_parni( 1 ), wxh_parc( 2 ) );
    }
}

/*
 wxToolBar:SetToolNormalBitmap
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLNORMALBITMAP )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    toolBar->SetToolNormalBitmap( hb_parni( 1 ), * (wxBitmap *) xho_par_XhoObject( 1 ) );
    }
}

/*
 wxToolBar:SetToolSeparation
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_SETTOOLSEPARATION )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    toolBar->SetToolSeparation( hb_parni( 1 ) );
    }
}

/*
 wxToolBar:ToggleTool
 Teo. Mexico 2009
 */
HB_FUNC( WXTOOLBAR_TOGGLETOOL )
{
    wxToolBar* toolBar = (wxToolBar *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( toolBar )
    {
    toolBar->ToggleTool( hb_parni( 1 ), hb_parl( 2 ) );
    }
}
