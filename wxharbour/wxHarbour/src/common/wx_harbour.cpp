/*
 * $Id: wx_harbour.cpp 666 2010-12-03 15:11:52Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxharbour:
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wx/strconv.h"
#include "wx/hashset.h"
#include "wxh.h"

#include "hbapicdp.h"
#include "hbdate.h"

/*
 WXHBaseClass:ObjectH : returns the harbour's object handle
 Teo. Mexico 2009
 */
HB_FUNC( WXHBASECLASS_OBJECTH )
{
    PHB_ITEM pSelf = hb_stackSelfItem();

    if( pSelf )
        hb_retptr( hb_arrayId( pSelf ) );
}

/*
 wxh_itemNullObject
 Teo. Mexico 2009
 */
PHB_ITEM wxh_itemNullObject( PHB_ITEM pSelf )
{
    if( HB_IS_OBJECT( pSelf ) )
    {
        //hb_gcRefDec( hb_arrayId( pSelf ) );
    }

    return pSelf;
}

HB_FUNC( WXH_NULLOBJECT )
{
    hb_itemReturn( wxh_itemNullObject( hb_param( 1, HB_IT_OBJECT ) ) );
}

HB_FUNC( WXH_DESTROYNULLOBJECT )
{
    PHB_ITEM pSelf = hb_param( 1, HB_IT_OBJECT );
    
    if ( pSelf ) 
    {
        pSelf->type = HB_IT_NIL;
    }
}

/*
 wxh_par_wxArrayString
 Teo. Mexico 2009
 */
wxArrayString wxh_par_wxArrayString( int param )
{
    wxArrayString arrayString;
    
    if( ISARRAY( param ) )
    {
        PHB_ITEM pArray = hb_param( param, HB_IT_ARRAY );
        PHB_ITEM pItm;
        ULONG ulLen = hb_arrayLen( pArray );
        for( ULONG ulI = 1; ulI <= ulLen; ulI++ )
        {
            pItm = hb_arrayGetItemPtr( pArray, ulI );
            if( hb_itemType( pItm ) && ( HB_IT_STRING || HB_IT_MEMO ) )
            {
                arrayString.Add( wxh_CTowxString( hb_itemGetCPtr( pItm ) ) );
            }
        }
    }
    
    return arrayString;
}

/*
 wxh_par_wxColour
 Teo. Mexico 2009
 */
wxColour wxh_par_wxColour( int param )
{
    PHB_ITEM pItem = hb_param( param, HB_IT_ANY );
    
    switch ( hb_itemType( pItem ) )
    {
        case HB_IT_STRING:
            return wxColour( wxh_parc( param ) );
        default:
            break;
    }
    return wxColour();
}

/*
 wxh_par_wxDateTime
 Teo. Mexico 2009
 */
wxDateTime wxh_par_wxDateTime( int param )
{
    long lDate = hb_pardl( param );
    int iYear, iMonth, iDay;
    hb_dateDecode( lDate, &iYear, &iMonth, &iDay );
    return wxDateTime( iDay, (wxDateTime::Month) (iMonth - 1), iYear, 0, 0, 0, 0 );
}

/*
    wxh_par_wxPoint
    Teo. Mexico 2009
*/
wxPoint wxh_par_wxPoint( int param )
{
    PHB_ITEM pStruct = hb_param( param, HB_IT_ARRAY );
    if( pStruct && hb_arrayLen( pStruct ) == 2 )
    {
        PHB_ITEM p1,p2;
        p1 = hb_arrayGetItemPtr( pStruct, 1 );
        p2 = hb_arrayGetItemPtr( pStruct, 2 );
        int x = HB_IS_NUMERIC( p1 ) ? hb_itemGetNI( p1 ) : -1;
        int y = HB_IS_NUMERIC( p2 ) ? hb_itemGetNI( p2 ) : -1;
        return wxPoint( x, y );
    }
    else
        return wxPoint( -1, -1 );
}

/*
    wxh_par_wxSize
    Teo. Mexico 2009
*/
wxSize wxh_par_wxSize( int param )
{
    PHB_ITEM pStruct = hb_param( param, HB_IT_ARRAY );
    if( pStruct && hb_arrayLen( pStruct ) == 2 )
    {
        PHB_ITEM pWidth,pHeight;
        pWidth = hb_arrayGetItemPtr( pStruct, 1 );
        pHeight = hb_arrayGetItemPtr( pStruct, 2 );
        int iWidth = HB_IS_NUMERIC( pWidth ) ? hb_itemGetNI( pWidth ) : -1;
        int iHeight = HB_IS_NUMERIC( pHeight ) ? hb_itemGetNI( pHeight ) : -1;
        return wxSize( iWidth, iHeight );
    }
    else
        return wxSize( -1, -1 );
}

/*
    wxh_CTowxString
    Teo. Mexico 2009
*/
wxString wxh_CTowxString( const char * szStr, bool convOEM )
{
#ifdef _UNICODE
    const wxMBConv& mbConv = wxConvUTF8;

    if( convOEM && szStr )
    {
        ULONG ulStrLen = strlen( szStr );
        PHB_CODEPAGE pcp = hb_vmCDP();

        if( ulStrLen > 0 && pcp )
        {
            wxString wxStr;
            ULONG ulUTF8Len = hb_cdpUTF8StringLength( szStr, ulStrLen );
            char *strUTF8 = (char *) hb_xgrab( ulUTF8Len + 1 );
            hb_cdpStrToUTF8( pcp, false, szStr, ulStrLen, (char *) strUTF8, ulUTF8Len + 1 );
            wxStr = wxString( strUTF8, mbConv );
            hb_xfree( strUTF8 );
            return wxStr;
        }
    }
#else
    const wxMBConv& mbConv = wxConvLocal;

    HB_SYMBOL_UNUSED( convOEM );

#endif

    return wxString( szStr, mbConv );
}

/*
 wxh_parc
 Teo. Mexico 2009
 */
wxString wxh_parc( int param )
{
    return wxh_CTowxString( hb_parc( param ) );
}

/*
 wxh_ret_wxSize
 Teo. Mexico 2009
 */
void wxh_ret_wxSize( wxSize* size )
{
    PHB_ITEM pSize = hb_itemNew( NULL );
    hb_arrayNew( pSize, 2 );
    hb_arraySetNI( pSize, 1, size->GetWidth() );
    hb_arraySetNI( pSize, 2, size->GetHeight() );
    hb_itemReturnRelease( pSize );
}

/*
 wxh_ret_wxPoint
 Teo. Mexico 2009
 */
void wxh_ret_wxPoint( const wxPoint& point )
{
    PHB_ITEM pPoint = hb_itemNew( NULL );
    hb_arrayNew( pPoint, 2 );
    hb_arraySetNI( pPoint, 1, point.x );
    hb_arraySetNI( pPoint, 2, point.y );
    hb_itemReturnRelease( pPoint );
}

/*
    wxh_retc
    Teo. Mexico 2009
 */
void wxh_retc( const wxString & string )
{
    hb_retc( wxh_wxStringToC( string ) );
}

/*
    wxMutexGuiEnter
    Teo. Mexico 2009
*/
HB_FUNC( WXMUTEXGUIENTER )
{
    wxMutexGuiEnter();
}

/*
    wxMutexGuiLeave
    Teo. Mexico 2009
*/
HB_FUNC( WXMUTEXGUILEAVE )
{
    wxMutexGuiLeave();
}

/*
    wxh_AddNavigationKeyEvent( wxEvtHandler, direction AS LOGICAL )
    Teo. Mexico 2009
*/
HB_FUNC( WXH_ADDNAVIGATIONKEYEVENT )
{
    wxEvtHandler* evtHandler = (wxEvtHandler *) xho_par_XhoObject( 1 );
    bool bDirection = ISNIL( 2 ) ? true : hb_parl( 2 );

    wxNavigationKeyEvent navEvent;
    navEvent.SetEventObject( evtHandler );
    navEvent.SetDirection( bDirection );
    hb_retl( evtHandler->ProcessEvent( navEvent ) );
}

/*
    wxh_L2BEBin
    Teo. Mexico 2010
 */
HB_FUNC( WXH_L2BEBIN )
{
    char szResult[ 4 ];
    HB_U32 i = ( HB_U32 ) hb_parnl( 1 );
    HB_PUT_BE_UINT32( szResult, i );
    hb_retclen( szResult, 4 );
}

/*
 wxIsPrint  (UNDOCUMENTED on wxWidgets)
 Teo. Mexico 2010
 */
HB_FUNC( WXISPRINT )
{
    hb_retl( wxIsprint( hb_parni( 1 ) ) );
}
