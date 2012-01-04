/*
 * $Id: mttest05.prg 14676 2010-06-03 16:23:36Z vszakats $
 */

/*
 * Harbour Project source code:
 *    demonstration/test code for thread static variables
 *
 * Copyright 2008 Przemyslaw Czerpak <druzus / at / priv.onet.pl>
 * www - http://harbour-project.org
 *
 */

#define N_THREADS 5
#define N_COUNT   1000000
#define N_INIT    100

thread static s_var := N_INIT

proc main()
   local aThreads := {}, i, nSum
   ? Version()
   s_var := N_INIT * 25
   ? "Starting threads: "
   for i :=1 to N_THREADS
      aadd( aThreads, hb_threadStart( @thFunc() ) )
      ?? "<" + ltrim( str( i ) ) + ">"
   next
   ? "Waiting for threads..."
   nSum := 0
   altd()
   aEval( aThreads, { |x| hb_threadJoin( x, @i ), nSum += i } )
   ? "Threads joined"
   ? "Sum of results:", nSum
   ? "     should be:", N_THREADS * ( N_INIT + N_COUNT ), ;
     iif( nSum == N_THREADS * ( N_INIT + N_COUNT ), "OK", "ERROR" )
return

func thFunc()
   local i
   for i := 1 to N_COUNT
      ++s_var
   next
return s_var
