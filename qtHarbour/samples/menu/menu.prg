
#include "qtHarbour.ch"

REQUEST QMenu

FUNCTION Main()
  LOCAL qtApp
  LOCAL treeWidget
  LOCAL menuBar
  LOCAL i

  qtApp := QApplication():New()

  treeWidget := QMainWindow():New()

  menuBar := QMenuBar():New( treeWidget )

  FOR i:=1 TO 5
    menuBar:addMenu( "Menu Item " + LTrim( Str( i ) ) )
  NEXT

  //treeWidget:addTab( QWidget():New(), "Widget" )
  //treeWidget:addTab( QPushButton():New( "press me..." ), "Button" )

  ? treeWidget:ClassName
  ? menuBar:ClassName

  //treeWidget:resize( 320, 240 )

  treeWidget:setWindowTitle( "Hello world..." )

  treeWidget:show()

  qtApp:exec()

  ? "Finished..."

RETURN NIL
