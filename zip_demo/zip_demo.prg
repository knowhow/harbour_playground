
procedure main()
local _files := {}
local _zip_file, _zip_path

// dodaj fajlove za zipovanje...
// test1.txt
// test2.txt
// test3.txt

AADD( _files, "test1.txt" )
AADD( _files, "test2.txt" )
AADD( _files, "test3.txt" )

// fajl ce se zvati
_zip_file := "zip_demo.zip"
_zip_path := "./"

zip_files( _zip_path, _zip_file, _files )

return



static function zip_files( zf_path, zf_name, files )
local hZip
local _zip_file_name, _i, _file

// ovo je izlazni fajl
_zip_file_name := HB_FNameMerge( zf_path, zf_name )

hZip := HB_ZIPOPEN( _zip_file_name )

IF !EMPTY( hZip )

    ? "Arhiviram fajl:", _zip_file_name

    FOR EACH _file IN files
        IF !EMPTY( _file )
            IF ! (_file == _zip_file_name )
                ? "Dodajem fajl:", _file
                HB_ZipStoreFile( hZip, _file, _file, nil )
            ENDIF
        ENDIF
    NEXT

    HB_ZIPCLOSE( hZip, "" )

ENDIF

return



