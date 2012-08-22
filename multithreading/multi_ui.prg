#include "inkey.ch"

thread static s_var1 := { "A", "B", "C" }
static _thread := { NIL, NIL }
static mtx_1

static w1 := NIL, w2 := NIL

procedure main()

REQUEST HB_GT_XWC_DEFAULT

REQUEST HB_CODEPAGE_SL852
REQUEST HB_CODEPAGE_SLISO


/*
#xcommand MENU [<oMenu>] => [ <oMenu> := ] HBDbMenu():New()
#xcommand MENUITEM [ <oMenuItem> PROMPT ] <cPrompt> ;
          [ IDENT <nIdent> ] [ ACTION <uAction,...> ] ;
         [ CHECKED <bChecked> ] => ;
    [ <oMenuItem> := ] HBDbMenu():AddItem( MenuItem():New( <cPrompt>,;
    [{||<uAction>}], [<bChecked>], [<nIdent>] ) )
#xcommand SEPARATOR => HBDbMenu():AddItem( HBDbMenuItem():New( "-" ) )
#xcommand ENDMENU => ATail( HBDbMenu():aMenus ):Build()


private oMenu

   MENU oMenu
      MENUITEM " ~File "
      MENU
         MENUITEM " ~Open..."         ACTION oDebugger:Open()
         MENUITEM " ~Resume"          ACTION oDebugger:Resume()
         MENUITEM " O~S Shell"        ACTION oDebugger:OSShell()
         SEPARATOR
         MENUITEM " e~Xit    Alt-X "  ACTION oDebugger:Quit()
      ENDMENU

      MENUITEM " ~Locate "
      MENU
         MENUITEM " ~Find"            ACTION oDebugger:Locate()
         MENUITEM " ~Next"            ACTION oDebugger:FindNext()
         MENUITEM " ~Previous"        ACTION oDebugger:FindPrevious()
         MENUITEM " ~Goto line..."    ACTION oDebugger:SearchLine()
         SEPARATOR
         MENUITEM " ~Case sensitive " IDENT "CASE" ;
            ACTION oDebugger:ToggleCaseSensitive() ;
            CHECKED oDebugger:lCaseSensitive
      ENDMENU

      MENUITEM " ~View "
      MENU
         MENUITEM " ~Sets"            ACTION oDebugger:ViewSets()
         MENUITEM " ~WorkAreas   F6"  ACTION oDebugger:ShowWorkAreas()
         MENUITEM " ~App Screen  F4 " ACTION oDebugger:ShowAppScreen()
         SEPARATOR
         MENUITEM " ~CallStack" IDENT "CALLSTACK";
            ACTION oDebugger:Stack() ;
            CHECKED oDebugger:lShowCallStack
      ENDMENU
 


oPop := Popup(10, 10, 20, 20)
oPop:
oPop:open()

*/

_thread[1] := hb_threadStart(@t1())




/*
mtx_1 := hb_mutexCreate()

public var_g := "AA"

get_1()

*/




? "glavni prozor"

inkey(0)


// ---------------------------
proc skoci_t2()

_thread[2] := hb_threadStart(@t2())
//alert("skacem na t2")
//hb_GtSelect(w2)

//-----------------------------------
//-----------------------------------
proc t1()

//set key K_F2 to skoci_t2()
set key K_F2 to skoci_t2()

Alert("t1")

if w1 == NIL
    w1 := hb_gtCreate("XWC")
endif

/*
hb_mutexLock( mtx_1 )
var_g := "G1"
get_1()
hb_mutexUnLock( mtx_1 )
*/

hb_GtSelect(w1)

var1 := SPACE(4)
var2 := SPACE(4)


@ 1, 2 SAY "hello var 1" GET var1
@ 3, 2 SAY "hello var 2" GET var2
READ

Alert(var1 + " / " + var2)

w1 := NIL

QUIT
return

//-----------------------------------
//-----------------------------------
proc t2()

set key K_F1 to t1()
if w2 == NIL
   w2 := hb_gtCreate("XWC")
endif

//Alert("t2")
/*
hb_mutexLock( mtx_1 )
var_g := "G2"
get_2()
hb_mutexUnLock( mtx_1 )
*/

hb_GtSelect(w2)

var2 := SPACE(10)

@ 1, 2 SAY "hello 2" GET var2
READ

Alert(var2)

w2 := NIL

QUIT
return


// -------------------------------
// -------------------------------
function get_1()

local _var_1 := SPACE(10)
local _var_2 := SPACE(2)

do while .t.
CLEAR SCREEN
Private GetList := {}
@ 5, 5 SAY "unesi 1" GET _var_1
@ 6, 5 SAY "unesi 2" GET _var_2

@ 20, 1 SAY "ja sam get_1"
@ 20,40 SAY "            "
READ

enddo

return

// -------------------------------
// -------------------------------
function get_2()

local _var_2 := PADR("2", 10)
local _var_3 := "XYZ"

do while .t.
CLEAR SCREEN
Private GetList := {}
@ 10, 5 SAY "unesi 2" GET _var_2
@ 11, 5 SAY "unesi 3" GET _var_3


@ 20, 1 SAY "              "
@ 20,40 SAY "ja sam get 2  "
READ

enddo

return

