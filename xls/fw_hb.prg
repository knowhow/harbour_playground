//contrib/hbnf/vidcur.prg

#translate highbyte( <X> )      => ( int( iif( (<X>) \< 0, 65536 + (<X>), (<X>) ) / 256 ) )
#translate lowbyte( <X> )       => (      iif( (<X>) \< 0, 65536 + (<X>), (<X>) ) % 256   )

function nHiByte(x)
return HIGHBYTE(x)

function nLoByte(x)
return LOWBYTE(x)

//http://wiki.fivetechsoft.com/doku.php?id=fivewin_function_d2bin

function D2Bin( num )
local _i, _tmp

// do 6 decimala
for _i := 0 to 6
  _tmp := num * (10 ** _i)
  if round( round(_tmp, 0) - round(_tmp, 7), 8) == 0
      return ALLTRIM(STR( num, num, _i))
  endif
next

// http://wiki.fivetechsoft.com/doku.php?id=fivewin_funcion_cvaltochar
function cValToChar( x )
return hb_ValToStr(x)

// http://wiki.fivetechsoft.com/doku.php?id=fivewin_funcion_ctempfile
function cTempFile(cPath, cExtension)

return TempFile( cPath, cExtension, NIL)

function nOr(val,...)
return NumOr(val,...)



