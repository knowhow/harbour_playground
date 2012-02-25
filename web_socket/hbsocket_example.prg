#include "hbclass.ch"
#include "hbsocket.ch"
#include "hbcompat.ch"
#include "fileio.ch"

#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
                  If( <uVar1> == nil, <uVar1> := <uVal1>, ) ;;
                [ If( <uVarN> == nil, <uVarN> := <uValN>, ); ]

#define CRLF chr(13)+chr(10)
#define MAGIC_KEY "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"

#define PID_FILE "pid.pid"
#define SIGHUP   1
#define SIGTERM 15
#define SIGKILL  9

static oServer, oPP

//adjust to own path
#define INCLUDE_PATH "/opt/harbour/include/harbour"
//#define INCLUDE_PATH "c:\harbour\include"

//-----------------------------------------//




//
//socket server test
//
//hbmk2 -mt -lxhb -ldflag=--allow-multiple-definition wsserver
//run: hbsocket [<nPort>]
//like daemon
//hbmk2 -mt -lxhb -ldflag=--allow-multiple-definition __DAEMON__ wsserver
//run: ./hbsocket start [<nPort>]
//


#ifdef __DAEMON__
FUNCTION main( cMode, nPuerto )
#else
FUNCTION main( nPuerto )
#endif      
   
DEFAULT nPuerto := "2000"
   
nPuerto = Val( nPuerto )
   
   //adjust include path
   
   cls
#ifdef __DAEMON__
   if cMode == "start"
     if File( PID_FILE )
        printf(  "daemon is already running" + CRLF )
        return nil
     else
        MemoWrit( PID_FILE, AllTrim( Str( getpid() ) ) )
     endif
   elseif cMode == "stop"
     if File( PID_FILE )
        nProcess = Val( MemoRead( PID_FILE ) ) + 1
        hb_tracelog( "finishing daemon", nProcess )
        KillTerm( nProcess )
        return nil
     endif
   else
     printf(  CRLF + "FiveTech daemon. Syntax:" + CRLF )
     printf(  "   ./daemon start" + CRLF )
     printf(  "   ./daemon stop" + CRLF + CRLF  )
     return nil
   endif   

   SetSignalsHandler()

   if Fork() > 0
     return nil  // Parent process ends and child process continues
   endif

   umask( 0 ) // In order to write to any files (including logs) created by the daemon

   SetSignalAlarm()

   printf(  "daemon starts" + CRLF )

   // Close standard files descriptors
   // CloseStandardFiles()
#endif

   oPP = __pp_Init( INCLUDE_PATH, "std.ch" )

   oServer = THB_Socket():new( nPuerto )
#ifndef __DAEMON__   
   printf(  "Presione <ESC> para salir" + CRLF)
#endif   
   oServer:lDebug = .T.
   oServer:bDebug = {| aParam | LogFile( "debug.txt", aParam ) }
   oServer:bOnProccess = {| oServer | Proceso( ) }
   ? "set bOnRead"
   oServer:bOnRead = {| oSrv, oClient | OnReadProcess( oClient ) }
   oServer:Listen()
   oServer:End()
#ifdef __DAEMON__
   printf(  CRLF + "daemon ends" + CRLF )
   nProcess = Val( MemoRead( PID_FILE ) ) + 1
   FErase( PID_FILE )
   KillKill( nProcess )
#endif    

   
RETURN nil

#ifdef __DAEMON__
function SignalHandler( nSignal )

  do case 
     case nSignal == SIGHUP
          printf(  "Received SIGHUP signal" + CRLF  )
     case nSignal == SIGKILL .or. nSignal == SIGTERM
          printf( "to exit..." + CRLF )
          oServer:lExit = .T. 
     otherwise
          printf(  "Unhandled SIGNAL " + AllTrim( Str( nSignal ) ) + CRLF )
  endcase

return nil

#endif

static function OnReadProcess( oClient )
   
   local cMask, cData, n, cMsg:="", oError
   local nMaskPos := 1

   ? "onread"
   
   //handshake
   if oClient:Cargo == NIL .OR. ( hb_HHasKey( oClient:Cargo, "HANDSHAKE" ) .AND. ! oClient:Cargo[ "HANDSHAKE" ] )
      HandShake( oClient ) 
   else 
      cData = oClient:cBuffer
      cMask = SubStr( cData, 3, 4 )
      for n = 1 to Len( SubStr( cData, 7 ) )
          cMsg += Chr( hb_BitXOR( Asc( SubStr( cMask, nMaskPos++, 1 ) ), Asc( SubStr( cData, 6 + n, 1 ) ) ) )
          if nMaskPos == 5
             nMaskPos = 1
          endif   
      next 
   
      oClient:SendData( chr( 129 ) + chr( len( cMsg ) ) + hb_StrToUTF8( cMsg ) )
      
      TRY
         cMsg = __pp_Process( oPP, cMsg )
         cAnswer = uValToChar( &cMsg ) 
      CATCH oError
         cAnswer = "Error: " + oError:Description
      END      

      oClient:SendData( Chr( 129 ) + Chr( Len( cAnswer ) ) + hb_StrToUtf8( cAnswer ) )
   endif

return nil

//-----------------------------------------//

static function HandShake(  oClient )
   local nLen, cBuffer, cContext, cKey, cSend
   
   cBuffer := oClient:cBuffer

   ? "handshake"

   cContext = GetContext( cBuffer, "Sec-WebSocket-Key" )
   cKey     = hb_Base64Encode( hb_sha1( cContext + MAGIC_KEY, .T. ) ) 
    // + "." add something to check that the handshake gets wrong
   
   cSend = "HTTP/1.1 101 Switching Protocols" + CRLF + ;
           "Upgrade: websocket" + CRLF + ;
           "Connection: Upgrade" + CRLF + ;
           "Sec-WebSocket-Accept: " + cKey + CRLF + CRLF   

   nLen = oClient:SendData( cSend )

   IF nLen > 0
      oClient:Cargo = hb_Hash()
      oClient:cargo[ "HANDSHAKE" ] = .T.    
      
   ENDIF

   
return nil 

//-----------------------------------------//

static function GetContext( cData, cContext )

  local nLen := Len( cContext )
  local cValue := ""
  local aLines
  local aSubLine
  local cRow
  
  aLines := hb_ATokens( cData, CRLF )
  for each cRow in aLines
     if cContext $ cRow
        aSubLine = hb_ATokens( cRow, ":" )
        cValue = AllTrim( aSubLine[ 2 ] )
        exit
     endif
  next

return cValue

//-----------------------------------------//

FUNCTION Proceso(  )
  
   //? "procesiram"
 
   oServer:lExit := ( LastKey() == 27 )
   
RETURN oServer:lExit

//-----------------------------------------//


