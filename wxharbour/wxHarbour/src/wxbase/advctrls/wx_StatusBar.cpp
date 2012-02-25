/*
 * $Id: wx_StatusBar.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_StatusBar: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_StatusBar.h"

/*
    ~wx_StatusBar
    Teo. Mexico 2006
*/
wx_StatusBar::~wx_StatusBar()
{
    xho_itemListDel_XHO( this );
}

/*
    Constructor: wxStatusBar Object
    Teo. Mexico 2009
*/
HB_FUNC( WXSTATUSBAR_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = (wxWindowID) hb_parni( 2 );
    long style = ISNIL( 3 ) ? wxST_SIZEGRIP : hb_parnl( 3 );
    const wxString& name = ISNIL( 4 ) ? wxString( _T("statusBar") ) : wxh_parc( 4 );

    wx_StatusBar* statusBar = new wx_StatusBar( parent, id, style, name );

    objParams.Return( statusBar );
}

/*
    SetFieldsCount: message
    Teo. Mexico 2006
*/
HB_FUNC( WXSTATUSBAR_SETFIELDSCOUNT )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_StatusBar* statusBar = (wx_StatusBar *) xho_itemListGet_XHO( pSelf );

    int number = hb_parni(1);
    int* widths = NULL;

    if(ISARRAY(2) && hb_arrayLen( hb_param( 2, HB_IT_ARRAY ) ))
    {
        PHB_ITEM pArray = hb_param( 2, HB_IT_ARRAY );
        int* aInt = new int[ hb_arrayLen( pArray ) ];
        for( unsigned int i=0; i < hb_arrayLen( pArray ); i++ )
            aInt[i] = hb_itemGetNI( hb_arrayGetItemPtr( pArray, i+1 ) );
        widths = aInt;
        //if( pSelf && statusBar ) statusBar->SetFieldsCount( number, widths );
    }
    //else
        //if( pSelf && statusBar ) statusBar->SetFieldsCount( number, widths );
    if( pSelf && statusBar )
        statusBar->SetFieldsCount( number, widths );

    /* TODO: Check if this frees correctly the array */
    delete[] widths;

}

/*
    SetStatusText
    Teo. Mexico 2008
*/
HB_FUNC( WXSTATUSBAR_SETSTATUSTEXT )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_StatusBar* statusBar = (wx_StatusBar *) xho_itemListGet_XHO( pSelf );

    const wxString& text = wxh_parc( 1 );
    int i = hb_parni( 2 );

    if( pSelf && statusBar )
        statusBar->SetStatusText( text, i );
}
