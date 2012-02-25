#include "inkey.ch"

#translate TEST_LINE( <x>, <result> ) => TEST_CALL( #<x>, {|| <x> }, <result> )

static __keystrokes := {}



static __only_one := 0

procedure Main(...)
local aPom
local cPom
local nPos
local pg_sql
local _var_1 := "0"
local _var_2 := "5"
local _var_3 := 100
local _var_4 := 0
CLEAR
? "pogledati: harbour-3.0.0/tests/inkeytst.prg"

/*
moze i vise varijabli odjednom:

__keystrokes := { ;
   { "_var_1", "1", K_ENTER}, ;
   { "_var_2", K_ENTER, "5", "444", K_ENTER} ;
}

*/

__keystrokes := { ;
   { "_var_1", "1", K_ENTER}, ;
   { "_var_2", K_ENTER, "2"}, ;
   { "_var_3", "333", K_DOWN}, ;
   { "_var_4", "7", K_ENTER} ;
}


 

nTask := HB_IDLEADD( {|| keystroke_test_1()} )

CLEAR
SET TYPEAHEAD TO 1000

@ 1, 1 SAY "ukucaj 1 pa enter" GET _var_1 PICT "9" 



READ

CLEAR
@ 5, 1 SAY "ukucaj 2 pa enter   " GET _var_2 PICT "9"  WHEN {|| valid_2(@_var_2)}
@ 6, 1 SAY " unesi nesto u var 3" GET _var_3 PICT "999" 
@ 7, 1 SAY " unesi nesto u var 4" GET _var_4 PICT "99" 

READ

if _var_1 == "1"
  ? "dobro si", _var_1
else
  ? "loshe si", _var_1
endif

? "_var_2 nakon ovih vratolomija je ", _var_2

? "_var_3", _var_3
? "_var_4", _var_4


Qout("uklanjam idleadd task")
HB_IDLEDEL(nTask)


return


function valid_2(var_2)

Alert("uletio sam u valid 2")

var_2 := "8"

return .t.

function keystroke_test_1()
local _var_name
local _i, _j, _expected_var_name
local _buffer
for _i := 1 to LEN(__keystrokes)

    if (__only_one + 1) == _i 
    
       _var_name := READVAR()
      
       _expected_var_name := UPPER(__keystrokes[_i, 1])

       if (_var_name == _expected_var_name)
            _buffer := {}
            for _j := 2 TO LEN(__keystrokes[_i])
                 AADD(_buffer, __keystrokes[_i, _j])
            next
            put_to_keyboard_buffer(_buffer)

             __only_one ++
       endif

    endif

next

return .t.


static function put_to_keyboard_buffer(buffer)
local _i

for _i := 1 to LEN(buffer)
   if VALTYPE(buffer[_i]) == "C"
       __KEYBOARD(buffer[_i])
   elseif VALTYPE(buffer[_i]) == "N"
        HB_KEYPUT(buffer[_i])

   else
        Alert("buffer tip: "  + VALTYPE(buffer[_i]) + " ?!")
   endif

next

return .t.

      
