function create_partn(cHome)

// PARTN
aDbf:={}
AADD(aDBf,{ 'ID'                  , 'C' ,   6 ,  0 })
AADD(aDBf,{ 'NAZ'                 , 'C' , 50 ,  0 })
if !file(cHome + "partn.dbf")
        dbcreate( cHome + 'partn.dbf', aDbf)
endif

CREATE_INDEX("ID", "ID", cHome + "partn")

CREATE_INDEX("NAZ","NAZ", cHome + "partn")

return .t.





function create_fin_suban(cHome)
local cTable := "fin_suban.dbf"
local cFullTable := cHome + cTable

aDbf:={}
AADD(aDBf,{ "IDFIRMA"             , "C" ,   2 ,  0 })
AADD(aDBf,{ "IDKONTO"             , "C" ,   7 ,  0 })
AADD(aDBf,{ "IDPARTNER"           , "C" ,   6 ,  0 })
AADD(aDBf,{ "IDVN"                , "C" ,   2 ,  0 })
AADD(aDBf,{ "BRNAL"               , "C" ,   8 ,  0 })
AADD(aDBf,{ "RBR"                 , "C" ,   4 ,  0 })
AADD(aDBf,{ "IDTIPDOK"            , "C" ,   2 ,  0 })
AADD(aDBf,{ "BRDOK"               , "C" ,   10 ,  0 })
AADD(aDBf,{ "DATDOK"              , "D" ,   8 ,  0 })
AADD(aDBf,{ "DatVal"              , "D" ,   8 ,  0 })
AADD(aDBf,{ "OTVST"               , "C" ,   1 ,  0 })
AADD(aDBf,{ "D_P"                 , "C" ,   1 ,  0 })
AADD(aDBf,{ "IZNOSBHD"            , "N" ,  21 ,  6 })
AADD(aDBf,{ "IZNOSDEM"            , "N" ,  19 ,  6 })
AADD(aDBf,{ "OPIS"               , "C" ,   20 ,  0 })
AADD(aDBf,{ "K1"               , "C" ,   1 ,  0 })
AADD(aDBf,{ "K2"               , "C" ,   1 ,  0 })
AADD(aDBf,{ "K3"               , "C" ,   2 ,  0 })
AADD(aDBf,{ "K4"               , "C" ,   2 ,  0 })
AADD(aDBf,{ "M1"               , "C" ,   1 ,  0 })
AADD(aDBf,{ "M2"               , "C" ,   1 ,  0 })


if !file(cFullTable)
            DBCREATE(cFullTable, aDbf)
endif

CREATE_INDEX("1" , "IdFirma+IdKonto+IdPartner+dtos(DatDok)+BrNal+RBr", cHome+"fin_suban") 
CREATE_INDEX("2" , "IdFirma+IdPartner+IdKonto", cHome+"fin_suban")
CREATE_INDEX("3" , "IdFirma+IdKonto+IdPartner+BrDok+dtos(DatDok)", cHome+"fin_suban")
CREATE_INDEX("4" , "idFirma + IdVN+BrNal + Rbr", cHome+"fin_suban")
CREATE_INDEX("5" , "idFirma+IdKonto + dtos(DatDok) + idpartner", cHome+"fin_suban")
CREATE_INDEX("6" , "IdKonto", cHome + "fin_suban")
CREATE_INDEX("7" , "Idpartner", cHome + "fin_suban")
CREATE_INDEX("8" , "Datdok", cHome + "fin_suban")
CREATE_INDEX("10" , "idFirma + IdVN + BrNal + idkonto + DTOS(datdok)", cHome+"fin_suban")

//    if gRJ=="D"
//        CREATE_INDEX("9","idfirma+idkonto+idrj+idpartner+DTOS(datdok)+brnal+rbr",cHome+"fin_suban")
//    endif
