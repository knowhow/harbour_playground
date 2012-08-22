REQUEST DBFCDX

procedure main(cImeDbf, polje, value, polje2, value2, polje3, value3 )
local _i

? "F18 setting je set deleted ON, sto znaci ne gledaj brisane zapise"

? "dbf=", cImeDbf

SET DATE TO german

SET DELETED OFF
USE (cImeDbf) VIA "DBFCDX" NEW

aStruct := DBSTRUCT()

? "Struktura polja: "
for _i := 1 TO LEN( aStruct )
    ? PADR(aStruct[ _i, 1 ], 15), aStruct[ _i, 2 ], aStruct[ _i, 3 ], aStruct[ _i, 4 ]
next

count to nCnt1
count for deleted() to nDel1


? "reccnt set deleted off - reccount / count", reccount(), "/", nCnt1
? "deleted", nDel1

USE

SET DELETED ON
USE (cImeDbf) VIA "DBFCDX" NEW

count to nCnt2
count for deleted() to nDel2

? "reccnt set deleted on - reccount / count", reccount(), "/", nCnt2
? "deleted", nDel2

? "on - off", nCnt2 - nCnt1
?
? "broj aktivnih zapisa:", nCnt2

if polje != NIL
    ispitaj( polje, value )  
endif
if polje2 != NIL
    ispitaj( polje2, value2 )  
endif
if polje3 != NIL
    ispitaj( polje3, value3 )  
endif

return


function ispitaj( polje, vrij )

// ako zelimo empty zapis proslijediti navodimo #
vrij := STRTRAN( vrij, "#", " ")
  
if VALTYPE(FIELDGET(FIELDPOS(polje))) == "N"
     vrij := VAL(vrij)
endif
  
if VALTYPE(FIELDGET(FIELDPOS(polje))) == "D"
     vrij := CTOD(vrij)
endif

count for { || FIELDGET(FIELDPOS(polje)) == vrij } to nTest1
? "polje="
?? polje, " #" 
?? vrij
?? "# "
?? nTest1

return


