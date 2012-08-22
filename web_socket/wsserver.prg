// HTML5 WebSockets server example 

#include "hbclass.ch"
#include "hbcompat.ch"

//extern hb_version, TDataBase

static oWnd, oSocket, oClient, oPP

#define MAGIC_KEY "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"                   
   
function Main()

   oSocket = THB_Socket():New( 2000 )

   ? VALTYPE(oSocket)

   oSocket:bOnAccept = { | oSocket | Qout("bOnAccept"), ;
               oClient := THB_SocketClient():Accept( oSocket:hSocket ),;
               oClient:Cargo := .F.,; //if handshake is valid
               oClient:bRead := { | oSocket | OnRead( oSocket ) },;
               oClient:bClose := { | oSocket | OnClose( oSocket ) } }

   ? "listen on 2000"
   oSocket:Listen()

return nil

//------------------------------------------------------------------------//

function OnRead( oSocket )

   local cData := oSocket:GetData()
   local cContext, cKey, cSend
   local cMask, cMsg := "", nMaskPos := 1, n, cAnswer, oError
   
   ? "onread"

   if ! oSocket:Cargo 
      cContext = GetContext( cData, "Sec-WebSocket-Key" )
      cKey     = hb_Base64Encode( hb_sha1( cContext + MAGIC_KEY, .t. ) ) 
      cSend    = "HTTP/1.1 101 Switching Protocols" + CRLF + ;
                        "Upgrade: websocket" + CRLF + ;
                        "Connection: Upgrade" + CRLF + ;
                        "Sec-WebSocket-Accept: " + cKey + CRLF + CRLF
      oSocket:SendData(  cSend )
      oSocket:Cargo = .T.
   else 
      cMask = SubStr( cData, 3, 4 )
      for n = 1 to Len( SubStr( cData, 7 ) )
         cMsg += Chr( nXor( Asc( SubStr( cMask, nMaskPos++, 1 ) ), Asc( SubStr( cData, 6 + n, 1 ) ) ) )
         if nMaskPos == 5
            nMaskPos = 1
         endif   
      next   
      
      TRY 
         cMsg = __pp_Process( oPP, cMsg )
         cAnswer = cValToChar( &cMsg ) 
      CATCH oError
         cAnswer = "Error: " + oError:Description
      END      

      oSocket:SendData( Chr( 129 ) + Chr( Len( cAnswer ) ) + hb_StrToUtf8( cAnswer ) )
   endif
   
return nil

//------------------------------------------------------------------------//

function OnClose( oSocket )

   ?  "Client has closed!"

   oSocket:End()
   oSocket = NIL

return nil

//------------------------------------------------------------------------//

static function GetContext( cData, cContext )

  local nLen := Len( cContext )
  local cValue := ""
  local aLines := hb_ATokens( cData, CRLF )
  local aSubLine
  local cRow

  ? "get context"

  for each cRow in aLines
     if cContext $ cRow
        aSubLine := hb_ATokens( cRow, ":" )
        cValue := AllTrim( aSubLine[ 2 ] )
        exit
     endif
  next

return cValue

//------------------------------------------------------------------------//

//function QOut( c )

// return cValToChar( c )   

//------------------------------------------------------------------------//
