/*
 * $Id: wx_MessageDialog.cpp 660 2010-11-04 04:18:08Z tfonrouge $
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

#include "wxbase/wx_MessageDialog.h"

/*
    ~wx_MessageDialog
    Teo. Mexico 2008
*/
wx_MessageDialog::~wx_MessageDialog()
{
    xho_itemListDel_XHO( this );
}

/*
    wx_MessageDialog
    Teo. Mexico 2009
*/
HB_FUNC( WXMESSAGEDIALOG_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    const wxString& message = wxh_parc( 2 );
    const wxString& caption = ISNIL( 3 ) ? wxString( _T("Message box") ) : wxh_parc( 3 );
    long style = ISNIL( 4 ) ? wxOK | wxCANCEL : hb_parni( 4 );
    wxPoint pos = wxh_par_wxPoint( 5 );

    wx_MessageDialog* msgDlg = new wx_MessageDialog( parent, message, caption, style, pos );

    objParams.Return( msgDlg );
}

/*
    ShowModal
    Teo. Mexico 2008
*/
HB_FUNC( WXMESSAGEDIALOG_SHOWMODAL )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_MessageDialog* msgDlg = (wx_MessageDialog *) xho_itemListGet_XHO( pSelf );

    if( msgDlg )
        hb_retni( msgDlg->ShowModal() );
}
