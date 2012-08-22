
#include "qtHarbour.ch"

FUNCTION Main()
  LOCAL app
  LOCAL mainWindow

  app := QApplication():New()

  QTimer():New():singleShot( 10000, app, SLOT(quit()) )

  mainWindow := QMainWindow():New()

  mainWindow:show()

  app:exec()

RETURN NIL
