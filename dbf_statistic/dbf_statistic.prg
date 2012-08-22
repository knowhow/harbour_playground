REQUEST DBFCDX

procedure main(cImeDbf)


? "dbf=", cImeDbf

SET DELETED ON
USE (cImeDbf) VIA "DBFCDX" NEW

nCnt1 := reccount()

? "reccnt set deleted on", nCnt1

SET DELETED OFF

nCnt2 := reccount()
? "reccnt set deleted off", nCnt2


? "on - off", nCnt1 - nCnt2

