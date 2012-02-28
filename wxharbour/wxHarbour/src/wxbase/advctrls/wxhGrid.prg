/*
 * $Id: wxhGrid.prg 648 2010-10-01 20:10:37Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

/*
    wxGrid
    Teo. Mexico 2006
*/
CLASS wxGrid FROM wxScrolledWindow
PRIVATE:
PROTECTED:
PUBLIC:
    CONSTRUCTOR New( parent, id, pos, size, style, name )
    METHOD AppendCols( numCols )
    METHOD AppendRows( numRows )
    METHOD AutoSize
    METHOD AutoSizeColumn( col, setAsMin )
    METHOD AutoSizeColumns( setAsMin )
    METHOD AutoSizeRow( row, setAsMin )
    METHOD AutoSizeRows( setAsMin )
    METHOD BeginBatch
//   METHOD BlockToDeviceRect
    METHOD CanDragColMove
    METHOD CanDragGridSize
    METHOD CanEnableCellControl
//   METHOD CanHaveAttributes
//   METHOD CellToRect
    METHOD ClearGrid
    METHOD ClearSelection
    METHOD CreateGrid( numRows, numCols, selmode )
    METHOD DeleteCols( pos, numCols )
    METHOD DeleteRows( pos, numRows )
    METHOD DisableCellEditControl
    METHOD DisableDragColMove
    METHOD DisableDragColSize
    METHOD DisableDragGridSize
    METHOD DisableDragRowSize
    METHOD EnableCellEditControl( enable )
    METHOD EnableDragColSize( enable )
    METHOD EnableDragColMove( enable )
    METHOD EnableDragGridSize( enable )
    METHOD EnableDragRowSize( enable )
    METHOD EnableEditing( edit )
    METHOD EnableGridLines( enable )
    METHOD EndBatch
    METHOD Fit
    METHOD ForceRefresh()
    METHOD GetBatchCount()
    METHOD GetCellValue( row, col )
    METHOD GetDefaultRowLabelSize()
    METHOD GetDefaultRowSize()
    METHOD GetGridCursorCol()
    METHOD GetGridCursorRow()
    METHOD GetNumberCols()
    METHOD GetNumberRows()
    METHOD GetRowLabelSize()
    METHOD GetRowSize()
    METHOD GetTable()
    METHOD HideCellEditControl()
    METHOD InsertCols( pos, numCols )
    METHOD InsertRows( pos, numRows )
    METHOD IsCellEditControlEnabled()
    METHOD IsCurrentCellReadOnly()
    METHOD IsEditable()
    METHOD IsInSelection( row, col )
    METHOD IsReadOnly( row, col )
    METHOD IsSelection()
    METHOD IsVisible( row, col, wholeCellVisible )
    METHOD MakeCellVisible( row, col )
    METHOD MoveCursorLeft( expandSelection )
    METHOD MoveCursorRight( expandSelection )
    METHOD SelectCol( col, addToSelected )
    METHOD SelectRow( row, addToSelected )
    METHOD SetCellAlignment( /* two methods */ )
    METHOD SetCellBackgroundColour( row, col,  colour )
    METHOD SetCellTextColour( row, col, colour )
    METHOD SetCellValue( row, col, s )
    METHOD SetColAttr( col, attr ) // attr == colour, at the moment.
    METHOD SetColLabelSize( height )
    METHOD SetColLabelValue( col, value )
    METHOD SetColFormatBool( col )
    METHOD SetColFormatNumber( col )
    METHOD SetColFormatFloat( col, width, precision )
    METHOD SetColSize( col, width )
    METHOD SetDefaultCellAlignment( horz, vert )
    METHOD SetDefaultColSize( width, resizeExistingCols )
    METHOD SetDefaultRowSize( height, resizeExistingRows )
    METHOD SetGridCursor( row, col )
    //METHOD SetRowAttr( row, attr )
    METHOD SetRowLabelSize( width )
    METHOD SetTable( table, takeOwnership, selmode )
PUBLISHED:
ENDCLASS

/*
    EndClass wxGrid
*/
