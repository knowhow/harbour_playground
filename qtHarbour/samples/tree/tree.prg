
#include "qtHarbour.ch"

FUNCTION Main()
  LOCAL qtApp
  LOCAL treeWidget
  LOCAL treeWidgetItem
  LOCAL i

  qtApp := QApplication():New()

  treeWidget := QTreeWidget():New()
  treeWidget:setColumnCount( 1 )

  FOR i:=1 TO 10
    treeWidgetItem := QTreeWidgetItem():New( QTreeWidget(), { "Item: " + LTrim( Str( i ) ) } )
    treeWidget:insertTopLevelItem( 0, treeWidgetItem )
  NEXT

  ? treeWidget:ClassName

  //treeWidget:resize( 320, 240 )

  treeWidget:setWindowTitle( "Hello world..." )

  treeWidget:show()

  qtApp:exec()

  ? "Finished..."

RETURN NIL

