/*
    $Id: AddressBook.prg 668 2010-12-07 13:49:43Z tfonrouge $
    Address book; test for RADO
*/

#include "wxharbour.ch"

#include "AddressBook.ch"

#ifdef _DEBUG_
#ifdef HB_OS_UNIX
    REQUEST HB_GT_XWC_DEFAULT
#endif
#ifdef HB_OS_WINDOWS
    REQUEST HB_GT_WVT_DEFAULT
#endif
#else
    REQUEST HB_GT_NUL_DEFAULT
#endif

REQUEST DBFCDX

FUNCTION Main()

#ifdef _DEBUG_
    SetMode( 40, 100 )
#endif

    //RddSetDefault( "DBFCDX" )

    IMPLEMENT_APP( myApp():New() )

RETURN NIL

/*
    myApp: wxApp descendand class
*/
CLASS myApp FROM wxApp
PRIVATE:
PROTECTED:

    DATA frame
    DATA searchExp
    DATA tbl_Name

    METHOD DefineDetailView()
    METHOD DefineMainList()
    METHOD DefineToolbar()
    METHOD Version() INLINE "v0.1"

PUBLIC:

    METHOD OnInit()

PUBLISHED:
ENDCLASS

/*
    OnInit
*/
METHOD FUNCTION OnInit() CLASS myApp

    ::tbl_Name := Tbl_Name():New()

    Tbl_Country():New()

    CREATE FRAME ::frame ;
        TITLE "Address Book " + ::Version() ;
        WIDTH 600 HEIGHT 400

    ::DefineToolbar()

    BEGIN PANEL VAR ::tbl_Name:panel CLASS "MyPanel"
        BEGIN BOXSIZER HORIZONTAL
        
            ::DefineMainList()

            ::DefineDetailView()

        END SIZER
    END PANEL

    SHOW WINDOW ::frame FIT CENTRE

RETURN .T.

/*
    DefineDetailView
*/
METHOD PROCEDURE DefineDetailView() CLASS myApp
    
    BEGIN PANEL VAR ::tbl_Name:panelDetail SIZERINFO ALIGN EXPAND STRETCH
        BEGIN FLEXGRIDSIZER COLS 2 GROWABLECOLS 2// ALIGN EXPAND

            @ SAY ::tbl_Name:Field_RecId:Label SIZERINFO ALIGN RIGHT
                @ GET ::tbl_Name:Field_RecId SIZERINFO ALIGN LEFT

            @ SAY ::tbl_Name:Field_DoB:Label SIZERINFO ALIGN RIGHT
                @ DATEPICKERCTRL ::tbl_Name:Field_DoB SIZERINFO ALIGN LEFT

            @ SAY ::tbl_Name:Field_Genre:Label SIZERINFO ALIGN RIGHT
                @ CHOICE ::tbl_Name:Field_Genre SIZERINFO ALIGN LEFT

            @ SAY ::tbl_Name:Field_FirstName:Label SIZERINFO ALIGN RIGHT
                @ GET ::tbl_Name:Field_FirstName SIZERINFO ALIGN EXPAND

            @ SAY ::tbl_Name:Field_LastName:Label SIZERINFO ALIGN RIGHT
                @ GET ::tbl_Name:Field_LastName SIZERINFO ALIGN EXPAND

            @ SAY ::tbl_Name:Field_Memo:Label SIZERINFO ALIGN RIGHT
                @ GET ::tbl_Name:Field_Memo MULTILINE SIZERINFO ALIGN EXPAND

        END SIZER
    END PANEL

RETURN

/*
    DefineMainList
*/
METHOD PROCEDURE DefineMainList() CLASS myApp

    @ BROWSE VAR ::tbl_Name:panel:browse DATASOURCE ::tbl_Name CLASS "TBaseBrowse" ;
        SIZERINFO ALIGN EXPAND //STRETCH
        
    ADD BCOLUMN TO ::tbl_Name:panel:browse FIELD "FullName"

RETURN

/*
    DefineToolbar
*/
METHOD PROCEDURE DefineToolbar() CLASS myApp
    LOCAL idBase

    idBase := ::tbl_Name:ClassH * 100

    BEGIN FRAME TOOLBAR //STYLE HB_BitOr( wxTB_HORIZONTAL, wxNO_BORDER ) SIZERINFO ALIGN RIGHT BORDER 0

        @ TOOL BUTTON ID idBase + abID_DB_INSERT LABEL "Add" SHORTHELP "Add " BITMAP "png/application_add.png" ;
            ACTION {|| ::tbl_Name:TryInsert() } ;
            ENABLED {|| ::tbl_Name:CanInsert() }

        @ TOOL BUTTON ID idBase + abID_DB_EDIT LABEL "Edit" SHORTHELP "Edit " BITMAP "png/application_edit.png" ;
            ACTION {|| ::tbl_Name:TryEdit() } ;
            ENABLED {|| ::tbl_Name:CanEdit() }

        @ TOOL BUTTON ID idBase + abID_DB_DELETE LABEL "Remove" SHORTHELP "Remove " BITMAP "png/application_remove.png" ;
            ACTION {|| ::tbl_Name:TryDelete( .T. ) } ;
            ENABLED {|| ::tbl_Name:CanDelete() }

        @ TOOL SEPARATOR

        @ TOOL BUTTON ID idBase + abID_DB_POST LABEL "Post" SHORTHELP "Write to table"  BITMAP "png/accept.png" ;
            ACTION {|| ::tbl_Name:TryPost() } ;
            ENABLED {|| ::tbl_Name:CanPost() }

        @ TOOL BUTTON ID idBase + abID_DB_CANCEL LABEL "Cancel" SHORTHELP "Cancel changes"  BITMAP "png/remove.png" ;
            ACTION {|| ::tbl_Name:Cancel() } ;
            ENABLED {|| ::tbl_Name:CanCancel() }

        @ TOOL SEPARATOR

        @ TOOL BUTTON ID idBase + abID_GOTOP LABEL "Top" SHORTHELP "Go to first record" BITMAP "png/skip_backward.png" ;
            ACTION {|| ::tbl_Name:panel:browse:GoTop() } ;
            ENABLED {|| ::tbl_Name:CanMove( abID_UP ) }

        @ TOOL BUTTON ID idBase + abID_GOPGUP LABEL "PgUp" SHORTHELP "Go to one Page Up" BITMAP "png/page_previous.png" ;
            ACTION {|| ::tbl_Name:panel:browse:PageUp() } ;
            ENABLED {|| ::tbl_Name:CanMove( abID_UP ) }

        @ TOOL BUTTON ID idBase + abID_GOUP LABEL "Up" SHORTHELP "Go to one record Up" BITMAP "png/back.png" ;
            ACTION {|| ::tbl_Name:panel:browse:Up() } ;
            ENABLED {|| ::tbl_Name:CanMove( abID_UP ) }

        @ TOOL BUTTON ID idBase + abID_GODOWN LABEL "Down" SHORTHELP "Go to one record Down" BITMAP "png/next.png" ;
            ACTION {|| ::tbl_Name:panel:browse:Down() } ;
            ENABLED {|| ::tbl_Name:CanMove( abID_DOWN ) }

        @ TOOL BUTTON ID idBase + abID_GOPGDOWN LABEL "PgDn" SHORTHELP "Go to one Page Down" BITMAP "png/page_next.png" ;
            ACTION {|| ::tbl_Name:panel:browse:PageDown() } ;
            ENABLED {|| ::tbl_Name:CanMove( abID_DOWN ) }

        @ TOOL BUTTON ID idBase + abID_GOBOTTOM LABEL "Bottom" SHORTHELP "Go to last record" BITMAP "png/skip_forward.png" ;
            ACTION {|| ::tbl_Name:panel:browse:GoBottom() } ;
            ENABLED {|| ::tbl_Name:CanMove( abID_DOWN ) }

        @ TOOL BUTTON ID idBase + abID_REFRESH LABEL "Refresh" SHORTHELP "Refresh List data" BITMAP "png/refresh.png" ;
            ACTION {|| ::tbl_Name:panel:browse:RefreshAll() } ;
            ENABLED {|| ::tbl_Name:CanMove( abID_NONE ) }
        
        @ SEARCHCTRL ::searchExp SIZERINFO ALIGN RIGHT

    END TOOLBAR

RETURN

/*
    MyPanel
*/
CLASS MyPanel FROM wxPanel
PRIVATE:
PROTECTED:
PUBLIC:

    DATA browse

PUBLISHED:
ENDCLASS
