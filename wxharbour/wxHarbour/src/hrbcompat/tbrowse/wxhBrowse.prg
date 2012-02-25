/*
 * $Id: wxhBrowse.prg 647 2010-09-27 20:17:26Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wxharbour.ch"
#include "xerror.ch"

/*
    wxhBrowse
    Teo. Mexico 2009
*/
CLASS wxhBrowse FROM wxGrid
PRIVATE:
    DATA FAlwaysShowSelectedRow INIT .T.
    DATA FColPos					INIT 0
    DATA FDataSource
    DATA FDataSourceType
    DATA FHeight INIT 0
    DATA FPanel AS OBJECT
    DATA FRecNo						INIT 0
    DATA FRowPos					INIT 0
    METHOD GetColCount INLINE Len( ::GetTable():ColumnList )
    METHOD GetRecNo
    METHOD SetAllowOnDataChange( allowOnDataChange )
    METHOD SetDataSource( dataSource )
    METHOD SetAlwaysShowSelectedRow( alwaysShowSelectedRow )
PROTECTED:
    METHOD CalcMaxRows /* array of { width, height } */
    METHOD GetMaxRows
    METHOD GetRowCount
    METHOD SetColPos( colPos )
    METHOD SetColWidth( col, colWidth )
    METHOD SetRowCount( rowCount )
    METHOD SetRowPos( rowPos )
    METHOD OnCreate()
PUBLIC:

    CONSTRUCTOR New( window, id, pos, size, style, name )
    METHOD ClearObjData()

    /* Begin TBrowse compatible */
    /* TBrowse compatible vars */
    DATA cargo
    DATA GoBottomBlock
    DATA GoTopBlock
    DATA SkipBlock

    PROPERTY ColCount READ GetColCount
    PROPERTY ColPos READ FColPos WRITE SetColPos
    PROPERTY MaxRows READ GetMaxRows
    PROPERTY RowCount READ GetRowCount WRITE SetRowCount
    PROPERTY RowPos READ FRowPos WRITE SetRowPos

    /* TBrowse compatible methods */
    METHOD AddColumn( column )
    METHOD DelColumn( pos )
    METHOD Down
    METHOD End
    METHOD GetColumn( nCol ) INLINE ::GetTable():GetColumn( nCol )
    METHOD GoBottom
    METHOD GoTop
    METHOD Home
    METHOD Left
    METHOD PageDown
    METHOD PageUp
    METHOD RefreshAll()
    METHOD RefreshCurrent()
    METHOD Right
    METHOD Up
    /* End TBrowse compatible */

    DATA AutoFill INIT .T.	/* autofill columns with DataSource data */
    DATA autoSizeColumnsOnRefresh INIT .T. // performs a ::AutoSizeColumns on Refresh/RefreshAll
    DATA BottomFirst INIT .F.
    DATA FillColumnsChecked INIT .F.
    DATA OnKeyDownBlock
    DATA OnSelectCellBlock

    METHOD DeleteAllColumns
    METHOD FillColumns

    METHOD GetBrowseParent INLINE ::GetGrandParent()

    METHOD GoFirstPos
    METHOD OnKeyDown( keyEvent )
    METHOD OnSelectCell( gridEvent )
    METHOD OnSetDataSource() VIRTUAL
    METHOD OnSize( size )
    METHOD SetColumnAlignment( nCol, align )
    METHOD ShowRow()

    PROPERTY AlwaysShowSelectedRow READ FAlwaysShowSelectedRow WRITE SetAlwaysShowSelectedRow
    PROPERTY RowParam READ GetTable():RowParam WRITE GetTable():SetRowParam
    PROPERTY ColumnList READ GetTable():ColumnList WRITE GetTable():SetColumnList
    PROPERTY ColumnZero READ GetTable():ColumnZero WRITE GetTable():SetColumnZero
    PROPERTY DataSource READ FDataSource WRITE SetDataSource
    PROPERTY DataSourceType READ FDataSourceType
    PROPERTY Panel READ FPanel
    PROPERTY RecNo READ GetRecNo

PUBLISHED:
ENDCLASS

/*
    AddColumn
    Teo. Mexico 2009
*/
METHOD PROCEDURE AddColumn( column ) CLASS wxhBrowse
    AAdd( ::GetTable():ColumnList, column )
    ::GetTable():AppendCols( 1 )
    column:colPos := Len( ::GetTable():ColumnList )
    IF column:Width != NIL
        ::SetColWidth( Len( ::GetTable():ColumnList ), column:Width )
    ENDIF
RETURN

/*
    ClearObjData
    Teo. Mexico 2009
*/
METHOD PROCEDURE ClearObjData() CLASS wxhBrowse
    //::GetTable():ClearObjData()
    ::GoTopBlock := NIL
    ::GoBottomBlock := NIL
    ::SkipBlock := NIL
    ::SetTable( NIL )
    //:: := NIL
RETURN

/*
    DelColumn
    Teo. Mexico 2009
*/
METHOD FUNCTION DelColumn( pos ) CLASS wxhBrowse
    LOCAL column
    LOCAL length := ::ColCount

    IF !Empty( pos ) .AND. pos > 0 .AND. pos <= length .AND. ::GetTable():DeleteCols( pos, 1 )
        column := ::GetTable():ColumnList[ pos ]
        ADel( ::GetTable():ColumnList, pos )
        ASize( ::GetTable():ColumnList, length - 1 )
    ENDIF

RETURN column

/*
    DeleteAllColumns
    Teo. Mexico 2009
*/
METHOD PROCEDURE DeleteAllColumns CLASS wxhBrowse
    WHILE ::ColCount > 0
        ::DelColumn( 1 )
    ENDDO
RETURN

/*
    Down
    Teo. Mexico 2009
*/
METHOD FUNCTION Down CLASS wxhBrowse
    LOCAL allowOnDataChange

    allowOnDataChange := ::SetAllowOnDataChange( .F. )
    
    IF ::RowPos < ::RowCount
        ::RowPos += 1
    ELSE
        IF ::SkipBlock:Eval( 1 ) = 1
            ADel( ::GetTable():GridBuffer, 1 )
            ::GetTable():GetGridRowData( ::RowCount )
            ::ForceRefresh()
            ::SetGridCursor( ::GetGridCursorRow(), ::GetGridCursorCol() )
        ENDIF
    ENDIF
    
    ::SetAllowOnDataChange( allowOnDataChange )

RETURN Self

/*
    End
    Teo. Mexico 2009
*/
METHOD FUNCTION End() CLASS wxhBrowse
    ::SetColPos( ::ColCount() )
    ::MakeCellVisible( ::GetGridCursorRow(), ::GetNumberCols() - 1 )
RETURN Self

/*
    FillColumns
    Teo. Mexico 2009
*/
    STATIC FUNCTION buildBlock( Self, col )
    RETURN {|key| ::DataSource[ key, col ] }

METHOD PROCEDURE FillColumns CLASS wxhBrowse
    LOCAL fld
    LOCAL vType := ValType( ::FDataSource )
    LOCAL itm1

    DO CASE
    CASE vType = "O" .AND. ::FDataSource:IsDerivedFrom( "TTable" )

        __wxh_BrowseAddColumn( .T., Self, "RecNo", {|| Transform( ::FDataSource:RecNo, "99999999" ) + iif( ::FDataSource:Deleted(), "*", " " ) } )

        FOR EACH fld IN ::FDataSource:FieldList
            IF fld:Published
                __wxh_BrowseAddColumnFromField( Self, fld, ::IsEditable() )
            ENDIF
        NEXT

    CASE vType $ "AH" .AND. Len( ::FDataSource ) > 0

        IF vType = "A"
            __wxh_BrowseAddColumn( .T., Self, "", {|recNo| recNo }, "9999" )
        ELSE
            __wxh_BrowseAddColumn( .T., Self, "", {|key| key } )
        ENDIF

        IF !Empty( ::FDataSource )
            IF vType = "A"
                itm1 := ::FDataSource[ 1 ]
            ELSE
                itm1 := HB_HValueAt( ::FDataSource, 1 )
            ENDIF
            IF ValType( itm1 ) = "A"
                FOR EACH fld IN ::FDataSource[ 1 ]
                    __wxh_BrowseAddColumn( .F., Self, NTrim( fld:__enumIndex() ), buildBlock( Self, fld:__enumIndex() ) )
                NEXT
            ELSE
                __wxh_BrowseAddColumn( .F., Self, "", {|key| ::FDataSource[ key ] } )
            ENDIF
        ENDIF

    ENDCASE

RETURN

/*
    GetRecNo
    Teo. Mexico 2009
*/
METHOD FUNCTION GetRecNo CLASS wxhBrowse
    IF ::FDataSourceType = "O"
        RETURN ::FDataSource:RecNo
    ENDIF
RETURN ::FRecNo

/*
    GoBottom
    Teo. Mexico 2009
*/
METHOD FUNCTION GoBottom CLASS wxhBrowse
    LOCAL allowOnDataChange
    
    allowOnDataChange := ::SetAllowOnDataChange( .F. )

    ::GoBottomBlock:Eval()
    ::GetTable():FillGridBuffer( 0 )
    ::RowPos := ::RowCount()

    ::ForceRefresh()

    ::SetAllowOnDataChange( allowOnDataChange )
    
RETURN Self

/*
    GoFirstPos
    Teo. Mexico 2009
*/
METHOD PROCEDURE GoFirstPos CLASS wxhBrowse
    IF ::BottomFirst
        ::GoBottomBlock:Eval()
    ELSE
        ::GoTopBlock:Eval()
    ENDIF
RETURN

/*
    GoTop
    Teo. Mexico 2009
*/
METHOD FUNCTION GoTop CLASS wxhBrowse
    LOCAL allowOnDataChange

    allowOnDataChange := ::SetAllowOnDataChange( .F. )

    ::GoTopBlock:Eval()
    ::GetTable():FillGridBuffer( 0 )
    ::RowPos := 1

    ::ForceRefresh()

    ::SetAllowOnDataChange( allowOnDataChange )

RETURN Self

/*
    Home
    Teo. Mexico 2009
*/
METHOD FUNCTION Home CLASS wxhBrowse
    ::SetColPos( 1 ) /* no freeze cols yet implemented */
    ::MakeCellVisible( ::GetGridCursorRow(), 0 )
RETURN Self

/*
    Left
    Teo. Mexico 2009
*/
METHOD FUNCTION Left CLASS wxhBrowse
    ::MoveCursorLeft()
RETURN Self

/*
    OnCreate : Defaults for this class
    Teo. Mexico 2009
*/
METHOD PROCEDURE OnCreate() CLASS wxhBrowse
    ::SetTable( wxhBrowseTableBase():New(), .T. )
    //::EnableGridLines( .F. )
    ::EnableDragRowSize( .F. )
    ::EnableDragColMove( .T. )
    ::SetColLabelSize( 22 )
    ::SetRowLabelSize( 0 )
RETURN

/*
    OnKeyDown
    Teo. Mexico 2009
*/
METHOD PROCEDURE OnKeyDown( keyEvent ) CLASS wxhBrowse
    LOCAL result
    LOCAL nKey := keyEvent:GetKeyCode()

    IF ::OnKeyDownBlock != NIL
        result := ::OnKeyDownBlock:Eval( Self, keyEvent )
        IF ValType( result ) = "L"
            IF result
                RETURN /* event key processed */
            ENDIF
        ELSE
            RAISE ERROR "OnKeyDownBlock must return a logical value."
        ENDIF
    ENDIF

    /* start cell edition keys */
    SWITCH nKey
    CASE WXK_RETURN
    CASE WXK_F2
        IF ( ::GetColumn( ::ColPos ):IsEditable .OR. ::IsEditable ) .AND. ! keyEvent:HasModifiers()
            IF ::IsCellEditControlEnabled()
                ::HideCellEditControl()
                ::RefreshAll()
            ELSE
                ::EnableCellEditControl( .T. )
            ENDIF
            RETURN
        ENDIF
    END

    SWITCH nKey
    CASE WXK_UP
        ::Up()
        EXIT
    CASE WXK_DOWN
        ::Down()
        EXIT
    CASE WXK_LEFT
        ::Left()
        EXIT
    CASE WXK_RIGHT
        IF keyEvent:GetModifiers() = wxMOD_CONTROL
            keyEvent:Skip( .F. )
        ELSE
            ::Right()
        ENDIF
        EXIT
    CASE WXK_HOME
        IF keyEvent:GetModifiers() = wxMOD_CONTROL
            ::Home()
        ELSE
            ::RowPos := 1
        ENDIF
        EXIT
    CASE WXK_END
        IF keyEvent:GetModifiers() = wxMOD_CONTROL
            ::End()
        ELSE
            ::RowPos := ::RowCount
        ENDIF
        EXIT
    CASE WXK_PAGEUP
        IF keyEvent:GetModifiers() = wxMOD_CONTROL
            ::GoTop()
        ELSE
            ::PageUp()
        ENDIF
        EXIT
    CASE WXK_PAGEDOWN
        IF keyEvent:GetModifiers() = wxMOD_CONTROL
            ::GoBottom()
        ELSE
            ::PageDown()
        ENDIF
        EXIT
    OTHERWISE
        keyEvent:Skip()
    END

RETURN

/*
    OnSelectCell
    Teo. Mexico 2009
*/
METHOD PROCEDURE OnSelectCell( gridEvent ) CLASS wxhBrowse
    LOCAL row

    IF !gridEvent:Selecting()
        gridEvent:Skip()
        RETURN
    ENDIF

    row := gridEvent:GetRow()
    
    IF ::FAlwaysShowSelectedRow
        ::ShowRow( row )
    ENDIF
    
    ::GetTable():CurRowIndex := row

    ::FColPos := gridEvent:GetCol() + 1
    ::FRowPos := row + 1

    IF ::OnSelectCellBlock != NIL .AND. ::RowCount > 0
        ::OnSelectCellBlock:Eval( gridEvent )
    ENDIF

    gridEvent:Skip()

RETURN

/*
    OnSize
    Teo. Mexico 2009
*/
METHOD FUNCTION OnSize( size ) CLASS wxhBrowse
    LOCAL Result := .T.
    LOCAL maxRows,rowCount
    LOCAL height
    LOCAL n
    LOCAL column

    IF !::FillColumnsChecked .AND. ::AutoFill .AND. ::DataSource != NIL
        IF ::ColCount = 0
            ::FillColumns()
        ENDIF
        ::FillColumnsChecked := .T.
    ENDIF

    rowCount := ::GetRowCount()
    maxRows := ::CalcMaxRows()

    height := size[ 2 ]

    IF ::FHeight != height .AND. maxRows != rowCount

        IF rowCount > 0
            IF rowCount < ::GetNumberRows()
                ::DeleteRows( rowCount, ::GetNumberRows() - rowCount )
            ELSE
                ::AppendRows( rowCount - ::GetNumberRows() )
                FOR n:=1 TO ::GetNumberCols
                    column := ::GetTable():ColumnList[ n ]
                    ::SetColumnAlignment( n, column:Align )
                NEXT
            ENDIF
        ELSE
            ::DeleteRows( 1, ::GetNumberRows() )
        ENDIF

        ::GetTable():FillGridBuffer( 0 )

        ::FHeight := height

    ENDIF

RETURN Result

/*
    PageDown
    Teo. Mexico 2009
*/
METHOD FUNCTION PageDown CLASS wxhBrowse
    LOCAL allowOnDataChange

    allowOnDataChange := ::SetAllowOnDataChange( .F. )
    
    IF ::RowPos = ::RowCount
        ::GetTable():FillGridBuffer( ::RowCount )
        ::ForceRefresh()
    ELSE
        ::RowPos := ::RowCount
    ENDIF

    ::SetAllowOnDataChange( allowOnDataChange )

RETURN Self

/*
    PageUp
    Teo. Mexico 2009
*/
METHOD FUNCTION PageUp CLASS wxhBrowse
    LOCAL allowOnDataChange

    allowOnDataChange := ::SetAllowOnDataChange( .F. )
    
    IF ::RowPos = 1
        ::GetTable():FillGridBuffer( - ::RowCount )
        ::ForceRefresh()
    ELSE
        ::RowPos := 1
    ENDIF

    ::SetAllowOnDataChange( allowOnDataChange )

RETURN Self

/*
    RefreshAll
    Teo. Mexico 2009
*/
METHOD FUNCTION RefreshAll() CLASS wxhBrowse
    LOCAL dbProvider := ::GetTable()
    LOCAL allowOnDataChange

    allowOnDataChange := ::SetAllowOnDataChange( .F. )

    IF dbProvider != NIL// .AND. dbProvider:IsDerivedFrom("wxhBrowseTableBase")
        dbProvider:FillGridBuffer( 0 )
        ::ForceRefresh()
    ENDIF

    ::SetAllowOnDataChange( allowOnDataChange )
    
    IF ::autoSizeColumnsOnRefresh
        ::AutoSizeColumns( .F. )
    ENDIF

RETURN Self

/*
    RefreshCurrent
    Teo. Mexico 2009
*/
METHOD FUNCTION RefreshCurrent() CLASS wxhBrowse
    LOCAL allowOnDataChange

    allowOnDataChange := ::SetAllowOnDataChange( .F. )

    ::GetTable():GetGridRowData( ::RowPos )
    ::ForceRefresh()

    ::SetAllowOnDataChange( allowOnDataChange )

    IF ::autoSizeColumnsOnRefresh
        ::AutoSizeColumns( .F. )
    ENDIF

RETURN Self

/*
    Right
    Teo. Mexico 2009
*/
METHOD FUNCTION Right CLASS wxhBrowse
    ::MoveCursorRight()
RETURN Self

/*
    SetAlwaysShowSelectedRow
    Teo. Mexico 2009
*/
METHOD PROCEDURE SetAlwaysShowSelectedRow( alwaysShowSelectedRow ) CLASS wxhBrowse
    ::ShowRow( NIL, alwaysShowSelectedRow )
    ::FAlwaysShowSelectedRow := alwaysShowSelectedRow
RETURN

/*
    SetAllowOnDataChange
    Teo. Mexico 2009
*/
METHOD FUNCTION SetAllowOnDataChange( allowOnDataChange ) CLASS wxhBrowse
    LOCAL oldValue
    
    IF ::DataSourceType = "O"
        oldValue := ::DataSource:allowOnDataChange
        ::DataSource:allowOnDataChange := allowOnDataChange
        IF allowOnDataChange
            ::DataSource:OnDataChange()
        ENDIF
    ENDIF
    
RETURN oldValue

/*
    SetColPos
    Teo. Mexico 2010
*/
METHOD PROCEDURE SetColPos( colPos ) CLASS wxhBrowse
    ::SetGridCursor( ::GetGridCursorRow(), colPos - 1 )
RETURN

/*
    SetColumnAlignment
    Teo. Mexico 2009
*/
METHOD PROCEDURE SetColumnAlignment( nCol, align ) CLASS wxhBrowse
    LOCAL i

    FOR i:=0 TO ::RowCount - 1
        ::SetCellAlignment( align, i, nCol - 1 )
    NEXT

RETURN

/*
    SetDataSource
    Teo. Mexico 2009
*/
METHOD PROCEDURE SetDataSource( dataSource ) CLASS wxhBrowse
    LOCAL oldPos
    LOCAL vt := ValType( dataSource )
    LOCAL workArea

    ::FDataSource := NIL
    ::FDataSourceType := NIL

    ::ColumnList := {}
    ::ColumnZero := NIL
    ::RowParam := NIL
    ::FillColumnsChecked := .F.

    SWITCH vt
    CASE 'A'				/* Array browse */
        ::FDataSource := dataSource
        ::FDataSourceType := "A"
        ::RowParam := {|Self| ::RecNo }

        ::GoTopBlock		:= {|| ::FRecNo := 1 }
        ::GoBottomBlock := {|| ::FRecNo := Len( dataSource ) }
        ::SkipBlock			:= {|n| oldPos := ::FRecNo, ::FRecNo := iif( n < 0, Max( 1, ::FRecNo + n ), Min( Len( dataSource ), ::FRecNo + n ) ), ::FRecNo - oldPos }

        EXIT

    CASE 'N'
    CASE 'C'				/* path/filename for a database browse */

        IF vt = 'N'
            workArea := dataSource
        ELSE
            workArea := Select( dataSource )
        ENDIF
        
        IF !Empty( workArea )
            ::FDataSource := workArea
            ::FDataSourceType := "D"
            ::RowParam := workArea
            ::GoTopBlock := {|| (workArea)->( DbGoTop() ) }
            ::GoBottomBlock := {|| (workArea)->( DbGoBottom() ) }
            ::SkipBlock := {|n| (workArea)->( __dbSkipper( n ) ) }
        ELSE
            wxhAlert( "Empty workarea on wxhBrowse" )
        ENDIF
        
        EXIT

    CASE 'H'				/* Hash browse */
        /* TODO: Implement this */
        ::FDataSource := dataSource
        ::FDataSourceType := "H"
        ::RowParam := {|Self| HB_HKeyAt( ::DataSource, ::RecNo ) }

        ::GoTopBlock		:= {|| ::FRecNo := 1 }
        ::GoBottomBlock := {|| ::FRecNo := Len( dataSource ) }
        ::SkipBlock			:= {|n| oldPos := ::FRecNo, ::FRecNo := iif( n < 0, Max( 1, ::FRecNo + n ), Min( Len( dataSource ), ::FRecNo + n ) ), ::FRecNo - oldPos }

        EXIT

    CASE 'O'
    
        IF dataSource:IsDerivedFrom("TTable")
            ::FDataSource := dataSource
            ::FDataSourceType := "O"
            ::RowParam := dataSource:GetDisplayFields()

            ::GoTopBlock		:= {|| dataSource:DbGoTop() }
            ::GoBottomBlock := {|| dataSource:DbGoBottom() }
            ::SkipBlock			:= {|n| dataSource:SkipBrowse( n ) }
            
            ::GetTable():gridDataIsOEM := dataSource:dataIsOEM

        ELSE
            wxhAlert("Invalid object assigned to wxhBrowse...")
        ENDIF

        EXIT

    END
    
    ::OnSetDataSource()

RETURN

/*
    SetRowPos
    Teo. Mexico 2010
*/
METHOD PROCEDURE SetRowPos( rowPos ) CLASS wxhBrowse
    LOCAL allowOnDataChange

    allowOnDataChange := ::SetAllowOnDataChange( .F. )

    IF rowPos > ::RowCount
        rowPos := ::RowCount
    ENDIF
    ::SetGridCursor( rowPos - 1, ::GetGridCursorCol() )
    
    ::SetAllowOnDataChange( allowOnDataChange )

RETURN

/*
    Up
    Teo. Mexico 2009
*/
METHOD FUNCTION Up CLASS wxhBrowse
    LOCAL allowOnDataChange

    allowOnDataChange := ::SetAllowOnDataChange( .F. )

    IF ::RowPos > 1
        ::RowPos -= 1
    ELSE
        IF ::SkipBlock:Eval( -1 ) = -1
            AIns( ::GetTable():GridBuffer, 1 )
            ::GetTable():GetGridRowData( 1 )
            ::ForceRefresh()
            ::SetGridCursor( ::GetGridCursorRow(), ::GetGridCursorCol() )
        ENDIF
    ENDIF
    
    ::SetAllowOnDataChange( allowOnDataChange )

RETURN Self

/*
    End Class wxhBrowse
*/
