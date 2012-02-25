/*
 * $Id: wx_ScrolledWindow.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2010 Teo Fonrouge
 
 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 
 (C) 2010 Teo Fonrouge <teo@windtelsoft.com>
 */

/*
 wx_Window: Implementation
 Teo. Mexico 2010
 */

#include "wx/wx.h"

#include "wxh.h"

#include "wxbase/wx_ScrolledWindow.h"

/*
 ~wx_ScrolledWindow
 Teo. Mexico 2010
 */
wx_ScrolledWindow::~wx_ScrolledWindow()
{
    xho_itemListDel_XHO( this );
}

/*
 New
 Teo. Mexico 2010
 */
HB_FUNC( WXSCROLLEDWINDOW_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    
    wx_ScrolledWindow* scrolledWindow;

    if( hb_pcount() > 0 )
    {
        wxWindow* parent = (wxFrame *) objParams.paramParent( 1 );
        wxWindowID id = ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
        wxPoint pos = wxh_par_wxPoint( 3 );
        wxSize size = wxh_par_wxSize( 4 );
        long style = ISNIL( 5 ) ? wxHSCROLL | wxVSCROLL : hb_parnl( 5 );
        wxString name = wxh_parc( 6 );
        scrolledWindow = new wx_ScrolledWindow( parent, id, pos, size, style, name );
    }
    else
        scrolledWindow = new wx_ScrolledWindow( NULL );
    
    objParams.Return( scrolledWindow );
    
}

/*
 * CalcScrolledPosition
 */
HB_FUNC( WXSCROLLEDWINDOW_CALCSCROLLEDPOSITION )
{
    wx_ScrolledWindow* scrolledWindow = (wx_ScrolledWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( scrolledWindow )
    {
        int xx;
        int yy;

        scrolledWindow->CalcScrolledPosition( hb_parni( 1 ), hb_parni( 2 ), &xx, &yy );
        
        if( hb_param( 3, HB_IT_BYREF ) && hb_param( 4, HB_IT_BYREF ) )
        {
            hb_storni( 3, xx );
            hb_storni( 4, yy );
        }
        else
        {
            PHB_ITEM pArray = hb_itemNew( NULL );
            hb_arrayNew( pArray, 2 );
            hb_arraySetNI( pArray, 1, xx );
            hb_arraySetNI( pArray, 2, yy );
            hb_itemReturnRelease( pArray );
        }
    }
}

/*
 * CalcUnscrolledPosition
 */
HB_FUNC( WXSCROLLEDWINDOW_CALCUNSCROLLEDPOSITION )
{
    wx_ScrolledWindow* scrolledWindow = (wx_ScrolledWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( scrolledWindow )
    {
        int xx;
        int yy;
        
        scrolledWindow->CalcUnscrolledPosition( hb_parni( 1 ), hb_parni( 2 ), &xx, &yy );
        
        if( hb_param( 3, HB_IT_BYREF ) && hb_param( 4, HB_IT_BYREF ) )
        {
            hb_storni( 3, xx );
            hb_storni( 4, yy );
        }
        else
        {
            PHB_ITEM pArray = hb_itemNew( NULL );
            hb_arrayNew( pArray, 2 );
            hb_arraySetNI( pArray, 1, xx );
            hb_arraySetNI( pArray, 2, yy );
            hb_itemReturnRelease( pArray );
        }
    }
}

/*
 * EnableScrolling
 */
HB_FUNC( WXSCROLLEDWINDOW_ENABLESCROLLING )
{
    wx_ScrolledWindow* scrolledWindow = (wx_ScrolledWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( scrolledWindow )
    {
        scrolledWindow->EnableScrolling( hb_parl( 1 ), hb_parl( 2 ) );
    }
}

/*
 * GetScrollPixelsPerUnit
 */
HB_FUNC( WXSCROLLEDWINDOW_GETSCROLLPIXELSPERUNIT )
{
    wx_ScrolledWindow* scrolledWindow = (wx_ScrolledWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( scrolledWindow )
    {
        int xx;
        int yy;
        
        scrolledWindow->GetScrollPixelsPerUnit( &xx, &yy );
        
        if( hb_param( 1, HB_IT_BYREF ) && hb_param( 2, HB_IT_BYREF ) )
        {
            hb_storni( 1, xx );
            hb_storni( 2, yy );
        }
        else
        {
            PHB_ITEM pArray = hb_itemNew( NULL );
            hb_arrayNew( pArray, 2 );
            hb_arraySetNI( pArray, 1, xx );
            hb_arraySetNI( pArray, 2, yy );
            hb_itemReturnRelease( pArray );
        }
    }
}

/*
 * GetViewStart
 */
HB_FUNC( WXSCROLLEDWINDOW_GETVIEWSTART )
{
    wx_ScrolledWindow* scrolledWindow = (wx_ScrolledWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( scrolledWindow )
    {
        int xx;
        int yy;
        
        scrolledWindow->GetViewStart( &xx, &yy );
        
        if( hb_param( 1, HB_IT_BYREF ) && hb_param( 2, HB_IT_BYREF ) )
        {
            hb_storni( 1, xx );
            hb_storni( 2, yy );
        }
        else
        {
            PHB_ITEM pArray = hb_itemNew( NULL );
            hb_arrayNew( pArray, 2 );
            hb_arraySetNI( pArray, 1, xx );
            hb_arraySetNI( pArray, 2, yy );
            hb_itemReturnRelease( pArray );
        }
    }
}

/*
 * GetVirtualSize
 */
HB_FUNC( WXSCROLLEDWINDOW_GETVIRTUALSIZE )
{
    wx_ScrolledWindow* scrolledWindow = (wx_ScrolledWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( scrolledWindow )
    {
        int xx;
        int yy;
        
        scrolledWindow->GetVirtualSize( &xx, &yy );
        
        if( hb_param( 1, HB_IT_BYREF ) && hb_param( 2, HB_IT_BYREF ) )
        {
            hb_storni( 1, xx );
            hb_storni( 2, yy );
        }
        else
        {
            PHB_ITEM pArray = hb_itemNew( NULL );
            hb_arrayNew( pArray, 2 );
            hb_arraySetNI( pArray, 1, xx );
            hb_arraySetNI( pArray, 2, yy );
            hb_itemReturnRelease( pArray );
        }
    }
}

/*
 * IsRetained
 */
HB_FUNC( WXSCROLLEDWINDOW_ISRETAINED )
{
    wx_ScrolledWindow* scrolledWindow = (wx_ScrolledWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( scrolledWindow )
    {
        hb_retl( scrolledWindow->IsRetained() );
    }
}

/*
 * Scroll
 */
HB_FUNC( WXSCROLLEDWINDOW_SCROLL )
{
    wx_ScrolledWindow* scrolledWindow = (wx_ScrolledWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( scrolledWindow )
    {
        scrolledWindow->Scroll( hb_parni( 1 ), hb_parni( 2 ) );
    }
}

/*
 * SetScrollbars
 */
HB_FUNC( WXSCROLLEDWINDOW_SETSCROLLBARS )
{
    wx_ScrolledWindow* scrolledWindow = (wx_ScrolledWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( scrolledWindow )
    {
        scrolledWindow->SetScrollbars( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ), hb_parl( 7 ) );
    }
}

/*
 * SetScrollRate
 */
HB_FUNC( WXSCROLLEDWINDOW_SETSCROLLRATE )
{
    wx_ScrolledWindow* scrolledWindow = (wx_ScrolledWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( scrolledWindow )
    {
        scrolledWindow->SetScrollRate( hb_parni( 1 ), hb_parni( 2 ) );
    }
}

/*
 * SetTargetWindow
 */
HB_FUNC( WXSCROLLEDWINDOW_SETTARGETWINDOW )
{
    wx_ScrolledWindow* scrolledWindow = (wx_ScrolledWindow *) xho_itemListGet_XHO( hb_stackSelfItem() );
    
    if( scrolledWindow )
    {
        scrolledWindow->SetTargetWindow( (wxWindow *) xho_par_XhoObject( 1 ) );
    }
}
