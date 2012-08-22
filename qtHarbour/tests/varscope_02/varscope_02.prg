/*
 * $Id: varscope_02.prg 97 2011-03-21 17:37:23Z tfonrouge $
 *
 * (C) 2011. qtHarbour
 * (C) 2011. Teo Fonrouge
 */

/*
    Tests:

    * A locally stored Qt object is automatically destroyed when var is out of scope

*/

#include "qtHarbour.ch"

FUNCTION Main
    LOCAL o
    LOCAL messageBox

    o := QApplication():New()

    Proc1()

    messageBox := QMessageBox():New()
    messageBox:setText( "Ernad Husremović" )
    messageBox:exec()

    o:exec()

RETURN NIL

STATIC PROCEDURE Proc1()
    LOCAL widget

    /* widget will be created, showed, and at exit procedure destroyed (local var out of scope)*/
    widget := QWidget():New()

    widget:show()

RETURN
