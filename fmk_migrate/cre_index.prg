#define SLASH "/"
#define DBFEXT "dbf"
#define INDEXEXT "cdx"
#define F_TMP 199

// -----------------------------------------------------
// -----------------------------------------------------
function create_index(cImeInd, cKljuc, cImeDbf, fSilent)

local bErr
local cFulDbf
local nH
local cImeCDXIz
local cImeCDX
local nOrder
local nPos

private cTag
private cKljuciz

if fSilent == nil
	fSilent := .t.
endif

close all

cImeCdx := ImeDbfCdx(cImeDbf)
 
nPom := RAT(SLASH, cImeInd)
cTag:=""

cKljucIz:=cKljuc

if nPom<>0
   cTag:=substr(cImeInd, nPom + 1)
else
   cTag := cImeInd
endif

fPostoji:=.t.

// bErr:=ERRORBLOCK({|o| MyErrHt(o)})
// BEGIN SEQUENCE

  select (F_TMP)
  USE(cImeDbf) VIA "DBFCDX"
  
  if USED()
    /*
    nPos:=FIELDPOS("BRISANO")
    //nPos == nil ako nije otvoren DBF
    
    if nPos==0
      AddFldBrisano(cImeDbf)
    endif

    nOrder:=ORDNUMBER("BRISAN")
    cOrdKey:=ORDKEY("BRISAN")
    if (nOrder==0)  .or. !(LEFT(cOrdKey,8)=="BRISANO")
      PRIVATE cPomKey:="BRISANO"
      PRIVATE cPomTag:="BRISAN"
      cImeCDX:=STRTRAN(cImeCDX,"."+INDEXEXT,"")
      INDEX ON &cPomKey  TAG (cPomTag) TO (cImeCDX)
    endif 
    */

    nOrder:=ORDNUMBER(cTag)
    cOrdKey:=ordkey(cTag)
    select (F_TMP)
    use
  else
    ?  "Nisam uspio otvoriti " + cImeDbf
    fPostoji:=.f.
  endif
  

//RECOVER
//  ? "recovvvvvvvver"
//  fPostoji:=.f.
//END SEQUENCE

//bErr:=ERRORBLOCK(bErr)

if !fPostoji
  // nisam uspio otvoriti, znaci ne mogu ni kreirati indexs ..
  return
endif

if !FILE(LOWER(cImeCdx))  .or. nOrder==0  .or. UPPER(cOrdKey) <> UPPER(cKljuc)


     cFulDbf:=cImeDbf
     if right(cFulDbf,4) <> "." + DBFEXT
        
        cFulDbf:=trim(cFulDbf)+"."+DBFEXT
        if at(SLASH,cFulDbf)==0  // onda se radi o kumulativnoj datoteci
             cFulDbf := alltrim(cDirRad) + SLASH + cFulDbf
        endif
     
     endif
     
     //if  !IsFreeForReading(cFulDBF,fSilent)
     //      return .f.
     //endif
    
     //DBUSEAREA (.f., nil, cImeDbf, nil, .t. )

     
     USE (cImeDbf) VIA "DBFCDX" NEW

	 if !fSilent
     	? "Baza:" + cImeDbf + ", Kreiram index-tag :" + cImeInd + "#" +  cImeCdx
	 endif    

     nPom:=RAT( SLASH, cImeInd)
    
     private cTag:=""
     private cKljuciz:=cKljuc
    
     if nPom<>0
       cTag:=substr(cImeInd, nPom)
     else
       cTag:=cImeInd
     endif

     if (LEFT(cTag, 4)=="ID_J" .and. FIELDPOS("ID_J")==0) .or. (cTag=="_M1_" .and. FIELDPOS("_M1_")==0)
        // da ne bi ispao ovo stavljam !!
     else

         cImeCdx := strtran(cImeCdx, "." + INDEXEXT, "" )
    
         if !fSilent
		    ? cKljucIz, cTag, cImeCdx
		 endif

         index on &cKljucIz TAG (cTag)
 
         //INDEX ON &cKljucIz  TAG (cTag) // TO (cImeCdx) VIA "DBFCDX"
         USE

     endif

     USE

endif

return

function MyErrHt(o)
   BREAK o
return .t.


function ImeDBFCDX(cIme)

 cIme:=trim(strtran( cIme, "." + DBFEXT, "." + INDEXEXT))
 if right(cIme, 4) <> "." + INDEXEXT
   cIme := cIme + "." + INDEXEXT
 endif

return  cIme

