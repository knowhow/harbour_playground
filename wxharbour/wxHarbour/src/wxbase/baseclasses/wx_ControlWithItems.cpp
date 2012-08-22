/*
 * $Id: wx_ControlWithItems.cpp 743 2011-07-27 18:26:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_ControlWithItems: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

/*
    Append1
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_APPEND1 )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        hb_retni( ctrlWItms->Append( wxh_parc( 1 ) ) + 1 ); /* zero to one based arrays C++ -> HB */
    }
}

/*
    Append2
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_APPEND2 )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        ctrlWItms->Append( wxh_par_wxArrayString( 1 ) ); /* zero to one based arrays C++ -> HB */
    }
}

/*
    Clear
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_CLEAR )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        ctrlWItms->Clear();
    }
}

/*
    Delete
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_DELETE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        ctrlWItms->Delete( HB_UINT( hb_parni( 1 ) ) );
    }
}

/*
    FindString
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_FINDSTRING )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        bool caseSensitive = HB_ISNIL( 2 ) ? false : hb_parl( 2 );
        hb_retni( ctrlWItms->FindString( wxh_parc( 1 ), caseSensitive ) );
    }
}

/*
    GetCount
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_GETCOUNT )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        hb_retnint( ctrlWItms->GetCount() );
    }
}

/*
    GetSelection
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_GETSELECTION )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        hb_retni( ctrlWItms->GetSelection() );
    }
}

/*
    GetString
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_GETSTRING )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        wxh_retc( ctrlWItms->GetString( hb_parni( 1 ) ) );
    }
}

/*
    GetStrings
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_GETSTRINGS )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        wxArrayString arrayString = ctrlWItms->GetStrings();
        PHB_ITEM pArray = hb_itemArrayNew( arrayString.GetCount() );
        for( HB_ULONG ulI = 0; ulI < arrayString.GetCount(); ulI++ )
        {
            hb_arraySetC( pArray, ulI + 1, arrayString[ ulI ].mb_str() );
        }
        hb_itemReturnRelease( pArray );
    }
}

/*
    GetStringSelection
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_GETSTRINGSELECTION )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        wxh_retc( ctrlWItms->GetStringSelection() );
    }
}

/*
    Insert
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_INSERT )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        hb_retni( ctrlWItms->Insert( wxh_parc( 1 ), hb_parnint( 2 ) - 1 ) + 1 );
    }
}

/*
    IsEmpty
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_ISEMPTY )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        hb_retl( ctrlWItms->IsEmpty() );
    }
}

/*
    SetSelection
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_SETSELECTION )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        ctrlWItms->SetSelection( hb_parni( 1 ) - 1 ); /* HB arrays */
    }
}

/*
    SetString
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_SETSTRING )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        ctrlWItms->SetString( hb_parnint( 1 ), wxh_parc( 2 ) );
    }
}

/*
    SetStringSelection
    Teo. Mexico 2008
*/
HB_FUNC( WXCONTROLWITHITEMS_SETSTRINGSELECTION )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxControlWithItems* ctrlWItms = (wxControlWithItems *) xho_itemListGet_XHO( pSelf );

    if( ctrlWItms )
    {
        hb_retl( ctrlWItms->SetStringSelection( wxh_parc( 1 ) ) );
    }
}
