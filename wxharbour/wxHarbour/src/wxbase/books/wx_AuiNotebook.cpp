/*
 * $Id: wx_AuiNotebook.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_AuiNotebook: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"
#include "wx/notebook.h"

#include "wxbase/wx_AuiNotebook.h"

/*
    ~wx_AuiNotebook
    Teo. Mexico 2006
*/
wx_AuiNotebook::~wx_AuiNotebook()
{
    xho_itemListDel_XHO( this );
}
/*
    wxAuiNotebook:New
    Teo. Mexico 2008
*/
HB_FUNC( WXAUINOTEBOOK_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_AuiNotebook* auiNotebook;

    if( hb_pcount() )
    {
        wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
        wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
        const wxPoint& pos = ISNIL( 3 ) ? wxDefaultPosition : wxh_par_wxPoint( 3 );
        const wxSize& size = ISNIL( 4 ) ? wxDefaultSize : wxh_par_wxSize( 4 );
        long style = ISNIL( 5 ) ? wxAUI_NB_DEFAULT_STYLE : hb_parni( 5 );
        auiNotebook = new wx_AuiNotebook( parent, id, pos, size, style );
    }
    else
        auiNotebook = new wx_AuiNotebook();

    objParams.Return( auiNotebook );
}

/*
    wxAuiNotebook:AddPage
    Teo. Mexico 2007
*/
HB_FUNC( WXAUINOTEBOOK_ADDPAGE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_xhoObject();

    //const wxBitmap& bitmap = objParam.paramParent( 4 );
    if( auiNotebook )
    {
        wxWindow* page = (wxWindow *) objParams.paramParent( 1 );
        if( page )
        {
            bool select = ISNIL( 3 ) ? false : hb_parl( 3 );
            auiNotebook->AddPage( page, wxh_parc( 2 ), select/*, bitmap*/ );
        }
    }
}

/*
    wxAuiNotebook:DeletePage
    Teo. Mexico 2009
*/
HB_FUNC( WXAUINOTEBOOK_DELETEPAGE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_xhoObject();

    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( auiNotebook && auiNotebook->GetPageCount() > page_i )
    {
        hb_retl( auiNotebook->DeletePage( page_i ) );
    }
}

/*
    wxAuiNotebook:GetPage
    Teo. Mexico 2009
*/
HB_FUNC( WXAUINOTEBOOK_GETPAGE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_xhoObject();
    
    size_t page_i = hb_parnl( 1 ) - 1;

    if( auiNotebook && auiNotebook->GetPageCount() > page_i )
    {
        xho_itemReturn( auiNotebook->GetPage( page_i ) );
    }
}

/*
    wxAuiNotebook:GetPageCount
    Teo. Mexico 2009
*/
HB_FUNC( WXAUINOTEBOOK_GETPAGECOUNT )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_xhoObject();

    if( auiNotebook )
    {
        hb_retnl( auiNotebook->GetPageCount() );
    }
}

HB_FUNC( WXAUINOTEBOOK_GETPAGETEXT )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    
    wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_xhoObject();
    
    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( auiNotebook && auiNotebook->GetPageCount() > page_i )
    {
        wxh_retc( auiNotebook->GetPageText( page_i ) );
    }
}

/*
    wxAuiNotebook:GetSelection
    Teo. Mexico 2009
*/
HB_FUNC( WXAUINOTEBOOK_GETSELECTION )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_xhoObject();

    if( auiNotebook )
    {
        hb_retni( auiNotebook->GetSelection() + 1 );
    }
}

/*
    wxAuiNotebook:RemovePage
    Teo. Mexico 2009
*/
HB_FUNC( WXAUINOTEBOOK_REMOVEPAGE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_xhoObject();

    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( auiNotebook && auiNotebook->GetPageCount() > page_i )
    {
        hb_retl( auiNotebook->RemovePage( page_i ) );
    }
}

/*
    wxAuiNotebook:SetPageText
    Teo. Mexico 2009
*/
HB_FUNC( WXAUINOTEBOOK_SETPAGETEXT )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_xhoObject();

    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( auiNotebook && auiNotebook->GetPageCount() > page_i )
    {
        hb_retl( auiNotebook->SetPageText( page_i, wxh_parc( 2 ) ) );
    }
}

/*
    wxAuiNotebook:SetSelection
    Teo. Mexico 2009
*/
HB_FUNC( WXAUINOTEBOOK_SETSELECTION )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxAuiNotebook* auiNotebook = (wxAuiNotebook *) objParams.Get_xhoObject();

    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( auiNotebook && auiNotebook->GetPageCount() > page_i )
    {
        hb_retni( auiNotebook->SetSelection( page_i ) + 1 );
    }
}
