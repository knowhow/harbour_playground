/*
 * $Id: wx_FileDialog.cpp 743 2011-07-27 18:26:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_FileDialog.h"

/*
    ~wxFileDialog
    Teo. Mexico 2008
*/
wx_FileDialog::~wx_FileDialog()
{
    xho_itemListDel_XHO( this );
}

/*
    wxFileDialog
    Teo. Mexico 2009
*/
HB_FUNC( WXFILEDIALOG_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    const wxString& message = HB_ISNIL( 2 ) ? wxString( _T("Choose a file") ) : wxh_parc( 2 );
    const wxString& defaultDir = wxh_parc( 3 );
    const wxString& defaultFile = wxh_parc( 4 );
    const wxString& wildcard = HB_ISNIL( 5 ) ? wxString( _T("*.*") ) : wxh_parc( 5 );
    long style = HB_ISNIL( 6 )  ? wxFD_DEFAULT_STYLE : hb_parni( 6 );
    wxPoint pos = wxh_par_wxPoint( 7 );
    wxSize size = wxh_par_wxSize( 8 );
    const wxString& name = HB_ISNIL( 9 ) ? wxString( _T("FileDlg") ) : wxh_parc( 9 );

    wxFileDialog* fileDlg = new wx_FileDialog( parent, message, defaultDir, defaultFile, wildcard, style, pos, size, name );

    objParams.Return( fileDlg );
}

/*
    GetDirectory
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETDIRECTORY )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    if( fileDlg )
        wxh_retc( fileDlg->GetDirectory() );
}

/*
    GetFilename
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETFILENAME )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    if( fileDlg )
        wxh_retc( fileDlg->GetFilename() );
}

/*
    GetFilenames
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETFILENAMES )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    wxArrayString filenames;

    if( fileDlg )
    {
        PHB_ITEM pResult = hb_itemArrayNew( 0 );
        fileDlg->GetFilenames( filenames );
        size_t count = filenames.GetCount();
        if( hb_arraySize( pResult, count ) )
        {
            for( size_t n = 0; n < count; n++ )
            {
                hb_itemPutC( hb_arrayGetItemPtr( pResult, n + 1 ), filenames[ n ].mb_str() );
            }
            hb_itemReturnRelease( pResult );
            return;
        }
        hb_itemRelease( pResult );
    }
}

/*
    GetFilterIndex
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETFILTERINDEX )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    if( fileDlg )
        hb_retni( fileDlg->GetFilterIndex() );
}

/*
    GetMessage
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETMESSAGE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    if( fileDlg )
        wxh_retc( fileDlg->GetMessage() );
}

/*
    GetPath
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETPATH )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    if( fileDlg )
        wxh_retc( fileDlg->GetPath() );
}

/*
    GetPaths
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETPATHS )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    wxArrayString paths;

    if( fileDlg )
    {
        PHB_ITEM pResult = hb_itemArrayNew( 0 );
        fileDlg->GetPaths( paths );
        size_t count = paths.GetCount();
        if( hb_arraySize( pResult, count ) )
        {
            for( size_t n = 0; n < count; n++ )
            {
                hb_itemPutC( hb_arrayGetItemPtr( pResult, n + 1 ), paths[ n ].mb_str() );
            }
            hb_itemReturnRelease( pResult );
            return;
        }
        hb_itemRelease( pResult );
    }
}

/*
    GetWildcard
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_GETWILDCARD )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    if( fileDlg )
        wxh_retc( fileDlg->GetWildcard() );
}

/*
    SetDirectory
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_SETDIRECTORY )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    if( fileDlg )
    {
        const wxString& directory = wxh_parc( 1 );
        fileDlg->SetDirectory( directory );
    }
}

/*
    SetFilename
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_SETFILENAME )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    if( fileDlg )
    {
        const wxString& filename = wxh_parc( 1 );
        fileDlg->SetFilename( filename );
    }
}

/*
    SetFilterIndex
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_SETFILTERINDEX )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    if( fileDlg )
    {
        int filterIndex = hb_parni( 1 );
        fileDlg->SetFilterIndex( filterIndex );
    }
}

/*
    SetMessage
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_SETMESSAGE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    if( fileDlg )
    {
        const wxString& message = wxh_parc( 1 );
        fileDlg->SetMessage( message );
    }
}

/*
    SetPath
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_SETPATH )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    if( fileDlg )
    {
        const wxString& path = wxh_parc( 1 );
        fileDlg->SetPath( path );
    }
}

/*
    SetWildcard
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_SETWILDCARD )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    if( fileDlg )
    {
        const wxString& wildcard = wxh_parc( 1 );
        fileDlg->SetWildcard( wildcard );
    }
}

/*
    ShowModal
    Teo. Mexico 2008
*/
HB_FUNC( WXFILEDIALOG_SHOWMODAL )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxFileDialog* fileDlg = (wxFileDialog *) xho_itemListGet_XHO( pSelf );

    if( fileDlg )
        hb_retni( fileDlg->ShowModal() );
}
