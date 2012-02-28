
FUNCTION Main()
  LOCAL time

  time := QTime():New()

  ? time:currentTime():toString()

  ? VALTYPE(time)
  ? "time:", time:fromString( "12:50", "h:m:s" )

RETURN NIL
