#include "inkey.ch"

static __root := "SIGMA"

procedure Main(...)
local _cur_dir, _file, _files
local _names, _attribs, _name, _attrib
local _i, _len

_cur_dir := __root

// SET DEFAULT TO _cur_dir

if  FILE(_cur_dir)
  ? "imamo", _cur_dir
endif

// SET PATH TO

// CURDIR()

//FT_CHDIR(_cur_dir)

//_files := DIRECTORY(_cur_dir + HB_OSPATHSEPARATOR() + "*.dbf")

_files := DIRECTORY("*.dbf")
? "cur dir", CURDIR()
for each _file in _files
  ? _file[1], _file[2], _file[3], _file[4], _file[5]
next

? "harbour/en/file.txt"

//? DIRMAKE()

?
?

dir_recurse(HB_OSPATHSEPARATOR() + CURDIR() + HB_OSPATHSEPARATOR() +  "SIGMA")

function dir_recurse(cur_dir)
local _files, _file

? "---------------------"

DIRCHANGE(cur_dir)

? "direct recurse:",  cur_dir
?

//DIRCHANGE(cur_dir) 
_files := DIRECTORY(cur_dir + HB_OSPATHSEPARATOR() + "*", "D")

? LEN(_files)
for each _file in _files
  if _file[5] != "D"
       ? _file[1], _file[2], _file[3], _file[4], _file[5]
       ? FILEBASE(_file[1])
  endif
next

? "==========================================="

for each _file in _files
  if _file[5] == "D"
        dir_recurse(cur_dir + HB_OSPATHSEPARATOR() +  _file[1])
  endif
next


return .t.

