/*
 * $Id: wx_HtmlWindow.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2010 Teo Fonrouge
 
 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 
 (C) 2010 Teo Fonrouge <teo@windtelsoft.com>
 */

/*
 wx_HtmlEasyPrinting: Implementation
 Teo. Mexico 2010
 */

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_HtmlWindow.h"

/*
 ~wx_HtmlWindow
 Teo. Mexico 2010
 */
wx_HtmlWindow::~wx_HtmlWindow()
{
    xho_itemListDel_XHO( this );
}

/*
 * OnOpeningURL
 */
wxHtmlOpeningStatus wx_HtmlWindow::OnOpeningURL( wxHtmlURLType type, const wxString& url, wxString *redirect )
{
    static PHB_DYNS s___OnOpeningURL = NULL;
    
    if(!s___OnOpeningURL)
        s___OnOpeningURL = hb_dynsymGetCase( "ONOPENINGURL" );

    PHB_ITEM hbRedirect = hb_itemPutC( NULL, redirect->mb_str() );
    
    hb_vmPushDynSym( s___OnOpeningURL );
    hb_vmPush( xho_itemListGet_HB( this ) );
    hb_vmPushInteger( type );
    hb_vmPushString( url.mb_str(), strlen( url.mb_str() ) );
    hb_vmPushItemRef( hbRedirect );
    
    hb_vmSend( 3 );
    
    *redirect = wxh_CTowxString( hb_itemGetCPtr( hbRedirect ) );

    hb_itemRelease( hbRedirect );

    return wxHtmlOpeningStatus( hb_itemGetNI( hb_stackReturnItem() ) );
}

/*
 * OnSetTitle
 */
void wx_HtmlWindow::OnSetTitle( const wxString& title )
{
    PHB_ITEM hbTitle = hb_itemNew( NULL );

    hb_itemPutC( hbTitle, title.mb_str() );
    
    hb_objSendMsg( xho_itemListGet_HB( this ), "OnSetTitle", 1, hbTitle );
    
    hb_itemRelease( hbTitle );
}

/*
 * New
 */
HB_FUNC( WXHTMLWINDOW_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    wxPoint pos = wxh_par_wxPoint( 3 );
    wxSize size = wxh_par_wxSize( 4 );
    long style = ISNIL( 5 ) ? wxHW_DEFAULT_STYLE : hb_parnl( 5 );
    wxString name = ISNIL( 6 ) ? _T("htmlWindow") : wxh_parc( 6 );

    objParams.Return( new wx_HtmlWindow( parent, id, pos, size, style, name ) );

}

/*
 * AppendToPage
 */
HB_FUNC( WXHTMLWINDOW_APPENDTOPAGE )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( htmlWindow )
    {
        hb_retl( htmlWindow->AppendToPage( wxh_parc( 1 ) ) );
    }
}

/*
 * GetOpenedAnchor
 */
HB_FUNC( WXHTMLWINDOW_GETOPENEDANCHOR )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        wxh_retc( htmlWindow->GetOpenedAnchor() );
    }
}

/*
 * GetOpenedPage
 */
HB_FUNC( WXHTMLWINDOW_GETOPENEDPAGE )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        wxh_retc( htmlWindow->GetOpenedPage() );
    }
}

/*
 * GetRelatedFrame
 */
HB_FUNC( WXHTMLWINDOW_GETRELATEDFRAME )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        xho_itemReturn( htmlWindow->GetRelatedFrame() );
    }
}

/*
 * HistoryBack
 */
HB_FUNC( WXHTMLWINDOW_HISTORYBACK )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        hb_retl( htmlWindow->HistoryBack() );
    }
}

/*
 * HistoryCanBack
 */
HB_FUNC( WXHTMLWINDOW_HISTORYCANBACK )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        hb_retl( htmlWindow->HistoryCanBack() );
    }
}

/*
 * HistoryCanForward
 */
HB_FUNC( WXHTMLWINDOW_HISTORYCANFORWARD )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        hb_retl( htmlWindow->HistoryCanForward() );
    }
}

/*
 * HistoryClear
 */
HB_FUNC( WXHTMLWINDOW_HISTORYCLEAR )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        htmlWindow->HistoryClear();
    }
}

/*
 * HistoryForward
 */
HB_FUNC( WXHTMLWINDOW_HISTORYFORWARD )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        hb_retl( htmlWindow->HistoryForward() );
    }
}

/*
 * LoadPage
 */
HB_FUNC( WXHTMLWINDOW_LOADPAGE )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        hb_retl( htmlWindow->LoadPage( wxh_parc( 1 ) ) );
    }
}

/*
 * SelectAll
 */
HB_FUNC( WXHTMLWINDOW_SELECTALL )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        htmlWindow->SelectAll();
    }
}

/*
 * SelectionToText
 */
HB_FUNC( WXHTMLWINDOW_SELECTIONTOTEXT )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        wxh_retc( htmlWindow->SelectionToText() );
    }
}

/*
 * SelectLine
 */
HB_FUNC( WXHTMLWINDOW_SELECTLINE )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        htmlWindow->SelectLine( wxh_par_wxPoint( 1 ) );
    }
}

/*
 * SelectWord
 */
HB_FUNC( WXHTMLWINDOW_SELECTWORD )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        htmlWindow->SelectWord( wxh_par_wxPoint( 1 ) );
    }
}

/*
 * SetBorders
 */
HB_FUNC( WXHTMLWINDOW_SETBORDERS )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        htmlWindow->SetBorders( hb_parni( 1 ) );
    }
}

/*
 * SetFonts
 */
HB_FUNC( WXHTMLWINDOW_SETFONTS )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        const int len = 7;
        const int* sizes = NULL;
        int aInt[ len ] = { 0, 0, 0, 0, 0, 0, 0 };
        
        if( hb_pcount() > 2 )
        {
            xho_par_arrayInt( 3, &aInt[ 0 ], len );
            sizes = &aInt[ 0 ];
        }

        htmlWindow->SetFonts( wxh_parc( 1 ), wxh_parc( 2 ), sizes );
    }
}

/*
 * SetPage
 */
HB_FUNC( WXHTMLWINDOW_SETPAGE )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        hb_retl( htmlWindow->SetPage( wxh_parc( 1 ) ) );
    }
}

/*
 * SetRelatedFrame
 */
HB_FUNC( WXHTMLWINDOW_SETRELATEDFRAME )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        htmlWindow->SetRelatedFrame( (wxFrame *) xho_par_XhoObject( 1 ), wxh_parc( 2 ) );
    }
}

/*
 * SetRelatedStatusBar
 */
HB_FUNC( WXHTMLWINDOW_SETRELATEDSTATUSBAR )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        htmlWindow->SetRelatedStatusBar( hb_parni( 1 ) );
    }
}

/*
 * ToText
 */
HB_FUNC( WXHTMLWINDOW_TOTEXT )
{
    wxHtmlWindow* htmlWindow = (wxHtmlWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( htmlWindow )
    {
        wxh_retc( htmlWindow->ToText() );
    }
}

