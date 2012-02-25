/*
 * $Id: wxhutils.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

STATIC BaseArray:="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

/*
    __ClsInstName
    Teo. Mexico 2007
*/
FUNCTION __ClsInstName( className )
    LOCAL Result

    Result := &(className+"()")

RETURN Result

#include "wxharbour.ch"

/*
    asCodeBlock : Convierte la cadena a un code block
    Teo. Mexico 2002
*/
FUNCTION asCodeBlock( cStr, xDefaultVal )
    IF empty(cStr)
        RETURN xDefaultVal
    ENDIF
RETURN &("{||" + cStr + "}")

/*
    AsDate
    Teo. Mexico 2004
*/
FUNCTION AsDate( xVal, sTemplate )
    LOCAL dVal := CtoD("")
    LOCAL cType := ValType( xVal )

    DO CASE
    CASE cType="C"
        dVal := Str2Date( xVal, sTemplate )
    CASE cType="D"
        dVal := xVal
    ENDCASE

RETURN dVal

/*
    AsLogical
    Teo. Mexico 2005
*/
FUNCTION AsLogical( xVal )

    SWITCH ValType( xVal )
    CASE 'C'
        RETURN AScan( {".T.","TRUE","YES","SI","1","ON"}, {|e| Upper(xVal) == e} ) > 0
    CASE 'N'
        RETURN xVal > 0
    END

RETURN .F.

/*
    AsNumeric
    Teo. Mexico 2004
*/
FUNCTION AsNumeric( xVal )

    SWITCH ValType( xVal )
    CASE 'C'
        RETURN Val( xVal )
    CASE 'N'
        RETURN xVal
    END

RETURN 0

/*
    AsString
    Teo. Mexico 2004
*/
FUNCTION AsString( xVal )

    SWITCH ValType( xVal )
    CASE 'C'
        RETURN xVal
    CASE 'D'
        //RETURN FDateS( xVal )
        IF Empty( xVal )
            RETURN "  /   /    "
        ENDIF
        RETURN Str( Day( xVal ), 2 ) + "/" + Left( CMonth( xVal ), 3 ) + "/" + Str( Year( xVal ), 4 )
    CASE 'B'
        RETURN "{|| ... }"
    CASE 'L'
        RETURN iif( xVal, ".T.", ".F." )
    CASE 'N'
        RETURN LTrim( Str( xVal ) )
    CASE 'O'
        RETURN "<Object>: "+xVal:ClassName
    CASE 'A'
        RETURN "<Array>: "+LTrim( Str( Len( xVal ) ) )
    END

RETURN ""

/*
    Base2N() : Convierte string de base numerica a numero en base 10
    Teo. USA 1995
*/
FUNCTION Base2N(sBase,nBase,l,cFill)
    STATIC dec
    STATIC i,c,n,s,lb
    dec:=0
    n:=1
    lb:=len(sBase:=Upper(alltrim(sBase)))
    s:=left(BaseArray,nBase)
    FOR i:=lb TO 1 STEP -1
        IF (c:=at(substr(sBase,i,1),s))==0
            RETURN iif(l==NIL,0,N2Base(0,10,l,cFill))  // Regresa un cero...
        ENDIF
        dec+=(c-1)*n
        n*=nBase
    NEXT
RETURN iif(l==NIL,dec,N2Base(dec,10,l,cFill))

/*
    Choose() : Elige de un array de opciones a un array de selecciones
    Teo. 1995
*/
FUNCTION Choose(se,ao,as,def,lSoftCompare)
    LOCAL n

    IF ValType( ao[1] ) = "A"
        IF lSoftCompare = .T.
            IF (n:=ascan(ao[1],{|e| se = e }))>0
                RETURN ao[2,n]
            ENDIF
        ELSE
            IF (n:=ascan(ao[1],{|e| se == e }))>0
                RETURN ao[2,n]
            ENDIF
        ENDIF
    ELSE
        IF lSoftCompare = .T.
            IF (n:=ascan(ao,{|e| se = e }))>0
                RETURN as[n]
            ENDIF
        ELSE
            IF (n:=ascan(ao,{|e| se == e }))>0
                RETURN as[n]
            ENDIF
        ENDIF
    ENDIF

    IF !def==NIL
        RETURN def
    ENDIF

    DO CASE
    CASE valtype(as[1])=="C"
        RETURN ""
    CASE valtype(as[1])=="N"
        RETURN 0
    CASE valtype(as[1])=="D"
        RETURN ctod("")
    ENDCASE

RETURN NIL

/*
    Dec
    Teo. Mexico 2005
*/
FUNCTION Dec(p,base,fill,n)
    LOCAL s,i,b,c

    IF n == NIL
        n:=1
    ENDIF

    SWITCH ValType( p )
    CASE 'C'
        IF len(p)==1 .AND. empty(base)
            RETURN chr(asc(p)-n)
        ENDIF
        iif(empty(base),base:=36,base)
        IF base<2 .OR.base>36
            RETURN "*"
        ENDIF
        s:=CharMirr(upper(p))
        //s := Upper( p )
        b:=left(BaseArray,base)+" "
        FOR i := 1 TO Len( s )
            iif((c:=substr(s,i,1))==" ",b:=" ",NIL)
            IF !(c$b)
                EXIT
            ENDIF
        NEXT
        RETURN left(p,len(p)-i+1)+N2Base(Base2N(right(p,i-1),base)-n,base,i-1,fill)
    CASE 'N'
        p-=n
        EXIT
    CASE 'D'
        IF Empty( p )
            p := Date()
        ENDIF
        p-=n
        EXIT
    CASE 'A'
        IF !empty(p)
            asize(p,len(p)-n)
        ENDIF
    OTHERWISE
        //mess_open("ERROR","* Dec() *",-1,C_ERROR)
    ENDSWITCH

RETURN p

/*
    Eval : Evalua la cadena y regresa el resultado
    Teo. Mexico 2002
*/
FUNCTION Exec(cStr,xDefaultVal)
    LOCAL xRet

    BEGIN SEQUENCE //WITH {|e| ArelErrorHandle(e) }

        IF ValType(cStr)="B"

            xRet := Eval( cStr )

        ELSE

            xRet := AsCodeBlock( cStr, xDefaultVal ):Eval()

        ENDIF

    RECOVER

        xRet := xDefaultVal

    END SEQUENCE

RETURN xRet

/*
    FDate2F() : Regresa un valor DATE como cadena en formato:
                            MM-DD-YYYY, D$-M$-Y$ ... D$ DD de M$ de Y$
    Teo. 1995
*/
FUNCTION FDate2F(d,p)
    LOCAL i,n,s
    IF valtype(d)=="C"
        IF len(d)==6
            d += "01"
        ENDIF
        d := stoj(d)
    ENDIF
    IF empty(iif(d==NIL,d:=date(),d)) .OR. dtos(d)="000000" .OR. p==NIL .OR. (n:=numtoken(p))==0
        RETURN ""
    ENDIF
    FOR i:=1 TO n
        s:=upper(token(p,,i))
        DO CASE
        CASE s=="DD" .OR. s=="D$"
            //p:=stuff(p,attoken(p,,i),2,iif(s=="D$",fdia(d),str(day(d),2)))
            p := SwapToken(p,,i, iif(s=="D$",NToCDOW(DOW(d)),str(day(d),2)) )
        CASE s=="DDD"
            //p:=stuff(p,attoken(p,,i),3,left(fdia(d),3))
            p := SwapToken(p,,i,left(NToCDOW(DOW(d)),3))
        CASE s=="MM"
            //p:=stuff(p,attoken(p,,i),2,str(month(d),2))
            p := SwapToken(p,,i,str(month(d),2))
        CASE s=="M$"
            //p:=stuff(p,attoken(p,,i),2,fmes(d))
            p := SwapToken(p,,i,CMonth(d))
        CASE s=="MMM"
            //p:=stuff(p,attoken(p,,i),3,left(fmes(d),3))
            p := SwapToken(p,,i,left(CMonth(d),3))
        CASE s=="YY"
            //p:=stuff(p,attoken(p,,i),2,substr(str(year(d),4),3,2))
            p := SwapToken(p,,i,substr(str(year(d),4),3,2))
        CASE s=="Y$" .OR. s=="YYYY"
            //p:=stuff(p,attoken(p,,i),len(s),ntrim(year(d)))
            p := SwapToken(p,,i,LTrim( Str( year( d ) ) ) )
        ENDCASE
    NEXT
RETURN p

/*
    FDateS
    Teo. Mexico 2008
*/
FUNCTION FDateS( d )
    IF Empty(iif(d==NIL,d:=Date(),d)) .OR. Empty(d) .OR. DToS(d)="000000"
        RETURN "  /   /    "
    ENDIF
RETURN Str(Day(d),2)+"/"+Left(CMonth(d),3)+"/"+Str(Year(d),4)

/*
    Inc
    Teo. Mexico 2005
*/
FUNCTION Inc( p, base, fill, n )
    LOCAL s,i,b,c

    IF n == NIL
        n:=1
    ENDIF

    SWITCH ValType( p )
    CASE 'C'
        IF len(p)==1 .AND. empty(base)
            RETURN chr(asc(p)+n)
        ENDIF
        iif(empty(base),base:=36,base)
        IF base<2 .OR. base>36
            RETURN "*"
        ENDIF
        s:=CharMirr(upper(p))
        //s := Upper( p )
        b:=left(BaseArray,base)+" "
        FOR i := 1 TO Len( s )
            iif((c:=substr(s,i,1))==" ",b:=" ",NIL)
            IF !(c$b)
                EXIT
            ENDIF
        NEXT
        RETURN left(p,len(p)-i+1)+N2Base(Base2N(right(p,i-1),base)+n,base,i-1,fill)
    CASE 'N'
        p+=n
        EXIT
    CASE 'D'
        IF Empty( p )
            p := Date()
        ENDIF
        p+=n
        EXIT
    CASE 'A'
        asize(p,len(p)+n)
        EXIT
    OTHERWISE
        //mess_open("ERROR","* Inc() *",-1,C_ERROR)
    ENDSWITCH

RETURN p

/*
    MyErrorNew
    Teo. Mexico 2007
*/
FUNCTION MyErrorNew(SubSystem,Operation,Description,Args,ProcFile,ProcName,ProcLine)
    LOCAL oErr
    oErr := ErrorNew()
    oErr:SubSystem := iif(SubSystem=NIL,"",SubSystem)
    oErr:Operation := iif(Operation=NIL,"",Operation)
    oErr:Description := Description
    oErr:Args := Args
    oErr:Cargo := HB_HSetAutoAdd( { "ProcFile" => ProcFile, "ProcName" => ProcName, "ProcLine" => ProcLine }, .T. )
RETURN oErr

/*
    N2Base() : Convierte numero a string de base numerica 'n'
    Teo. USA 1995
*/
FUNCTION N2Base(nVal,nBase,l,cFill)
    STATIC sBase
    STATIC n
    sBase:=""
    n:=1
    iif(cFill==NIL,cFill:="0",NIL)
    WHILE .T.
        n*=nBase
        IF n>nVal
            EXIT
        ENDIF
    ENDDO
    WHILE n!=1
        n/=nBase
        sBase+=substr(BaseArray,nVal/n+1,1)
        nVal%=n
    ENDDO
    iif(l==NIL,l:=len(sBase),NIL)
RETURN iif(len(sBase)>l,replicate("*",l),padl(sBase,l,cFill))

/*
    SToJ
    Teo. Mexico 2004
*/
FUNCTION SToJ( cDate )
RETURN Str2Date( cDate, "YYYYMMDD" )

/*
    Str2Date : convierte una fecha en string a tipo date
    Teo. USA 1995
*/
FUNCTION Str2Date( sDate , sTemplate , sReturn )
    LOCAL sDay
    LOCAL tMonth,sMonth,nMonth
    LOCAL sYear
    LOCAL s,i,j
    LOCAL d

    IF empty(sDate)
        RETURN CtoD("")
    ENDIF

    IF empty(sTemplate)
        sTemplate := "DD MMM YYYY"
    ENDIF

    sDay := sMonth := sYear := ""

    sDate := Upper(sDate)
    sTemplate := upper(sTemplate)

    // Hay separadores...
    IF (j:=NumToken(sTemplate))>1
        FOR i:=1 TO j
            s := Token(sTemplate,,i)
            DO CASE
            CASE s="D"
                sDay := Token(sDate,,i)
            CASE s="M"
                tMonth := s
                sMonth := Token(sDate,,i)
            CASE s="Y"
                sYear := Token(sDate,,i)
            ENDCASE
        NEXT
    ELSE

        IF (i:=At("YYYY",sTemplate))>0
            sYear := SubStr(sDate,i,4)
        ELSEIF (i:=At("YY",sTemplate))>0
            sYear := SubStr(sDate,i,2)
        ENDIF

        IF (i:=At("MMM",sTemplate))>0
            tMonth := "MMM"
            sMonth := SubStr(sDate,i,3)
        ELSEIF (i:=At("MM",sTemplate))>0
            tMonth := "MM"
            sMonth := SubStr(sDate,i,2)
        ENDIF

        IF (i:=At("DD",sTemplate))>0
            sDay := SubStr(sDate,i,2)
        ENDIF

    ENDIF


    IF (tMonth == "M$" .OR. tMonth=="MMM") .AND. Len(sMonth)>=3
        FOR i:=1 TO 12
            IF Upper(NToCMonth(i))=sMonth
                nMonth := i
                EXIT
            ENDIF
            IF Upper(NToCMonth(i))=sMonth
                nMonth := i
                EXIT
            ENDIF
        NEXT
    ELSE
        nMonth := Val( sMonth )
    ENDIF

    IF empty(nMonth)
        d := CtoD("")
    ELSE
        d := CtoD(iif(empty(sDay),"1",sDay) + "/" + LTrim( Str( nMonth ) ) + "/" + sYear )
    ENDIF

    IF !empty(sReturn)
        DO CASE
        CASE empty(d)
            RETURN space(len(sReturn))
        CASE sReturn == "MMDD"
            RETURN Base2N( LTrim( Str( month( d ) ) ),10,2)+Base2N(LTrim( Str( day( d ) ) ),10,2)
        CASE sReturn == "DDMMM"
            RETURN str(day(d),2)+left(cmonth(d),3)
        CASE sReturn == "YYYYMM"
            RETURN Base2N( LTrim( Str( year( d ) ) ),10,4)+Base2N(LTrim( Str( month( d ) ) ),10,2)
        CASE sReturn == "MMMYYYY"
            RETURN left(cmonth(d),3)+str(year(d),4)
        OTHERWISE
            RETURN fdate2f(d,sReturn)
        ENDCASE
    ENDIF

RETURN d

/*
    SwapToken :
    Teo. Mexico 2004
*/
FUNCTION SwapToken( cString, cDelims, nOccur, cSwapStr )
    LOCAL n := 0

    TokenInit( cString, cDelims )

    WHILE (!TokenEnd())
        n++
        IF n = nOccur
            cString := Stuff( cString, TokenAt(), TokenAt(.T.) - TokenAt(), cSwapStr )
            EXIT
        ENDIF
        TokenNext(cString)
    ENDDO

    TokenExit()

RETURN cString

/*
    wxhAlert
    Teo. Mexico 2009
*/
FUNCTION wxhAlert( cMessage, aOptions )
    LOCAL result

    IF wxGetApp() == NIL .OR. wxGetApp():GetTopWindow() == NIL
        result := Alert( cMessage, aOptions )
    ELSE
        IF aOptions = NIL
            aOptions := 0
        ENDIF
        result := wxMessageBox( cMessage, "Message", HB_BitOr( aOptions, wxICON_EXCLAMATION ) )
    ENDIF

RETURN result

/*
    wxhAlertYesNo
    Teo. Mexico 2009
*/
FUNCTION wxhAlertYesNo( cMessage )
    LOCAL result

    IF wxGetApp() == NIL .OR. wxGetApp():GetTopWindow() == NIL
        result := Alert( cMessage, {"Yes","No"} )
    ELSE
        result := wxMessageBox( cMessage, "Message!", HB_BitOr( wxYES_NO, wxICON_QUESTION ) )
        SWITCH result
        CASE wxYES
            result := 1
            EXIT
        CASE wxNO
            result := 2
            EXIT
        OTHERWISE
            result := 0
        ENDSWITCH
    ENDIF

RETURN result
