/*
 * $Id: wx_TextCtrl.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_TextCtrl: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_Colour.h"
#include "wxbase/wx_TextCtrl.h"

/*
    ~wx_TextCtrl
    Teo. Mexico 2009
*/
wx_TextCtrl::~wx_TextCtrl()
{
    xho_itemListDel_XHO( this );
}

/*
    wxTextCtrl:New
    Teo. Mexico 2008
*/
HB_FUNC( WXTEXTCTRL_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = ISNIL(2) ? wxID_ANY : hb_parni( 2 );
    const wxString& value = wxh_parc( 3 );
    const wxPoint& pos = wxh_par_wxPoint( 4 );
    const wxSize& size = wxh_par_wxSize( 5 );
    long style = hb_parnl( 6 );
    const wxValidator& validator = ISNIL( 7 ) ? wxDefaultValidator : *( (wxValidator *) objParams.paramChild( 7 ) ) ;
    const wxString& name = wxh_parc( 8 );
    wx_TextCtrl* textCtrl = new wx_TextCtrl( parent, id, value, pos, size, style, validator, name );

    objParams.Return( textCtrl );
}

/*
    wxTextCtrl:AppendText
    Teo. Mexico 2008
*/
HB_FUNC( WXTEXTCTRL_APPENDTEXT )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( textCtrl )
    {
        const wxString& text = wxh_parc( 1 );
        textCtrl->AppendText( text );
    }
}

/*
 wxTextCtrl:ChangeValue
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_CHANGEVALUE )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
    textCtrl->ChangeValue( wxh_parc( 1 ) );
}

/*
    wxTextCtrl:Clear
    Teo. Mexico 2008
*/
HB_FUNC( WXTEXTCTRL_CLEAR )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( textCtrl )
    {
        textCtrl->Clear();
    }
}

/*
 wxTextCtrl:DiscardEdits
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_DISCARDEDITS )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        textCtrl->DiscardEdits();
}

/*
 wxTextCtrl:GetInsertionPoint
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_GETINSERTIONPOINT )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
    hb_retnl( textCtrl->GetInsertionPoint() );
}

/*
 wxTextCtrl:GetLastPosition
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_GETLASTPOSITION )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
    hb_retnl( textCtrl->GetLastPosition() );
}

/*
 wxTextCtrl:GetLineLength
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_GETLINELENGTH )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        hb_parni( textCtrl->GetLineLength( hb_parnl( 1 ) ) );
}

/*
 wxTextCtrl:GetLineText
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_GETLINETEXT )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        wxh_retc( textCtrl->GetLineText( hb_parnl( 1 ) ) );
}

/*
 wxTextCtrl:GetNumberOfLines
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_GETNUMBEROFLINES )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        hb_parni( textCtrl->GetNumberOfLines() );
}

/*
 wxTextCtrl:GetRange
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_GETRANGE )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        wxh_retc( textCtrl->GetRange( hb_parnl( 1 ), hb_parnl( 2 ) ) );
}

/*
 wxTextCtrl:GetStringSelection
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_GETSTRINGSELECTION )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        wxh_retc( textCtrl->GetStringSelection() );
}

/*
 wxTextCtrl:GetValue
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_GETVALUE )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        wxh_retc( textCtrl->GetValue() );
}

/*
 wxTextCtrl:IsEditable
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_ISEDITABLE )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
    hb_retl( textCtrl->IsEditable() );
}

/*
 wxTextCtrl:IsEmpty
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_ISEMPTY )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        hb_retl( textCtrl->IsEmpty() );
}

/*
 wxTextCtrl:IsModified
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_ISMODIFIED )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        hb_retl( textCtrl->IsModified() );
}

/*
    wxTextCtrl:IsMultiLine
    Teo. Mexico 2009
*/
HB_FUNC( WXTEXTCTRL_ISMULTILINE )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( textCtrl )
        hb_retl( textCtrl->IsMultiLine() );
}

/*
 wxTextCtrl:IsSingleLine
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_ISSINGLELINE )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
    hb_retl( textCtrl->IsSingleLine() );
}

/*
 wxTextCtrl:LoadFile
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_LOADFILE )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        hb_retl( textCtrl->LoadFile( wxh_parc( 1 ), hb_parni( 2 ) ) );
}

/*
 wxTextCtrl:MarkDirty
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_MARKDIRTY )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        textCtrl->MarkDirty();
}

/*
 wxTextCtrl:SaveFile
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_SAVEFILE )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        hb_retl( textCtrl->SaveFile( wxh_parc( 1 ), hb_parni( 2 ) ) );
}

/*
 wxTextCtrl:SetEditable
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_SETEDITABLE )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
    {
    bool editable = hb_pcount() == 0 ? true : hb_parl( 1 );
        textCtrl->SetEditable( editable );
    }
}

/*
 wxTextCtrl:SetInsertionPoint
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_SETINSERTIONPOINT )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        textCtrl->SetInsertionPoint( hb_parnl( 1 ) );
}

/*
 wxTextCtrl:SetInsertionPointEnd
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_SETINSERTIONPOINTEND )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        textCtrl->SetInsertionPointEnd();
}

/*
 wxTextCtrl:SetMaxLength
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_SETMAXLENGTH )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        textCtrl->SetMaxLength( ( ULONG ) hb_parnl( 1 ) );
}

/*
 wxTextCtrl:SetModified
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_SETMODIFIED )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
    {
    bool modified = hb_pcount() == 0 ? true : hb_parl( 1 );
        textCtrl->SetModified( modified );
    }
}

/*
 wxTextCtrl:SetSelection
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_SETSELECTION )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
    textCtrl->SetSelection( ISNIL( 1 ) ? -1 : hb_parnl( 1 ), ISNIL( 2 ) ? -1 : hb_parnl( 2 ) );
}

/*
    wxTextCtrl:SetValue
    Teo. Mexico 2009
*/
HB_FUNC( WXTEXTCTRL_SETVALUE )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( textCtrl )
    {
        const wxString& text = wxh_parc( 1 );
        textCtrl->SetValue( text );
    }
}

/*
 wxTextCtrl:ShowPosition
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_SHOWPOSITION )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        textCtrl->ShowPosition( hb_parnl( 1 ) );
}

/*
 wxTextCtrl:WriteText
 Teo. Mexico 2009
 */
HB_FUNC( WXTEXTCTRL_WRITETEXT )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( textCtrl )
        textCtrl->WriteText( wxh_parc( 1 ) );
}

/*
 wxTextCtrl:SetBackgroundColour
 jamaj Brasil 2009
 */
HB_FUNC( WXTEXTCTRL_SETBACKGROUNDCOLOUR )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );
 
    if( textCtrl )
    {
        if (hb_pcount() == 3)
        {
            wxColour* color;
            color = new wxColour((unsigned char)hb_parni( 1 ),(unsigned char)hb_parni( 2 ),(unsigned char)hb_parni( 3 ), (unsigned char)255 );
            textCtrl->SetBackgroundColour( *color );
        }
        else if (hb_pcount() == 4)
        {
            wxColour* color;
            color = new wxColour((unsigned char)hb_parni( 1 ),(unsigned char)hb_parni( 2 ),(unsigned char)hb_parni( 3 ), (unsigned char)hb_parni( 4 ) );
            textCtrl->SetBackgroundColour( *color );
        }
        else if (hb_pcount() == 1 && ISARRAY(1) )
        {
            PHB_ITEM pArray = hb_param( 1, HB_IT_ARRAY );
            if (hb_arrayLen( pArray ) == 3)
            {
                wxColour* color;
                unsigned char r,g,b;
                r = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 1 ) );
                g = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 2 ) );
                b = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 3 ) );
                color = new wxColour( r, g, b, (unsigned char)255 );
                textCtrl->SetBackgroundColour( *color );
            }
            else if (hb_arrayLen( pArray ) == 4)
            {
                wxColour* color;
                unsigned char r,g,b,a;
                r = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 1 ) );
                g = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 2 ) );
                b = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 3 ) );
                a = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 4 ) );
                color = new wxColour( r, g, b, a );
                textCtrl->SetBackgroundColour( *color );
            }
        }
        else if (hb_pcount() == 1 && ISOBJECT(1) )			
        {
            const wxColour& color = * (wxColour *) xho_par_XhoObject( 1 );
            textCtrl->SetBackgroundColour( color );
        }
    }
}

/*
 wxTextCtrl:SetForegroundColour
 jamaj Brasil 2009
 */
HB_FUNC( WXTEXTCTRL_SETFOREGROUNDCOLOUR )
{
    wxTextCtrl* textCtrl = (wxTextCtrl *) xho_itemListGet_XHO( hb_stackSelfItem() );


    if( textCtrl )
    {
        if (hb_pcount() == 3)
        {
            wxColour* color;
            color = new wxColour((unsigned char)hb_parni( 1 ),(unsigned char)hb_parni( 2 ),(unsigned char)hb_parni( 3 ), (unsigned char)255 );
            textCtrl->SetForegroundColour( *color );
        }
        else if (hb_pcount() == 4)
        {
            wxColour* color;
            color = new wxColour((unsigned char)hb_parni( 1 ),(unsigned char)hb_parni( 2 ),(unsigned char)hb_parni( 3 ), (unsigned char)hb_parni( 4 ) );
            textCtrl->SetForegroundColour( *color );
        }
        else if (hb_pcount() == 1 && ISARRAY(1) )
        {
            PHB_ITEM pArray = hb_param( 1, HB_IT_ARRAY );
            if (hb_arrayLen( pArray ) == 3)
            {
                unsigned char r,g,b;
                wxColour* color;
                r = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 1 ) );
                g = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 2 ) );
                b = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 3 ) );
                color =  new wxColour( r, g, b, (unsigned char)255 );
                textCtrl->SetForegroundColour( *color );
            }
            else if (hb_arrayLen( pArray ) == 4)
            {
                unsigned char r,g,b,a;
                wxColour* color;
                r = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 1 ) );
                g = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 2 ) );
                b = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 3 ) );
                a = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 4 ) );
                color = new wxColour( r, g, b, a );
                textCtrl->SetForegroundColour( *color );
            }
        }
        else if (hb_pcount() == 1 && ISOBJECT(1) )			
        {
            const wxColour& color = * (wxColour *) xho_par_XhoObject( 1 );
            textCtrl->SetForegroundColour( color );
        }
    }
}


