/*
 * $Id: varscope_01.prg 97 2011-03-21 17:37:23Z tfonrouge $
 *
 * (C) 2011. qtHarbour
 * (C) 2011. Teo Fonrouge
 */

/*
    Tests:

    * A locally stored Qt object can be available out of the scope where it's defined
        ( MyApplication is retrieved in Proc1() )

*/

#include "qtHarbour.ch"

CLASS MyApplication FROM QApplication
    DATA widget1
ENDCLASS

FUNCTION Main
    LOCAL app

    app := MyApplication():New()

    Proc1()

    app:exec()

RETURN NIL

STATIC PROCEDURE Proc1()
    LOCAL app

    app := qApp()  // Qt macro to get instance of Q[Core]Application

    app:widget1 := QWidget():New()

    app:widget1:show()

RETURN
