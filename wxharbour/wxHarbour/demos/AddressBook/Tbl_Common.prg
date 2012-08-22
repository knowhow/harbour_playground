/*
    $Id: Tbl_Common.prg 668 2010-12-07 13:49:43Z tfonrouge $
    Tbl_Common : Table to contain names
*/

#include "wxharbour.ch"

#include "AddressBook.ch"

CLASS Tbl_Common FROM TTable
PRIVATE:
PROTECTED:
    METHOD InitDataBase INLINE MyDataBase():New()
PUBLIC:

    DATA panel

    PROPERTY AutoCreate DEFAULT .T.

    DEFINE FIELDS

    METHOD CanCancel() INLINE AScan( { dsEdit, dsInsert }, ::State ) > 0
    METHOD CanDelete() INLINE ! ::Eof() .AND. ::State = dsBrowse
    METHOD CanEdit() INLINE ! ::Eof() .AND. ::State = dsBrowse
    METHOD CanInsert() INLINE ::State = dsBrowse
    METHOD CanMove( direction )
    METHOD CanPost() INLINE AScan( { dsEdit, dsInsert }, ::State ) > 0

    METHOD OnDataChange()

    METHOD TryDelete()
    METHOD TryEdit()
    METHOD TryInsert()
    METHOD TryPost()

PUBLISHED:
ENDCLASS

/*
    FIELDS
*/
BEGIN FIELDS CLASS Tbl_Common

    /* Add here field's common to all descendant tables */

END FIELDS CLASS

/*
    CanMove
*/
METHOD FUNCTION CanMove( direction ) CLASS Tbl_Common
    LOCAL Result := .F.
    
    SWITCH direction
    CASE abID_UP
        Result := !::Bof()
        EXIT
    CASE abID_DOWN
        Result := !::Eof()
        EXIT
    CASE abID_NONE
        Result := .T.
        EXIT
    ENDSWITCH

RETURN Result .AND. ::State = dsBrowse

/*
    OnDataChange
*/
METHOD PROCEDURE OnDataChange() CLASS Tbl_Common

    IF ::panel != NIL
        ::panel:TransferDataToWindow()
    ENDIF

    Super:OnDataChange()

RETURN

/*
    TryDelete
*/
METHOD FUNCTION TryDelete() CLASS Tbl_Common
RETURN ::Delete()

/*
    TryEdit
*/
METHOD FUNCTION TryEdit() CLASS Tbl_Common

    IF ::Edit()
        ::panel:TransferDataToWindow()
        RETURN .T.
    ENDIF

RETURN .F.

/*
    TryInsert
*/
METHOD FUNCTION TryInsert() CLASS Tbl_Common

    IF ::Insert()
        ::panel:TransferDataToWindow()
        RETURN .T.
    ENDIF

RETURN .F.

/*
    TryPost
*/
METHOD PROCEDURE TryPost() CLASS Tbl_Common
    ::Post()
    ::panel:browse:RefreshAll()
RETURN
