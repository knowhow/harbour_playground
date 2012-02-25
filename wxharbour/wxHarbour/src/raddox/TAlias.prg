/*
 * $Id: TAlias.prg 643 2010-09-24 13:50:18Z tfonrouge $
 */

/*
    TAlias
    Teo. Mexico 2007
*/

#include "hbclass.ch"
#include "property.ch"
#include "raddox.ch"
#include "xerror.ch"

CLASS TAlias FROM WXHBaseClass
PRIVATE:
    DATA FBof      INIT .T.
    DATA FEof      INIT .T.
    DATA FFound    INIT .F.
    DATA FRecNo
    DATA FStack    INIT {}
    DATA FStackLen INIT 0
    DATA FTableName
    METHOD GetRecNo INLINE ::SyncFromRecNo(),::FRecNo
    METHOD SetRecNo( RecNo ) INLINE ::DbGoTo( RecNo )
PROTECTED:
    CLASSDATA FInstances INIT HB_HSetCaseMatch( {=>}, .F. )
    METHOD GetAliasName() INLINE ::FInstances[ ::FTableName, "aliasName" ]
    METHOD SetWorkArea( workArea )
PUBLIC:

    DATA driver
    DATA lReadOnly INIT .F.
    DATA lShared INIT .T.

    CONSTRUCTOR New( table, aliasName )

    METHOD __DbZap()
    METHOD AddRec( index )
    METHOD DbCloseArea()
    METHOD DbDelete()
    METHOD DbGoBottom( indexName )
    METHOD DbGoTo( RecNo )
    METHOD DbGoTop( indexName )
    METHOD DbInfo( ... )
    METHOD DbOpen( table, aliasName )
    METHOD DbOrderInfo( ... )
    METHOD DbRecall()
    METHOD DbSkip( nRecords, indexName )
    METHOD DbStruct()
    METHOD DbUnLock() INLINE (::workArea)->( DbUnLock() )
    METHOD Deleted()
    METHOD Eval( codeBlock, ... )
    METHOD ExistKey( KeyValue, IndexName, RecNo )
    METHOD FCount INLINE (::workArea)->(FCount())
    METHOD FieldPos( FieldName ) INLINE (::workArea)->( FieldPos( FieldName ) )
    METHOD FLock() INLINE (::workArea)->( FLock() )
    METHOD Get4Seek( xVal, keyVal, indexName, softSeek )
    METHOD Get4SeekLast( xVal, keyVal, indexName, softSeek )
    METHOD GetFieldValue( fieldName )
    METHOD IsLocked( RecNo )
    METHOD KeyVal( indexName )
    METHOD LastRec INLINE (::workArea)->( LastRec() )
    METHOD OrdCondSet( ... )
    METHOD OrdCreate( ... )
    METHOD OrdCustom( Name, cBag, KeyVal )
    METHOD OrdKeyAdd( Name, cBag, KeyVal )
    METHOD OrdKeyDel( Name, cBag, KeyVal )
    METHOD OrdKeyNo( ... )
    METHOD OrdNumber( ordName, ordBagName )
    METHOD OrdSetFocus( Name, cBag )
    METHOD Pop()
    METHOD Push()
    METHOD RawGet4Seek( direction, xVal, keyVal, indexName, softSeek )
    METHOD RecCount INLINE (::workArea)->( RecCount() )
    METHOD RecLock( RecNo )
    METHOD RecUnLock( RecNo )
    METHOD Seek( cKey, indexName, softSeek )
    METHOD SeekLast( cKey, indexName, softSeek )
    METHOD SetFieldValue( fieldName, value )
    METHOD SyncFromAlias
    METHOD SyncFromRecNo

    /*!
     * needed for tdbrowse.prg (oDBE:Alias)
     */
    PROPERTY Alias READ GetAliasName
    PROPERTY Instances READ FInstances
    PROPERTY workArea READ FInstances[ ::FTableName, "workArea" ] WRITE SetWorkArea

PUBLISHED:
    PROPERTY Bof READ FBof
    PROPERTY Eof READ FEof
    PROPERTY Found READ FFound
    PROPERTY Name READ GetAliasName
    PROPERTY RecNo READ GetRecNo WRITE SetRecNo
ENDCLASS

/*
    New
    Teo. Mexico 2007
*/
METHOD New( table, aliasName ) CLASS TAlias
    LOCAL tableName

    IF Empty( table )
        RAISE ERROR "TAlias: Empty Table parameter."
    ENDIF

    IF HB_IsObject( table )

        tableName := table:TableFileName

        /* Check if this is a remote request */
        IF table:RDOClient != NIL
            RETURN table:Alias
        ENDIF

        IF Empty( tableName )
            RAISE ERROR "TAlias: Empty Table Name..."
        ENDIF

    ELSE

        tableName := table

    ENDIF

    IF !::DbOpen( table, aliasName )
        //RAISE ERROR "TAlias: Cannot Open Table '" + table:TableFileName + "'"
        BREAK( "TAlias: Cannot Open Table '" + tableName + "'" )
    ENDIF

    ::SyncFromAlias()

RETURN Self

/*
    __DbZap
    Teo. Mexico 2010
*/
METHOD FUNCTION __DbZap() CLASS TAlias
RETURN (::workArea)->( __DbZap() )

/*
    AddRec
    Teo. Mexico 2007
*/
METHOD FUNCTION AddRec( index ) CLASS TAlias
    LOCAL Result
    Result := (::workArea)->( AddRec(,index) )
    ::SyncFromAlias()
RETURN Result

/*
    DbCloseArea
    Teo. Mexico 2010
*/
METHOD PROCEDURE DbCloseArea() CLASS TAlias
    IF HB_HHasKey( ::FInstances, ::FTableName )
        ( ::workArea )->( DbCloseArea() )
        HB_HDel( ::FInstances, ::FTableName )
    ENDIF
RETURN

/*
    DbDelete
    Teo. Mexico 2009
*/
METHOD PROCEDURE DbDelete() CLASS TAlias
    ::SyncFromRecNo()
    (::workArea)->( DbDelete() )
RETURN

/*
    DbGoBottom
    Teo. Mexico 2007
*/
METHOD FUNCTION DbGoBottom( indexName ) CLASS TAlias
    LOCAL Result
    IF Empty( indexName )
        Result := (::workArea)->( DbGoBottom() )
    ELSE
        Result := (::workArea)->( DbGoBottomX( indexName ) )
    ENDIF
    ::SyncFromAlias()
RETURN Result

/*
    DbGoTo
    Teo. Mexico 2007
*/
METHOD FUNCTION DbGoTo( RecNo ) CLASS TAlias
    LOCAL Result
    Result := (::workArea)->( DbGoTo( RecNo ) )
    ::SyncFromAlias()
RETURN Result

/*
    DbGoTop
    Teo. Mexico 2007
*/
METHOD FUNCTION DbGoTop( indexName ) CLASS TAlias
    LOCAL Result
    IF Empty( indexName )
        Result := (::workArea)->( DbGoTop() )
    ELSE
        Result := (::workArea)->( DbGoTopX( indexName ) )
    ENDIF
    ::SyncFromAlias()
RETURN Result

/*
    DbInfo
    Teo. Mexico 2010
*/
METHOD FUNCTION DbInfo( ... ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( DbInfo( ... ) )

/*
    DbOpen
    Teo. Mexico 2008
*/
METHOD DbOpen( table, aliasName ) CLASS TAlias
    LOCAL path
    LOCAL tableName
    LOCAL tableFullFileName

    IF HB_IsObject( table )

        /* Check for a previously open workarea */
        IF HB_HHasKey( ::FInstances, table:TableFileName )
            ::FTableName := table:TableFileName
            RETURN .T.
        ENDIF
        
        IF table:IsTempTable
            IF !table:CreateTable()
                RETURN .F.
            ENDIF
            ::lShared := .F.
        ENDIF

        IF table:DataBase:OpenBlock != NIL
            IF !table:DataBase:OpenBlock:Eval( table, aliasName )
                ::FTableName := ""
                ::workArea := 0
                RETURN .F.
            ENDIF
            ::FTableName := table:TableFileName
            ::workArea := Select()
            RETURN .T.
        ENDIF

        IF !Empty( path := LTrim( RTrim( table:DataBase:Directory ) ) )
            IF !Right( path, 1 ) == HB_OSPathSeparator()
                path += HB_OSPathSeparator()
            ENDIF
        ELSE
            path := ""
        ENDIF

        table:fullFileName := path + table:TableFileName
        
        tableFullFileName := table:fullFileName
        tableName := table:TableFileName
        
    ELSE
    
        tableFullFileName := table
        tableName := table

    ENDIF
    
    IF ! HB_DbExists( tableFullFileName ) .AND. table:AutoCreate
        IF !table:CreateTable( tableFullFileName )
            BREAK( "TAlias: Cannot Create Table '" + tableFullFileName + "'" )
        ENDIF
    ENDIF

    DbUseArea( .T., ::driver, tableFullFileName, aliasName, ::lShared, ::lReadOnly )

    ::FTableName := tableName
    ::workArea := Select()

RETURN !NetErr()

/*
    DbOrderInfo
    Teo. Mexico 2010
*/
METHOD FUNCTION DbOrderInfo( ... ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( DbOrderInfo( ... ) )

/*
    DbRecall
    Teo. Mexico 2009
*/
METHOD PROCEDURE DbRecall() CLASS TAlias
    ::SyncFromRecNo()
    (::workArea)->( DbRecall() )
RETURN

/*
    DbSkip
    Teo. Mexico 2007
*/
METHOD FUNCTION DbSkip( nRecords, indexName ) CLASS TAlias
    LOCAL Result

    ::SyncFromRecNo()

    IF Empty( indexName )
        Result := (::workArea)->( DbSkip( nRecords ) )
    ELSE
        Result := (::workArea)->( DbSkipX( nRecords, indexName ) )
    ENDIF

    ::SyncFromAlias()

RETURN Result

/*
    DbStruct
    Teo. Mexico 2010
*/
METHOD FUNCTION DbStruct() CLASS TAlias
RETURN (::workArea)->(DbStruct())

/*
    Deleted
    Teo. Mexico 2009
*/
METHOD FUNCTION Deleted() CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( Deleted() )

/*
    Eval
    Teo. Mexico 2007
*/
METHOD FUNCTION Eval( codeBlock, ... ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->(codeBlock:Eval( ... ) )

/*
    ExistKey
    Teo. Mexico 2007
*/
METHOD FUNCTION ExistKey( KeyValue, IndexName, RecNo ) CLASS TAlias
RETURN (::workArea)->( ExistKey( KeyValue, IndexName, RecNo ) )

/*
    Get4Seek
    Teo. Mexico 2008
*/
METHOD FUNCTION Get4Seek( xVal, keyVal, indexName, softSeek ) CLASS TAlias
RETURN ::RawGet4Seek( 1, xVal, keyVal, indexName, softSeek )

/*
    Get4SeekLast
    Teo. Mexico 2007
*/
METHOD FUNCTION Get4SeekLast( xVal, keyVal, indexName, softSeek ) CLASS TAlias
RETURN ::RawGet4Seek( 0, xVal, keyVal, indexName, softSeek )

/*
    GetFieldValue
    Teo. Mexico 2007
*/
METHOD FUNCTION GetFieldValue( fieldName ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( FieldGet( FieldPos( fieldName ) ) )

/*
    IsLocked
    Teo. Mexico 2007
*/
METHOD FUNCTION IsLocked( RecNo ) CLASS TAlias
RETURN (::workArea)->( IsLocked( iif( RecNo == NIL, ::FRecNo, RecNo ) ) )

/*
    KeyVal
    Teo. Mexico 2007
*/
METHOD FUNCTION KeyVal( indexName ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( KeyVal( indexName ) )

/*
    OrdCondSet
    Teo. Mexico 2010
*/
METHOD FUNCTION OrdCondSet( ... ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( OrdCondSet( ... ) )

/*
    OrdCreate
    Teo. Mexico 2010
*/
METHOD FUNCTION OrdCreate( ... ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( OrdCreate( ... ) )

/*
    OrdCustom
    Teo. Mexico 2007
*/
METHOD FUNCTION OrdCustom( Name, cBag, KeyVal ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( OrdCustom( Name, cBag, KeyVal ) )

/*
    OrdKeyAdd
    Teo. Mexico 2007
*/
METHOD FUNCTION OrdKeyAdd( Name, cBag, KeyVal ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( OrdKeyAdd( Name, cBag, KeyVal ) )

/*
    OrdKeyDel
    Teo. Mexico 2007
*/
METHOD FUNCTION OrdKeyDel( Name, cBag, KeyVal ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( OrdKeyDel( Name, cBag, KeyVal ) )

/*
    OrdKeyNo
    Teo. Mexico 2010
*/
METHOD FUNCTION OrdKeyNo( ... ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( OrdKeyNo( ... ) )

/*
    OrdNumber
    Teo. Mexico 2009
*/
METHOD FUNCTION OrdNumber( ordName, ordBagName ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( OrdNumber( ordName, ordBagName ) )

/*
    OrdSetFocus
    Teo. Mexico 2007
*/
METHOD FUNCTION OrdSetFocus( Name, cBag ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( OrdSetFocus( Name, cBag ) )

/*
    Pop
    Teo. Mexico 2009
*/
METHOD PROCEDURE Pop() CLASS TAlias
    IF ::FStackLen > 0
        ::FBof	 := ::FStack[ ::FStackLen, 1 ]
        ::FEof	 := ::FStack[ ::FStackLen, 2 ]
        ::FFound := ::FStack[ ::FStackLen, 3 ]
        ::FRecNo := ::FStack[ ::FStackLen, 4 ]
        --::FStackLen
    ENDIF
RETURN

/*
    Push
    Teo. Mexico 2009
*/
METHOD PROCEDURE Push() CLASS TAlias
    IF Len( ::FStack ) < ++::FStackLen
        AAdd( ::FStack, { NIL, NIL, NIL, NIL } )
    ENDIF
    ::FStack[ ::FStackLen, 1 ] := ::FBof
    ::FStack[ ::FStackLen, 2 ] := ::FEof
    ::FStack[ ::FStackLen, 3 ] := ::FFound
    ::FStack[ ::FStackLen, 4 ] := ::FRecNo
RETURN

/*
    RawGet4Seek
    Teo. Mexico 2009
*/
METHOD FUNCTION RawGet4Seek( direction, xVal, keyVal, indexName, softSeek ) CLASS TAlias

    IF ValType( xVal ) = "O"
        xVal := xVal:FieldReadBlock
    END	

    IF keyVal = NIL
        keyVal := ""
    ENDIF

    IF direction = 1
        RETURN (::workArea)->( Get4Seek( xVal, keyVal, indexName, softSeek ) )
    ENDIF
    
RETURN (::workArea)->( Get4SeekLast( xVal, keyVal, indexName, softSeek ) )

/*
    RecLock
    Teo. Mexico 2007
*/
METHOD FUNCTION RecLock( RecNo ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( RecLock( RecNo ) )

/*
    RecUnLock
    Teo. Mexico 2007
*/
METHOD FUNCTION RecUnLock( RecNo ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( RecUnLock( RecNo ) )

/*
    Seek
    Teo. Mexico 2007
*/
METHOD FUNCTION Seek( cKey, indexName, softSeek ) CLASS TAlias
    LOCAL Result
    Result := (::workArea)->( Seek( cKey, indexName, softSeek ) )
    ::SyncFromAlias()
RETURN Result

/*
    SeekLast
    Teo. Mexico 2007
*/
METHOD FUNCTION SeekLast( cKey, indexName, softSeek ) CLASS TAlias
    LOCAL Result
    Result := (::workArea)->( SeekLast( cKey, indexName, softSeek ) )
    ::SyncFromAlias()
RETURN Result

/*
    SetFieldValue
    Teo. Mexico 2007
*/
METHOD FUNCTION SetFieldValue( fieldName, value ) CLASS TAlias
    ::SyncFromRecNo()
RETURN (::workArea)->( FieldPut( FieldPos( fieldName ), value ) )

/*
    SetWorkArea
    Teo. Mexico 2010
*/
METHOD PROCEDURE SetWorkArea( workArea ) CLASS TAlias
    ::FInstances[ ::FTableName ] := {=>}
    ::FInstances[ ::FTableName, "workArea" ] := workArea
    ::FInstances[ ::FTableName, "aliasName" ] := Alias( workArea )
RETURN

/*
    SyncFromAlias
    Teo. Mexico 2007
*/
METHOD PROCEDURE SyncFromAlias CLASS TAlias
    ::FBof	 := (::workArea)->( Bof() )
    ::FEof	 := (::workArea)->( Eof() )
    ::FFound := (::workArea)->( Found() )
    ::FRecNo := (::workArea)->( RecNo() )
RETURN

/*
    SyncFromRecNo
    Teo. Mexico 2007
*/
METHOD PROCEDURE SyncFromRecNo CLASS TAlias
    IF (::workArea)->(RecNo()) != ::FRecNo
        ::DbGoTo( ::FRecNo )
    ENDIF
RETURN

/*
    ENDCLASS TAlias
*/
