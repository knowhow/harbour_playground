#include "inkey.ch"
#include "hbclass.ch"

#translate TEST_LINE( <x>, <result> ) => TEST_CALL( #<x>, {|| <x> }, <result> )

#include "FileXLS.ch"

procedure Main(...)


_xls := TFileXLS():New( "test.xls", , , .F., .T. )

@ 1, 1 XLS SAY 1 OF _xls ALIGNAMENT ALIGN_RIGHT


SET XLS TO DISPLAY  OF _xls


_xls:end()




