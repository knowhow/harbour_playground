/*
 * $Id: Dba.prg 760 2011-09-17 22:54:23Z tfonrouge $
 */

/*
    dba : database access
    Teo. Mexico 2008
*/

#include "inkey.ch"

STATIC aws:={}                  // stack de PushWS/PopWS

/*
    AddRec
    Teo. Mexico 2008
*/
FUNCTION AddRec(nrec,index)
    LOCAL rn:=RecNo()

    IF GetNextEmpty(index)
        nrec := RecNo()
        RETURN .T.
    ENDIF

    DbAppend(.F.)

    IF ! NetErr()
        nrec := RecNo()
        RETURN .T.
    ENDIF

    WHILE .T.

        IF GetNextEmpty()
            nrec := RecNo()
            RETURN .T.
        ENDIF

        DbAppend(.F.)

        IF ! NetErr()
        IF Deleted()
                DbRecall()
            ENDIF
            nrec := RecNo()
            RETURN .T.
        ENDIF

        DbSkip(0)
        DbGoTo(rn)
        InKey(.5) //** Espera 1/2 segundo

        IF LastKey()==K_ESC .AND. ;
            wxhAlert( "Si cancela, el Sistema puede no completar el proceso iniciado;" + ;
                         "*;" + ;
                         "Puede verificar que otro usuario, en otra estacion de trabajo;" + ;
                         "no tenga detenido algun proceso inadvertidamente (o no).;" + ;
                         "Tambien puede checar su red de computadoras...;" + ;
                         ";;" + ;
                         "De cualquier modo desea cancelar  ?", ;
                         {" Si "," No "} ) = 1
            nrec := 0
            RETURN .F. //** ni modo...
        ENDIF

    ENDDO

    nrec := 0

RETURN .F.         // Not locked

/*
    Clear
    Teo. Mexico 2008
*/
FUNCTION Clear()
    LOCAL i,a:=dbstruct(),j
    j:=len(a)
    FOR i:=1 TO j
        DO CASE
        CASE a[i,2]$"CM"
            // fieldput(i,iif(a[i,3]==8,replicate(chr(0),8),""))
            fieldput(i,"")
        CASE a[i,2]$"NB"
            fieldput(i,0)
        CASE a[i,2]=="D"
            fieldput(i,ctod(""))
        CASE a[i,2]=="L"
            fieldput(i,.F.)
        ENDCASE
    NEXT
    DbRecall()
RETURN .T.

/*
    DbSkipX() : menos
    Teo. USA 1995
*/
FUNCTION DbSkipX(n,ord)
    STATIC bord,orden,ret
    ret:=.T.
    bord:=OrdSetFocus()
    IF ord==NIL
        orden:=OrdSetFocus()
    ELSE
        orden:=ord
    ENDIF
    OrdSetFocus(orden)
    DbSkip(n)
    IF ((n==NIL .OR. n>0) .AND. Eof()) .OR. bof()
        ret:=.F.
    ENDIF
    OrdSetFocus(bord)
RETURN ret

/*
    ExistKey() : Checa si existe key en indice dado
    Teo. Mexico 1996
*/
FUNCTION ExistKey(cKey,xOrder,nRec,bFor,bEval)
    LOCAL nr:=RecNo()
    LOCAL recNo
    IF !(Seek(cKey,xOrder))
        DbGoTo(nr)
        RETURN .F.
    ENDIF
    IF bFor==NIL .OR. bFor:eval
        IF empty(nRec)
            IF !bEval==NIL
                bEval:eval()
            ENDIF
            DbGoTo(nr)
            RETURN .T.
        ENDIF
        IF HB_IsBlock( nRec )
            recNo := nRec:Eval()
        ELSE
            recNo := nRec
        ENDIF
        IF !RecNo()==recNo
            IF !bEval==NIL
                bEval:eval()
            ENDIF
            DbGoTo(nr)
            RETURN .T.
        ENDIF
    ENDIF
    DbGoTo(nr)
RETURN .F.

/*
    Get4Seek(cFieldname,xSeekvalue,nOrder,lSoftseek)
    Regresa 'xVar' (nombre de la variable) del registro en xSeek...
    Teo. USA 1995
*/
FUNCTION Get4Seek(xVar,xs,no,ss,cAlias)
    LOCAL ret
    LOCAL nrec

    nrec:=RecNo()

    IF cAlias=NIL
        (Seek(xs,no,ss))
    ELSE
        (cAlias)->(Seek(xs,no,ss))
    ENDIF

    IF valtype(xVar)=="B"
        ret:=Eval(xVar)
        DbGoTo(nrec)
        RETURN ret
    ELSE
        IF cAlias=NIL
            ret := Exec(xVar)
        ELSE
            ret:=(cAlias)->(Exec(xVar))
        ENDIF
    ENDIF

    DbGoTo(nrec)

RETURN iif(valtype(ret)=="C" .AND. len(ret)==8,ret,ret)

/*
    Get4SeekLast(cFieldname,xSeekvalue,nOrder,lSoftseek)
    Regresa 'var' (nombre de la variable) del registro en xSeek...
    Teo. USA 1995
*/
FUNCTION Get4SeekLast(var,xs,no,ss)
    LOCAL ret
    LOCAL nrec:=RecNo()
    (seeklast(xs,no,ss))
    IF valtype(var)=="B"
        ret := var:eval()
        DbGoTo(nrec)
        RETURN ret
    ELSE
        ret:=eval(fieldblock(var))
    ENDIF
    DbGoTo(nrec)
//RETURN iif(valtype(ret)=="C" .AND. len(ret)==8,ret,ret)
RETURN ret

/*
    GetNextEmpty
    Teo. Mexico 2008
*/
STATIC FUNCTION GetNextEmpty( index )
    LOCAL rec:=RecNo(),key

    IF index == NIL
        IF OrdNumber( "Primary" ) > 0
            index := "Primary"
        ELSEIF OrdNumber( "X01" ) > 0
            index := "X01"
        ELSE
            index := OrdName()
        ENDIF
    ENDIF

    DbGoTopX(index)

    IF valtype(key:=KeyVal(index))!="C"
        DbGoTo(rec)
        RETURN .F.
    ENDIF

    (Seek(space(len(key)),index))

    WHILE !Eof() .AND. empty(KeyVal(index))
        IF IsLocked()
            (DbSkipX(1,index))
            LOOP
        ENDIF
        dbrlock(RecNo())
        //rlock()
        (DbSkipX(0,index))
        IF dbrlock(RecNo()) .AND. empty(KeyVal(index))
        //IF rlock() .AND. empty(KeyVal(index))
            Clear()
            RETURN .T.
        ELSE
            dbrunlock(RecNo())
        ENDIF
        (DbSkipX(1,index))
    ENDDO

    DbGoTo(rec)

RETURN .F.

/*
    DbGoBottom
    Teo. Mexico 2008
*/
FUNCTION DbGoBottomX(ord)
    LOCAL bord
    IF ord==NIL
        dbgobottom()
        RETURN NIL
    ENDIF
    bord:=OrdSetFocus()
    OrdSetFocus(ord)
    dbgobottom()
    OrdSetFocus(bord)
RETURN NIL

/*
    DbGoTopX
    Teo. Mexico 2008
*/
FUNCTION DbGoTopX(ord)
    LOCAL bord
    IF ord==NIL
        dbgotop()
        RETURN NIL
    ENDIF
    bord:=OrdSetFocus()
    OrdSetFocus(ord)
    dbgotop()
    OrdSetFocus(bord)
RETURN NIL

/*
    IsLocked
    Teo. Mexico 2008
*/
FUNCTION IsLocked(n)
    LOCAL alocks:=dbrlocklist()                // eliminar si falla
    iif(n==NIL,n:=RecNo(),)
RETURN !empty(ascan(alocks,n))

/*
    KeyVal() : regresa la expresion del indice (necesario para indicar index)
    Teo. USA 1995
*/
FUNCTION KeyVal(ord)
    LOCAL ret
    LOCAL oo
    IF ord==NIL
        RETURN ordKeyVal()
    ENDIF
    oo:=OrdSetFocus()
    OrdSetFocus(ord)
    ret:=ordKeyVal()
    OrdSetFocus(oo)
RETURN ret

/*
    PopWS
    Teo. Mexico 2008
*/
FUNCTION PopWS(n)
    LOCAL ws,a,wa
    n:=iif(n==NIL,len(aws),n)
    IF n<=0 .OR. n>Len(aws)
        //mess_open("!","ERROR: PopWS Fuera de rango !!!",-1,C_ERROR,,0)
        RETURN 0
    ENDIF
    ws:=Alias()
    IF !empty( wa := aws[n] )
        a := wa[1]
        DbSelectArea(a)
        IF !empty(alias())
            OrdSetFocus(wa[2])
            DbGoTo(wa[3])
            IF !empty( wa[2] )
                ordDescend(,,wa[4])
            ENDIF
        ENDIF
    ELSE
        a := ""
    ENDIF
    IF !Empty( ws )
        DbSelectArea(ws)
    ENDIF
    adel(aws,n)
    asize(aws,len(aws)-1)
RETURN a

/*
    PushWS
    Teo. Mexico 2008
*/
FUNCTION PushWS(p)
    LOCAL n
    IF p!=NIL
        RETURN len(aws)
    ENDIF
    IF !Alias()==""
        n := {Alias(),OrdSetFocus(),RecNo(),ordDescend()}
    ENDIF
    aadd(aws,n)
RETURN n

/*
    RecLock
    Teo. Mexico 2008
*/
FUNCTION RecLock(nr,n)

    nr:=iif(nr==NIL,RecNo(),nr)
    n:=nr

    IF nr>lastrec()
        //mess_open("!","Locking error: End Of File...",-1,C_ERROR,,0)
        wxhAlert( "Locking error: End of file..." )
        RETURN .F.
    ENDIF
    IF IsLocked(nr)
        nr:=n:=-1
        RETURN .T.
    ENDIF
    IF dbrlock(n)
        RETURN .T.        // Locked
    ENDIF

    WHILE !dbrlock(n)
        DbSkip(0)
        DbGoTo(n)
        InKey(.5) //** Espera 1/2 segundo
        IF LastKey()==K_ESC .AND. ;
            wxhAlert( "Si cancela, el Sistema puede no completar el proceso iniciado;" + ;
                         "*;" + ;
                         "Puede verificar que otro usuario, en otra estacion de trabajo;" + ;
                         "no tenga detenido algun proceso inadvertidamente (o no).;" + ;
                         "Tambien puede checar su red de computadoras...;" + ;
                         ";;" + ;
                         "De cualquier modo desea cancelar  ?", ;
                         {" Si "," No "} ) = 1
            RETURN .F. //** ni modo...
        ENDIF
    ENDDO
RETURN .T. //** Agueso debe salir con registro bloqueado

/*
    RecUnLock
    Teo. Mexico 2008
*/
FUNCTION RecUnLock(n)
    IF valtype(n)=="A"
        aeval(n,{|x,i| iif(valtype(x)=="A",RecUnLock(x), iif(valtype(n[i])=="N",RecUnLock(n[i]),NIL) )})
        RETURN NIL
    ENDIF
    dbrunlock(iif(n==NIL,n:=RecNo(),n))
    DbSkip(0)
RETURN .T.

/*
    Seek() : no requiere presentacion
    Teo. USA 1995
*/
FUNCTION Seek(expr,ord,ss)
    STATIC ret
    STATIC bord
    IF ord==NIL
        RETURN DbSeek(expr,ss)
    ENDIF
    bord:=OrdSetFocus()
    OrdSetFocus(ord)
    ret:=DbSeek(expr,ss)
    OrdSetFocus(bord)
RETURN ret

/*
    SeekLast() : tampoco
    Teo. USA 1995
*/
FUNCTION SeekLast(expr,ord,ss)
    STATIC ret
    STATIC bord

    IF ord==NIL
        RETURN DBSeek(expr,ss,.T.)
    ENDIF

    bord:=OrdSetFocus()
    OrdSetFocus(ord)
    ret := DBSeek(expr,ss,.T.)
    OrdSetFocus(bord)

RETURN ret
