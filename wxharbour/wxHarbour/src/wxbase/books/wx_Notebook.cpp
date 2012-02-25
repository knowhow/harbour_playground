/*
 * $Id: wx_Notebook.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Notebook: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"
#include "wx/notebook.h"

#include "wxbase/wx_Notebook.h"

/*
    ~wx_Notebook
    Teo. Mexico 2009
*/
wx_Notebook::~wx_Notebook()
{
    xho_itemListDel_XHO( this );
}
/*
    wxNotebook(wxWindow* parent, wxWindowID id, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxString& name = wxNotebookNameStr)
    */

/*
    New
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_Notebook* noteBook;

    if( hb_pcount() )
    {
        wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
        wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
        const wxPoint& pos = ISNIL( 3 ) ? wxDefaultPosition : wxh_par_wxPoint( 3 );
        const wxSize& size = ISNIL( 4 ) ? wxDefaultSize : wxh_par_wxSize( 4 );
        long style = ISNIL( 5 ) ? 0 : hb_parnl( 5 );
        const wxString& name = ISNIL( 6 ) ? wxString( _T("noteBook") ) : wxh_parc( 6 );
        noteBook = new wx_Notebook( parent, id, pos, size, style, name );
    }
    else
        noteBook = new wx_Notebook();

    objParams.Return( noteBook );
}

/*
    wxNotebook:AddPage
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_ADDPAGE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    if( noteBook )
    {
        wxNotebookPage* page = (wxNotebookPage *) objParams.paramParent( 1 );
        if( page )
        {
            bool select = ISNIL( 3 ) ? false : hb_parl( 3 );
            int imageld = ISNIL( 4 ) ? -1 : hb_parni( 4 );
            hb_retl( noteBook->AddPage( page, wxh_parc( 2 ), select, imageld ) );
        }
    }
}

/*
    wxNotebook:AdvanceSelection
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_ADVANCESELECTION )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    if( noteBook )
    {
        bool forward = ISNIL( 1 ) ? true : hb_parl( 1 );
        noteBook->AdvanceSelection( forward );
    }
}

/*
    wxNotebook:AssignImageList
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_ASSIGNIMAGELIST )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    if( noteBook )
    {
        wxImageList *imageList = (wxImageList *) objParams.param( 1 );
        if( imageList )
        {
            noteBook->AssignImageList( imageList );
        }
    }
}

/*
    wxNotebook:ChangeSelection
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_CHANGESELECTION )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( noteBook && noteBook->GetPageCount() > page_i )
    {
        hb_retni( noteBook->ChangeSelection( page_i ) + 1 );
    }
}

/*
    wxNotebook:DeleteAllPages
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_DELETEALLPAGES )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    if( noteBook )
    {
        hb_retl( noteBook->DeleteAllPages() );
    }
}

/*
    wxNotebook:DeletePage
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_DELETEPAGE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( noteBook && noteBook->GetPageCount() > page_i )
    {
        hb_retl( noteBook->DeletePage( page_i ) );
    }
}

/*
    wxNotebook:GetCurrentPage
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETCURRENTPAGE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    if( noteBook )
    {
        xho_itemReturn( noteBook->GetCurrentPage() );
    }
}

/*
    wxNotebook:GetImageList
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETIMAGELIST )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    if( noteBook )
    {
        /* TODO: Check why it's neccesary to cast to wxObject* */
        xho_itemReturn( (wxObject *) noteBook->GetImageList() );
    }
}

/*
    wxNotebook:GetPage
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETPAGE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( noteBook && noteBook->GetPageCount() > page_i )
    {
        xho_itemReturn( noteBook->GetPage( page_i ) );
    }
}

/*
    wxNotebook:GetPageCount
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETPAGECOUNT )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    if( noteBook )
    {
        hb_retnl( noteBook->GetPageCount() );
    }
}

/*
    wxNotebook:GetPageImage
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETPAGEIMAGE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( noteBook && noteBook->GetPageCount() > page_i )
    {
        hb_retni( noteBook->GetPageImage( page_i ) );
    }
}

/*
    wxNotebook:GetPageText
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETPAGETEXT )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( noteBook && noteBook->GetPageCount() > page_i )
    {
        wxh_retc( noteBook->GetPageText( page_i ) );
    }
}

/*
    wxNotebook:GetRowCount
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETROWCOUNT )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    if( noteBook )
    {
        hb_retni( noteBook->GetRowCount() );
    }
}

/*
    wxNotebook:GetSelection
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_GETSELECTION )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    if( noteBook )
    {
        hb_retni( noteBook->GetSelection() + 1 );
    }
}

/*
    wxNotebook:GetThemeBackgroundColour
    Teo. Mexico 2009
*/
// HB_FUNC( WXNOTEBOOK_GETTHEMEBACKGROUNDCOLOUR )
// {
//   xho_ObjParams objParams = xho_ObjParams( NULL );
//
//   wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();
//
//   if( noteBook )
//   {
//     hb_itemReturn( xho_itemListGet_HB( noteBook->GetThemeBackgroundColour() ) );
//   }
// }

/*
    wxNotebook:HitTest
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_HITTEST )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    if( noteBook )
    {
        long flags;
        hb_retni( noteBook->HitTest( wxh_par_wxPoint( 1 ), &flags ) );
        if( ( hb_pcount() == 2 ) && ISBYREF( 2 ) )
            hb_stornl( flags, 2 );
    }
}

/*
    wxNotebook:InsertPage
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_INSERTPAGE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( noteBook && noteBook->GetPageCount() > page_i )
    {
        wxNotebookPage* page = (wxNotebookPage *) objParams.paramParent( 2 );
        if( page )
        {
            bool select = ISNIL( 4 ) ? false : hb_parl( 4 );
            int imageld = ISNIL( 5 ) ? -1 : hb_parni( 5 );
            hb_retl( noteBook->InsertPage( page_i, page, wxh_parc( 3 ), select, imageld ) );
        }
    }
}

/*
    wxNotebook:RemovePage
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_REMOVEPAGE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( noteBook && noteBook->GetPageCount() > page_i )
    {
        hb_retl( noteBook->RemovePage( page_i ) );
    }
}

/*
    wxNotebook:SetImageList
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_SETIMAGELIST )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    if( noteBook )
    {
        wxImageList *imageList = (wxImageList *) objParams.param( 1 );
        if( imageList )
        {
            noteBook->SetImageList( imageList );
        }
    }
}

/*
    wxNotebook:SetPadding
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_SETPADDING )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    if( noteBook )
    {
        noteBook->SetPadding( wxh_par_wxSize( 1 ) );
    }
}

/*
    wxNotebook:SetPageSize
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_SETPAGESIZE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    if( noteBook )
    {
        noteBook->SetPageSize( wxh_par_wxSize( 1 ) );
    }
}

/*
    wxNotebook:SetPageImage
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_SETPAGEIMAGE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( noteBook && noteBook->GetPageCount() > page_i )
    {
        hb_retl( noteBook->SetPageImage( page_i, hb_parni( 2 ) ) );
    }
}

/*
    wxNotebook:SetPageText
    Teo. Mexico 2009
*/
HB_FUNC( WXNOTEBOOK_SETPAGETEXT )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();

    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( noteBook && noteBook->GetPageCount() > page_i )
    {
        hb_retl( noteBook->SetPageText( page_i, wxh_parc( 2 ) ) );
    }
}

/*
 wxNotebook:SetSelection
 Teo. Mexico 2009
 */
HB_FUNC( WXNOTEBOOK_SETSELECTION )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    
    wxNotebook* noteBook = (wxNotebook *) objParams.Get_xhoObject();
    
    size_t page_i = hb_parnl( 1 ) - 1;
    
    if( noteBook && noteBook->GetPageCount() > page_i )
    {
        hb_retni( noteBook->SetSelection( page_i ) + 1 );
    }
}
