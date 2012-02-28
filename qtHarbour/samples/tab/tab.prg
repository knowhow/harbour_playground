
#include "qtHarbour.ch"

FUNCTION Main()
  LOCAL qtApp
  LOCAL treeWidget

  qtApp := QApplication():New()

  treeWidget := QTabWidget():New()

  treeWidget:addTab( QWidget():New(), "Widget" )
  treeWidget:addTab( QPushButton():New( "press me..." ), "Button" )

  ? treeWidget:ClassName

  //treeWidget:resize( 320, 240 )

  treeWidget:setWindowTitle( "Hello world..." )

  treeWidget:show()

  qtApp:exec()

  ? "Finished..."

RETURN NIL
