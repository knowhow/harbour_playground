function matrica()
local aPom
local nPos

aPom := { { "jedan", 100 },;
          { "dva", 200 }, ;
          { "tri", 300 } ;
        }

nPos:=ASCAN(aPom,  { |x|  x[1]=="dva"} )

? "nasao sam da je 'dva' clan sa vrijednosti", aPom[nPos, 1], aPom[nPos, 2]


