//
//socket server test
//
//hbmk2 -mt -lxhb -ldflag=--allow-multiple-definition hbsocket
//run: hbsocket [<nPort>]
//like daemon
//hbmk2 -mt -lxhb -ldflag=--allow-multiple-definition __DAEMON__ wsserver
//run: ./hbsocket start [<nPort>]
//

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
//#define INCLUDE_PATH "/usr/local/include/harbour"
#define INCLUDE_PATH "/opt/harbour/include/harbour"


//-----------------------------------------//

#ifdef __DAEMON__
FUNCTION main( cMode, nPuerto )
#else
FUNCTION main( nPuerto )
#endif      
   DEFAULT nPuerto := "2000"
   
   nPuerto = Val( nPuerto )
  
   ? nPuerto 
   //adjust include path
   
   //cls
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

   _fork := Fork() 
   if _fork > 0
     ? "fork ?? =", _fork 
     // Parent process ends and child process continues
     return nil  
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
   printf(  "lupi <ESC> za kraj" + CRLF)
#endif   
   oServer:lDebug = .T.
   oServer:bDebug = {| aParam | LogFile( "debug.txt", aParam ) }
   oServer:bOnProccess = {| oServer | Proceso( ) }
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

   cContext = GetContext( cBuffer, "Sec-WebSocket-Key" )
   cKey     = hb_Base64Encode( hb_sha1( cContext + MAGIC_KEY, .T. ) ) // + "." add something to check that the handshake gets wrong
   
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
   
   oServer:lExit := ( LastKey() == 27 )
   
RETURN oServer:lExit


function jen_dva_tri()
return "funkcija jedan_dva_tri"

//-----------------------------------------//

CLASS THB_Socket

   DATA   cBindAddress INIT "127.0.0.1"

   DATA bDebug
   DATA bOnAccept
   DATA bOnClose
   DATA bOnListen
   DATA bOnRead
   DATA bOnWrite
   DATA bOnProccess
 
   DATA cBuffer
   DATA cLogFile
   DATA cError
 
   DATA hClients
   DATA hMutexUser

   DATA nClientId
   DATA nPort

   DATA lDebug
   DATA lExit        

   DATA pSocket

   METHOD New()
   METHOD End()

   METHOD Listen()

   METHOD NewId() INLINE ::nClientId++
   
   METHOD OnAccept( oClient )
   METHOD OnClose()
   METHOD OnRead( oClient )
   
   METHOD SendData( cText ) 
   
   HIDDEN:
   
   METHOD Debug( cText ) 


ENDCLASS

//-----------------------------------------//

METHOD New( nPort ) CLASS THB_Socket

   DEFAULT nPort := 8080
   
   ::nClientId = 1
   ::nPort     = nPort
   ::hClients  = hb_Hash()

   ::lExit     = .F.
   ::lDebug    = .F. 
   

RETURN Self

//-----------------------------------------//

METHOD End() CLASS THB_Socket

   LOCAL pClient
   
   for each pClient in ::hClients
      ::OnClose( pClient )
   next
   
   if ::pSocket != NIL
      //hb_socketClose( ::pSocket )
   endif

RETURN nil

//-----------------------------------------//

METHOD Debug( ... ) CLASS THB_Socket
   
   local aParams := hb_aParams()

   IF ::lDebug 
   
      IF hb_IsBlock( ::bDebug )
         Eval( ::bDebug, aParams )
      ELSE
         AEval( aParams, {| u | printf( u ) } )
      ENDIF
      
   ENDIF

RETURN NIL
//-----------------------------------------//

METHOD Listen() CLASS THB_Socket

   ::pSocket     = hb_socketOpen( )
   ::hMutexUser  = HB_MutexCreate()   

   IF ! hb_socketBind( ::pSocket, { HB_SOCKET_AF_INET, ::cBindAddress, ::nPort } )
      PRINTF( ::cError :=  "Bind error " + hb_ntos( hb_socketGetError() ) )
      hb_socketClose( ::pSocket )
      RETURN .F.
   ENDIF

   IF ! hb_socketListen( ::pSocket )
      PRINTF( ::cError :=  "Listen error " + hb_ntos( hb_socketGetError() ) )
      hb_socketClose( ::pSocket )
      RETURN .F.
   ENDIF
      
   if hb_IsBlock( ::bOnListen )
      Eval( ::bOnListen, Self )
   endif
   ::Debug( "LISTEN" )

   hb_ThreadStart( @OnAccept(), Self )

   DO WHILE ! ::lExit
   
      if ::bOnProccess != nil 
         eval( ::bOnProccess, Self )
      endif
      
      inkey( 0.5 )  
               
   ENDDO    

   ::End()
   
RETURN .T.

//-----------------------------------------//

METHOD OnAccept() CLASS THB_Socket

   local pClientSocket
   local oClient
   
   ::Debug( "ONACCEPT" )
      
   do while ! ::lExit
      inkey( 0.1 )

      if ! Empty( pClientSocket := hb_socketAccept( ::pSocket,, 1000 ) )
         ::Debug( "ACCEPTED", pClientSocket )
         hb_mutexLock( ::hMutexUser )
         ::NewId()
         oClient = THB_SocketClient():New( Self )
         oClient:nID = ::nClientId
         oClient:hSocket = pClientSocket
         hb_HSET( ::hClients, ::nClientId, oClient )
         hb_mutexUnlock( ::hMutexUser )
         hb_ThreadStart( @OnRead(), Self, oClient )
         if ::bOnAccept != NIL
            Eval( ::bOnAccept, Self, oClient )
         endif
      elseif ! ::lExit
         //? "Catched error ",  hb_ntos( hb_socketGetError() )
         //EXIT
      endif
   enddo
   
RETURN nil

//------------------------------------------------------//

METHOD OnClose( oClient ) CLASS THB_Socket
   
   ::Debug( "CLIENT CLOSED", oClient:hSocket, oClient:nID )
   
   hb_mutexLock( ::hMutexUser )
   hb_HDEL( ::hClients, oClient:nID )
   hb_mutexUnlock( ::hMutexUser )     
   
   oClient:End()
   oClient = NIL
   if ::bOnClose != NIL 
      Eval( ::bOnClose, Self )
   endif      


return nil

//------------------------------------------------------//

METHOD OnRead( oClient ) CLASS THB_Socket

   local lMyExit    := .F.
   local cData, oError
   local nLength  := 0
   local nRetry   := 0
   local lActive  := .T.
   local cBuffer
   
   do while ! lMyExit
      inkey( 0.05 )
      cBuffer = Space( 4096 )   
      TRY
         if ( nLength := hb_socketRecv( oClient:hSocket, @cBuffer,,, 10000 ) ) > 0
            oClient:cBuffer = AllTrim( cBuffer )
          endif         
      CATCH oError
         ::Debug( oError:Description )
         lMyExit := .t.
      END 

      if lMyExit
         EXIT
      endif
      
      if nLength > 0
         ::Debug( "ONREAD", oClient:hSocket, oClient:cBuffer )
      endif

      if nLength == 0
         lMyExit = .T.         
      elseif nLength > 1         
         if ::bOnRead != NIL
            Eval( ::bOnRead, Self, oClient )
         endif
      endif

   enddo  
   
   ::Debug( "LISTEN FINISHED", oClient:hSocket )   
   
   ::OnClose( oClient )


RETURN nil

//-----------------------------------------//

METHOD SendData( oClient, cSend ) CLASS THB_Socket

   local nLen 

   ::Debug( "SENDING...", cSend )

   DO WHILE Len( cSend ) > 0
      IF ( nLen := hb_socketSend( oClient:hSocket, @cSend ) ) == - 1
         EXIT
      ELSEIF nLen > 0
         cSend = SubStr( cSend, nLen + 1 )     
      ENDIF
   ENDDO
   
RETURN nLen   

//-----------------------------------------//

//-----------------------------------------//

CLASS THB_SocketClient

   DATA hSocket
   DATA nID
   DATA Cargo
   DATA oServer
   DATA cBuffer
   
   METHOD New( oServer )
   
   METHOD End() INLINE ::hSocket := NIL
   
   METHOD SendData( cSend ) INLINE ::oServer:SendData( Self, cSend )

ENDCLASS

//-----------------------------------------//

METHOD New( oSrv ) CLASS  THB_SocketClient

   ::oServer = oSrv

RETURN Self

//-----------------------------------------//

static FUNCTION OnAccept( oSrv )
   oSrv:OnAccept()
RETURN nil

//-----------------------------------------//

static FUNCTION OnRead( oSrv, oClient )
   oSrv:OnRead( oClient )
RETURN nil
//-----------------------------------------//

//---------------------------------------------------------------------------//

static function LogFile( cFileName, aInfo )

   local hFile, cLine := DToC( Date() ) + " " + Time() + ": ", n

   for n = 1 to Len( aInfo )
      cLine += uValToChar( aInfo[ n ] ) + Chr( 9 )
   next
   cLine += CRLF

   if ! File( cFileName )
      FClose( FCreate( cFileName ) )
   endif

   if( ( hFile := FOpen( cFileName, FO_WRITE ) ) != -1 )
      FSeek( hFile, 0, FS_END )
      FWrite( hFile, cLine, Len( cLine ) )
      FClose( hFile )
   endif

return nil

//---------------------------------------------------------------------------//

static function uValToChar( uVal )

   local cType := ValType( uVal )

   do case
      case cType == "C" .or. cType == "M"
           return uVal

      case cType == "D"
           #ifdef __XHARBOUR__
              if HasTimePart( uVal )
                 return If( Year( uVal ) == 0, TToC( uVal, 2 ), TToC( uVal ) )
              endif
           #endif
           return DToC( uVal )

      #ifdef __HARBOUR__
         #ifndef __XHARBOUR__
            case cType == "T"
               return If( Year( uVal ) == 0, HB_TToC( uVal, '', Set( _SET_TIMEFORMAT ) ), HB_TToC( uVal ) )
         #endif
      #endif

      case cType == "L"
           return If( uVal, ".T.", ".F." )

      case cType == "N"
           return TStr( uVal )

      case cType == "B"
           return "{|| ... }"

      case cType == "A"
           return hb_dumpvar( uVal )

      case cType == "O"
           return If( __ObjHasData( uVal, "cClassName" ), uVal:cClassName, uVal:ClassName() )

      case cType == "H"
           return "{=>}"

      case cType == "P"
           #ifdef __XHARBOUR__
              return "0x" + NumToHex( uVal )
           #else
              return "0x" + hb_NumToHex( uVal )
           #endif

      otherwise

           return ""
   endcase

return nil

//---------------------------------------------------------------------------//

function TStr( n )
return AllTrim( Str( n ) )

//---------------------------------------------------------------------------//

function QOut_2( c )

   c = uValToChar( c )

   oServer:SendData( Chr( 129 ) + Chr( Len( c ) ) + hb_StrToUtf8( c ) )
   
return nil   


//---------------------------------------------------------------------------//

#ifdef __DAEMON__

#pragma BEGINDUMP

#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <syslog.h>
#include <string.h>
#include <signal.h>

#include <hbapi.h>
#include <hbvm.h>

HB_FUNC( FORK )
{
 hb_retnl( fork() );
}

HB_FUNC( UMASK )
{
  umask( hb_parnl( 1 ) );
}

HB_FUNC( EXIT )
{
  exit( EXIT_SUCCESS );
}

HB_FUNC( GETPPID )
{
  hb_retnl( getppid() );
}

HB_FUNC( GETPID )
{
  hb_retnl( getpid() );
}

HB_FUNC( KILLTERM )
{
  kill( hb_parnl( 1 ), SIGTERM );
}

HB_FUNC( KILLKILL )
{
  kill( hb_parnl( 1 ), SIGKILL );
}

HB_FUNC( CLOSESTANDARDFILES )
{
  close( STDIN_FILENO );
  close( STDOUT_FILENO );
  close( STDERR_FILENO );
}

void CatchAlarm( int sig )
{
 HB_SYMBOL_UNUSED( sig );
}

void SignalHandler( int sig )
{
  hb_vmPushSymbol( hb_dynsymGetSymbol( "SIGNALHANDLER" ) );
  hb_vmPushNil();
  hb_vmPushLong( sig );
  hb_vmFunction( 1 );
}

HB_FUNC( SETSIGNALALARM )
{
 signal( SIGALRM, CatchAlarm );
}

HB_FUNC( SETSIGNALSHANDLER )
{
  signal( SIGHUP, SignalHandler );
  signal( SIGTERM, SignalHandler );
  signal( SIGINT, SignalHandler );
  signal( SIGQUIT, SignalHandler );
  signal( SIGKILL, SignalHandler );
}

HB_FUNC( ALARM )
{
 alarm( hb_parnl( 1 ) );
}

HB_FUNC( SLEEP )
{
 sleep( hb_parnl( 1 ) );
}

HB_FUNC( SYSLOG )
{
  syslog( hb_parnl( 1 ), hb_parc( 2 ), hb_parc( 3 ) );
}

HB_FUNC( TEST )
{
  hb_retnl( LOG_WARNING );
}

#pragma ENDDUMP

#endif 
#pragma BEGINDUMP
#include <hbapi.h>

HB_FUNC( PRINTF )
{
 printf( hb_parc( 1 ) );
}


#pragma ENDDUMP
