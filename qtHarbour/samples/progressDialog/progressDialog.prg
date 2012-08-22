
#include "qtHarbour.ch"

FUNCTION Main()
  LOCAL app

  app := QApplication():New()
  
  CreateDialog()
  
  app:exec()

RETURN NIL

STATIC PROCEDURE CreateDialog()
  LOCAL mainWnd
  LOCAL progressDialog
  
  mainWnd := QMainWindow():New()

  progressDialog := QProgressDialog():New( mainWnd, 0 )

  mainWnd:show()

  progressDialog:exec()

RETURN
