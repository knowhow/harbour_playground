#include "inkey.ch"

procedure Main(...)

local aPom
local cPom
local nPos

? "hello world"

? K_ESC

? "Valtype od .f. :", VALTYPE(.f.)
for i:=1 to 10
  ? "hello world", i
next

cPom := "/home/hernad/test/DATA.DBF"

? FILEBASE(cPom), FILEEXT(cPom)

cPom := "osuban"

? FILEBASE(cPom), FILEEXT(cPom)

aPom := { { "jedan", 100 },;
          { "dva", 200 }, ;
          { "tri", 300 } ;
        }

nPos:=ASCAN(aPom,  { |x|  x[1]=="dva"} )

? "nasao sam da je 'dva' clan sa vrijednosti", aPom[nPos, 1], aPom[nPos, 2]


? "broj ulaznih parametara: ", PCount() 


