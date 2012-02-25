#include "inkey.ch"

#translate TEST_LINE( <x>, <result> ) => TEST_CALL( #<x>, {|| <x> }, <result> )

static __keystrokes := {}
static __only_one := 0


#ifdef TEST


procedure Main()
local _task, _var_key, _key_test, _key_tests := {}
local _i := 1

AADD(_key_tests, key_test_1())
AADD(_key_tests, key_test_2())

for each _key_test IN _key_tests 

  __keystrokes := _key_test["keys"]
  __only_one := 0
   CLEAR TYPEAHEAD
   _task := HB_IDLEADD( {|| test_keystrokes()} )

  run_main()

  Qout("uklanjam idleadd task")
  HB_IDLEDEL(_task)
  CLEAR TYPEAHEAD

  check_test_vars(_key_test["vars"])
  _i++
next

return

static function check_test_vars(var_tests)
local  _v1, _v2, _var_key := NIL

for each _var_key in var_tests:Keys
      ? "var:", _var_key
      
      _v1 := __g_test_vars[_var_key] 
      _v2 := var_tests[_var_key]

      if VALTYPE(_v1) == VALTYPE(_v2)

            if _v1 == _v2
                ??  " OK: "
            else
                ?? " ERR: "
            endif

      else
            ?? " ERR: tipovi razliciti:"
      endif
      ?? " ocekivana vrijednost (" + VALTYPE(_v2) + ")",  _v2
      ?? " dobijena vrijednost (" +  VALTYPE(_v1) + ")", _v1
next

alert("check test vars zavrsen")
return .t.




static function key_test_1()
local _ret := hb_hash()
local _keys := { ;
   { "_var_1", "1", K_ENTER}, ;
   { "_var_2", K_ENTER, "2"}, ;
   { "_var_3", "333", K_DOWN}, ;
   { "_var_4", "7", K_ENTER} ;
}

local _vars := hb_hash()
_vars["main_var_1"] := "1"
_vars["main_var_3"] := "333"

_ret["keys"] := _keys
_ret["vars"] := _vars
return _ret


static function  key_test_2()
local _ret := hb_hash()
local _keys := { ;
   { "_var_1", "1", K_ENTER}, ;
   { "_var_2", K_ENTER, "2"}, ;
   { "_var_3", "555", K_DOWN}, ;
   { "_var_4", "1", K_ENTER} ;
}
local _vars := hb_hash()

_vars["main_var_3"] := 111

_ret["keys"] := _keys
_ret["vars"] := _vars
return _ret

#endif


#ifdef TEST
procedure run_Main(...)
#else
procedure Main(...)
#endif

local aPom
local cPom
local nPos
local pg_sql
local _var_2 := "5"
local _var_3 := 100
local _var_4 := 0

local  _var_1 := "0"

#ifdef TEST
  public __g_test_vars := hb_hash()
#endif

CLEAR
? "pogledati: harbour-3.0.0/tests/inkeytst.prg"

CLEAR
SET TYPEAHEAD TO 1000

@ 1, 1 SAY "ukucaj 1 pa enter" GET _var_1 PICT "9" 
READ

CLEAR
@ 5, 1 SAY "ukucaj 2 pa enter   " GET _var_2 PICT "9"  WHEN {|| valid_2(@_var_2)}
@ 6, 1 SAY " unesi nesto u var 3" GET _var_3 PICT "999" 
@ 7, 1 SAY " unesi nesto u var 4" GET _var_4 PICT "99" 

READ

#ifdef TEST
__g_test_vars["main_var_1"] := _var_1
__g_test_vars["main_var_3"] := _var_3
#endif

if _var_1 == "1"
  ? "dobro si", _var_1
else
  ? "loshe si", _var_1
endif

? "_var_2 nakon ovih vratolomija je ", _var_2

? "_var_3", _var_3
? "_var_4", _var_4



return


function valid_2(var_2)

Alert("uletio sam u valid 2")

var_2 := "8"

return .t.

function test_keystrokes()
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

      
