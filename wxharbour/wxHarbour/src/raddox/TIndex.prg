/*
 * $Id: TIndex.prg 771 2011-09-30 20:41:23Z tfonrouge $
 */

/*
    TIndex
    Teo. Mexico 2007
*/

#include "hbclass.ch"
#include "dbinfo.ch"

#include "property.ch"
#include "raddox.ch"
#include "xerror.ch"

/*
    CLASS TIndex
    Teo. Mexico 2006
*/
CLASS TIndex FROM WXHBaseClass
PRIVATE:
    DATA FAutoIncrementKeyField
    DATA FCaseSensitive INIT .T.
    DATA FCustom INIT .F.
    DATA FDescend INIT .F.
    DATA FFilter
    DATA FForKey
    DATA FKeyField
    DATA FName
    DATA FMasterKeyField
    DATA FScopeBottom
    DATA FScopeTop
    DATA FTable
    DATA FTagName
    DATA FUniqueKeyField
    METHOD DbGoBottomTop( n )
    METHOD GetArrayKeyFields INLINE ::KeyField:FieldMethod
    METHOD GetAutoIncrement INLINE ::FAutoIncrementKeyField != NIL
    METHOD GetField
    METHOD GetIdxAlias()
    METHOD GetMasterKeyVal()
    METHOD GetScope INLINE iif( ::FScopeBottom == NIL .AND. ::FScopeTop == NIL, NIL, { ::FScopeTop, ::FScopeBottom } )
    METHOD GetScopeBottom INLINE iif( !Empty( ::FScopeBottom ), ::FScopeBottom, "" )
    METHOD GetScopeTop INLINE iif( !Empty( ::FScopeTop ), ::FScopeTop, "" )
    METHOD GetUnique INLINE ::FUniqueKeyField != NIL
    METHOD SetCaseSensitive( CaseSensitive ) INLINE ::FCaseSensitive := CaseSensitive
    METHOD SetCustom( Custom )
    METHOD SetDescend( Descend ) INLINE ::FDescend := Descend
    METHOD SetField( nIndex, XField )
    METHOD SetForKey( ForKey ) INLINE ::FForKey := ForKey
    METHOD SetIdxAlias( alias )
    METHOD SetScope( value )
    METHOD SetScopeBottom( value )
    METHOD SetScopeTop( value )
PROTECTED:
    DATA FTableBaseClass
PUBLIC:

    DATA associatedTable
    DATA FIdxAlias INIT .F.
    DATA getRecNo
    DATA setRecNo
    DATA temporary INIT .F.
    DATA useIndex

    METHOD New( Table, tagName, name, indexType, curClass ) CONSTRUCTOR

    METHOD AddIndex
    METHOD BaseSeek( direction, keyValue, lSoftSeek )
    METHOD CustomKeyDel
    METHOD CustomKeyUpdate
    METHOD DbGoBottom INLINE ::DbGoBottomTop( -1 )
    METHOD DbGoTop INLINE ::DbGoBottomTop( 1 )
    METHOD DbSetFilter( filter ) INLINE ::FFilter := filter
    METHOD DbSkip( numRecs )
    METHOD GetKeyVal()
    METHOD ExistKey( keyValue )
    METHOD Get4Seek( blk, keyVal, softSeek )
    METHOD Get4SeekLast( blk, keyVal, softSeek )
    METHOD GetAlias()
    METHOD GetCurrentRecord()
    METHOD IndexExpression()
    METHOD InsideScope()
    METHOD KeyExpression()
    METHOD MasterKeyExpression()

    METHOD OrdCondSet( ... ) INLINE ::FTable:OrdCondSet( ... )
    METHOD OrdCreate( ... ) INLINE ::FTable:OrdCreate( ... )
    METHOD OrdKeyNo() INLINE ::GetAlias():OrdKeyNo()

    METHOD RawGet4Seek( direction, blk, keyVal, softSeek )
    METHOD RawSeek( Value )

    METHOD SetKeyVal( keyVal )

    PROPERTY Filter READ FFilter
    PROPERTY IdxAlias READ GetIdxAlias WRITE SetIdxAlias
    PROPERTY KeyVal READ GetKeyVal WRITE SetKeyVal
    PROPERTY Scope READ GetScope WRITE SetScope
    PROPERTY ScopeBottom READ GetScopeBottom WRITE SetScopeBottom
    PROPERTY ScopeTop READ GetScopeTop WRITE SetScopeTop

    METHOD Seek( keyValue, lSoftSeek ) INLINE ::BaseSeek( 0, keyValue, lSoftSeek )
    METHOD SeekLast( keyValue, lSoftSeek ) INLINE ::BaseSeek( 1, keyValue, lSoftSeek )

PUBLISHED:
    PROPERTY AutoIncrement READ GetAutoIncrement
    PROPERTY AutoIncrementKeyField INDEX 1 READ GetField WRITE SetField
    PROPERTY CaseSensitive READ FCaseSensitive WRITE SetCaseSensitive
    PROPERTY Custom READ FCustom WRITE SetCustom
    PROPERTY Descend READ FDescend WRITE SetDescend
    PROPERTY ForKey READ FForKey WRITE SetForKey
    PROPERTY KeyField INDEX 3 READ GetField WRITE SetField
    PROPERTY UniqueKeyField INDEX 2 READ GetField WRITE SetField
    PROPERTY Name READ FName
    PROPERTY MasterKeyField INDEX 0 READ GetField WRITE SetField
    PROPERTY MasterKeyVal READ GetMasterKeyVal
    PROPERTY Table READ FTable
    PROPERTY TagName READ FTagName
    PROPERTY Unique READ GetUnique
ENDCLASS

/*
    New
    Teo. Mexico 2006
*/
METHOD New( Table, tagName, name, indexType, curClass ) CLASS TIndex

    ::FTable := Table
    
    IF Len( tagName ) > 10
        RAISE ERROR "TagName '" + tagName + "' exceeds lenght of 10..."
    ENDIF

    ::FTagName := tagName

    IF Empty( name )
        name := tagName
    ENDIF

    ::FName := name

    IF curClass = NIL
        curClass := ::FTable:ClassName()
    ENDIF

    ::FTableBaseClass := curClass

    IF !HB_HHasKey( ::FTable:IndexList, curClass )
        ::FTable:IndexList[ curClass ] := HB_HSetCaseMatch( {=>}, .F. )
    ENDIF

    ::FTable:IndexList[ curClass, name ] := Self

    IF "PRIMARY" = indexType
        ::FTable:SetPrimaryIndexList( curClass, name )
        ::FTable:SetPrimaryIndex( Self )
    ENDIF

RETURN Self

/*
    AddIndex
    Teo. Mexico 2008
*/
METHOD AddIndex( cMasterKeyField, ai, un, cKeyField, ForKey, cs, de, acceptEmptyUnique, useIndex, temporary /*, cu*/ )

    ::MasterKeyField := cMasterKeyField

    /* Check if needs to add the primary index key */
    IF ::FTable:PrimaryIndex == Self
        IF ai == .T.
            ::AutoIncrementKeyField := cKeyField
        ELSE
            ::UniqueKeyField := cKeyField
        ENDIF
    ELSE
        DO CASE
        /* Check if index key is AutoIncrement */
        CASE ai == .T.
            ::AutoIncrementKeyField := cKeyField
        /* Check if index key is Unique */
        CASE un == .T.
            ::UniqueKeyField := cKeyField
        /* Check if index key is a simple index */
        OTHERWISE
            ::KeyField := cKeyField
        ENDCASE
    ENDIF

    IF acceptEmptyUnique != NIL
        ::UniqueKeyField:AcceptEmptyUnique := acceptEmptyUnique
    ENDIF

    ::ForKey := ForKey
    ::CaseSensitive := iif( HB_ISNIL( cs ), .F. , cs )
    ::Descend := iif( HB_ISNIL( de ), .F. , de )
    ::useIndex := useIndex
    ::temporary := temporary == .T.
//	 ::Custom := iif( HB_ISNIL( cu ), .F. , cu )

    /* check for a valid index  order */
    IF ::FTable:Alias:OrdNumber( ::TagName ) = 0
        IF ::temporary
            IF ! ::FTable:CreateTempIndex( Self )
                RAISE ERROR "Failure to create temporal Index '" + ::Name + "'"
            ENDIF
        ELSE
            IF ! ::FTable:CreateIndex( Self )
                RAISE ERROR "Failure to create Index '" + ::Name + "'"
            ENDIF
        ENDIF
    ENDIF

RETURN Self

/*
    BaseSeek
    Teo. Mexico 2007
*/
METHOD FUNCTION BaseSeek( direction, keyValue, lSoftSeek ) CLASS TIndex
    LOCAL alias

    alias := ::GetAlias()

    IF AScan( {dsEdit,dsInsert}, ::FTable:State ) > 0
        ::FTable:Post()
    ENDIF

    keyValue := ::KeyField:GetKeyVal( keyValue )

    IF direction = 0
        alias:Seek( ::MasterKeyVal + keyValue, ::FTagName, lSoftSeek )
    ELSE
        alias:SeekLast( ::MasterKeyVal + keyValue, ::FTagName, lSoftSeek )
    ENDIF

    ::GetCurrentRecord()

RETURN ::FTable:Found()

/*
    CustomKeyDel
    Teo. Mexico 2006
*/
METHOD PROCEDURE CustomKeyDel CLASS TIndex
    LOCAL KeyVal

    IF !::FCustom
        RETURN
    ENDIF

    KeyVal := ::FTable:Alias:KeyVal( ::FTagName )

    WHILE ::FTable:Alias:ordKeyDel( ::FTagName, , KeyVal )
    ENDDO

RETURN

/*
    CustomKeyUpdate
    Teo. Mexico 2006
*/
METHOD PROCEDURE CustomKeyUpdate CLASS TIndex
    LOCAL KeyVal
    LOCAL Value

    KeyVal := ::FTable:Alias:KeyVal( ::FTagName )

    ::CustomKeyDel()

    IF !::FCustom .AND. ::UniqueKeyField != NIL
        RETURN
    ENDIF

    Value :=	::UniqueKeyField:AsString

    IF Empty( Value )
        RETURN
    ENDIF

    IF !::FCaseSensitive
        Value := Upper( Value )
    ENDIF

    IF KeyVal != NIL .AND. ( Len( KeyVal ) != Len( ::FTable:MasterKeyString + Value ) )
        ::Error_Custom_Index_Lenght_does_not_match_value()
        RETURN
    ENDIF

    ::FTable:Alias:ordKeyAdd( ::FTagName, , ::FTable:MasterKeyString + Value )

RETURN

/*
    DbGoBottomTop
    Teo. Mexico 2008
*/
METHOD FUNCTION DbGoBottomTop( n ) CLASS TIndex
    LOCAL masterKeyVal := ::MasterKeyVal
    LOCAL alias

    alias := ::GetAlias()

    IF n = 1
        IF ::GetScopeTop() == ::GetScopeBottom()
            alias:Seek( masterKeyVal + ::GetScopeTop(), ::FTagName )
        ELSE
            alias:Seek( masterKeyVal + ::GetScopeTop(), ::FTagName, .T. )
        ENDIF
    ELSE
        IF ::GetScopeTop() == ::GetScopeBottom()
            alias:SeekLast( masterKeyVal + ::GetScopeBottom() , ::FTagName )
        ELSE
            alias:SeekLast( masterKeyVal + ::GetScopeBottom() , ::FTagName, .T. )
        ENDIF
    ENDIF

    ::GetCurrentRecord()

    IF !::FTable:FilterEval( Self )
        ::FTable:SkipFilter( n, Self )
    ENDIF

RETURN ::FTable:Found()

/*
    DbSkip
    Teo. Mexico 2007
*/
METHOD FUNCTION DbSkip( numRecs ) CLASS TIndex
    LOCAL table

    IF ::associatedTable = NIL
        table := ::FTable
    ELSE
        table := ::associatedTable
    ENDIF

    IF ::FFilter = NIL .AND. !table:HasFilter
        ::GetAlias():DbSkip( numRecs, ::FTagName )
        RETURN ::GetCurrentRecord()
    ENDIF

RETURN ::FTable:SkipFilter( numRecs, Self )

/*
    ExistKey
    Teo. Mexico 2007
*/
METHOD FUNCTION ExistKey( keyValue ) CLASS TIndex
RETURN ::GetAlias():ExistKey( ::MasterKeyVal + keyValue, ::FTagName, ;
        {||
            IF ::IdxAlias = NIL
                RETURN ::FTable:RecNo
            ENDIF
            RETURN ( ::IdxAlias:workArea )->RecNo
        } )

/*
    Get4Seek
    Teo. Mexico 2009
*/
METHOD FUNCTION Get4Seek( blk, keyVal, softSeek ) CLASS TIndex
RETURN ::RawGet4Seek( 1, blk, keyVal, softSeek )

/*
    Get4SeekLast
    Teo. Mexico 2009
*/
METHOD FUNCTION Get4SeekLast( blk, keyVal, softSeek ) CLASS TIndex
RETURN ::RawGet4Seek( 0, blk, keyVal, softSeek )

/*
    GetAlias
    Teo. Mexico 2010
*/
METHOD FUNCTION GetAlias() CLASS TIndex
    IF ::IdxAlias = NIL
        RETURN ::FTable:Alias
    ENDIF
RETURN ::IdxAlias

/*
    GetCurrentRecord
    Teo. Mexico 2010
*/
METHOD FUNCTION GetCurrentRecord() CLASS TIndex
    LOCAL result
    LOCAL index := ::FTable:Index

    ::FTable:Index := Self
    result := ::FTable:GetCurrentRecord( ::GetIdxAlias() )
    ::FTable:Index := index

    IF ::associatedTable != NIL
        ::associatedTable:ExternalIndexList[ ::ObjectH ] := NIL
        result := ::getRecNo:Eval( ::associatedTable, ::FTable )
        ::associatedTable:ExternalIndexList[ ::ObjectH ] := Self
    ENDIF

RETURN result

/*
    GetField
    Teo. Mexico 2006
*/
METHOD FUNCTION GetField( nIndex ) CLASS TIndex
    LOCAL AField

    SWITCH nIndex
    CASE 0
        AField := ::FMasterKeyField
        EXIT
    CASE 1
        AField := ::FAutoIncrementKeyField
        EXIT
    CASE 2
        AField := ::FUniqueKeyField
        EXIT
    CASE 3
        AField := ::FKeyField
        EXIT
    ENDSWITCH

RETURN AField

/*
    GetIdxAlias
    Teo. Mexico 2010
*/
METHOD FUNCTION GetIdxAlias() CLASS TIndex
    IF ::temporary
        RETURN ::FTable:aliasTmp
    ENDIF
RETURN ::FTable:aliasIdx

/*
    GetKeyVal
    Teo. Mexico 2009
*/
METHOD FUNCTION GetKeyVal() CLASS TIndex

    IF ::FKeyField == NIL
        RETURN ""
    ENDIF

RETURN ::FKeyField:GetKeyVal

/*
    GetMasterKeyVal
    Teo. Mexico 2009
*/
METHOD FUNCTION GetMasterKeyVal() CLASS TIndex

    IF ::FMasterKeyField == NIL
        RETURN "" //::FTable:MasterKeyString
    ENDIF

RETURN ::FMasterKeyField:GetKeyVal

/*
    IndexExpression
    Teo. Mexico 2010
*/
METHOD FUNCTION IndexExpression() CLASS TIndex
    LOCAL exp

    exp := ::MasterKeyExpression

    exp += iif( Len( exp ) = 0, "", "+" ) + ::KeyExpression

RETURN exp

/*
    InsideScope
    Teo. Mexico 2008
*/
METHOD FUNCTION InsideScope() CLASS TIndex
    LOCAL masterKeyVal
    LOCAL scopeVal
    LOCAL keyValue

    IF ::FTable:Alias:Eof() .OR. ::FTable:Alias:Bof()
        RETURN .F.
    ENDIF

    keyValue := ::GetAlias():KeyVal( ::FTagName )

    IF keyValue == NIL
        RETURN .F.
    ENDIF

    masterKeyVal := ::MasterKeyVal

    scopeVal := ::GetScope()

    IF scopeVal == NIL
        RETURN masterKeyVal == "" .OR. keyValue = masterKeyVal
    ENDIF

RETURN keyValue >= ( masterKeyVal + ::GetScopeTop() ) .AND. ;
             keyValue <= ( masterKeyVal + ::GetScopeBottom() )

/*
    KeyExpression
    Teo. Mexico 2010
*/
METHOD FUNCTION KeyExpression() CLASS TIndex

    IF ::FKeyField != NIL
        RETURN ::FKeyField:IndexExpression
    ENDIF

RETURN ""

/*
    MasterKeyExpression
    Teo. Mexico 2011
*/
METHOD FUNCTION MasterKeyExpression() CLASS TIndex

    IF ::FMasterKeyField != NIL
        RETURN ::FMasterKeyField:IndexExpression
    ENDIF

RETURN ""

/*
    RawGet4Seek
    Teo. Mexico 2009
*/
METHOD FUNCTION RawGet4Seek( direction, blk, keyVal, softSeek ) CLASS TIndex

    IF keyVal = NIL
        keyVal := ::MasterKeyVal
    ELSE
        keyVal := ::MasterKeyVal + keyVal
    ENDIF

RETURN ::GetAlias():RawGet4Seek( direction, blk, keyVal, ::FTagName, softSeek )

/*
    RawSeek
    Teo. Mexico 2008
*/
METHOD FUNCTION RawSeek( Value ) CLASS TIndex

    IF AScan( {dsEdit,dsInsert}, ::FTable:State ) > 0
        ::FTable:Post()
    ENDIF

    ::GetAlias():Seek( Value, ::FTagName )

    ::GetCurrentRecord()

RETURN ::FTable:Found()

/*
    SetCustom
    Teo. Mexico 2006
*/
METHOD PROCEDURE SetCustom( Custom ) CLASS TIndex

    ::FCustom := Custom

    ::FTable:Alias:ordCustom( ::FTagName, , Custom )

RETURN

/*
    SetField
    Teo. Mexico 2006
*/
METHOD PROCEDURE SetField( nIndex, XField ) CLASS TIndex
    LOCAL AField
    LOCAL fld

    SWITCH ValType( XField )
    CASE 'C'
        AField := ::FTable:FieldByName( XField )
        IF AField == NIL
            RAISE ERROR "Declared Index Field '" + XField + "' doesn't exist..."
            RETURN
        ENDIF
        EXIT
    CASE 'O'
        IF !XField:IsDerivedFrom("TField")
            ::Error_Not_TField_Type_Object()
            RETURN
        ENDIF
        AField := XField
        EXIT
    CASE 'A'
        /* Array of fields are stored in a TStringField (for the index nature) */
        AField := TStringField():New( ::FTable, ::FTableBaseClass )
        AField:FieldMethod	:= XField
        fld := ::FTable:FieldByName( AField:Name )
        IF fld = NIL
            AField:AddFieldMessage()
        ELSE
            AField := fld
        ENDIF
        EXIT
    CASE 'U'
        AField := NIL
        EXIT
    OTHERWISE
        wxhAlert("! : Not a Valid Field Identifier...")
        RETURN
    ENDSWITCH

    /* Assign PrimaryKeyComponent value */
    IF ::FTable:PrimaryIndex == Self /* check if index is the Primary index */
        IF !HB_ISNIL( AField )
            AField:PrimaryKeyComponent := .T.
            /* Assign MasterField value to the TTable object field */
            IF nIndex = 0
                AField:IsMasterFieldComponent := .T.
            ENDIF
        ENDIF
    ELSE
        //AField:SecondaryKeyComponent := .T.
    ENDIF

    IF AField == NIL
        RETURN
    ENDIF

    SWITCH nIndex
    CASE 0	 /* MasterKeyField */
        ::FMasterKeyField := AField
        EXIT
    CASE 1	 /* AutoIncrementKeyField */
        IF AField:FieldMethodType = 'A'
            RAISE ERROR "Array of Fields are not Allowed as AutoIncrement Index Key..."
        ENDIF
        IF AField:IsDerivedFrom( "TObjectField" )
            RAISE ERROR "TObjectField's are not Allowed as AutoIncrement Index Key..."
        ENDIF
        AField:AutoIncrementKeyIndex := Self
        ::FAutoIncrementKeyField := AField
    CASE 2	 /* UniqueKeyField */
        AField:UniqueKeyIndex := Self
        ::FUniqueKeyField := AField
    CASE 3	 /* KeyField */
        IF AField:IsDerivedFrom( "TStringField" ) .AND. Len( AField ) = 0
            RAISE ERROR ::FTable:ClassName + ": Master key field <" + AField:Name + ">	needs a size > zero..."
        ENDIF
        AField:KeyIndex := Self
        ::FKeyField := AField
        IF ::FTable:BaseKeyField = NIL
            ::FTable:SetBaseKeyField( AField )
        ENDIF
        EXIT
    ENDSWITCH

RETURN

/*
    SetIdxAlias
    Teo. Mexico 2010
*/
METHOD PROCEDURE SetIdxAlias( alias ) CLASS TIndex
    IF ::temporary
        ::FTable:aliasTmp := alias
    ELSE
        ::FTable:aliasIdx := alias
    ENDIF
RETURN

/*
    SetKeyVal
    Teo. Mexico 2010
*/
METHOD FUNCTION SetKeyVal( keyVal ) CLASS TIndex

    ::FKeyField:SetKeyVal( keyVal )

RETURN Self

/*
    SetScope
    Teo. Mexico 2008
*/
METHOD FUNCTION SetScope( value ) CLASS TIndex
    LOCAL oldValue := { ::FScopeTop, ::FScopeBottom }

    IF ValType( value ) = "A" // scope by field
        ::FScopeTop := value[ 1 ]
        ::FScopeBottom := value[ 2 ]
    ELSE
        ::FScopeTop := value
        ::FScopeBottom := value
    ENDIF

RETURN oldValue

/*
    SetScopeBottom
    Teo. Mexico 2008
*/
METHOD FUNCTION SetScopeBottom( value ) CLASS TIndex
    LOCAL oldValue := ::FScopeBottom

    ::FScopeBottom := value

RETURN oldValue

/*
    SetScopeTop
    Teo. Mexico 2008
*/
METHOD FUNCTION SetScopeTop( value ) CLASS TIndex
    LOCAL oldValue := ::FScopeTop

    ::FScopeTop := value

RETURN oldValue

/*
    End Class TIndex
*/
