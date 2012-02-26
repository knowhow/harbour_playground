#include "qtHarbour.ch"

REQUEST QSTATUSBAR

FUNCTION Main()
    LOCAL wnd := NIL
    LOCAL app

    ? "init"

    app := QApplication():New()

    CreateWindow( @wnd )

    ? "Window created..."

    ? "dumpObjectTree:", wnd:dumpObjectTree()

    app:exec()

RETURN NIL

STATIC PROCEDURE CreateWindow( wnd )
    LOCAL statusBar

    wnd := QMainWindow():New()

    wnd:setWindowTitle( "Main Window" )

    //statusBar := QStatusBar():New()

    //btn:connect( btn, SIGNAL(clicked()), app, SLOT(quit()) )
    //app:connect( QPushButton():New( "press me", wnd ), SIGNAL(clicked()), SLOT(quit()) )

    wnd:show()

    //wnd:setStatusBar( 0 )

    //?
    //? "parent:", statusBar:parent:ClassName
    //wnd:setStatusBar( statusBar )

    //? "parent:", statusBar:parent:ClassName

    statusBar := wnd:statusBar()

    ? "statusBar:ClassName()", statusBar:ClassName()

    statusBar:showMessage( "status bar...", 10000 )

RETURN
