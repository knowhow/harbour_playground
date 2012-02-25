/*
 * $Id: wx_GridTableBase.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2010 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2010 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_GridTableBase: Implementation
    Teo. Mexico 2010
*/

#include "wx/wx.h"
#include "wx/grid.h"
#include "wx/generic/gridctrl.h"
#include "wxh.h"

#include "wxbase/wx_Grid.h"
#include "wxbase/wx_GridTableBase.h"

/*
    ~wx_GridTableBase
    Teo. Mexico 2010
*/
wx_GridTableBase::~wx_GridTableBase()
{
    xho_itemListDel_XHO( this );
}

/*
    AppendCols
    Teo. Mexico 2010
*/
bool wx_GridTableBase::AppendCols( size_t numCols )
{
    if( GetView() && numCols > 0 )
    {
        m_numCols += numCols;
        wxGridTableMessage msg( this, wxGRIDTABLE_NOTIFY_COLS_APPENDED, numCols );
        GetView()->ProcessTableMessage( msg );
        return true;
    }
    return false;
}

/*
    AppendRows
    Teo. Mexico 2010
*/
bool wx_GridTableBase::AppendRows( size_t numRows )
{
    if( GetView() && numRows > 0 )
    {
        m_numRows += numRows;
        wxGridTableMessage msg( this, wxGRIDTABLE_NOTIFY_ROWS_APPENDED, numRows );
        GetView()->ProcessTableMessage( msg );
        return true;
    }
    return false;
}

/*
    DeleteCols
    Teo. Mexico 2010
*/
bool wx_GridTableBase::DeleteCols( size_t pos, size_t numCols )
{
    if( GetView() && numCols > 0 && (pos + numCols) <= m_numCols )
    {
        m_numCols -= numCols;
        wxGridTableMessage msg( this, wxGRIDTABLE_NOTIFY_COLS_DELETED, pos, numCols );
        GetView()->ProcessTableMessage( msg );
        return true;
    }
    return false;
}

/*
    DeleteRows
    Teo. Mexico 2010
*/
bool wx_GridTableBase::DeleteRows( size_t pos, size_t numRows )
{
    if( GetView() && numRows > 0 && (pos + numRows) <= m_numRows )
    {
        m_numRows -= numRows;
        wxGridTableMessage msg( this, wxGRIDTABLE_NOTIFY_ROWS_DELETED, pos, numRows );
        GetView()->ProcessTableMessage( msg );
        return true;
    }
    return false;
}

/*
    InsertCols
    Teo. Mexico 2010
*/
bool wx_GridTableBase::InsertCols( size_t pos, size_t numCols )
{
    if( GetView() && numCols > 0 )
    {
        m_numCols += numCols;
        wxGridTableMessage msg( this, wxGRIDTABLE_NOTIFY_COLS_INSERTED, pos, numCols );
        GetView()->ProcessTableMessage( msg );
        return true;
    }
    return false;
}

/*
    InsertRows
    Teo. Mexico 2010
*/
bool wx_GridTableBase::InsertRows( size_t pos, size_t numRows )
{
    if( GetView() && numRows > 0 )
    {
        m_numRows += numRows;
        wxGridTableMessage msg( this, wxGRIDTABLE_NOTIFY_ROWS_INSERTED, pos, numRows );
        GetView()->ProcessTableMessage( msg );
        return true;
    }
    return false;
}

/*
    IsEmptyCell
    Teo. Mexico 2010
*/
bool wx_GridTableBase::IsEmptyCell( int row, int col )
{
    PHB_ITEM pRow = hb_itemPutNI( NULL, row );
    PHB_ITEM pCol = hb_itemPutNI( NULL, col );
    bool emptyCell;

    hb_objSendMsg( xho_itemListGet_HB( this ), "IsEmptyCell", 2, pRow, pCol );
    emptyCell = hb_itemGetL( hb_stackReturnItem() );

    hb_itemRelease( pRow );
    hb_itemRelease( pCol );

    return emptyCell;
}

/*
    GetValue
    Teo. Mexico 2010
*/
wxString wx_GridTableBase::GetValue( int row, int col )
{
    PHB_ITEM pRow = hb_itemPutNI( NULL, row );
    PHB_ITEM pCol = hb_itemPutNI( NULL, col );
    wxString value = _T("");

    hb_objSendMsg( xho_itemListGet_HB( this ), "GetValue", 2, pRow, pCol );
    value = wxh_CTowxString( hb_itemGetCPtr( hb_stackReturnItem() ), gridDataIsOEM );

    hb_itemRelease( pRow );
    hb_itemRelease( pCol );

    return value;
}

wxString wx_GridTableBase::GetColLabelValue( int col )
{
    PHB_ITEM pCol = hb_itemPutNI( NULL, col );
    wxString labelValue = _T("");

    hb_objSendMsg( xho_itemListGet_HB( this ), "GetColLabelValue", 1, pCol );
    labelValue = wxh_CTowxString( hb_itemGetCPtr( hb_stackReturnItem() ) );

    hb_itemRelease( pCol );

    return labelValue;
}

wxString wx_GridTableBase::GetRowLabelValue( int row )
{
    PHB_ITEM pRow = hb_itemPutNI( NULL, row );
    wxString labelValue = _T("");

    hb_objSendMsg( xho_itemListGet_HB( this ), "GetRowLabelValue", 1, pRow );
    labelValue = wxh_CTowxString( hb_itemGetCPtr( hb_stackReturnItem() ) );

    hb_itemRelease( pRow );

    return labelValue;
}

/*
    SetValue
    Teo. Mexico 2010
*/
void wx_GridTableBase::SetValue( int row, int col, const wxString& value )
{
    PHB_ITEM hbRow = hb_itemNew( NULL );
    PHB_ITEM hbCol = hb_itemNew( NULL );
    PHB_ITEM hbStr = hb_itemNew( NULL );

    hb_itemPutNI( hbRow, row );
    hb_itemPutNI( hbCol, col );
    hb_itemPutC( hbStr, value.mb_str() );

    hb_objSendMsg( xho_itemListGet_HB( this ), "SetValue", 3, hbRow, hbCol, hbStr );

    hb_itemRelease( hbRow );
    hb_itemRelease( hbCol );
    hb_itemRelease( hbStr );
}

/*
    New
    Teo. Mexico 2010
*/
HB_FUNC( WXGRIDTABLEBASE_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( hb_stackSelfItem() );

    wx_GridTableBase* gridTable = new wx_GridTableBase;

    objParams.Return( gridTable );
}

/*
    AppendCols
    Teo. Mexico 2010
*/
HB_FUNC( WXGRIDTABLEBASE_APPENDCOLS )
{
    wx_GridTableBase* gridTable = (wx_GridTableBase *) xho_itemListGet_XHO( hb_stackSelfItem() );

    size_t numCols = hb_pcount() > 0 ? hb_parni( 1 ) : 1;

    if( gridTable )
    {
        hb_retl( gridTable->AppendCols( numCols ) );
    }
}

/*
    AppendRows
    Teo. Mexico 2010
*/
HB_FUNC( WXGRIDTABLEBASE_APPENDROWS )
{
    wx_GridTableBase* gridTable = (wx_GridTableBase *) xho_itemListGet_XHO( hb_stackSelfItem() );

    size_t numRows = hb_pcount() > 0 ? hb_parni( 1 ) : 1;

    if( gridTable )
        hb_retl( gridTable->AppendRows( numRows ) );
}

/*
    DeleteCols
    Teo. Mexico 2010
*/
HB_FUNC( WXGRIDTABLEBASE_DELETECOLS )
{
    wx_GridTableBase* gridTable = (wx_GridTableBase *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridTable )
    {
        size_t pos = hb_pcount() > 0 ? hb_parni( 1 ) - 1 : 0;
        size_t numCols = hb_pcount() > 1 ? hb_parni( 2 ) : 1;
        hb_retl( gridTable->DeleteCols( pos, numCols ) );
    }
}

/*
    DeleteRows
    Teo. Mexico 2010
*/
HB_FUNC( WXGRIDTABLEBASE_DELETEROWS )
{
    wx_GridTableBase* gridTable = (wx_GridTableBase *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridTable )
    {
        size_t pos = hb_pcount() > 0 ? hb_parni( 1 ) - 1 : 0;
        size_t numRows = hb_pcount() > 1 ? hb_parni( 2 ) : 1;
        hb_retl( gridTable->DeleteRows( pos, numRows ) );
    }
}

/*
    GetGridDataIsOEM
    Teo. Mexico 2010
 */
HB_FUNC( WXGRIDTABLEBASE_GETGRIDDATAISOEM )
{
    wx_GridTableBase* gridTable = (wx_GridTableBase *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridTable )
    {
        hb_retnl( gridTable->gridDataIsOEM );
    }
}

/*
 GetNumberCols
 Teo. Mexico 2010
 */
HB_FUNC( WXGRIDTABLEBASE_GETNUMBERCOLS )
{
    wx_GridTableBase* gridTable = (wx_GridTableBase *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridTable )
    {
        hb_retnl( gridTable->GetNumberCols() );
    }
}

/*
    GetNumberRows
    Teo. Mexico 2010
*/
HB_FUNC( WXGRIDTABLEBASE_GETNUMBERROWS )
{
    wx_GridTableBase* gridTable = (wx_GridTableBase *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridTable )
    {
        hb_retnl( gridTable->GetNumberRows() );
    }
}

/*
    GetView
    Teo. Mexico 2010
*/
HB_FUNC( WXGRIDTABLEBASE_GETVIEW )
{
    wx_GridTableBase* gridTable = (wx_GridTableBase *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridTable )
    {
        wx_Grid* grid = (wx_Grid *) gridTable->GetView();
        if( grid )
        {
            xho_itemReturn( grid );
        }
    }
}

/*
    InsertCols
    Teo. Mexico 2010
*/
HB_FUNC( WXGRIDTABLEBASE_INSERTCOLS )
{
    wx_GridTableBase* gridTable = (wx_GridTableBase *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridTable )
    {
        size_t pos = hb_pcount() > 0 ? hb_parni( 1 ) - 1 : 0;
        size_t numCols = hb_pcount() > 1 ? hb_parni( 2 ) : 1;
        hb_retl( gridTable->InsertCols( pos, numCols ) );
    }
}

/*
    InsertRows
    Teo. Mexico 2010
*/
HB_FUNC( WXGRIDTABLEBASE_INSERTROWS )
{
    wx_GridTableBase* gridTable = (wx_GridTableBase *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridTable )
    {
        size_t pos = hb_pcount() > 0 ? hb_parni( 1 ) - 1 : 0;
        size_t numRows = hb_pcount() > 1 ? hb_parni( 2 ) : 1;
        hb_retl( gridTable->InsertRows( pos, numRows ) );
    }
}

/*
    SetGridDataIsOEM
    Teo. Mexico 2010
 */
HB_FUNC( WXGRIDTABLEBASE_SETGRIDDATAISOEM )
{
    wx_GridTableBase* gridTable = (wx_GridTableBase *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridTable )
    {
        gridTable->gridDataIsOEM = hb_parl( 1 );
    }
}
