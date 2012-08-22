/*
 * $Id: wxhBrowseDbProvider.prg 794 2012-01-26 22:08:58Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"
#include "xerror.ch"

#include "wxharbour.ch"

#include "wxh/grid.ch"

#include "hbtrace.ch"

/*
    wxhBrowseTableBase
    Teo. Mexico 2008
*/
CLASS wxhBrowseTableBase FROM wxGridTableBase
PRIVATE:
    DATA FRowParam
    DATA FRowParamType
    DATA FColumnList INIT {}
    DATA FColumnZero
    DATA FCurRowIndex //INIT 0
    DATA FGridBuffer
    DATA FGridBufferCols INIT 0
    DATA FGridBufferRows INIT 0
    DATA FRowLabel INIT {}
    DATA FIgnoreCellEvalError INIT .F.
    METHOD GetRowParam
    METHOD SetCurRowIndex( rowIndex )
    METHOD SetGridBufferSize( rows )
PROTECTED:
PUBLIC:

    DATA dtPicture INIT "9999-99-99 99:99"

    METHOD ClearObjData INLINE ::FColumnList := NIL

    METHOD FillGridBuffer( start )
    METHOD GetCellValueAtCol( nCol )
    METHOD GetColLabelValue( col )
    METHOD GetColumn( nCol ) INLINE ::FColumnList[ nCol ]
    METHOD GetGridRowData( row )
    METHOD GetRowLabelValue( row )
    METHOD GetValue( row, col )
    METHOD GridBuffer_Delete( row )
    METHOD GridBuffer_Insert( row )
    METHOD Initialized INLINE ::FGridBuffer != NIL
    METHOD SetRowParam( rowParam )
    METHOD SetColumnList( columnList )
    METHOD SetColumnZero( columnZero )
    METHOD SetValue( row, col, value )

    PROPERTY RowParam READ GetRowParam WRITE SetRowParam
    PROPERTY CurRowIndex READ FCurRowIndex WRITE SetCurRowIndex
    PROPERTY ColumnList READ FColumnList WRITE SetColumnList
    PROPERTY ColumnZero READ FColumnZero WRITE SetColumnZero
    PROPERTY GridBuffer READ FGridBuffer
    PROPERTY RowLabel READ FRowLabel

PUBLISHED:
ENDCLASS

/*
    FillGridBuffer
    Teo. Mexico 2008
*/
METHOD PROCEDURE FillGridBuffer( start ) CLASS wxhBrowseTableBase
    LOCAL i
    LOCAL n
    LOCAL direction
    LOCAL totalSkipped := 0
    LOCAL topRecord
    LOCAL curRowPos
    LOCAL browse := ::GetView()
    LOCAL allowOnDataChange

    IF browse:SkipBlock == NIL
        RETURN
    ENDIF

    curRowPos := browse:RowPos

    /* TODO: ask Harbour team if it's possible to have ++start -= curRowPos */
    ++start
    start -= curRowPos

    IF browse:DataSourceType = "O"
        allowOnDataChange := browse:DataSource:allowOnDataChange
        browse:DataSource:allowOnDataChange := .F.
    ENDIF

    browse:SkipBlock:Eval( 0 )

    IF ::FCurRowIndex == NIL .OR. ( browse:DataSourceType = "O" .AND. browse:DataSource:Eof() )
        browse:GoFirstPos()
    ENDIF

    IF start != 0
        browse:SkipBlock:Eval( start )
    ENDIF

    ::FCurRowIndex := 0

    n := browse:MaxRows()

    SWITCH browse:DataSourceType
    CASE "A"
    CASE "H"
        IF Len( browse:DataSource ) = 0
            n := 0
        ENDIF
        EXIT
    CASE "X"
        IF Len( browse:DataSource:List ) = 0
            n := 0
        ENDIF
        EXIT
    ENDSWITCH

    IF ::FGridBufferRows != n
        ::SetGridBufferSize( n )
    ENDIF

    IF !Empty( ::FGridBuffer )

        FOR EACH i IN ::FGridBuffer
            IF i = NIL
                i := {}
            ELSE
                AFill( i, NIL )
            ENDIF
        NEXT

        n := browse:SkipBlock:Eval( -1 )
        topRecord := n = 0

        IF !topRecord
            browse:SkipBlock:Eval( -n )
        ENDIF

        /* Fill in the First row */
        ::GetGridRowData( 1 )

        direction := 1
        i := 2

        WHILE i <= browse:MaxRows()

            n := browse:SkipBlock:Eval( direction )
            totalSkipped += n

            IF n != direction
                IF direction = 1
                    /* check if we are filling right from after GoTop */
                    IF topRecord
                        ::SetGridBufferSize( i - 1 )
                        EXIT
                    ENDIF
                    /* go to first record */
                    IF totalSkipped != 0
                        browse:SkipBlock:Eval( - totalSkipped )
                    ENDIF
                    direction := -1
                    LOOP
                ELSE /* we are at a premature bof */
                    ::SetGridBufferSize( i - 1 )
                    EXIT
                ENDIF
            ENDIF

            IF direction = 1
                n := i
            ELSE
                n := 1
                ::GridBuffer_Insert( 1 )
            ENDIF

            ::GetGridRowData( n )

            i++

        ENDDO

        /* normal fill (top-down) require repos at rowIndex 1 */
        IF direction = 1 .AND. totalSkipped != 0
            browse:SkipBlock:Eval( - totalSkipped )
        ENDIF

        IF curRowPos > browse:RowCount
            browse:RowPos := browse:RowCount
        ELSE
            browse:RowPos := curRowPos
        ENDIF

    ENDIF

    IF allowOnDataChange != NIL
        browse:DataSource:allowOnDataChange := allowOnDataChange
    ENDIF

RETURN

/*
    GetCellValueAtCol
    Teo. Mexico 2008
*/
METHOD FUNCTION GetCellValueAtCol( nCol ) CLASS wxhBrowseTableBase
    LOCAL Result
    LOCAL column
    LOCAL width
    LOCAL picture

    IF nCol = 0
        column := ::FColumnZero
    ELSE
        column := ::FColumnList[ nCol ]
    ENDIF

    picture := column:Picture
    width := column:Width

    IF ::FIgnoreCellEvalError
        BEGIN SEQUENCE WITH {|oErr| Break( oErr ) }
            Result := column:GetValue( ::GetRowParam(), nCol )
        RECOVER
            Result := "<error on block>"
        END SEQUENCE
    ELSE
        Result := column:GetValue( ::GetRowParam(), nCol )
    ENDIF

    IF picture != NIL
        Result := Transform( Result, picture )
    ENDIF

    SWITCH ValType( Result )
    CASE 'N'
        Result := Str( Result )
        EXIT
    CASE 'D'
        Result := FDateS( Result )
        EXIT
    CASE 'L'
        Result := iif( Result, "True", "False" )
        EXIT
    CASE 'C'
    CASE 'M'
        Result := RTrim( Result )
        EXIT
    CASE 'T'
        Result := Trans( ::dtPicture, HB_TSToStr( Result ) )
        EXIT
    CASE 'O'
        IF Result:IsDerivedFrom( "TField" )
            Result := Result:AsString()
            EXIT
        ELSE
            Result := "<" +  Result:ClassName() + ">"
            EXIT
        ENDIF
    OTHERWISE
        Result := "<unknown type '" + ValType( Result ) + "'>"
    END

    IF width != NIL
        Result := Left( Result, width )
    ENDIF

RETURN Result

/*
    GetColLabelValue
    Teo. Mexico 2008
*/
METHOD FUNCTION GetColLabelValue( col ) CLASS wxhBrowseTableBase
    LOCAL value := ""

    IF ++col < 1
        RETURN value
    ENDIF

    value := ::FColumnList[ col ]:Heading

RETURN iif( value = NIL, "", value )

/*
    GetGridRowData
    Teo. Mexico 2008
*/
METHOD PROCEDURE GetGridRowData( row ) CLASS wxhBrowseTableBase
    LOCAL i
    LOCAL cols := Len( ::FColumnList )

    IF row <= ::FGridBufferRows

        IF Len( ::FGridBuffer[ row ] ) < cols
            ASize( ::FGridBuffer[ row ], cols )
        ENDIF

        /* Column Zero */
        IF ::FColumnZero == NIL
            ::FRowLabel[ row ] := LTrim( Str( ::GetView():RecNo ) )
        ELSE
            ::FRowLabel[ row ] := ::GetCellValueAtCol( 0 )
        ENDIF

        FOR i:=1 TO Len( ::FColumnList )
            IF ::FGridBuffer[ row, i ] = NIL
                ::FGridBuffer[ row, i ] := ::GetCellValueAtCol( i )
            ENDIF
        NEXT

    ENDIF

RETURN

/*
    GetRowLabelValue
    Teo. Mexico 2008
*/
METHOD FUNCTION GetRowLabelValue( row ) CLASS wxhBrowseTableBase

    IF ++row > ::FGridBufferRows
        RETURN ""
    ENDIF

RETURN ::FRowLabel[ row ]

/*
    GetRowParam
    Teo. Mexico 2009
*/
METHOD FUNCTION GetRowParam CLASS wxhBrowseTableBase

    IF ::FRowParamType = "B"
        RETURN ::FRowParam:Eval( ::GetView() )
    ENDIF

RETURN ::FRowParam

/*
    GetValue
    Teo. Mexico 2008
*/
METHOD GetValue( row, col ) CLASS wxhBrowseTableBase

    ++row
    ++col

    IF ::FGridBuffer == NIL .OR. row > ::FGridBufferRows .OR. Empty( ::FGridBuffer[ row ] ) .OR. col > Len( ::FGridBuffer[ row ] )
        RETURN ""
    ENDIF

RETURN ::FGridBuffer[ row, col ]

/*
    GridBuffer_Delete
    Teo. Mexico 2011
*/
METHOD PROCEDURE GridBuffer_Delete( row ) CLASS wxhBrowseTableBase
    ADel( ::FGridBuffer, row )
    ::FGridBuffer[ ::FGridBufferRows ] := Array( Len( ::FColumnList ) )
    ADel( ::FRowLabel, row )
RETURN

/*
    GridBuffer_Insert
    Teo. Mexico 2011
*/
METHOD PROCEDURE GridBuffer_Insert( row ) CLASS wxhBrowseTableBase
    AIns( ::FGridBuffer, row )
    ::FGridBuffer[ row ] := Array( Len( ::FColumnList ) )
    AIns( ::FRowLabel, row )
RETURN

/*
    SetRowParam
    Teo. Mexico 2009
*/
METHOD PROCEDURE SetRowParam( rowParam ) CLASS wxhBrowseTableBase

    ::FRowParam := rowParam
    ::FRowParamType := ValType( rowParam )

RETURN

/*
    SetColumnList
    Teo. Mexico 2008
*/
METHOD PROCEDURE SetColumnList( columnList ) CLASS wxhBrowseTableBase
    ::FColumnList := columnList
    ::DeleteCols( 1, ::GetNumberCols() )
    ::AppendCols( Len( columnList ) )
RETURN

/*
    SetColumnZero
    Teo. Mexico 2009
*/
METHOD PROCEDURE SetColumnZero( columnZero ) CLASS wxhBrowseTableBase
    IF columnZero = NIL
        ::GetView():SetRowLabelSize( 0 )
    ELSE
        ::GetView():SetRowLabelSize( wxGRID_AUTOSIZE )
    ENDIF
    ::FColumnZero := columnZero
RETURN

/*
    SetCurRowIndex
    Teo. Mexico 2008
*/
METHOD PROCEDURE SetCurRowIndex( rowIndex ) CLASS wxhBrowseTableBase
    LOCAL n

    IF rowIndex >= ::GetView():RowCount .OR. ::FCurRowIndex == NIL
        RETURN
    ENDIF

    n := rowIndex - ::FCurRowIndex

    IF ::GetView():SkipBlock:Eval( n ) != n
        ::FCurRowIndex := NIL
        ::GetView():SkipBlock:Eval( 0 ) /* forces state at Eof/Bof */
    ELSE
        ::FCurRowIndex := rowIndex
    ENDIF

RETURN

/*
    SetGridBufferSize
    Teo. Mexico 2008
*/
METHOD PROCEDURE SetGridBufferSize( rows ) CLASS wxhBrowseTableBase
    LOCAL start
    LOCAL itm

    IF ::FGridBuffer = NIL
        ::FGridBuffer := Array( rows )
        FOR EACH itm IN ::FGridBuffer
            itm := {}
        NEXT
    ELSEIF Len( ::FGridBuffer ) < rows
        start := rows - Len( ::FGridBuffer ) + 1
        ASize( ::FGridBuffer, rows )
        FOR itm := start TO rows
            ::FGridBuffer[ itm ] := {}
        NEXT
    ENDIF

    ASize( ::FRowLabel, rows )

    ::FGridBufferRows := rows

    IF ::GetView():RowCount != rows
        ::GetView():RowCount := rows
    ENDIF

    ::GetView():ForceRefresh()

RETURN

/*
    SetValue
    Teo. Mexico 2008
*/
METHOD PROCEDURE SetValue( row, col, value ) CLASS wxhBrowseTableBase
    LOCAL oCol
    oCol := ::GetView():GetColumn( col + 1 )

    IF oCol:CanSetValue

        oCol:SetValue( ::GetRowParam(), value )

        /*
         TODO[FIXED]: Check why uncommenting this causes infinite loop (wxMAC at least)
               the loop trigger seems to be ::AutoSizeColumns inside ::RefreshCurrent
         However this is not needed here because an ::RefreshAll is done after
         ::HideCellEditControl()

            Seems that ENTER key triggers twice the SetValue call here...
            anyway, this was solved by not allowing calling twice SetValue here
            an flag in oCol is setted when calling oCol:SetValue to avoid re-enter here

        */
        //::GetView():RefreshCurrent()

    ELSE

        HB_SYMBOL_UNUSED( row )
        //? "Changing:","Row:", row, "Col:", col, "Value:",value

    ENDIF

RETURN

/*
    End Class wxhBrowseTableBase
*/
