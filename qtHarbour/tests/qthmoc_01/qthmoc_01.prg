
#include "qtHarbour.ch"

CLASS MyApplication FROM QApplication
PUBLIC:
    DATA mainWindow
ENDCLASS

FUNCTION Main()

    QApplication():New()

    BuildWidgets()

    qApp():exec()

RETURN NIL

STATIC PROCEDURE BuildWidgets()

    qApp():mainWindow := MyMainWindow():New()

    qApp():mainWindow::show()

RETURN
