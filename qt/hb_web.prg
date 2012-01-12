#include "hbqtgui.ch"
#include "hbtrace.ch"
#include "common.ch"


function Main()

LOCAL oWnd
LOCAL oDA
LOCAL oEventLoop
local lExit
local lay1
local oDlg

oDlg := QWebView()
oUrl := QUrl()
oUrl:setUrl( "http://redmine.bring.out.ba" )
oDlg:setWindowTitle( "Harbour-QT Web Page Navigator" )
oDlg:load(oUrl)
oDlg:show()

oDlg:connect( QEvent_Close, {|| QQout("izlazim ..."),  lExit := .t. } )
oEventLoop := QEventLoop( oDlg )

lExit := .f.
DO WHILE ! lExit 
      oEventLoop:processEvents( QEventLoop_AllEvents )
ENDDO

oDlg:show()

oDlg:disconnect( QEvent_Close )
oEventLoop:exit( 0 )

return 0
