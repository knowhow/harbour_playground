#include "inkey.ch"
#include "getexit.ch"

static __get_list := NIL

procedure Main(...)

local aPom
local cPom
local nPos
local _v_1 := SPACE(5)
local _v_2 := PADR("2", 15)
local _v_3 := 15.5
local _v_4 := CTOD("")
local _last_read_var:=""

clear screen
set date to german
set confirm off

@ 1, 1 SAY "var 1" GET _v_1 ;
   VALID {|| _last_read_var:=READVAR(), GetList[4]:varput(STOD("20110101")), field_set_focus("_v_3"), .t. } ; 
   WHEN { || Alert("orig var 1"), .t. }
@ 2, 1 SAY "var 2" GET _v_2 ;
   WHEN { || Alert("orig var 2"), IIF(_last_read_var == "_V_1", hb_KeyPut(K_ENTER), ALERT(_last_read_var)), .t.} ;
   VALID {|| _last_read_var:=READVAR(), .t. }
 
@ 3, 1 SAY "var 3" GET _v_3 ;
   VALID {|| _last_read_var:=READVAR(), .t. } ;
   WHEN { || Alert("orig var 3"), .t. } 

@ 4, 1 SAY "var 4" GET _v_4 ;
   VALID {|| _last_read_var:=READVAR(), .t. } ;
   WHEN { || Alert("orig var 4"), .t. } 

READ
-
// --------------------------------------------------------------------
// sva polja disableujemo osim onoga na koje zelimo "skociti"
// -------------------------------------------------------------------
function field_set_focus(f_name)
local _i

__get_list := {}

for _i:=1 TO LEN(GetList)
   AADD(__get_list, GetList[_i]:PreBlock)

   if GetList[_i]:name() == f_name
      GetList[_i]:PreBlock := {|| restore_getlist(), .t.}
   else
      GetList[_i]:PreBlock := {|| .f.}
   endif
next

function restore_getlist()
local _i

  Alert("restore getlist")

  for _i := 1 TO LEN(GetList)
     GetList[_i]:PreBlock := __get_list[_i]
  next

return .t.
