/*
 * $Id: helloworld.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxarel
    Teo. Mexico 2006
*/

#include "wxharbour.ch"

FUNCTION Main()

    IMPLEMENT_APP( MyApp():New() )

RETURN NIL

PROCEDURE CTest()
    LOCAL o

    o := MyClass1():New()

    wxGetApp():MyObj := WXH_NullObject( o )

    ? "Copy:", wxGetApp():MyObj:ClassName()
    wxGetApp():MyObj:Ping()

    o := NIL

    ? "Class is finished ?"

    ? wxGetApp():MyObj:ClassName()

RETURN

CLASS MyClass1

    DESTRUCTOR Destruct()

    METHOD Ping INLINE qout("Hello...")

ENDCLASS

METHOD PROCEDURE Destruct() CLASS MyClass1
    ? "Destroying: " + ::ClassName()
    //ASize( wxGetApp():MyObj, 1 )
RETURN

CLASS MyApp FROM wxApp
PRIVATE:
PROTECTED:
PUBLIC:
    DATA frame
    DATA MyObj
    METHOD OnInit()
PUBLISHED:
ENDCLASS

METHOD FUNCTION OnInit() CLASS MyApp
    LOCAL g_cve := ""
    LOCAL cComentario := ""

    CTest()
    
    //? "devuelta:", wxGetApp():MyObj:ClassName()

    CREATE FRAME ::frame ;
        TITLE "Frame1"

    BEGIN BOXSIZER VERTICAL
        BEGIN FLEXGRIDSIZER COLS 2 GROWABLECOLS 2 ALIGN EXPAND
        @ SAY "Codigo" SIZERINFO ALIGN RIGHT
        @ GET g_cve SIZERINFO ALIGN LEFT
            @ SAY "Comentario" SIZERINFO ALIGN RIGHT
        @ GET cComentario MULTILINE SIZERINFO ALIGN EXPAND
        END SIZER
        @ BUTTON "ShowTitle" ACTION {|| wxMessageBox( wxGetApp():frame:GetTitle() ) }
    END SIZER	

    SHOW WINDOW ::frame FIT CENTRE

RETURN .T.
