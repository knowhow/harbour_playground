/*
 * $Id: wxhColumn.prg 800 2012-02-01 00:09:56Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wxharbour.ch"

/*
    wxhBrowseColumn
    Teo. Mexico 2008
*/
CLASS wxhBrowseColumn
PRIVATE:

    DATA FAlign
    DATA FAligned INIT .F.
    DATA FBlock INIT {|| "<empty>" }
    DATA FBrowse
    DATA FFooting
    DATA FHeading INIT ""
    DATA FField
    DATA FOnSetValue INIT .F.
    DATA FPicture
    DATA FReadOnly INIT .F.
    DATA FValType
    DATA FWidth

    METHOD GetCanSetValue()
    METHOD SetAlign( align ) INLINE ::FAlign := align
    METHOD SetAligned( aligned ) INLINE ::FAligned := aligned
    METHOD SetBlock( block ) INLINE ::FBlock := block
    METHOD SetFooting( footing ) INLINE ::FFooting := footing
    METHOD SetHeading( heading )
    METHOD SetPicture( picture ) INLINE ::FPicture := picture
    METHOD SetReadOnly( readOnly ) INLINE ::FReadOnly := readOnly
    METHOD SetField( xfield )
    METHOD SetValType( valType ) INLINE ::FValType := valType
    METHOD SetWidth( width ) INLINE ::FWidth := width

PROTECTED:
    DATA hashValue INIT .F.
PUBLIC:

    CONSTRUCTOR New( browse, heading, block )

    DATA colPos INIT 0

    DATA IsEditable INIT .F.

    DATA OnSetValue

    METHOD GetValue( rowParam, nCol )
    METHOD SetValue( rowParam, value )

    PROPERTY Browse READ FBrowse
    PROPERTY CanSetValue READ GetCanSetValue
    PROPERTY Field READ FField WRITE SetField

PUBLISHED:

    PROPERTY Align READ FAlign WRITE SetAlign
    PROPERTY Aligned READ FAligned WRITE SetAligned
    PROPERTY Block READ FBlock WRITE SetBlock
    PROPERTY Footing READ FFooting WRITE SetFooting
    PROPERTY Heading READ FHeading WRITE SetHeading
    PROPERTY Picture READ FPicture WRITE SetPicture
    PROPERTY ReadOnly READ FReadOnly WRITE SetReadOnly
    PROPERTY ValType READ FValType WRITE SetValType
    PROPERTY Width READ FWidth WRITE SetWidth

ENDCLASS

/*
    New
    Teo. Mexico 2008
*/
METHOD New( browse, heading, block ) CLASS wxhBrowseColumn

    ::FBrowse := browse

    IF HB_IsObject( heading )
        ::Field := heading
    ELSE
        ::FHeading := heading
        IF block != NIL
            ::FBlock := block
        ENDIF
    ENDIF

RETURN Self

/*
    GetCanSetValue
    Teo. Mexico 2009
*/
METHOD FUNCTION GetCanSetValue() CLASS wxhBrowseColumn
RETURN ! ::ReadOnly .AND. !::FOnSetValue

/*
    GetValue
    Teo. Mexico 2010
*/
METHOD FUNCTION GetValue( rowParam, nCol ) CLASS wxhBrowseColumn
    LOCAL result

    IF ::FField != NIL
        IF !rowParam:__FObj:Eof()
            result := ::FBlock:Eval( rowParam:__FObj ):GetAsVariant()
            IF ::hashValue
                IF HB_HHasKey( ::FField:ValidValues, result )
                    result := ::FField:ValidValues[ result ]
                ELSE
                    result := "<Invalid Hash Key>"
                ENDIF
            ENDIF
        ELSE
            result := ::FBlock:Eval( rowParam:__FObj ):EmptyValue()
        ENDIF
    ELSE
        result := ::FBlock:Eval( rowParam )
    ENDIF

    IF HB_IsObject( rowParam )
        IF ::FHeading = NIL
            IF rowParam:__FLastLabel = NIL
                ::Heading := ""
            ELSE
                ::Heading := rowParam:__FLastLabel
            ENDIF
        ENDIF
    ENDIF

    IF ::ValType == NIL
        ::ValType := ValType( Result )
    ENDIF

    IF !::FAligned
        ::FAligned := .T.
        IF ::FAlign == NIL
            SWITCH ::ValType
            CASE 'N'
                ::FAlign := wxALIGN_RIGHT
                ::FBrowse:SetColFormatNumber( nCol )
                EXIT
            CASE 'C'
            CASE 'M'
                ::FAlign := wxALIGN_LEFT
                EXIT
            CASE 'L'
                ::FAlign := wxALIGN_CENTRE
//				 ::GetView():SetColFormatBool( nCol - 1 )
                ::FBrowse:SetColumnAlignment( nCol, ::FAlign )
                EXIT
            OTHERWISE
                ::FAlign := wxALIGN_CENTRE
            END
        ENDIF
        ::FBrowse:SetColumnAlignment( nCol, ::FAlign )
    ENDIF

RETURN result

/*
    SetHeading
    Teo. Mexico 2010
*/
METHOD PROCEDURE SetHeading( heading ) CLASS wxhBrowseColumn
    IF ! ::FHeading == heading
        ::FHeading := heading
        ::browse:SetColLabelValue( ::colPos, heading )
    ENDIF
RETURN

/*
    SetField
    Teo. Mexico 2010
*/
METHOD PROCEDURE SetField( xfield ) CLASS wxhBrowseColumn
    LOCAL block := ::FBlock
    LOCAL s
    LOCAL ds
    LOCAL i
    LOCAL fld
    LOCAL fldName
    LOCAL nTokens
    LOCAL index

    SWITCH ValType( xfield )
    CASE 'B'
        ::FField := xfield:Eval( ::browse:DataSource )
        ::FBlock := xfield
        EXIT
    CASE 'O'
        ::FField := xfield
        ::FBlock := {|| xfield }
        EXIT
    CASE 'C'
        ds := ::browse:DataSource
        nTokens := NumToken( xfield, ":" )
        FOR i:=1 TO nTokens
            fldName := Token( xfield, ":", i )
            fld := ds:FieldByName( fldName, @index )
            IF i = 1
                s := "::FieldList[" + NTrim( index ) + "]"
            ELSE
                s += ":DataObj:FieldList[" + NTrim( index ) + "]"
            ENDIF
            IF fld:IsDerivedFrom( "TObjectField" )
                ds := fld:DataObj
            ENDIF
        NEXT
        ::FBlock := &("{|Self| " + s + " }")
        ::FField := ::FBlock:Eval( ::browse:DataSource )
        ::hashValue := HB_IsHash( ::FField:ValidValues )
        EXIT
    ENDSWITCH

    IF HB_IsObject( ::FField ) .AND. ::FField:IsDerivedFrom( "TField" )
        ::Heading := ::FField:Label
        ::FPicture := ::FField:Picture
        ::FReadOnly := .F.
    ELSE
        ::FBlock := block
        wxhAlert( "Invalid TField value given to column browse" )
    ENDIF

RETURN

/*
    SetValue
    Teo. Mexico 2009
*/
METHOD FUNCTION SetValue( rowParam, value ) CLASS wxhBrowseColumn
    LOCAL itm
    LOCAL checkEditable

    IF ::IsEditable .AND. !::FOnSetValue

        ::FOnSetValue := .T.

        IF !::ReadOnly
            IF ::Field != NIL
                IF ::browse:DataSource:Eof()
                    ::FOnSetValue := .F.
                    RETURN .F.
                ENDIF
                checkEditable := ::Field:CheckEditable( .T. )
                IF ::browse:DataSource:State = dsBrowse .AND. !::browse:DataSource:autoEdit
                    ::Field:CheckEditable( checkEditable )
                    wxhAlert( "Can't edit field '" + ::Field:Label + "' on table '" + ::browse:DataSource:ClassName() + "'" )
                    ::FOnSetValue := .F.
                    RETURN .F.
                ENDIF
                IF !::browse:DataSource:OnBeforeLock()
                    ::Field:CheckEditable( checkEditable )
                    ::FOnSetValue := .F.
                    RETURN .F.
                ENDIF
                IF  ::hashValue
                    FOR EACH itm IN ::Field:ValidValues
                        IF value == itm:__enumValue
                            value := itm:__enumKey
                            EXIT
                        ENDIF
                    NEXT
                ENDIF
                ::Field:AsString := value
                ::browse:RefreshCurrent()
                ::Field:CheckEditable( checkEditable )
            ELSE
                ::FBlock:Eval( rowParam, value )
            ENDIF
        ENDIF

        IF ::OnSetValue != NIL
            ::OnSetValue:Eval()
        ENDIF

        ::FOnSetValue := .F.

    ENDIF

RETURN .T.
