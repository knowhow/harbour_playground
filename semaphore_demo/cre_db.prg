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


