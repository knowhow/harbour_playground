/*
 * $Id: wx_Grid.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2010 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2010 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_Grid: Implementation
    Teo. Mexico 2010
*/

#include "wx/wx.h"
#include "wx/grid.h"
#include "wxh.h"

#include "wxbase/wx_GridTableBase.h"
#include "wxbase/wx_Grid.h"

/*
    ~wx_Grid
    Teo. Mexico 2010
*/
wx_Grid::~wx_Grid()
{
    xho_itemListDel_XHO( this );
}

/*
    Constructor: wxGrid Object
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxWindow* parent = (wxWindow *) objParams.paramParent( 1 );
    wxWindowID id = HB_ISNIL(2) ? wxID_ANY : hb_parni( 2 );
    wxPoint pos = wxh_par_wxPoint( 3 );
    wxSize size = wxh_par_wxSize( 4 );
    long style = HB_ISNIL( 5 ) ? wxWANTS_CHARS : hb_parnl( 5 );
    wxString name = wxh_parc( 6 );

    wx_Grid* grid = new wx_Grid( parent, id, pos, size, style, name );

    objParams.Return( grid );
}

/*
 AppendCols
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_APPENDCOLS )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
        hb_retl( grid->AppendCols( hb_parni( 1 ) ) );
}

/*
 AppendRows
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_APPENDROWS )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
        hb_retl( grid->AppendRows( hb_parni( 1 ) ) );
}

/*
 AutoSize
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_AUTOSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
        grid->AutoSize();
}

/*
 AutoSizeColumn
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_AUTOSIZECOLUMN )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() > 0 )
        {
            bool setAsMin = hb_pcount() > 1 ? hb_parl( 2 ) : true;
            grid->AutoSizeColumn( hb_parni( 1 ) - 1, setAsMin );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
    AutoSizeColumns
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_AUTOSIZECOLUMNS )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        bool setAsMin = hb_pcount() > 0 ? hb_parl( 1 ) : true;
        grid->AutoSizeColumns( setAsMin );
    }
}

/*
    AutoSizeRow
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_AUTOSIZEROW )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() > 0 )
        {
            bool setAsMin = hb_pcount() > 1 ? hb_parl( 2 ) : true;
            grid->AutoSizeRow( hb_parni( 1 ) - 1, setAsMin );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
    AutoSizeRows
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_AUTOSIZEROWS )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        bool setAsMin = hb_pcount() > 0 ? hb_parl( 1 ) : true;
        grid->AutoSizeRows( setAsMin );
    }
}

/*
    BeginBatch
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_BEGINBATCH )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        grid->BeginBatch();
    }
}

/*
    CanDragColMove
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_CANDRAGCOLMOVE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        hb_retl( grid->CanDragColMove() );
    }
}

/*
    CanDragGridSize
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_CANDRAGGRIDSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        hb_retl( grid->CanDragGridSize() );
    }
}

/*
    CanEnableCellControl
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_CANENABLECELLCONTROL )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        hb_retl( grid->CanEnableCellControl() );
    }
}

/*
    ClearGrid
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_CLEARGRID )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        grid->ClearGrid();
    }
}

/*
    ClearSelection
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_CLEARSELECTION )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        grid->ClearSelection();
    }
}

/*
    CreateGrid
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_CREATEGRID )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() > 1 )
        {
            wxGrid::wxGridSelectionModes selmode = (wxGrid::wxGridSelectionModes) hb_parnl( 3 );
            hb_retl( grid->CreateGrid( hb_parnl( 1 ), hb_parnl( 2 ), selmode ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
 DeleteCols
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_DELETECOLS )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        int pos = hb_pcount() > 0 ? hb_parni( 1 ) - 1 : 0;
        int numCols = hb_pcount() > 1 ? hb_parni( 2 ) : 1;
        hb_retl( grid->DeleteCols( pos, numCols ) );
    }
}

/*
 DeleteRows
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_DELETEROWS )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        int pos = hb_pcount() > 0 ? hb_parni( 1 ) - 1 : 0;
        int numRows = hb_pcount() > 1 ? hb_parni( 2 ) : 1;
        hb_retl( grid->DeleteRows( pos, numRows ) );
    }
}

/*
    DisableCellEditControl
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_DISABLECELLEDITCONTROL )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        grid->DisableCellEditControl();
    }
}

/*
    DisableDragColMove
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_DISABLEDRAGCOLMOVE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        grid->DisableDragColMove();
    }
}

/*
    DisableDragColSize
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_DISABLEDRAGCOLSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        grid->DisableDragColSize();
    }
}

/*
    DisableDragGridSize
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_DISABLEDRAGGRIDSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        grid->DisableDragGridSize();
    }
}

/*
    DisableDragRowSize
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_DISABLEDRAGROWSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        grid->DisableDragRowSize();
    }
}

/*
    EnableCellEditControl
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_ENABLECELLEDITCONTROL )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        bool enable = hb_pcount() > 0 ? hb_parl( 1 ) : true;
        grid->EnableCellEditControl( enable );
    }
}

/*
    EnableDragColSize
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_ENABLEDRAGCOLSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        bool enable = hb_pcount() > 0 ? hb_parl( 1 ) : true;
        grid->EnableDragColSize( enable );
    }
}

/*
    EnableDragColMove
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_ENABLEDRAGCOLMOVE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        bool enable = hb_pcount() > 0 ? hb_parl( 1 ) : true;
        grid->EnableDragColMove( enable );
    }
}

/*
    EnableDragGridSize
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_ENABLEDRAGGRIDSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        bool enable = hb_pcount() > 0 ? hb_parl( 1 ) : true;
        grid->EnableDragGridSize( enable );
    }
}

/*
    EnableDragRowSize
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_ENABLEDRAGROWSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        bool enable = hb_pcount() > 0 ? hb_parl( 1 ) : true;
        grid->EnableDragRowSize( enable );
    }
}

/*
    EnableEditing
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_ENABLEEDITING )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 1 )
        {
            grid->EnableEditing( hb_parl( 1 ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
    wxGrid:EnableGridLines
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_ENABLEGRIDLINES )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        bool enable = hb_pcount() > 0 ? hb_parl( 1 ) : true;
        grid->EnableGridLines( enable );
    }
}

/*
    EndBatch
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_ENDBATCH )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
        grid->EndBatch();
}

/*
    Fit
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_FIT )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
        grid->Fit();
}

/*
    ForceRefresh
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_FORCEREFRESH )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
        grid->ForceRefresh();
}

/*
    GetBatchCount
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_GETBATCHCOUNT )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
        hb_retni( grid->GetBatchCount() );
}

/*
    GetCellValue
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_GETCELLVALUE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 2 )
        {
            wxh_retc( grid->GetCellValue( hb_parni( 1 ) - 1, hb_parni( 2 ) - 1 ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
 GetDefaultRowLabelSize
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_GETDEFAULTROWLABELSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid && grid->GetTable() )
    {
        hb_retni( grid->GetDefaultRowLabelSize() );
    }
}

/*
 GetDefaultRowSize
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_GETDEFAULTROWSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid && grid->GetTable() )
    {
        hb_retni( grid->GetDefaultRowSize() );
    }
}

/*
    GetGridCursorCol
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_GETGRIDCURSORCOL )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        hb_retni( grid->GetGridCursorCol() + 1 );
    }
}

/*
    GetGridCursorRow
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_GETGRIDCURSORROW )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        hb_retni( grid->GetGridCursorRow() + 1 );
    }
}

/*
    GetNumberCols
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_GETNUMBERCOLS )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid && grid->GetTable() )
    {
        hb_retnl( grid->GetTable()->GetNumberCols() );
    }
}

/*
 GetNumberRows
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_GETNUMBERROWS )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid && grid->GetTable() )
    {
        hb_retnl( grid->GetTable()->GetNumberRows() );
    }
}

/*
 GetRowLabelSize
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_GETROWLABELSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid && grid->GetTable() )
    {
        hb_retni( grid->GetRowLabelSize() );
    }
}

/*
 GetRowLabelValue
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_GETROWLABELVALUE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid && grid->GetTable() )
    {
        if( hb_pcount() == 1 )
        {
            wxh_retc( grid->GetRowLabelValue( hb_parni( 1 ) - 1 ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
 GetRowSize
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_GETROWSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid && grid->GetTable() )
    {
        if( hb_pcount() == 1 )
        {
            hb_retni( grid->GetRowSize( hb_parni( 1 ) - 1 ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
 GetTable
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_GETTABLE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        wx_GridTableBase* gridTable = (wx_GridTableBase *) grid->GetTable();
        if( gridTable )
        {
            xho_itemReturn( gridTable );
        }
    }
}

/*
 HideCellEditControl
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_HIDECELLEDITCONTROL )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        grid->HideCellEditControl();
    }
}

/*
 InsertCols
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_INSERTCOLS )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        int pos = hb_pcount() > 0 ? hb_parni( 1 ) - 1 : 0;
        int numCols = hb_pcount() > 1 ? hb_parni( 2 ) : 1;
        hb_retl( grid->InsertCols( pos, numCols ) );
    }
}

/*
 InsertRows
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_INSERTROWS )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        int pos = hb_pcount() > 0 ? hb_parni( 1 ) - 1 : 0;
        int numRows = hb_pcount() > 1 ? hb_parni( 2 ) : 1;
        hb_retl( grid->InsertRows( pos, numRows ) );
    }
}

/*
 IsCellEditControlEnabled
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_ISCELLEDITCONTROLENABLED )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        hb_retl( grid->IsCellEditControlEnabled() );
    }
}

/*
 IsCurrentCellReadOnly
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_ISCURRENTCELLREADONLY )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        hb_retl( grid->IsCurrentCellReadOnly() );
    }
}

/*
 IsEditable
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_ISEDITABLE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        hb_retl( grid->IsEditable() );
    }
}

/*
 IsInSelection
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_ISINSELECTION )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 2 )
        {
            hb_retl( grid->IsInSelection( hb_parni( 1 ) - 1, hb_parni( 2 ) - 1 ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
 IsReadOnly
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_ISREADONLY )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 2 )
        {
            hb_retl( grid->IsReadOnly( hb_parni( 1 ) - 1, hb_parni( 2 ) - 1 ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
 IsSelection
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_ISSELECTION )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        hb_retl( grid->IsSelection() );
    }
}

/*
    IsVisible
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_ISVISIBLE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() > 1 )
        {
            bool wholeCellVisible = hb_pcount() > 2 ? hb_parl( 3 ) : true;
            hb_retl( grid->IsVisible( hb_parni( 1 ) - 1, hb_parni( 2 ) - 1, wholeCellVisible ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
    MakeCellVisible
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_MAKECELLVISIBLE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 2 )
        {
            grid->MakeCellVisible( hb_parni( 1 ) - 1, hb_parni( 2 ) - 1 );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
    MoveCursorLeft
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_MOVECURSORLEFT )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        hb_retl( grid->MoveCursorLeft( hb_parl( 1 ) ) );
    }
}

/*
    MoveCursorRight
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_MOVECURSORRIGHT )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        hb_retl( grid->MoveCursorRight( hb_parl( 1 ) ) );
    }
}

/*
 SelectCol
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_SELECTCOL )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() > 0 )
        {
            grid->SelectCol( hb_parni( 1 ) - 1, hb_parnl( 2 ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
 SelectRow
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_SELECTROW )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() > 0 )
        {
            grid->SelectRow( hb_parni( 1 ) - 1, hb_parnl( 2 ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
    wxGrid:SetCellAlignment
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_SETCELLALIGNMENT )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 3 )
        {
            grid->SetCellAlignment( hb_parni( 1 ), hb_parni( 2 ) - 1, hb_parni( 3 ) - 1 );
        }
        else if( hb_pcount() == 4 )
        {
            grid->SetCellAlignment( hb_parni( 1 ) - 1, hb_parni( 2 ) - 1, hb_parni( 3 ), hb_parni( 4 ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
 SetCellBackgroundColour
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_SETCELLBACKGROUNDCOLOUR )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 3 )
        {
            grid->SetCellBackgroundColour( hb_parni( 1 ) - 1, hb_parni( 2 ) - 1, wxh_par_wxColour( 3 ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
 SetCellTextColour
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_SETCELLTEXTCOLOUR )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 3 )
        {
            if( hb_itemType( hb_param( 1, HB_IT_ANY ) ) & HB_IT_NUMERIC )
                grid->SetCellTextColour( hb_parni( 1 ) - 1, hb_parni( 2 ) - 1, wxh_par_wxColour( 3 ) );
            else
                grid->SetCellTextColour( wxh_par_wxColour( 1 ), hb_parni( 2 ) - 1, hb_parni( 3 ) - 1 );
        }
        else if( hb_pcount() == 1 )
        {
            grid->SetCellTextColour( wxh_par_wxColour( 1 ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
 SetCellValue
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_SETCELLVALUE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 3 )
        {
            if( hb_itemType( hb_param( 1, HB_IT_ANY ) ) & HB_IT_STRING )
                grid->SetCellValue( wxh_parc( 1 ), hb_parni( 2 ) - 1, hb_parni( 3 ) - 1 );
            else
                grid->SetCellValue( hb_parni( 1 ) - 1, hb_parni( 2 ) - 1, wxh_parc( 3 ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
 SetColAttr
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_SETCOLATTR )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 2 )
        {
            wxColour colour = wxColour( wxh_parc( 2 ) );

            wxGridCellAttr *attr;
            attr = new wxGridCellAttr;
            attr->SetBackgroundColour( colour );

            grid->SetColAttr( hb_parni( 1 ) - 1, attr );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
 SetColFormatBool
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_SETCOLFORMATBOOL )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 1 )
            grid->SetColFormatBool( hb_parni( 1 ) - 1 );
        else
            wxh_errRT_ParamNum();
    }
}

/*
    SetColFormatNumber
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_SETCOLFORMATNUMBER )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 1 )
            grid->SetColFormatNumber( hb_parni( 1 ) - 1 );
        else
            wxh_errRT_ParamNum();
    }
}

/*
    SetColFormatFloat
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_SETCOLFORMATFLOAT )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() > 0 && hb_pcount() < 4 )
        {
            int width = hb_pcount() > 1 ? hb_parni( 2 ) : -1;
            int precision = hb_pcount() > 2 ? hb_parni( 3 ) : -1;
            grid->SetColFormatFloat( hb_parni( 1 ) - 1, width, precision );
        }
        else
            wxh_errRT_ParamNum();
    }
}

HB_FUNC( WXGRID_SETCOLLABELSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 1 )
        {
            grid->SetColLabelSize( hb_parni( 1 ) );
        }
        else
            wxh_errRT_ParamNum();
    }
}

HB_FUNC( WXGRID_SETCOLLABELVALUE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 2 )
            grid->SetColLabelValue( hb_parni( 1 ) - 1, wxh_parc( 2 ) );
        else
            wxh_errRT_ParamNum();
    }
}

/*
    SetColSize
    Teo. Mexico 2010
*/
HB_FUNC( WXGRID_SETCOLSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 2 )
            grid->SetColSize( hb_parni( 1 ) - 1, hb_parni( 2 ) );
        else
            wxh_errRT_ParamNum();
    }
}

/*
 SetDefaultCellAlignment
 Teo. Mexico 2010
 */
HB_FUNC( WXGRID_SETDEFAULTCELLALIGNMENT )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 2 )
            grid->SetDefaultCellAlignment( hb_parni( 1 ), hb_parni( 2 ) );
        else
            wxh_errRT_ParamNum();
    }
}

HB_FUNC( WXGRID_SETDEFAULTCOLSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() > 0 )
        {
            bool resizeExistingCols = hb_pcount() > 1 ? hb_parl( 2 ) : false;
            grid->SetDefaultColSize( hb_parni( 1 ), resizeExistingCols );
        }
        else
            wxh_errRT_ParamNum();
    }
}

HB_FUNC( WXGRID_SETDEFAULTROWSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() > 0 )
        {
            bool resizeExistingRows = hb_pcount() > 1 ? hb_parl( 2 ) : false;
            grid->SetDefaultRowSize( hb_parni( 1 ), resizeExistingRows );
        }
        else
            wxh_errRT_ParamNum();
    }
}

/*
    SetGridCursor
*/
HB_FUNC( WXGRID_SETGRIDCURSOR )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 2 )
            grid->SetGridCursor( hb_parni( 1 ) - 1, hb_parni( 2 ) - 1 );
        else
            wxh_errRT_ParamNum();
    }
}

HB_FUNC( WXGRID_SETROWLABELSIZE )
{
    wx_Grid* grid = (wx_Grid *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( grid )
    {
        if( hb_pcount() == 1 )
            grid->SetRowLabelSize( hb_parni( 1 ) );
        else
            wxh_errRT_ParamNum();
    }
}

HB_FUNC( WXGRID_SETTABLE )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wx_Grid* grid = (wx_Grid *) objParams.Get_xhoObject();

    if( grid ) /* gridTable can be NULL */
    {
        if( hb_pcount() > 0 )
        {
            wx_GridTableBase* gridTable = (wx_GridTableBase *) objParams.paramChild( 1 );
            if( gridTable )
            {
                grid->SetTable( gridTable, hb_parl( 2 ), (wxGrid::wxGridSelectionModes) hb_parnl( 3 ) );
            }
        }
        else
            wxh_errRT_ParamNum();
    }
}
