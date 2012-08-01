#include "inkey.ch"
#include "getexit.ch"

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
   VALID {|| _last_read_var:=READVAR(), GetList[4]:varput(STOD("20110101")), .t. } 

@ 2, 1 SAY "var 2" GET _v_2 WHEN { || IIF(_last_read_var == "_V_1", hb_KeyPut(K_ENTER), ALERT(_last_read_var)), .t.} ;
   VALID {|| _last_read_var:=READVAR(), .t. }
 
@ 3, 1 SAY "var 3" GET _v_3 ;
   VALID {|| _last_read_var:=READVAR(), .t. } ;

@ 4, 1 SAY "var 4" GET _v_4 ;
   VALID {|| _last_read_var:=READVAR(), .t. } ;

READ
