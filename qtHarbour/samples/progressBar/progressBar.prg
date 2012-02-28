
#include "qtHarbour.ch"

CLASS MyApplication FROM QApplication
    DATA mainWindow
ENDCLASS

FUNCTION Main()
  LOCAL app

  app := MyApplication():New()

  CreateDialog()

  app:exec()

RETURN NIL

STATIC PROCEDURE CreateDialog()

  qApp():mainWindow := QMainWindow():New()

  QProgressBar():New( qApp():mainWindow )

  qApp():mainWindow:show()

RETURN
