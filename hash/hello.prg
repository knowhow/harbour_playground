#include "inkey.ch"

procedure Main(...)

local aIni

aIni := hb_hash()

aIni[ "database" ] := NIL
aIni[ "user_name" ] := NIL

set_hash(aIni)

? "hash poslije setovanja:"
print_hash(@aIni)

if ! HB_HHASKEY(aIni, "nepostojeci_key")
  aIni["nepostojeci_key"] := NIL
  ? "vrijednost za nepostojeci key je nakon setovanja nil", aIni["nepostojeci_key"]
else  
  ? "vrijednost za nepostojeci_key", aIni["nepostojeci_key"]
endif

return


function set_hash(aIni)
local cKey

? "hash prije setovanja:"
print_hash(aIni)

? "sve kljuceve setujem sa test vrijednoscu"
FOR EACH cKey IN aIni:Keys
    aIni[cKey] := "test"
NEXT

return .t.

function print_hash(aHash)
local cKey

FOR EACH cKey IN aHash:Keys
    ? cKey, ":", aHash[cKey] 
NEXT
