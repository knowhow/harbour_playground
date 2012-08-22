REQUEST DBFCDX

procedure main(cImeDbf, polje, value)

? "F18 setting je set deleted ON, sto znaci ne gledaj brisane zapise"

? "dbf=", cImeDbf

SET DELETED ON
USE (cImeDbf) VIA "DBFCDX" NEW

count to nCnt1
count for deleted() to nDel1


? "reccnt set deleted on - reccount / count", reccount(), "/", nCnt1
? "deleted", nDel1

USE

SET DELETED OFF
USE (cImeDbf) VIA "DBFCDX" NEW

count to nCnt2
count for deleted() to nDel2

? "reccnt set deleted off - reccount / count", reccount(), "/", nCnt2
? "deleted", nDel2

? "on - off", nCnt1 - nCnt2
?
? "broj aktivnih zapisa:", nCnt1

if polje != NIL
  if VALTYPE(FIELDGET(FIELDPOS(polje))) == "N"
     value := VAL(value)
  endif

  count for { || FIELDGET(FIELDPOS(polje)) == value } to nTest1
  ? polje, value,  nTest1
endif
