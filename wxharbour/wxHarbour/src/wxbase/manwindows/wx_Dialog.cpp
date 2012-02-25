/*
 * $Id: wx_Dialog.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Dialog: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_Dialog.h"

using namespace std;

/*
    Constructor
    Teo. Mexico 2006
*/
wx_Dialog::wx_Dialog( wxWindow* parent, wxWindowID id, const wxString& title, const wxPoint& pos, const wxSize& size, long style, const wxString& name )
{
    Create( parent, id, title, pos, size, style, name );
}

/*
    Constructor: Object
    Teo. Mexico 2006
*/
HB_FUNC( WXDIALOG_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_Dialog* dialog;

    if(hb_pcount())
    {
        wxWindow* parent = (wxDialog *) objParams.paramParent( 1 );
        wxWindowID id = ISNIL(2) ? wxID_ANY : hb_parni( 2 );
        const wxString& title = wxh_parc( 3 );
        wxPoint point = wxh_par_wxPoint(4);
        wxSize size = wxh_par_wxSize(5);
        long style = ISNIL( 6 ) ? wxDEFAULT_DIALOG_STYLE : hb_parnl( 6 );
        wxString name = wxh_parc( 7 );
        dialog = new wx_Dialog( parent, id, title, point, size, style, name );
    }
    else
        dialog = new wx_Dialog( NULL );

    objParams.Return( dialog );
}

/*
    wxDialog::Centre( int direction = wxBOTH )
    RETURN void
    Teo. Mexico 2006
*/
HB_FUNC( WXDIALOG_CENTRE )
{
    wx_Dialog* dialog = (wx_Dialog *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( dialog )
    {
        int direction = ISNIL( 1 ) ? wxBOTH : hb_parni( 1 );
        dialog->Centre( direction );
    }
}

/*
    wxDialog::CreateButtonSizer( long flags )
    RETURN NIL (wxSizer*)
    Teo. Mexico 2006
*/
HB_FUNC( WXDIALOG_CREATEBUTTONSIZER )
{
    wx_Dialog* dialog = (wx_Dialog *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( dialog )
    {
        xho_itemNewReturn( "wxSizer", dialog->CreateButtonSizer( hb_parnl( 1 ) ) );
    }
}

/*
 wxDialog::CreateSeparatedButtonSizer( long flags )
 Teo. Mexico 2006
 */
HB_FUNC( WXDIALOG_CREATESEPARATEDBUTTONSIZER )
{
    wx_Dialog* dialog = (wx_Dialog *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( dialog )
    {
        xho_itemNewReturn( "wxSizer", dialog->CreateSeparatedButtonSizer( hb_parnl( 1 ) ) );
    }
}

/*
 wxDialog::CreateStdDialogButtonSizer( long flags )
 Teo. Mexico 2006
 */
HB_FUNC( WXDIALOG_CREATESTDDIALOGBUTTONSIZER )
{
    wx_Dialog* dialog = (wx_Dialog *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( dialog )
    {
        xho_itemNewReturn( "wxBoxSizer", dialog->CreateStdDialogButtonSizer( hb_parnl( 1 ) ) );
    }
}

/*
 * wxDialog::EndModal()
 * Teo. Mexico 2008
 */
HB_FUNC( WXDIALOG_ENDMODAL )
{
    wx_Dialog* dialog = (wx_Dialog *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( dialog )
        dialog->EndModal( hb_parni( 1 ) );
}

/*
 * wxDialog::GetAffirmativeId()
 * Teo. Mexico 2009
 */
HB_FUNC( WXDIALOG_GETAFFIRMATIVEID )
{
    wx_Dialog* dialog = (wx_Dialog *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( dialog )
        hb_retni( dialog->GetAffirmativeId() );
}

/*
 * wxDialog::GetEscapeId()
 * Teo. Mexico 2009
 */
HB_FUNC( WXDIALOG_GETESCAPEID )
{
    wx_Dialog* dialog = (wx_Dialog *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( dialog )
        hb_retni( dialog->GetEscapeId() );
}

/*
 * wxDialog::GetReturnCode()
 * Teo. Mexico 2008
 */
HB_FUNC( WXDIALOG_GETRETURNCODE )
{
    wx_Dialog* dialog = (wx_Dialog *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( dialog )
        hb_retni( dialog->GetReturnCode() );
}

/*
 * wxDialog::SetAffirmativeId()
 * Teo. Mexico 2009
 */
HB_FUNC( WXDIALOG_SETAFFIRMATIVEID )
{
    wx_Dialog* dialog = (wx_Dialog *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( dialog )
        dialog->SetAffirmativeId( hb_parni( 1 ) );
}

/*
 * wxDialog::SetEscapeId()
 * Teo. Mexico 2009
 */
HB_FUNC( WXDIALOG_SETESCAPEID )
{
    wx_Dialog* dialog = (wx_Dialog *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( dialog )
        dialog->SetEscapeId( hb_parni( 1 ) );
}

/*
    wxDialog::Show( const bool show )
    RETURN bool
    Teo. Mexico 2006
*/
HB_FUNC( WXDIALOG_SHOW )
{
    wx_Dialog* dialog = (wx_Dialog *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( dialog )
        hb_retl( dialog->Show( hb_parl( 1 ) ) );
}

/*
    wxDialog::ShowModal()
    RETURN int
    Teo. Mexico 2006
*/
HB_FUNC( WXDIALOG_SHOWMODAL )
{
    wx_Dialog* dialog = (wx_Dialog *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( dialog )
        hb_retni( dialog->ShowModal() );
}
