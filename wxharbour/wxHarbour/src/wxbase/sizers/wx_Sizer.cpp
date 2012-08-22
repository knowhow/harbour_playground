/*
 * $Id: wx_Sizer.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Sizer: Implementation
    Teo. Mexico 2006
*/

/* C++ Abstract Class */

#include "wx/wx.h"

#include "wxh.h"

#include "wxbase/wx_Sizer.h"

/*
 * ChkFlagInParameter
 * Teo. USA 2010
 */
static int ChkFlagInParameter( int iParam )
{
    PHB_ITEM p = hb_param( iParam, HB_IT_ANY );

    if( p )
    {
        if( HB_IS_NUMERIC( p ) )
            return hb_itemGetNI( p );
        else if( HB_IS_ARRAY( p ) )
        {
            PHB_BASEARRAY pBaseArray = (HB_BASEARRAY *) hb_arrayId( p );
            int result = 0;
            HB_ULONG ulLen = hb_arrayLen( p );
            HB_ULONG ulIndex;
            for( ulIndex = 0; ulIndex < ulLen; ulIndex++ )
            {
                PHB_ITEM pItem = pBaseArray->pItems + ulIndex;
                if( HB_IS_NUMERIC( pItem ) )
                    result |= hb_itemGetNI( pItem );
            }
            return result;
        }
    }
    return 0;
}

/*
    wxSizer:Add Emulates Overload on Harbour method.
    Teo. Mexico 2007
*/
HB_FUNC( WXSIZER_ADD )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wxSizer* sizer = (wxSizer *) objParams.Get_xhoObject();

    if(sizer)
    {
        if( HB_ISOBJECT( 1 ) )
        {
            wxObject* obj = (wxObject *) objParams.param( 1 );
            if( obj->IsKindOf( CLASSINFO( wxWindow ) ) )
            {
                if( hb_pcount() == 2 )
                /*wxSizerItem* Add(wxWindow* window, const wxSizerFlags& flags)*/
                    sizer->Add( (wxWindow *) obj, ChkFlagInParameter( 2 ) ) ;
                else
                /*wxSizerItem* Add(wxWindow* window, int proportion = 0,int flag = 0, int border = 0, wxObject* userData = NULL)*/
                    sizer->Add( (wxWindow *) obj, HB_ISNIL( 2 ) ? 0 : hb_parnl( 2 ), ChkFlagInParameter( 3 ), HB_ISNIL( 4 ) ? 0 : hb_parnl( 4 ), HB_ISNIL( 5 ) ? NULL : (wxObject *) objParams.param( 5 ) );
            }
            else
                if( obj->IsKindOf( CLASSINFO( wxSizer ) ) )
                {
                    if( hb_pcount() == 2 )
                    /*wxSizerItem* Add(wxSizer* sizer, const wxSizerFlags& flags)*/
                        sizer->Add( (wxSizer *) objParams.paramChild( 1 ), ChkFlagInParameter( 2 ) ) ;
                    else
                    /*wxSizerItem* Add(wxSizer* sizer, int proportion = 0, int flag = 0, int border = 0, wxObject* userData = NULL)*/
                        sizer->Add( (wxSizer *) objParams.paramChild( 1 ), HB_ISNIL( 2 ) ? 0 : hb_parnl( 2 ), ChkFlagInParameter( 3 ), HB_ISNIL( 4 ) ? 0 : hb_parnl( 4 ), HB_ISNIL( 5 ) ? NULL : (wxObject *) objParams.param( 5 ) );
                }
        }
        else
            if( HB_ISNUM( 1 ) )
            /*wxSizerItem* Add(int width, int height, int proportion = 0, int flag = 0, int border = 0, wxObject* userData = NULL)*/
                sizer->Add( hb_parnl( 1 ), hb_parnl( 2 ), HB_ISNIL( 3 ) ? 0 : hb_parnl( 3 ), ChkFlagInParameter( 4 ), HB_ISNIL( 5 ) ? 0 : hb_parnl( 5 ), HB_ISNIL( 6 ) ? NULL : (wxObject *) objParams.param( 6 ) );
    }
}

/*
    SetSizeHints
    Teo. Mexico 2008
*/
HB_FUNC( WXSIZER_SETSIZEHINTS )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wxSizer* sizer = (wxSizer *) objParams.Get_xhoObject();

    if( sizer )
    {
        wxWindow* wnd = (wxWindow *) objParams.param( 1 );
        if( wnd )
            sizer->SetSizeHints( wnd );
    }
}
