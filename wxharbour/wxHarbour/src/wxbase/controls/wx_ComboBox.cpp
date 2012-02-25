/*
 * $Id: wx_ComboBox.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_ComboBox: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_ComboBox.h"

/*
    ~wx_ComboBox
    Teo. Mexico 2009
*/
wx_ComboBox::~wx_ComboBox()
{
    xho_itemListDel_XHO( this );
}

/*
    wxComboBox:New
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    //New( parent, id, value, pos, size, choices, style, validator, name )

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    const wxString& value = wxh_parc( 3 );
    const wxPoint& pos = wxh_par_wxPoint( 4 );
    const wxSize& size = wxh_par_wxSize( 5 );
    const wxArrayString& choices = wxh_par_wxArrayString( 6 );
    long style = hb_parnl( 7 );
    const wxValidator& validator = ISNIL( 8 ) ? wxDefaultValidator : (*((wxValidator *) objParams.param( 8 ))) ;
    const wxString& name = wxh_parc( 9 );

    wx_ComboBox* comboBox = new wx_ComboBox( parent, id, value, pos, size, choices, style, validator, name );

    objParams.Return( comboBox );
}

/*
    CanCopy
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_CANCOPY )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        hb_retl( comboBox->CanCopy() );
    }
}

/*
    CanCut
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_CANCUT )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        hb_retl( comboBox->CanCut() );
    }
}

/*
    CanPaste
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_CANPASTE )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        hb_retl( comboBox->CanPaste() );
    }
}

/*
    CanRedo
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_CANREDO )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        hb_retl( comboBox->CanRedo() );
    }
}

/*
    CanUndo
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_CANUNDO )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        hb_retl( comboBox->CanUndo() );
    }
}

/*
    Copy
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_COPY )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        comboBox->Copy();
    }
}

/*
    Cut
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_CUT )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        comboBox->Cut();
    }
}

/*
    GetCurrentSelection
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_GETCURRENTSELECTION )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        hb_retni( comboBox->GetCurrentSelection() + 1 ); /* zero to one based arrays C++ -> HB */
    }
}

/*
    GetInsertionPoint
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_GETINSERTIONPOINT )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        hb_retnl( comboBox->GetInsertionPoint() );
    }
}

/*
    GetSelection
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_GETSELECTION )
{
#if wxVERSION > 20804
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        //if( ISBYREF( 1 ) && ISBYREF( 2 ) )
        {
            //long from, to;
            //comboBox->GetSelection( &from, &to );
        hb_retni( comboBox->GetSelection() );
            //hb_stornl( from, 1 );
            //hb_stornl( to, 2 );
        }
        //else
            //hb_errRT_BASE( EG_ARG, 9999, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
    }
#endif
}

/*
    GetValue
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_GETVALUE )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        wxh_retc( comboBox->GetValue() );
    }
}

/*
    Paste
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_PASTE )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        comboBox->Paste();
    }
}

/*
    Redo
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_REDO )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        comboBox->Redo();
    }
}

/*
    Replace
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_REPLACE )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        comboBox->Replace( hb_parnl( 1 ), hb_parnl( 2 ), wxh_parc( 3 ) );
    }
}

/*
    Remove
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_REMOVE )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        comboBox->Remove( hb_parnl( 1 ), hb_parnl( 2 ) );
    }
}

/*
    SetInsertionPoint
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_SETINSERTIONPOINT )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        comboBox->SetInsertionPoint( hb_parnl( 1 ) );
    }
}

/*
    SetInsertionPointEnd
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_SETINSERTIONPOINTEND )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        comboBox->SetInsertionPointEnd();
    }
}

/*
    SetSelection
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_SETSELECTION )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        comboBox->SetSelection( hb_parnl( 1 ), hb_parnl( 2 ) );
    }
}

/*
    SetValue
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_SETVALUE )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        comboBox->SetValue( wxh_parc( 1 ) );
    }
}

/*
    Undo
    Teo. Mexico 2009
*/
HB_FUNC( WXCOMBOBOX_UNDO )
{
    wx_ComboBox* comboBox = (wx_ComboBox *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( comboBox )
    {
        comboBox->Undo();
    }
}
