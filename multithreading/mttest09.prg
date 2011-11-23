/*
 * $Id: mttest09.prg 14676 2010-06-03 16:23:36Z vszakats $
 */

/*
 * Harbour Project source code:
 *    demonstration/test code for using the same work area in different
 *    threads. Please note that this program also works when compiled
 *    without thread support.
 *
 * Copyright 2008 Przemyslaw Czerpak <druzus / at / priv.onet.pl>
 * www - http://harbour-project.org
 *
 */

STATIC s_mainThreadID

proc main()
   field F1
   local thID, bResult  
   local i
   s_mainThreadID := hb_threadSelf()
   /* create table */

   dbCreate("_tst",{{"F1","C",1,0}})
   use _tst
   i := 0
   while lastRec() < 10
      dbAppend()
      ? i++
      F1 := chr( recno() )
   enddo

   ? "main thread ID:", s_mainThreadID
   thID := hb_threadStart( @thFunc() )
   ? "current thread ID:", thID
   ? "work area in use, used() =>", used(), alias()
   ? 
   ? "detachhing WA"
   //WAIT "Press a key to detach work area"
   //hb_dbDetach( , {|| countRecords( {|| F1 == "A" } ) } )
   hb_dbDetach( , {|| countRecords( {|| .t. } ) } )
   ? "work area detached, used() =>", used(), alias()
   ? "we will make some other things now..."
   ? "tamo u pozadini se radi cekam dvije sec ......................................................"
   hb_idleSleep( 2 )
   ? REPLICATE("=", 80)
   ? "Zavrsio sam posao unosa, idem sada provjeriti je li onaj sljaker zavrsio sa brojanjem:"
   ? "let's check the result"
   ? "request for work area"
   hb_dbRequest( , , @bResult, .T. )
   ? "work area atached, used() =>", used(), alias()
   ? "query result:", eval( bResult )
   close
   dbDrop("_tst")
   return

proc thFunc()
   local bQuery, xResult

   if hb_dbRequest( , , @bQuery, .T. )
      xResult := Eval( bQuery )
      hb_dbDetach( , {|| xResult } )
   endif
   return

static func countRecords( bFor )
   local nCount := 0
   dbGoTop()
   while ! eof()
      if eval( bFor )
         ? "ajoj jest naporno radit' u drugoj niti", nCount ++
         hb_idleSleep(0.09)
      endif
      dbSkip()
   enddo
   ? "!!! JOB DONE !!!" + iif( hb_threadSelf() == s_mainThreadID, ;
                               " (by main thread)", " (by child thread)" )
   
   ? "napokon ZAVRSIO !"
   return nCount
