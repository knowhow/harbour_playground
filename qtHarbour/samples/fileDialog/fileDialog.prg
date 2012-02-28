
#include "qtHarbour.ch"

CLASS MyApplication FROM QApplication
  METHOD DoFileDialog
ENDCLASS

METHOD DoFileDialog CLASS MyApplication
  LOCAL fileDialog

  fileDialog := QFileDialog():New()

  fileDialog:exec()

RETURN NIL

FUNCTION Main()
  LOCAL app
  LOCAL widget
  LOCAL button1

  app := MyApplication():New()

  widget := QWidget():New()

  button1 := QPushButton():New( widget )
  button1:setText( "File Dialog" )

  button1:hbConnect( SIGNAL(clicked()), app, "DoFileDialog" )

  widget:show()

  app:exec()

RETURN NIL
