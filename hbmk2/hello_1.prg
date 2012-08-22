#include "inkey.ch"

function f1()

? K_ESC

? "Valtype od .f. :", VALTYPE(.f.)
for i:=1 to 9
  ? "hello world", i
next

return
