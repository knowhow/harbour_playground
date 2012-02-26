
#include "qtHarbour.ch"

FUNCTION Main()
  LOCAL qtApp
  LOCAL widget

  qtApp := QApplication():New()

  BuildWidgets( @widget )

  qtApp:exec()

RETURN NIL

PROCEDURE BuildWidgets( tableWidget )
  LOCAL tableWidgetItem
  LOCAL i,n

  n := 10

  tableWidget := QTableWidget():New( n, 10 )

  tableWidget:show()

  FOR i:=1 TO n
    tableWidgetItem := QTableWidgetItem():New( "Hello " + Str( i ), 0 )
    tableWidget:setItem( i, 1, tableWidgetItem )
  NEXT

  ? "item(): ", tableWidget:item( 1, 1 ):text

  ? "moving items..."

  FOR i:=1 TO n
    IF (i % 2) = 0
      tableWidgetItem := tableWidget:takeItem( i, 1 )
      tableWidget:setItem( i, 2, tableWidgetItem )
    ENDIF
  NEXT

RETURN
