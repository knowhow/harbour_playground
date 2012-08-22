
#include "qtHarbour.ch"

Function main()
   LOCAL app
   LOCAL oWnd, oDateEdit , oButton

   app := QApplication():New()

   oWnd := QmainWindow():New()
   oWnd:SetFixedSize( 400, 300 )
   oWnd:setWindowTitle( "Finestra Giovanni" )

   oDateEdit := QDateEdit():New( oWnd )
   oDateEdit:move( 150, 50 )

   oButton := QPushButton():New( oWnd )
   oButton:setText( "Press to Release Parent" )
   oButton:move( 150, 99 )
   oButton:resize( 199, 50 )
   oButton:HbConnect( SIGNAL(clicked()), ;
      { ||
         IF oDateEdit:parent() != NIL
           oDateEdit:setParent( QWidget() ) 
         ENDIF
         RETURN NIL
      } )

   oWnd:show()

   app:exec()

RETURN NIL
