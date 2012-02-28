#include "inkey.ch"
#include "hbclass.ch"

#translate TEST_LINE( <x>, <result> ) => TEST_CALL( #<x>, {|| <x> }, <result> )

#include "FileXLS.ch"

procedure Main(...)
local nFont1, nFormat1, _i, _xls

_tmp := 0.001
? _tmp, D2Bin(_tmp)


DEFINE XLS FONT nFont1 NAME "Arial" HEIGHT 12 BOLD 

DEFINE XLS FORMAT nFormat1 PICTURE "0.00"

_xls := TFileXLS():New( "test_2.xls", , , .F., .T. )

for _i := 1 to 10

   @ _i, _i XLS SAY _i OF _xls FONT nFont1 FORMAT nFormat1

next



SET XLS TO DISPLAY  OF _xls


_xls:end()


_cmd := "sh open test.xls"

? "run", _cmd
run _cmd


