
#include "qtHarbour.ch"

REQUEST QSIZE,QPOINT

FUNCTION Main()
  LOCAL app
  LOCAL mainWindow
  LOCAL settings

  app := QApplication():New()

  settings := QSettings():New( "MyHarbourSoft", "InvoiceApp" )

  ? "settings:format():", settings:format()

  app:setOrganizationName( "MyHarbourSoft" )
  app:setOrganizationDomain( "myharboursoft.com" )
  app:setApplicationName( "InvoiceApps" )

  mainWindow := QMainWindow():New()

  mainWindow:show()

  // TODO: move the following section to endclose event of mainWindow
  settings:beginGroup("MainWindow")
  settings:setValue("size", mainWindow:size())
  settings:setValue("pos", mainWindow:pos())
  settings:setValue("uno", 1)
  settings:setValue("dos", 2)
  settings:endGroup()

  app:exec()

RETURN NIL
