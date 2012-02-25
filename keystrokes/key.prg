#include "inkey.ch"

#translate TEST_LINE( <x>, <result> ) => TEST_CALL( #<x>, {|| <x> }, <result> )


static __keystrokes := { ;
   { "_VAR_1", "1", K_ENTER}, ;
   {"_var_2", "9", K_ENTER, "105", K_ENTER} ;
}
 
static __only_one := 0

procedure Main(...)
local aPom
local cPom
local nPos
local pg_sql
local _var_1 := "0"
local _var_2 := "5"
local _var_3 := 100
CLEAR
? "pogledati: harbour-3.0.0/tests/inkeytst.prg"



nTask := HB_IDLEADD( {|| keystroke_test_1()} )


//CLEAR
SET TYPEAHEAD TO 1000
//setkey_1()

@ 1, 1 SAY "ukucaj 1 pa enter" GET _var_1 PICT "9" 


// WHEN {|| keystroke_test_1()}

READ

//CLEAR
@ 5, 1 SAY "ukucaj 2 pa enter" GET _var_2 PICT "9"  WHEN {|| valid_2(@_var_2)}
@ 5, 1 SAY "ukucaj 2 pa enter" GET _var_3 PICT "999" 

READ




if _var_1 == "1"
  ? "dobro si", _var_1
else
  ? "loshe si", _var_1
endif

? "_var_2 nakon ovih vratolomija je ", _var_2

? "_var_3", _var_3


Qout("uklanjam idleadd task")
HB_IDLEDEL(nTask)


return


function valid_2(var_2)

Alert("uletio sam u valid 2")

var_2 := "8"

return .t.

function setkey_1()

SetKey( ASC("1"), {|| QOut("pritisn'o 1"), __KEYBOARD("2" + CHR(K_ENTER))})
return

function keystroke_test_1()
local _var_name
local _i
 
if __only_one == 0
   //? "poslao keyboard keystroke"

    ? "readvar_1", _var_name := READVAR()

    __KEYBOARD( "1" )
    HB_KEYPUT(K_ENTER) 

    __only_one ++
endif


if __only_one == 1

? "cekam _var_2"
_var_name := READVAR()

    if _var_name == "_VAR_2"
        ? "readvar_2", READVAR()
        HB_KEYPUT(K_ENTER)
        HB_KEYPUT(K_ENTER)

        __only_one ++
    endif

endif


return .t.



//if HB_SetKeyCheck( K_ALT_X, GetActive() ) ... // some other processing endif

