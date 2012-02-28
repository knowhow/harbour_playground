/*
 * $Id: TTable.prg 814 2012-02-24 03:22:08Z tfonrouge $
 */

/*
    TTable
    Teo. Mexico 2007
*/

#include "wxharbour.ch"
#include "error.ch"
#include "xerror.ch"

#include "dbinfo.ch"

#define rxMasterSourceTypeNone     0
#define rxMasterSourceTypeTTable   1
#define rxMasterSourceTypeTField   2
#define rxMasterSourceTypeBlock    3

STATIC FErrorBlock := {|oErr| Break( oErr ) }

REQUEST TField

FUNCTION RadoxErrorNew( Self, description, args )
    LOCAL oErr := ErrorNew()

    oErr:cargo := Self
    oErr:description := description
    oErr:args := args
    
    IF ::IsDerivedFrom("TField")
        oErr:operation := "Table: " + ::Table:ClassName() + E"\nField: " + ::Name
    ENDIF

RETURN oErr

/*
    __ClsInstFromName (Just UpperCase in __ClsInstName)
    Teo. Mexico 2007
*/
FUNCTION __ClsInstFromName( ClassName )
RETURN __ClsInstName( Upper( ClassName ) )

/*
    ErrorBlockOODB
    Teo. Mexico 2011
*/
FUNCTION ErrorBlockOODB( oErr )

    // By default, division by zero results in zero
    IF oErr:genCode == EG_ZERODIV .AND. oErr:canSubstitute
        RETURN 0
    ENDIF

    // By default, retry on RDD lock error failure */
    IF oErr:genCode == EG_LOCK .AND. oErr:canRetry
        // oErr:tries++
        RETURN .T.
    ENDIF

    // Set NetErr() of there was a database open error
    IF oErr:genCode == EG_OPEN .AND. ;
        oErr:osCode == 32 .AND. ;
        oErr:canDefault
        NetErr( .T. )
        RETURN .F.
    ENDIF

    // Set NetErr() if there was a lock error on dbAppend()
    IF oErr:genCode == EG_APPENDLOCK .AND. oErr:canDefault
        NetErr( .T. )
        RETURN .F.
    ENDIF

    wxhAlert( oErr:description )

    IF .T.
        //Break( oErr )
        RETURN NIL
    ENDIF

RETURN NIL

/*
    OODB_ErrorHandler
    Teo. Mexico 2011
*/
/*
FUNCTION OODB_ErrorHandler( ... )
    LOCAL Self := QSelf()
    LOCAL sErr
    LOCAL oErr
    LOCAL nErr
    LOCAL description
    LOCAL errorBlock

    errorBlock := ErrorBlock()

    sErr := __GetMessage()

    //oErr := ErrorNew()
    oErr := ErrorNew()

    oErr:cargo := {"ProcLine"=>2}

    oErr:severity := ES_ERROR
    oErr:genCode := EG_ARG
    oErr:subSystem := "OODB:" + ::ClassName()
    oErr:canRetry := .F.
    oErr:canDefault := .F.
    oErr:args := HB_AParams()
    oErr:operation := ProcName( 2 )

    IF ::IsDerivedFrom( "TTable" ) .OR. ::IsDerivedFrom( "TField" )

        nErr := Val( SubStr( sErr, 7 ) )

        oErr:subCode := nErr

        description := ""

        IF ::IsDerivedFrom( "TField" )

            description += ;
                E"\n" + ;
                E"\n" + ;
                E"Table : " + ::Table:ClassName() + E"\n" + ;
                E"FieldName : '" + ::Name + E"', Label: '" + ::Label + E"'\n" + ;
                E"\n"

            SWITCH nErr
            CASE OODB_ERR__FIELD_METHOD_TYPE_NOT_SUPPORTED
                description += "Field method type not supported: '" + HB_AParams()[ 1 ] + "'"
                EXIT
            CASE OODB_ERR__CALCULATED_FIELD_CANNOT_BE_SOLVED
                description += "Calculated Field cannot be solved."
                EXIT
            OTHERWISE
                description := NIL
            ENDSWITCH

        ELSE // TTable

            SWITCH nErr
            CASE OODB_ERR__NO_BASEKEYFIELD
                description += "No Primary Base Key Field in Table."
                EXIT
            OTHERWISE
                description := NIL
            ENDSWITCH

        ENDIF

    ENDIF

    IF description = NIL
        oErr:description := "Message does not exist: '" + sErr + "'"
        oErr:operation := ProcName( 1 )
        oErr:cargo[ "ProcLine" ] := 1
        errorBlock := {|oErr| ErrorBlockOODB( oErr ) }
    ELSE
        oErr:description := description
    ENDIF

    errorBlock:Eval( oErr )

RETURN NIL
*/

/*
    TTable
    Teo. Mexico 2007
*/
CLASS TTable FROM WXHBaseClass
PRIVATE:

    CLASSDATA FFieldTypes
    CLASSDATA FInstances INIT HB_HSetCaseMatch( {=>}, .F. )

    DATA FActive				INIT .F.
    DATA FAddress
    DATA FAlias
    DATA FDisplayFields										// Contains a Object
    DATA FHasDeletedOrder INIT .F.
    DATA FIndex														// Current TIndex in Table
    DATA FMasterSource
    DATA FMasterSourceType  INIT rxMasterSourceTypeNone
    DATA FPort

    /* TODO: Check if we can re-use a client socket */
    DATA FRDOClient

    DATA FRecNoBeforeInsert

    DATA FReadOnly              INIT .F.
    DATA FRemote				INIT .F.
    DATA FState INIT dsInactive
    DATA FSubState INIT dssNone
    DATA FSyncingToContainerField INIT .F.
    DATA FTimer INIT 0
    DATA FUndoList

    METHOD DbGoBottomTop( n )
    METHOD GetAlias
    METHOD GetDbStruct
    METHOD GetFieldTypes
    METHOD GetFound INLINE ::Alias:Found
    METHOD GetIndexName INLINE iif( ::FIndex = NIL, NIL, ::FIndex:Name )
    METHOD GetInstance
    METHOD GetKeyExpression()
    METHOD GetKeyField()
    METHOD GetKeyString INLINE iif( ::GetKeyField == NIL, "", ::GetKeyField:AsString )
    METHOD GetMasterKeyExpression()
    METHOD GetMasterKeyField()
    METHOD GetMasterKeyString INLINE iif( ::GetMasterKeyField == NIL, "", ::GetMasterKeyField:AsString )
    METHOD GetMasterKeyVal INLINE iif( ::GetMasterKeyField == NIL, "", ::GetMasterKeyField:GetKeyVal )
    METHOD GetMasterSource()
    METHOD SetIndex( index )
    METHOD SetIndexName( IndexName )
    METHOD SetMasterSource( masterSource )
    METHOD SetReadOnly( readOnly )
    METHOD SetState( state )
    METHOD SetSyncingToContainerField( value ) INLINE ::FSyncingToContainerField := value
    METHOD Process_TableName( tableName )
    METHOD SendToServer

PROTECTED:

    CLASSDATA hDataBase INIT HB_HSetCaseMatch( {=>}, .F. )

    DATA FAutoCreate         INIT .F.
    DATA FBaseKeyField
    DATA FBof				INIT .T.
    DATA FDataBaseClass
    DATA FEof				INIT .T.
    DATA FFieldList         INIT {}
    DATA FFilledFieldList   INIT .F.
    DATA FFilter
    DATA FIndexList			INIT HB_HSetCaseMatch( {=>}, .F. )  // <className> => <indexName> => <indexObject>
    DATA FIsTempTable        INIT .F.
    DATA FFound				INIT .F.
    DATA FOnActiveSetKeyVal  INIT .F.
    DATA FPrimaryIndex
    DATA FPrimaryIndexList	INIT HB_HSetOrder( HB_HSetCaseMatch( {=>}, .F. ), .T. )  // <className> => <indexName>
    DATA FRecNo				INIT 0
    DATA FTableFileName     INIT "" // to be assigned (INIT) on inherited classes
    DATA tableState INIT {}
    DATA tableStateLen INIT 0

    METHOD AddRec()
    METHOD CheckDbStruct()
    METHOD DefineFieldsFromDb()
    METHOD FillFieldList()
    METHOD FillPrimaryIndexes( curClass )
    METHOD FindDetailSourceField( masterField )
    METHOD FixDbStruct( aNewStruct, message )
    METHOD GetDataBase()
    METHOD GetErrorBlock() INLINE FErrorBlock
    METHOD GetHasFilter()
    METHOD InitDataBase INLINE TDataBase():New()
    METHOD InitTable()
    METHOD RawGet4Seek( direction, xField, keyVal, index, softSeek )
    METHOD SetDataBase( dataBase )
    METHOD SetErrorBlock( errorBlock ) INLINE FErrorBlock := errorBlock
    METHOD SetTableFileName( tableFileName ) INLINE ::FTableFileName := tableFileName

PUBLIC:

    DATA aliasIdx
    DATA aliasTmp
    DATA allowOnDataChange  INIT .F.
    DATA autoEdit           INIT .F.
    DATA autoMasterSource   INIT .F.
    DATA autoOpen           INIT .T.
    DATA dataIsOEM          INIT .T.
    /*!
        array of possible TObjectField's that have this (SELF) object referenced
     */
    DATA DetailSourceList INIT {=>}
    DATA ExternalIndexList INIT {=>}
    DATA FieldNamePrefix	INIT "Field_"	// Table Field Name prefix
    DATA filterPrimaryIndexScope INIT .T.	// include filter if PrimaryIndex is in valid scope
    DATA FUnderReset INIT .F.
    DATA fullFileName
    DATA LinkedObjField

    DATA OnDataChangeBlock
    DATA OnDataChangeBlock_Param

    DATA validateDbStruct INIT .T.      // On Open, Check for a valid struct dbf (against DEFINE FIELDS )

    CONSTRUCTOR New( MasterSource, tableName )
    DESTRUCTOR OnDestruct()
    //ON ERROR FUNCTION OODB_ErrorHandler( ... )

    METHOD __DefineFields() VIRTUAL // DEFINE FIELDS
    METHOD __DefineIndexes() VIRTUAL // DEFINE INDEXES

    METHOD BaseSeek( direction, Value, index, lSoftSeek )
    METHOD AddFieldAlias( nameAlias, fld )
    METHOD AddFieldMessage( messageName, AField )
    METHOD AssociateTableIndex( table, name, getRecNo, setRecNo )
    METHOD Cancel
    METHOD Childs( ignoreAutoDelete, block, curClass, childs )
    METHOD ChildSource( tableName, destroyChild )
    METHOD CopyRecord( origin )
    METHOD Count( bForCondition, bWhileCondition, index, scope )
    METHOD CreateIndex( index )
    METHOD CreateTempIndex( index )
    METHOD CreateTable( fullFileName )
    METHOD DefineMasterDetailFields			VIRTUAL
    METHOD DefineRelations							VIRTUAL
    METHOD Destroy()
    METHOD DbEval( bBlock, bForCondition, bWhileCondition, index, scope )
    METHOD DbGoBottom INLINE ::DbGoBottomTop( -1 )
    METHOD DbGoTo( RecNo )
    METHOD DbGoTop INLINE ::DbGoBottomTop( 1 )
    METHOD DbSetFilter( filter ) INLINE ::FFilter := filter
    METHOD DbSkip( numRecs )
    METHOD Delete( lDeleteChilds )
    METHOD DeleteChilds( curClass )
    METHOD Edit()
    METHOD FieldByName( name, index )
    METHOD FieldByObjClass( objClass, derived )
    METHOD FilterEval( index )
    METHOD FindIndex( index )
    METHOD FindMasterSourceField( detailField )
    METHOD Get4Seek( xField, keyVal, index, softSeek ) INLINE ::RawGet4Seek( 1, xField, keyVal, index, softSeek )
    METHOD Get4SeekLast( xField, keyVal, index, softSeek ) INLINE ::RawGet4Seek( 0, xField, keyVal, index, softSeek )
    METHOD GetAsString
    METHOD GetCurrentRecord( idxAlias )
    METHOD GetDisplayFieldBlock( xField )
    METHOD GetDisplayFields( syncFromAlias )
    METHOD GetField( fld )
    METHOD GetKeyVal( value )
    METHOD GetMasterSourceClassName()
    METHOD GetPublishedFieldList( typeList )
    METHOD GetPublishedFieldNameList( typeList )
    METHOD GetTableFileName()
    METHOD GetValue
    METHOD ImportField( fromField, fieldDbName, fieldName )
    METHOD IndexByName( IndexName, curClass )
    METHOD Insert()
    METHOD InsertRecord( origin )
    METHOD InsideScope()
    METHOD Open
    METHOD OrdCondSet( ... )
    METHOD OrdCreate( ... )
    METHOD OrdKeyNo() INLINE ::Index:OrdKeyNo()
    METHOD Post()
    METHOD RawSeek( Value, index )
    METHOD RecLock()
    METHOD RecUnLock()
    METHOD Refresh
    METHOD Reset()	// Set Field Record to their default values, Sync MasterKeyVal Value
    METHOD Seek( Value, AIndex, SoftSeek ) INLINE ::BaseSeek( 0, Value, AIndex, SoftSeek )
    METHOD SeekLast( Value, AIndex, SoftSeek ) INLINE ::BaseSeek( 1, Value, AIndex, SoftSeek )
    METHOD SetAlias( alias ) INLINE ::FAlias := alias
    METHOD SetAsString( Value ) INLINE ::GetKeyField():AsString := Value
    METHOD SetBaseKeyField( baseKeyField )
    METHOD SetKeyVal( keyVal )
    /*
     * TODO: Enhance this to:
     *			 <order> can be "fieldname" or "fieldname1;fieldname2"
     *			 able to create a live index
     */
    METHOD SetOrderBy( order ) INLINE ::FIndex := ::FieldByName( order ):KeyIndex
    METHOD SetPrimaryIndex( primaryIndex )
    METHOD SetPrimaryIndexList( clsName, name )
    METHOD SetValue( value )
    METHOD SkipBrowse( n )
    METHOD SkipFilter( n, index )
    METHOD StatePop()
    METHOD StatePush()
    METHOD SyncDetailSources
    METHOD SyncFromMasterSourceFields()
    METHOD SyncRecNo( fromAlias )
    METHOD TableClass INLINE ::ClassName + "@" + ::TableFileName

    METHOD Validate( showAlert )

    METHOD OnClassInitializing() VIRTUAL
    METHOD OnCreate() VIRTUAL
    METHOD OnActiveSetKeyVal( value )
    METHOD OnAfterCancel() VIRTUAL
    METHOD OnAfterChange() VIRTUAL
    METHOD OnAfterDelete() VIRTUAL
    METHOD OnAfterInsert() VIRTUAL
    METHOD OnAfterOpen() VIRTUAL
    METHOD OnAfterPost() VIRTUAL
    METHOD OnBeforeCancel() INLINE .T.
    METHOD OnBeforeDelete() INLINE .T.
    METHOD OnBeforeInsert() INLINE .T.
    METHOD OnBeforeLock INLINE .T.
    METHOD OnBeforePost() INLINE .T.
    METHOD OnDataChange()
    METHOD OnPickList( param ) VIRTUAL
    METHOD OnStateChange( oldState ) VIRTUAL
    METHOD OnSyncFromMasterSource() VIRTUAL

    PROPERTY Active READ FActive
    PROPERTY Alias READ GetAlias WRITE SetAlias
    PROPERTY AsString READ GetAsString WRITE SetAsString
    PROPERTY AutoCreate READ FAutoCreate
    PROPERTY BaseKeyField READ FBaseKeyField
    PROPERTY BaseKeyIndex READ FBaseKeyField:KeyIndex
    PROPERTY BaseKeyVal READ BaseKeyField:GetKeyVal WRITE BaseKeyField:SetKeyVal
    PROPERTY Bof READ FBof
    PROPERTY DataBase READ GetDataBase WRITE SetDataBase
    PROPERTY DbStruct READ GetDbStruct
    PROPERTY Deleted READ Alias:Deleted()
    PROPERTY DisplayFields READ GetDisplayFields
    PROPERTY ErrorBlock READ GetErrorBlock WRITE SetErrorBlock
    PROPERTY Eof READ FEof
    PROPERTY FieldList READ FFieldList
    PROPERTY Found READ FFound
    PROPERTY FieldTypes READ GetFieldTypes
    PROPERTY Filter READ FFilter
    PROPERTY HasFilter READ GetHasFilter
    PROPERTY Instance READ GetInstance
    PROPERTY Instances READ FInstances
    PROPERTY IsTempTable READ FIsTempTable
    PROPERTY KeyExpression READ GetKeyExpression
    PROPERTY KeyField READ GetKeyField
    PROPERTY KeyString READ GetKeyString
    PROPERTY KeyVal READ GetKeyVal WRITE SetKeyVal
    PROPERTY MasterKeyExpression READ GetMasterKeyExpression
    PROPERTY MasterKeyString READ GetMasterKeyString
    PROPERTY MasterKeyVal READ GetMasterKeyVal
    PROPERTY PrimaryIndexList READ FPrimaryIndexList
    PROPERTY RDOClient READ FRDOClient
    PROPERTY RecCount READ GetAlias:RecCount()
    PROPERTY RecNo READ FRecNo WRITE DbGoTo
    PROPERTY State READ FState
    PROPERTY SubState READ FSubState
    PROPERTY SyncingToContainerField READ FSyncingToContainerField WRITE SetSyncingToContainerField
    PROPERTY TableFileName READ GetTableFileName WRITE SetTableFileName
    PROPERTY UndoList READ FUndoList

PUBLISHED:

    DATA Cargo

    PROPERTY ChildReferenceList READ FInstances[ ::TableClass, "ChildReferenceList" ]
    PROPERTY Index READ FIndex WRITE SetIndex
    PROPERTY IndexList READ FIndexList
    PROPERTY IndexName READ GetIndexName WRITE SetIndexName
    PROPERTY MasterDetailFieldList READ FInstances[ ::TableClass, "MasterDetailFieldList" ]
    PROPERTY MasterKeyField READ GetMasterKeyField
    PROPERTY MasterSource READ GetMasterSource WRITE SetMasterSource
    PROPERTY PrimaryIndex READ FPrimaryIndex
    PROPERTY PublishedFieldList READ GetPublishedFieldList
    PROPERTY PublishedFieldNameList READ GetPublishedFieldNameList
    PROPERTY ReadOnly READ FReadOnly WRITE SetReadOnly
    PROPERTY Value READ GetValue( ... ) WRITE SetValue

ENDCLASS

/*
    New
    Teo. Mexico 2006
*/
METHOD New( masterSource, tableName ) CLASS TTable
    LOCAL rdoClient
    LOCAL Result,itm
    LOCAL ms
    LOCAL n

    ::Process_TableName( tableName )

    IF ::FRDOClient != NIL

        rdoClient := ::FRDOClient

        Result := ::SendToServer( masterSource, ::TableFileName )

        ? "Result from Server:"
        ? "ClassName:",Result:ClassName,":",Result
        ? "Alias",Result:Alias:Name

        FOR EACH itm IN Result
            Self[ itm:__enumIndex() ] := itm
        NEXT

        ::FRDOClient := rdoClient

        IF !HB_HHasKey( ::FInstances, ::TableFileName )
            ::FInstances[ ::TableFileName ] := ::GetInstance()
        ENDIF

        RETURN Self

    ENDIF

    IF ::DataBase == NIL
        ::DataBase := ::InitDataBase()
    ENDIF

    IF masterSource = NIL .AND. !Empty( ms := ::GetMasterSourceClassName() ) .AND. ::autoMasterSource
        masterSource := __ClsInstName( ms )
        masterSource:autoMasterSource := .T.
        masterSource:New()
    ENDIF

    /*!
     * Sets the MasterSource (maybe will be needed in the fields definitions ahead )
     */
    IF masterSource != NIL

        /*
         * As we have not fields defined yet, this will not execute SyncFromMasterSourceFields()
         */
        ::SetMasterSource( masterSource )

    ENDIF

    ::InitTable()

    /*!
     * Load definitions for Fields
     */
    ::FillFieldList()

    /* Check for a valid db structure (based on definitions on DEFINE FIELDS) */
    IF !Empty( ::TableFileName ) .AND. ::validateDbStruct .AND. !HB_HHasKey( ::FInstances[ ::TableClass ], "DbStructValidated" )
        ::CheckDbStruct()
    ENDIF

    /* sets the DBS field info for each table field */
    FOR EACH itm IN ::FFieldList
        IF itm:IsTableField()
            n := Upper( itm:DBS_NAME )
            n := AScan( ::DbStruct, {|e| e[ 1 ] == n } )
            IF n > 0
                itm:SetDbStruct( ::DbStruct[ n ] )
            ENDIF
        ENDIF
    NEXT

    /*!
     * Load definitions for Indexes
     */
    IF Empty( ::FIndexList )
        ::__DefineIndexes()
    ENDIF

    IF ::FIndex = NIL
        IF ::FPrimaryIndex != NIL
            ::FIndex := ::FPrimaryIndex
        ELSEIF !Empty( ::FIndexList )
            ::FIndex := HB_HValueAt( HB_HValueAt( ::FIndexList, 1 ), 1 )
        ENDIF
    ENDIF

    ::OnCreate()

    IF ::autoOpen
        ::Open()
    ENDIF

RETURN Self

/*
    OnDestruct
    Teo. Mexico 2010
*/
METHOD PROCEDURE OnDestruct() CLASS TTable
    LOCAL dbfName, indexName

    IF ::aliasTmp != NIL
        dbfName := ::aliasTmp:DbInfo( DBI_FULLPATH )
        indexName := ::aliasTmp:DbOrderInfo( DBOI_FULLPATH )
        ::aliasTmp:DbCloseArea()
        FErase( dbfName )
        FErase( indexName )
    ENDIF

    //::Destroy()

RETURN

/*
    AddFieldAlias
    Teo. Mexico 2010
*/
METHOD PROCEDURE AddFieldAlias( nameAlias, fld ) CLASS TTable
    LOCAL AField

    SWITCH ValType( fld )
    CASE 'C'
        AField := ::FieldByName( fld )
        EXIT
    CASE 'O'
        IF fld:IsDerivedFrom("TField")
            AField := fld
            EXIT
        ENDIF
    ENDSWITCH

    IF AField != NIL
        IF AField:nameAlias != NIL
            RAISE ERROR "Alias Field Name '" + nameAlias + "' attempt to re-declare alias name on Field"
        ENDIF
        ::AddFieldMessage( nameAlias, AField )
        AField:nameAlias := nameAlias
    ELSE
        RAISE ERROR "Alias Field Name '" + nameAlias + "' not valid Field from"
    ENDIF

RETURN

/*
    AddFieldMessage
    Teo. Mexico 2006
*/
METHOD PROCEDURE AddFieldMessage( messageName, AField ) CLASS TTable
    LOCAL index
    LOCAL fld

    fld := ::FieldByName( messageName, @index )

    IF index = 0
        AAdd( ::FFieldList, AField )
        index := Len( ::FFieldList )
    ELSE
        IF fld:IsKeyIndex
            RAISE ERROR "Attempt to overwrite key index Field '" + messageName + "' on Class <" + ::ClassName + ">"
        ENDIF
        IF AField:TableBaseClass == fld:TableBaseClass
            RAISE ERROR "Attempt to Re-Declare Field '" + messageName + "' on Class <" + ::ClassName + ">"
        ENDIF
        ::FFieldList[ index ] := AField
    ENDIF

    /* Check if Name is already created in class */
    IF !__ObjHasMsg( Self, ::FieldNamePrefix + messageName )
        EXTEND OBJECT Self WITH MESSAGE ::FieldNamePrefix + messageName INLINE ::FieldList[ index ]
    ENDIF

RETURN

/*
    AddRec
    Teo. Mexico 2006
*/
METHOD FUNCTION AddRec() CLASS TTable
    LOCAL Result
    LOCAL AField
    LOCAL errObj
    LOCAL index
    LOCAL defaultValue

    IF ::FReadOnly
        wxhAlert( "Table '" + ::ClassName() + "' is marked as READONLY...")
        RETURN .F.
    ENDIF

    IF ::FHasDeletedOrder
        index := "__AVAIL"
    ELSEIF ::FPrimaryIndex != NIL
        index := ::FPrimaryIndex:Name
    ENDIF

    ::FRecNoBeforeInsert := ::RecNo()

    IF !( Result := ::Alias:AddRec(index) )
        RETURN Result
    ENDIF

    ::FEof := .F.
    ::FBof := .F.

    ::FRecNo := ::Alias:RecNo

    ::Reset() // Reset record data to default values

    ::SetState( dsInsert )
    ::FSubState := dssAdding

    /*
     * Write the MasterKeyField
     * Write the PrimaryKeyField
     * Write the Fields that have a DefaultValue
     */
    BEGIN SEQUENCE WITH ::ErrorBlock

        ::FillPrimaryIndexes( Self )

        FOR EACH AField IN ::FFieldList
            IF AField:FieldMethodType = 'C' .AND. !AField:PrimaryKeyComponent .AND. AField:WrittenValue == NIL .AND. AField:Enabled
                defaultValue := AField:DefaultValue
                IF !AField:Calculated .AND. ( defaultValue != NIL .OR. AField:AutoIncrement )
                    AField:SetData( defaultValue )
                ENDIF
            ENDIF
        NEXT

    RECOVER USING errObj

        ::TTable:Delete()
        ::RecUnLock()

        SHOW ERROR errObj

        Result := .F.

    END SEQUENCE

    ::FSubState := dssNone

RETURN Result

/*
    AssociateTableIndex
    Teo. Mexico 2010
*/
METHOD PROCEDURE AssociateTableIndex( table, name, getRecNo, setRecNo ) CLASS TTable
    LOCAL index

    IF !HB_HHasKey( ::IndexList, ::ClassName() )
        ::IndexList[ ::ClassName() ] := HB_HSetCaseMatch( {=>}, .F. )
    ENDIF

    index := table:IndexByName( name )
    index:associatedTable := Self

    index:getRecNo := getRecNo
    index:setRecNo := setRecNo

    ::IndexList[ ::ClassName(), name ] := index

    ::ExternalIndexList[ index:ObjectH ] := index

RETURN

/*
    BaseSeek
    Teo. Mexico 2007
*/
METHOD FUNCTION BaseSeek( direction, Value, index, lSoftSeek ) CLASS TTable
    LOCAL AIndex

    AIndex := ::FindIndex( index )

    IF direction = 0
        RETURN AIndex:BaseSeek( 0, Value, lSoftSeek )
    ENDIF

RETURN AIndex:BaseSeek( 1, Value, lSoftSeek )

/*
    Cancel
    Teo. Mexico 2006
*/
METHOD PROCEDURE Cancel CLASS TTable
    LOCAL AField

    IF !::OnBeforeCancel()
        RETURN
    ENDIF

    IF AScan( { dsInsert, dsEdit }, ::State ) = 0
        //::Error_Table_Not_In_Edit_or_Insert_mode()
        RETURN
    ENDIF

    SWITCH ::State
    CASE dsInsert
        FOR EACH AField IN ::FFieldList
            IF !AField:Calculated .AND. AField:FieldMethodType = "C" .AND. !Empty( AField:Value ) .AND. AField:Enabled .AND. !AField:Validate( .F. )
                AField:Reset()
            ENDIF
        NEXT
        ::TTable:Delete( .T. )
        EXIT
    CASE dsEdit
        FOR EACH AField IN ::FieldList
            IF !AField:Calculated .AND. AField:FieldMethodType = "C" .AND. HB_HHasKey( ::FUndoList, AField:Name ) .AND. !AField:Value == ::FUndoList[ AField:Name ]
                AField:RevertValue()
            ENDIF
        NEXT
        EXIT
    OTHERWISE

    ENDSWITCH

    ::RecUnLock()

    ::OnAfterCancel()

    IF ::FRecNoBeforeInsert != NIL
        ::RecNo := ::FRecNoBeforeInsert
        ::FRecNoBeforeInsert := NIL
    ENDIF

RETURN

/*
    CheckDbStruct
    Teo. Mexico 2010
*/
METHOD FUNCTION CheckDbStruct() CLASS TTable
    LOCAL AField,pkField
    LOCAL n
    LOCAL aDb
    LOCAL sResult := ""

    IF !HB_HHasKey( ::FInstances[ ::TableClass ], "DbStructValidating" )

        aDb := AClone( ::DbStruct() )

        ::FInstances[ ::TableClass, "DbStructValidating" ] := NIL

        FOR EACH AField IN ::FieldList
            IF AField:FieldMethodType = "C" .AND. !AField:Calculated .AND. AField:UsingField = NIL

                n := AScan( aDb, {|e| Upper( e[1] ) == Upper( AField:DBS_NAME ) } )

                IF n > 0
                    //AField:SetDbStruct( aDb[ n ] )
                ENDIF

                IF AField:IsDerivedFrom("TObjectField")
                    LOOP
                    /*
                    pkField := AField:BaseKeyField
                    IF pkField = NIL
                        RAISE ERROR "Cannot find data field for TObjectField '" + AField:Name + "'" + " in Table '" + ::ClassName + "'"
                    ENDIF
                    */
                ELSE
                    pkField := AField
                ENDIF

                IF n = 0
                    AAdd( aDb, { AField:DBS_NAME, pkField:DBS_TYPE, pkField:DBS_LEN, pkField:DBS_DEC } )
                    sResult += "Field not found '" + AField:DBS_NAME + E"'\n"
                ELSEIF !aDb[ n, 2 ] == pkField:DBS_TYPE
                    sResult += "Wrong type ('" + aDb[ n, 2 ] + "') on field '" + AField:DBS_NAME +"', must be '" + pkField:DBS_TYPE + E"'\n"
                    aDb[ n, 2 ] := pkField:DBS_TYPE
                    aDb[ n, 3 ] := pkField:DBS_LEN
                    aDb[ n, 4 ] := pkField:DBS_DEC
                ELSEIF aDb[ n, 2 ] = "C" .AND. aDb[ n, 3 ] < pkField:Size
                    sResult += "Wrong len value (" + NTrim( aDb[ n, 3 ] ) + ") on 'C' field '" + AField:DBS_NAME + E"', must be " + NTrim( pkField:DBS_LEN ) + E"\n"
                    aDb[ n, 3 ] := pkField:DBS_LEN
                ELSEIF aDb[ n, 2 ] = "N" .AND. ( !aDb[ n, 3 ] == pkField:DBS_LEN .OR. !aDb[ n, 4 ] == pkField:DBS_DEC )
                    sResult += "Wrong len/dec values (" + NTrim( aDb[ n, 3 ] ) + "," + NTrim( aDb[ n, 4 ] ) + ") on 'N' field '" + AField:DBS_NAME + E"', must be " + NTrim( pkField:DBS_LEN ) + "," + NTrim( pkField:DBS_DEC ) + E"\n"
                    aDb[ n, 3 ] := pkField:DBS_LEN
                    aDb[ n, 4 ] := pkField:DBS_DEC
                ENDIF

            ENDIF
        NEXT

        ::FInstances[ ::TableClass, "DbStructValidated" ] := .T.

        IF ! Empty( sResult )
            sResult := "Error on Db structure." + ;
                        E"\nClass: " + ::ClassName() + ", Table: " + ::Alias:Name + ;
                        E"\n\n-----\n" + ;
                        sResult + ;
                        E"-----\n\n"
            ? sResult

            ::FInstances[ ::TableClass, "DbStructValidated" ] := ::FixDbStruct( aDb, sResult )

        ENDIF

        HB_HDel( ::FInstances[ ::TableClass ], "DbStructValidating" )

    ENDIF

RETURN .T.

/*
    Childs
    Teo. Mexico 2011
*/
METHOD FUNCTION Childs( ignoreAutoDelete, block, curClass, childs ) CLASS TTable
    LOCAL childTableName
    LOCAL ChildDB
    LOCAL clsName
    LOCAL destroyChild

    IF curClass = NIL
        curClass := Self
    ENDIF

    IF childs = NIL
        childs := {}
    ENDIF

    clsName := curClass:ClassName

    IF clsName == "TTABLE"
        RETURN childs
    ENDIF

    IF HB_HHasKey( ::DataBase:ParentChildList, clsName )

        FOR EACH childTableName IN ::DataBase:GetParentChildList( clsName )

            IF !ignoreAutoDelete == .T. .OR. !::DataBase:TableList[ childTableName, "AutoDelete" ]

                ChildDB := ::ChildSource( childTableName, @destroyChild )

                IF ::DataBase:TableList[ childTableName, "IndexName" ] != NIL
                    ChildDB:IndexName := ::DataBase:TableList[ childTableName, "IndexName" ]
                ENDIF

                ChildDB:StatePush()
                
                ChildDB:PrimaryIndex:Scope := NIL

                IF ChildDB:PrimaryIndex:DbGoTop()
                    AAdd( childs, iif( block == NIL, ChildDB:ClassName, block:Eval( ChildDB ) ) )
                    ChildDB:StatePop()
                    IF destroyChild
                        ChildDB:Destroy()
                    ENDIF
                    LOOP
                ENDIF

                ChildDB:StatePop()
                
                IF destroyChild
                    ChildDB:Destroy()
                ENDIF

            ENDIF

        NEXT

    ENDIF

    ::Childs( ignoreAutoDelete, block, curClass:__Super, childs )

RETURN childs

/*
    ChildSource
    Teo. Mexico 2008
*/
METHOD FUNCTION ChildSource( tableName, destroyChild ) CLASS TTable
    LOCAL itm

    tableName := Upper( tableName )

    /* tableName is in the DetailSourceList */
    FOR EACH itm IN ::DetailSourceList
        IF itm:ClassName() == tableName
            itm:Reset()
            destroyChild := .F.
            RETURN itm
        ENDIF
    NEXT

    destroyChild := .T.

RETURN __ClsInstFromName( tableName ):New( Self )

/*
    CopyRecord
    Teo. Mexico 2007
*/
METHOD FUNCTION CopyRecord( origin ) CLASS TTable
    LOCAL AField
    LOCAL AField1
    LOCAL entry

    SWITCH ValType( origin )
    CASE 'O'	// Record from another Table
        IF !origin:IsDerivedFrom("TTable")
            RAISE ERROR "Origin is not a TTable class descendant."
            RETURN .F.
        ENDIF
        IF origin:Eof()
            RAISE ERROR "Origin is at EOF."
            RETURN .F.
        ENDIF
        FOR EACH AField IN ::FFieldList
            IF AField:FieldMethodType = 'C' .AND. !AField:PrimaryKeyComponent
                AField1 := origin:FieldByName( AField:Name )
                IF AField1 != NIL
                    AField:Value := AField1:Value
                ENDIF
            ENDIF
        NEXT
        EXIT
    CASE 'H'	// Hash of Values
        FOR EACH entry IN origin
            AField := ::FieldByName( entry:__enumKey )
            IF AField!=NIL .AND. AField:FieldMethodType = 'C' .AND. !AField:PrimaryKeyComponent
                AField:Value := entry:__enumValue
            ENDIF
        NEXT
        EXIT
    OTHERWISE
        RAISE ERROR "Unknown Record from Origin"
        RETURN .F.
    ENDSWITCH

RETURN .T.

/*
    Count : number of records
    Teo. Mexico 2008
*/
METHOD FUNCTION Count( bForCondition, bWhileCondition, index, scope ) CLASS TTable
    LOCAL nCount := 0

    ::DbEval( {|| ++nCount }, bForCondition, bWhileCondition, index, scope )

RETURN nCount

/*
    CreateTable
    Teo. Mexico 2010
*/
METHOD FUNCTION CreateTable( fullFileName ) CLASS TTable
    LOCAL aDbs := {}
    LOCAL fld
    LOCAL cNet

    ::FillFieldList()

    FOR EACH fld IN ::FieldList
        IF fld:IsTableField .AND. !fld:ReUseField
            AAdd( aDbs, { fld:DBS_NAME, fld:DBS_TYPE, fld:DBS_LEN, fld:DBS_DEC } )
        ENDIF
    NEXT
    
    IF Empty( aDbs )
        wxhAlert( "CreateTable: Cannot create table with empty data..." )
        RETURN .F.
    ENDIF

    IF fullFileName = NIL
        fullFileName := ::TableFileName
    ENDIF

    IF !::IsTempTable .AND. ::dataBase != NIL .AND. ::dataBase:netIO == .T.
        cNet := iif( Upper( fullFileName ) = "NET:", "", "net:" )
    ELSE
        cNet := ""
    ENDIF

    DbCreate( cNet + fullFileName, aDbs )

RETURN .T.

/*
    CreateIndex
    Teo. Mexico 2010
*/
METHOD FUNCTION CreateIndex( index ) CLASS TTable
    LOCAL indexExp
    LOCAL recNo

    indexExp := index:IndexExpression()

    DbSelectArea( ::Alias:Name )
    
    recNo := ::Alias:RecNo

    CREATE INDEX ON indexExp TAG index:TagName ADDITIVE
    
    ::Alias:RecNo := recNo

RETURN .T.

/*
    CreateTempIndex
    Teo. Mexico 2010
*/
METHOD FUNCTION CreateTempIndex( index ) CLASS TTable
    LOCAL fileName
    LOCAL pathName
    LOCAL aliasName
    LOCAL dbsIdx
    LOCAL size
    LOCAL fldName
    LOCAL lNew := .F.

    fldName := index:Name

    IF !index:temporary

        HB_FNameSplit( ::Alias:DbOrderInfo( DBOI_FULLPATH ), @pathName )

        pathName += Lower( ::ClassName )

        fileName := pathName + ".dbf"

        aliasName := "IDX_" + ::ClassName()

        IF File( fileName ) .AND. index:IdxAlias = NIL

            index:IdxAlias := TAlias()
            index:IdxAlias:lShared := .F.
            index:IdxAlias:New( fileName, aliasName )

        ENDIF

    ENDIF

    IF index:IdxAlias = NIL

        IF index:temporary

            FClose( HB_FTempCreateEx( @fileName, NIL, "t", ".dbf" ) )

            aliasName := "TMP_" + ::ClassName()

        ENDIF

        size := 0

        IF index:MasterKeyField != NIL
            size += index:MasterKeyField:Size
        ENDIF

        IF index:KeyField != NIL
            size += index:KeyField:Size
        ENDIF

        dbsIdx := ;
        { ;
            { "RECNO", "I", 4, 0 },;
            { fldName, "C", size, 0 } ;
        }

        DbCreate( fileName, dbsIdx )

        index:IdxAlias := TAlias()
        index:IdxAlias:lShared := .F.
        index:IdxAlias:New( fileName, aliasName )

        CREATE INDEX ON "RecNo" TAG "IDX_RECNO" BAG pathName ADDITIVE

        CREATE INDEX ON fldName TAG index:Name BAG pathName ADDITIVE

        lNew := .T.

    ENDIF

    IF index:temporary

        index:IdxAlias:__DbZap()

    ENDIF

    IF index:temporary .OR. lNew
        ::DbEval( ;
            {|Self|
                index:IdxAlias:AddRec()
                index:IdxAlias:SetFieldValue( "RECNO", ::RecNo() )
                index:IdxAlias:SetFieldValue( fldName, index:MasterKeyVal + index:KeyVal )
                RETURN NIL
            }, NIL, NIL, index:useIndex )
    ENDIF

    index:FIdxAlias := .T.

RETURN .T.

/*
    DbEval
    Teo. Mexico 2008
*/
METHOD PROCEDURE DbEval( bBlock, bForCondition, bWhileCondition, index, scope ) CLASS TTable
    LOCAL oldIndex
    LOCAL oldScope

    ::StatePush()

    IF index != NIL
        oldIndex := ::IndexName
        index := ::FindIndex( index )
        IF index != NIL
            ::IndexName := index:Name
        ENDIF
    ENDIF

    IF scope != NIL
        oldScope := ::Index:Scope
        ::Index:Scope := scope
    ENDIF

    ::DbGoTop()

    WHILE !::Eof() .AND. ( bWhileCondition == NIL .OR. bWhileCondition:Eval( Self ) )

        IF bForCondition == NIL .OR. bForCondition:Eval( Self )
            bBlock:Eval( Self )
        ENDIF

        ::DbSkip()

    ENDDO

    IF oldScope != NIL
        ::Index:Scope := oldScope
    ENDIF

    IF oldIndex != NIL
        ::IndexName := oldIndex
    ENDIF

    ::StatePop()

RETURN

/*
    DbGoBottomTop
    Teo. Mexico 2007
*/
METHOD FUNCTION DbGoBottomTop( n ) CLASS TTable

    IF AScan( {dsEdit,dsInsert}, ::FState ) > 0
        ::Post()
    ENDIF

    IF ::FIndex != NIL
        IF n = 1
            RETURN ::FIndex:DbGoTop()
        ELSE
            RETURN ::FIndex:DbGoBottom()
        ENDIF
    ELSE
        IF n = 1
            ::Alias:DbGoTop()
        ELSE
            ::Alias:DbGoBottom()
        ENDIF
        ::GetCurrentRecord()
        IF ::HasFilter .AND. !::FilterEval()
            ::SkipFilter( n )
        ENDIF
    ENDIF

RETURN .F.

/*
    DbGoTo
    Teo. Mexico 2007
*/
METHOD FUNCTION DbGoTo( RecNo ) CLASS TTable
    LOCAL Result

    Result := ::Alias:DbGoTo( RecNo )

    ::GetCurrentRecord()

RETURN Result

/*
    DbSkip
    Teo. Mexico 2011
*/
METHOD FUNCTION DbSkip( numRecs ) CLASS TTable

    IF AScan( {dsEdit,dsInsert}, ::FState ) > 0
        ::Post()
    ENDIF

    IF ::FIndex != NIL
        RETURN ::FIndex:DbSkip( numRecs )
    ELSE
        IF !::HasFilter
            ::Alias:DbSkip( numRecs )
            RETURN ::GetCurrentRecord()
        ENDIF
    ENDIF

RETURN ::SkipFilter( numRecs )

/*
    FIELDS END
    Teo. Mexico 2010
*/
METHOD PROCEDURE DefineFieldsFromDb() CLASS TTable
    LOCAL dbStruct
    LOCAL fld
    LOCAL AField

    IF ::Alias != NIL .AND. Empty( ::FFieldList ) .AND. !Empty( dbStruct := ::GetDbStruct() )
        FOR EACH fld IN dbStruct

            AField := __ClsInstFromName( ::FieldTypes[ fld[ 2 ] ] ):New( Self )

            AField:FieldMethod := fld[ 1 ]
            IF AField:IsDerivedFrom( "TStringField" )
                AField:Size := fld[ 3 ]
            ENDIF
            IF AField:IsDerivedFrom( "TNumericField" )
                AField:DBS_LEN := fld[ 3 ]
                AField:DBS_DEC := fld[ 4 ]
            ENDIF
            AField:AddFieldMessage()

        NEXT

    ENDIF

RETURN

/*
    Delete
    Teo. Mexico 2006
*/
METHOD FUNCTION Delete( lDeleteChilds ) CLASS TTable
    LOCAL AField
    LOCAL aChilds
    LOCAL child
    LOCAL lDel

    IF AScan( { dsBrowse, dsEdit, dsInsert }, ::State ) = 0
        ::Error_Table_Not_In_Browse_or_Insert_State()
        RETURN .F.
    ENDIF

    IF ::State = dsBrowse .AND. !::RecLock()
        RETURN .F.
    ENDIF

    aChilds := ::Childs()

    lDel := .T.

    IF !Empty( aChilds )
        FOR EACH child IN aChilds
            IF ! ::DataBase:TableList[ child, "AutoDelete" ]
                lDel := .F.
            ENDIF
        NEXT
        IF !lDel .AND. !lDeleteChilds == .T.
            wxhAlert("Error_Table_Has_Childs")
            RETURN .F.
        ENDIF
        IF !::DeleteChilds()
            wxhAlert("Error_Deleting_Childs")
            RETURN .F.
        ENDIF
    ENDIF

    IF ::OnBeforeDelete()

        FOR EACH AField IN ::FieldList
            AField:Delete()
        NEXT

        IF ::FHasDeletedOrder()
            ::Alias:DbDelete()
        ENDIF

        ::RecUnLock()

        ::GetCurrentRecord()

        ::OnAfterDelete()

    ENDIF

RETURN .T.

/*
    DeleteChilds
    Teo. Mexico 2006
*/
METHOD FUNCTION DeleteChilds( curClass ) CLASS TTable
    LOCAL childTableName
    LOCAL ChildDB
    LOCAL clsName
    LOCAL destroyChild
    LOCAL nrec

    IF curClass = NIL
        curClass := Self
    ENDIF

    clsName := curClass:ClassName

    IF clsName == "TTABLE"
        RETURN .T.
    ENDIF

    IF HB_HHasKey( ::DataBase:ParentChildList, clsName )

        nrec := ::Alias:RecNo()

        FOR EACH childTableName IN ::DataBase:GetParentChildList( clsName )

            ChildDB := ::ChildSource( childTableName, @destroyChild )

            IF ::DataBase:TableList[ childTableName, "IndexName" ] != NIL
                ChildDB:IndexName := ::DataBase:TableList[ childTableName, "IndexName" ]
            ENDIF

            ChildDB:StatePush()
            
            ChildDB:PrimaryIndex:Scope := NIL

            WHILE ChildDB:PrimaryIndex:DbGoTop()
                IF !ChildDB:TTable:Delete( .T. )
                    ChildDB:StatePop()
                    IF destroyChild
                        ChildDB:Destroy()
                    ENDIF
                    RETURN .F.
                ENDIF
            ENDDO
            
            ChildDB:StatePop()

            IF destroyChild
                ChildDB:Destroy()
            ENDIF

        NEXT

        ::Alias:DbGoTo(nrec)

    ENDIF

RETURN ::DeleteChilds( curClass:__Super )

/*
    Destroy
    Teo. Mexico 2008
*/
METHOD PROCEDURE Destroy() CLASS TTable
    LOCAL table

    IF HB_IsObject( ::MasterSource )
        IF HB_HHasKey( ::MasterSource:DetailSourceList, ::ObjectH )
            HB_HDel( ::MasterSource:DetailSourceList, ::ObjectH )
        ENDIF
    ENDIF

    IF !HB_IsArray( ::FFieldList )
        //WLOG("ERROR!: " + ::ClassName + ":Destroy - :FieldList is not a array...")
        RETURN
    ENDIF

    FOR EACH table IN ::DetailSourceList
        table:Destroy()
    NEXT

    ::FFieldList := NIL
    ::FDisplayFields := NIL
    ::tableState := NIL

    ::FActive := .F.

    IF ::IsTempTable
        ::Alias:DbCloseArea()
        HB_DbDrop( ::TableFileName )
    ENDIF

RETURN

/*
    Edit
    Teo. Mexico 2006
*/
METHOD FUNCTION Edit() CLASS TTable

    IF !::State = dsBrowse
        ::Error_TableNotInBrowseState()
        RETURN .F.
    ENDIF

    IF ::Eof() .OR. !::RecLock()
        RETURN .F.
    ENDIF

RETURN .T.

/*
    FieldByName
    Teo. Mexico 2006
*/
METHOD FUNCTION FieldByName( name, index ) CLASS TTable
    LOCAL AField

    index := 0

    IF Empty( name )
        RETURN NIL
    ENDIF

    name := Upper( name )

    FOR EACH AField IN ::FFieldList
        IF name == Upper( AField:Name ) .OR. ( AField:nameAlias != NIL .AND. name == Upper( AField:nameAlias ) )
            index := AField:__enumIndex
            RETURN AField
        ENDIF
    NEXT

RETURN NIL

/*
    FieldByObjClass
    Teo. Mexico 2010
*/
METHOD FUNCTION FieldByObjClass( objClass, derived ) CLASS TTable
    LOCAL fld

    objClass := Upper( objClass )

    FOR EACH fld IN ::FFieldList
        IF fld:IsDerivedFrom( "TObjectField" )
            IF derived == .T.
                IF fld:LinkedTable:IsDerivedFrom( objClass )
                    RETURN fld
                ENDIF
            ELSE
                IF fld:LinkedTable:ClassName() == objClass
                    RETURN fld
                ENDIF
            ENDIF
        ENDIF
    NEXT

RETURN NIL

/*
    FillFieldList
    Teo. Mexico 2010
*/
METHOD PROCEDURE FillFieldList() CLASS TTable
    IF ::FFilledFieldList = .F.
        ::FFilledFieldList := .T.
        ::__DefineFields()
        IF Empty( ::FFieldList )
            ::DefineFieldsFromDb()
        ENDIF
    ENDIF
RETURN

/*
    FillPrimaryIndexes
    Teo. Mexico 2009
*/
METHOD PROCEDURE FillPrimaryIndexes( curClass ) CLASS TTable
    LOCAL className
    LOCAL AIndex
    LOCAL AField
    LOCAL isEmpty
    LOCAL itm

    className := curClass:ClassName()

    IF !className == "TTABLE"

        ::FillPrimaryIndexes( curClass:Super )

        IF HB_HHasKey( ::FPrimaryIndexList, className )
            AIndex := ::FIndexList[ className, ::FPrimaryIndexList[ className ] ]
        ELSE
            AIndex := NIL
        ENDIF

        IF AIndex != NIL
            AField := AIndex:MasterKeyField
            IF AField != NIL
                AField:SetData()
            ENDIF
            /*!
             * AutoIncrement fields always need to be written (to set a value)
             */
            AField := AIndex:UniqueKeyField
            IF AField:FieldMethodType = "A"
                isEmpty := .F.
                FOR EACH itm IN AField:FieldArrayIndex
                    IF Empty( ::FFieldList[ itm ]:Value )
                        isEmpty := .T.
                        EXIT
                    ENDIF
                NEXT
            ELSE
                isEmpty := Empty( AField:Value )
            ENDIF
            IF AField != NIL .AND. ( AIndex:AutoIncrement .OR. !isEmpty )
                AField:SetData()
            ENDIF
        ENDIF

    ENDIF

RETURN

/*
    FilterEval
    Teo. Mexico 2010
*/
METHOD FUNCTION FilterEval( index ) CLASS TTable
    LOCAL table

    IF index != NIL .AND. index:associatedTable != NIL
        table := index:associatedTable
    ELSE
        table := Self
    ENDIF

    IF index != NIL .AND. index:Filter != NIL .AND. !index:Filter:Eval( table )
        RETURN .F.
    ENDIF

    IF ::filterPrimaryIndexScope .AND. ::FPrimaryIndex != NIL .AND. !::FPrimaryIndex:InsideScope()
        RETURN .F.
    ENDIF

RETURN table:Filter = NIL .OR. table:Filter:Eval( table )

/*
    FindDetailSourceField
    Teo. Mexico 2007
*/
METHOD FUNCTION FindDetailSourceField( masterField ) CLASS TTable
    LOCAL Result

    IF HB_HHasKey( ::MasterDetailFieldList, masterField:Name )
        Result := ::FieldByName( ::MasterDetailFieldList[ masterField:Name ] )
    ELSE
        Result := ::FieldByName( masterField:Name )
    ENDIF

RETURN Result

/*
    FindIndex
    Teo. Mexico 2010
*/
METHOD FUNCTION FindIndex( index ) CLASS TTable
    LOCAL AIndex

    SWITCH ValType( index )
    CASE 'U'
        AIndex := ::FIndex
        EXIT
    CASE 'C'
        IF Empty( index )
            AIndex := ::FPrimaryIndex
        ELSE
            AIndex := ::IndexByName( index )
        ENDIF
        EXIT
    CASE 'O'
        IF index:IsDerivedFrom( "TIndex" )
            AIndex := index
            EXIT
        ENDIF
    OTHERWISE
        RAISE ERROR "Unknown index reference..."
    ENDSWITCH

RETURN AIndex

/*
    FindMasterSourceField
    Teo. Mexico 2007
*/
METHOD FUNCTION FindMasterSourceField( detailField ) CLASS TTable
    LOCAL enum
    LOCAL name
    LOCAL vt := ValType( detailField )

    IF ::FMasterSource == NIL
        RETURN NIL
    ENDIF

    DO CASE
    CASE vt = "C"
        name := Upper( detailField )
    CASE vt = "O" .AND. detailField:IsDerivedFrom( "TField" )
        name := Upper( detailField:Name )
    OTHERWISE
        RETURN NIL
    ENDCASE

    FOR EACH enum IN ::MasterDetailFieldList
        IF name == Upper( enum:__enumValue )
            RETURN ::MasterSource:FieldByName( enum:__enumValue )
        ENDIF
    NEXT

RETURN ::MasterSource:FieldByName( name )

/*
    FixDbStruct
    Teo. Mexico 2010
*/
METHOD FUNCTION FixDbStruct( aNewStruct, message ) CLASS TTable
    LOCAL fileName
    LOCAL tempName
    LOCAL sPath,sName,sExt,sDrv
    LOCAL sPath2,sName2,sExt2,sDrv2
    LOCAL result
    LOCAL recNo

    IF message = NIL
        message := ""
    ENDIF

    IF ::dataBase != NIL .AND. ::dataBase:netIO
        wxhAlert( "Cannot run FixDbStruct on netIO tables..." )
        RETURN .F.
    ENDIF

    IF wxhAlertYesNo( message + "Proceed to update Db Structure ?" ) = 1

        fileName := ::fullFileName

        sExt := DbInfo( DBI_TABLEEXT )

        HB_FNameSplit( fileName, @sPath, @sName, NIL, @sDrv )
        
        recNo := ::Alias:RecNo

        ::Alias:DbCloseArea()

        FClose( HB_FTempCreateEx( @tempName, sPath, "tmp", sExt ) )

        DBCreate( tempName, aNewStruct )

        USE ( tempName ) NEW

        BEGIN SEQUENCE WITH ;
            {|oErr|

                IF oErr:GenCode = EG_DATATYPE
                    RETURN .F.
                ENDIF

                IF .T.
                    Break( oErr )
                ENDIF

                RETURN NIL
            }

            APPEND FROM ( fileName )

            CLOSE ( Alias() )

            FRename( HB_FNameMerge( sPath, sName, sExt, sDrv ), HB_FNameMerge( sPath, "_" + sName, sExt, sDrv ) )

            FRename( HB_FNameMerge( sPath, sName, ".fpt", sDrv ), HB_FNameMerge( sPath, "_" + sName, ".fpt", sDrv ) )

            HB_FNameSplit( tempName, @sPath2, @sName2, @sExt2, @sDrv2 )

            FRename( HB_FNameMerge( sPath2, sName2, sExt2, sDrv2 ), HB_FNameMerge( sPath, sName, sExt, sDrv ) )

            FRename( HB_FNameMerge( sPath2, sName2, ".fpt", sDrv2 ), HB_FNameMerge( sPath, sName, ".fpt", sDrv ) )

            result := ::Alias:DbOpen( Self )
            
            ::Alias:RecNo := recNo

            HB_HDel( ::FInstances[ ::TableClass ], "DbStruct" )

        RECOVER

            result := .F.

        END SEQUENCE

    ELSE
        ::CancelAtFixDbStruct()
        result := .F.
    ENDIF

RETURN result

/*
    GetAlias
    Teo. Mexico 2008
*/
METHOD FUNCTION GetAlias CLASS TTable
    IF ::FRDOClient != NIL .AND. ::FAlias == NIL
        //::FAlias := ::SendToServer()
    ENDIF
RETURN ::FAlias

/*
    GetAsString
    Teo. Mexico 2009
*/
METHOD FUNCTION GetAsString() CLASS TTable
    LOCAL pkField := ::GetKeyField()

    IF pkField == NIL
        RETURN ""
    ENDIF

RETURN pkField:AsString

/*
    GetCurrentRecord
    Teo. Mexico 2010
*/
METHOD FUNCTION GetCurrentRecord( idxAlias ) CLASS TTable
    LOCAL AField
    LOCAL Result
    LOCAL index
    LOCAL read
    LOCAL table

    IF idxAlias = NIL
        IF ::aliasIdx != NIL
            ::aliasIdx:Seek( ::Alias:RecNo, "IDX_RECNO" )
        ENDIF
        IF ::aliasTmp != NIL
            ::aliasTmp:Seek( ::Alias:RecNo, "IDX_RECNO" )
        ENDIF
        ::FBof   := ::Alias:Bof()
        ::FEof   := ::Alias:Eof()
        ::FFound := ::Alias:Found()
    ELSE
        ::Alias:DbGoTo( (idxAlias:workArea)->RecNo )
        ::FBof   := idxAlias:Bof()
        ::FEof   := idxAlias:Eof()
        ::FFound := idxAlias:Found()
        IF ::aliasIdx != NIL .AND. ::aliasTmp != NIL
            IF idxAlias == ::aliasIdx
                ::aliasTmp:Seek( ::Alias:RecNo, "IDX_RECNO" )
            ELSE
                ::aliasIdx:Seek( ::Alias:RecNo, "IDX_RECNO" )
            ENDIF
        ENDIF
    ENDIF

    IF ::FIndex != NIL .AND. HB_HHasKey( ::ExternalIndexList, ::FIndex:ObjectH )
        index := ::FIndex ; ::FIndex := NIL
        ::GetCurrentRecord( idxAlias )
        index:setRecNo:Eval( Self, index:Table)
        ::FIndex := index
        read := .T.
    ENDIF

    ::FRecNo := ::Alias:RecNo

    IF ::FState = dsBrowse

        IF ( Result := ::InsideScope() )

            IF !read == .T.

                FOR EACH AField IN ::FFieldList

                    IF AField:Enabled
                        IF AField:FieldMethodType = "C" .AND. !AField:Calculated //.AND. !AField:IsMasterFieldComponent
                            AField:GetData()
                        ENDIF

                        IF AField:FieldType = ftObject .AND. AField:Calculated .AND. AField:LinkedTableAssigned
                            table := AField:LinkedTable
                            IF table:LinkedObjField != NIL .AND. table:LinkedObjField:Calculated .AND. !table:MasterSource == Self .AND. table:MasterSource == table:LinkedObjField:Table:KeyField:LinkedTable
                                table:LinkedObjField:Table:KeyField:DataObj()
                            ENDIF
                        ENDIF
                    ENDIF

                NEXT

            ENDIF

        ELSE
            ::FEof := .T.
            ::FBof := .T.
            ::FFound := .F.
            ::Reset()
        ENDIF

        ::SyncDetailSources()

    ELSE
        //RAISE ERROR "Table not in dsBrowse mode..."
        Result := .F.
    ENDIF

    IF ::allowOnDataChange
        ::OnDataChange()
    ENDIF

RETURN Result

/*
    GetDataBase
    Teo. Mexico 2010
*/
METHOD FUNCTION GetDataBase() CLASS TTable
    IF ::FDataBaseClass = NIL
        RETURN NIL
    ENDIF
RETURN ::hDataBase[ ::FDataBaseClass ]

/*
    GetDbStruct
    Teo. Mexico 2007
*/
METHOD FUNCTION GetDbStruct CLASS TTable
    IF ! HB_HHasKey( ::FInstances[ ::TableClass ], "DbStruct" )
        ::FInstances[ ::TableClass, "DbStruct" ] := ::Alias:DbStruct
    ENDIF
RETURN ::FInstances[ ::TableClass, "DbStruct" ]

/*
    GetDisplayFieldBlock
    Teo. Mexico 2008
*/
METHOD FUNCTION GetDisplayFieldBlock( xField ) CLASS TTable
    LOCAL AField
    LOCAL msgName

    SWITCH ValType( xField )
    CASE 'C'
        AField := ::FieldByName( xField )
        EXIT
    CASE 'O'
        AField := xField
        EXIT
    CASE 'N'
        AField := ::FieldList[ xField ]
        EXIT
    ENDSWITCH

    IF AField == NIL
        RAISE ERROR "Wrong value"
        RETURN NIL
    ENDIF

    msgName := AField:Name

    IF ! AField:IsDerivedFrom("TObjectField")
        RETURN ;
            {|o,...|
                LOCAL odf
                LOCAL AField

                IF HB_HHasKey( o:__FFields, msgName )
                    AField := o:__FFields[ msgName ]
                ELSE
                    AField := o:__FObj:FieldByName( msgName )
                    o:__FFields[ msgName ] := AField
                ENDIF

                IF o:__FSyncFromAlias
                    o:__FObj:SyncRecNo( .T. )
                ENDIF

                odf := o

                WHILE odf:__FObj:LinkedObjField != NIL
                    odf := odf:__FObj:LinkedObjField:Table:GetDisplayFields()
                    odf:__FLastLabel := AField:Label
                ENDDO

                IF o:__FObj:Eof() .OR. o:__FObj:Bof()
                    RETURN AField:EmptyValue
                ENDIF

                RETURN AField:GetAsVariant( ... )

            }

    ENDIF

    RETURN ;
        {|o|
            LOCAL AField

            IF HB_HHasKey( o:__FFields, msgName )
                AField := o:__FFields[ msgName ]
            ELSE
                AField := o:__FObj:FieldByName( msgName )
                o:__FFields[ msgName ] := AField
            ENDIF

            IF o:__FSyncFromAlias
                o:__FObj:SyncRecNo( .T. )
            ENDIF

            RETURN AField:DataObj:GetDisplayFields( NIL )

        }

METHOD FUNCTION GetDisplayFields( syncFromAlias ) CLASS TTable
    LOCAL DisplayFieldsClass
    LOCAL msgName
    LOCAL AField

    IF ::FDisplayFields == NIL

        IF ::FInstances[ ::TableClass, "DisplayFieldsClass" ] == NIL

            DisplayFieldsClass := HBClass():New( ::ClassName + "DisplayFields", { @HBObject() } )

            DisplayFieldsClass:AddData( "__FObj" )
            DisplayFieldsClass:AddData( "__FFields" )
            DisplayFieldsClass:AddData( "__FLastLabel" )
            DisplayFieldsClass:AddData( "__FSyncFromAlias" )

            FOR EACH AField IN ::FFieldList

                IF AField:nameAlias = NIL
                    msgName := AField:Name
                ELSE
                    msgName := AField:nameAlias
                ENDIF

                /* TODO: Check for a duplicate message name */
                IF !Empty( msgName ) //.AND. ! __ObjHasMsg( ef, msgName )

                    DisplayFieldsClass:AddInline( msgName, ::GetDisplayFieldBlock( msgName ) )

                ENDIF

            NEXT

            // Create the MasterSource field access reference
            IF ::FMasterSource != NIL
                DisplayFieldsClass:AddInline( "MasterSource", {|Self| ::__FObj:MasterSource:GetDisplayFields() } )
            ENDIF

            DisplayFieldsClass:Create()

            ::FInstances[ ::TableClass, "DisplayFieldsClass" ] := DisplayFieldsClass

        ENDIF

        ::FDisplayFields := ::FInstances[ ::TableClass, "DisplayFieldsClass" ]:Instance()
        ::FDisplayFields:__FObj := Self
        ::FDisplayFields:__FFields := {=>}
        ::FDisplayFields:__FSyncFromAlias := syncFromAlias == .T.

    ENDIF

RETURN ::FDisplayFields

/*
    GetFieldTypes
    Teo. Mexico 2008
*/
METHOD FUNCTION GetFieldTypes CLASS TTable

    /* obtained from Harbour's src/rdd/workarea.c hb_waCreateFields */

    IF ::FFieldTypes == NIL
        ::FFieldTypes := {=>}
        ::FFieldTypes['C'] := "TStringField"		/* HB_FT_STRING */
        ::FFieldTypes['L'] := "TLogicalField"		/* HB_FT_LOGICAL */
        ::FFieldTypes['D'] := "TDateField"			/* HB_FT_DATE */
        ::FFieldTypes['I'] := "TIntegerField"		/* HB_FT_INTEGER */
        ::FFieldTypes['Y'] := "TNumericField"		/* HB_FT_CURRENCY */
        ::FFieldTypes['2'] := "TIntegerField"		/* HB_FT_INTEGER */
        ::FFieldTypes['4'] := "TIntegerField"		/* HB_FT_INTEGER */
        ::FFieldTypes['N'] := "TNumericField"		/* HB_FT_LONG */
        ::FFieldTypes['F'] := "TNumericField"		/* HB_FT_FLOAT */
        ::FFieldTypes['8'] := "TFloatField"			/* HB_FT_DOUBLE */
        ::FFieldTypes['B'] := "TFloatField"			/* HB_FT_DOUBLE */

        ::FFieldTypes['T'] := "TTimeField"			/* HB_FT_TIME(4) */
        ::FFieldTypes['@'] := "TDateTimeField"		/* HB_FT_TIMESTAMP */
        ::FFieldTypes['='] := "TModTimeField"		/* HB_FT_MODTIME */
        ::FFieldTypes['^'] := "TRowVerField"		/* HB_FT_ROWVER */
        ::FFieldTypes['+'] := "TAutoIncField"		/* HB_FT_AUTOINC */
        ::FFieldTypes['Q'] := "TVarLengthField"		/* HB_FT_VARLENGTH */
        ::FFieldTypes['V'] := "TVarLengthField"		/* HB_FT_VARLENGTH */
        ::FFieldTypes['M'] := "TMemoField"			/* HB_FT_MEMO */
        ::FFieldTypes['P'] := "TImageField"			/* HB_FT_IMAGE */
        ::FFieldTypes['W'] := "TBlobField"			/* HB_FT_BLOB */
        ::FFieldTypes['G'] := "TOleField"			/* HB_FT_OLE */
        ::FFieldTypes['0'] := "TVarLengthField"		/* HB_FT_VARLENGTH (NULLABLE) */
    ENDIF

RETURN ::FFieldTypes

/*
    GetField
    Teo. Mexico 2009
*/
METHOD FUNCTION GetField( fld ) CLASS TTable
    LOCAL AField

    SWITCH ValType( fld )
    CASE 'C'
        AField := ::FieldByName( fld )
        EXIT
    CASE 'O'
        AField := fld
        EXIT
    OTHERWISE
        RAISE ERROR "Unknown field reference..."
    ENDSWITCH

RETURN AField

/*
    GetHasFilter
    Teo. Mexico 2010
*/
METHOD GetHasFilter() CLASS TTable
//RETURN ::filterPrimaryIndexScope .OR. ::FFilter != NIL
RETURN ::FFilter != NIL

/*
    GetInstance
    Teo. Mexico 2008
*/
METHOD FUNCTION GetInstance CLASS TTable
//	 LOCAL instance

//	 IF ::FRDOClient != NIL //.AND. !HB_HHasKey( ::FInstances, ::TableClass )
//		 instance := ::SendToServer()
//		 RETURN instance
//	 ENDIF

    IF HB_HHasKey( ::FInstances, ::TableClass )
        RETURN ::FInstances[ ::TableClass ]
    ENDIF

RETURN NIL

/*
    GetKeyExpression
    Teo. Mexico 2011
*/
METHOD FUNCTION GetKeyExpression() CLASS TTable

    IF ::FPrimaryIndex != NIL
        RETURN ::FPrimaryIndex:KeyExpression
    ENDIF

RETURN ""

/*
    GetKeyField
    Teo. Mexico 2010
*/
METHOD FUNCTION GetKeyField() CLASS TTable
    IF ::FPrimaryIndex != NIL
        RETURN ::FPrimaryIndex:KeyField
    ENDIF
RETURN NIL

/*
    GetKeyVal
    Teo. Mexico 2010
*/
METHOD FUNCTION GetKeyVal( value ) CLASS TTable
    LOCAL fld
    fld := ::GetKeyField()
    IF fld = NIL
        RETURN NIL
    ENDIF
RETURN fld:GetKeyVal( value )

/*
    GetMasterKeyExpression
    Teo. Mexico 2011
*/
METHOD FUNCTION GetMasterKeyExpression() CLASS TTable

    IF ::FPrimaryIndex != NIL
        RETURN ::FPrimaryIndex:MasterKeyExpression
    ENDIF

RETURN ""

/*
    GetMasterKeyField
    Teo. Mexico 2009
*/
METHOD FUNCTION GetMasterKeyField() CLASS TTable
    IF ::FPrimaryIndex != NIL
        RETURN ::FPrimaryIndex:MasterKeyField
    ENDIF
RETURN NIL

/*
    GetMasterSource
    Teo. Mexico 2009
*/
METHOD FUNCTION GetMasterSource() CLASS TTable

    SWITCH ::FMasterSourceType
    CASE rxMasterSourceTypeTTable
        RETURN ::FMasterSource
    CASE rxMasterSourceTypeTField
        RETURN ::FMasterSource:LinkedTable
    CASE rxMasterSourceTypeBlock
        RETURN ::FMasterSource:Eval()
    ENDSWITCH

RETURN NIL

/*
    GetMasterSourceClassName
    Teo. Mexico 2008
*/
METHOD FUNCTION GetMasterSourceClassName() CLASS TTable
    LOCAL Result := ""
    LOCAL className := ::ClassName

    IF ::DataBase = NIL
        ::DataBase := ::InitDataBase()
    ENDIF

    IF HB_HHasKey( ::DataBase:ChildParentList, className )
        Result := ::DataBase:ChildParentList[ className ]
        WHILE HB_HHasKey( ::DataBase:TableList, Result ) .AND. ::DataBase:TableList[ Result, "Virtual" ]
            IF !HB_HHasKey ( ::DataBase:ChildParentList, Result )
                EXIT
            ENDIF
            Result := ::DataBase:ChildParentList[ Result ]
        ENDDO
    ENDIF

RETURN Result

/*
    GetPublishedFieldList
    Teo. Mexico 2007
*/
METHOD FUNCTION GetPublishedFieldList( typeList ) CLASS TTable
    LOCAL Result := {}
    LOCAL AField
    LOCAL itm

    FOR EACH AField IN ::FFieldList
        IF !Empty( AField:Name ) .AND. AField:Published
            IF Empty( typeList )
                AAdd( Result, AField )
            ELSE
                FOR EACH itm IN typeList
                    IF AField:IsDerivedFrom( itm )
                        AAdd( Result, AField )
                    ENDIF
                NEXT
            ENDIF
        ENDIF
    NEXT

    ASort( Result,,, {|x,y| x:ValType < y:ValType .OR. ( x:ValType == y:ValType .AND. x:Name < y:Name ) } )

RETURN Result

/*
    GetPublishedFieldNameList
    Teo. Mexico 2012
*/
METHOD FUNCTION GetPublishedFieldNameList( typeList ) CLASS TTable
    LOCAL result := {}
    LOCAL AField
    LOCAL itm

    FOR EACH AField IN ::FFieldList
        IF !Empty( AField:Name ) .AND. AField:Published
            IF Empty( typeList )
                AAdd( result, AField:Name )
            ELSE
                FOR EACH itm IN typeList
                    IF AField:IsDerivedFrom( itm )
                        AAdd( Result, AField:Name )
                    ENDIF
                NEXT
            ENDIF
        ENDIF
    NEXT

    //ASort( result,,, {|x,y| x:ValType < y:ValType .OR. ( x:ValType == y:ValType .AND. x:Name < y:Name ) } )

RETURN result

/*
    GetTableFileName
    Teo. Mexico 2010
*/
METHOD FUNCTION GetTableFileName() CLASS TTable
    IF Empty( ::FTableFileName )
        IF ::AutoCreate
            FClose( HB_FTempCreateEx( @::FTableFileName, NIL, "t", ".dbf" ) )
            ::FIsTempTable := .T.
        ENDIF
    ENDIF
RETURN ::FTableFileName

/*
    GetValue
    Teo. Mexico 2011
*/
METHOD FUNCTION GetValue CLASS TTable
RETURN ::FBaseKeyField:Value

/*
    ImportField
    Teo. Mexico 2012
*/
METHOD FUNCTION ImportField( fromField, fieldDbName, fieldName ) CLASS TTable
    LOCAL fld

    IF Empty( fieldDbName )
        fieldDbName := fromField:FieldMethod
    ELSEIF Empty( fieldName )
        fieldName := fieldDbName
    ENDIF

    IF Empty( fieldName )
        fieldName := fromField:Name
    ENDIF

    fld :=  __clsInst( fromField:ClassH() )
    
    fld:New( Self )

    fld:Name := fieldName
    fld:FieldMethod := fieldDbName
    
    IF fld:IsDerivedFrom( "TObjectField" )
        fld:ObjClass := fromField:ObjClass
    ENDIF
    
    AAdd( ::FFieldList, fld )

RETURN fld

/*
    IndexByName
    Teo. Mexico 2006
*/
METHOD FUNCTION IndexByName( indexName, curClass ) CLASS TTable
    LOCAL className

    curClass := iif( curClass = NIL, Self, curClass )
    className := curClass:ClassName()

    IF ! className == "TTABLE"
        IF HB_HHasKey( ::FIndexList, className )
            IF HB_HHasKey( ::FIndexList[ className ], indexName )
                RETURN ::FIndexList[ className, indexName ]
            ENDIF
        ENDIF
        RETURN ::IndexByName( indexName, curClass:Super )
    ENDIF

RETURN NIL

/*
    InitTable
    Teo. Mexico 2009
*/
METHOD PROCEDURE InitTable() CLASS TTable

    IF !HB_HHasKey( ::FInstances, ::TableClass )

        ::FInstances[ ::TableClass ] := HB_HSetCaseMatch( { "Initializing" => .T. }, .F. )

    ENDIF

    /*!
    * Make sure that database is open here
    */
    IF ::FAlias == NIL
        ::FAlias := TAlias():New( Self )
    ENDIF

    IF ::FInstances[ ::TableClass, "Initializing" ]

        ::OnClassInitializing()

        ::FInstances[ ::TableClass, "ChildReferenceList" ] := {}

        ::DefineRelations()

        ::FInstances[ ::TableClass, "MasterDetailFieldList" ] := HB_HSetCaseMatch( {=>}, .F. )

        ::DefineMasterDetailFields()

        ::FInstances[ ::TableClass, "DisplayFieldsClass" ] := NIL

        ::FInstances[ ::TableClass, "Initializing" ] := .F.

    ENDIF

RETURN

/*
    Insert
    Teo. Mexico 2006
*/
METHOD FUNCTION Insert() CLASS TTable

    IF !::State = dsBrowse
        ::Error_TableNotInBrowseState()
        RETURN .F.
    ENDIF

    IF ::OnBeforeInsert() .AND. ::AddRec()

        /* To Flush !!! */
        ::Alias:DbSkip( 0 )

        ::SyncDetailSources()

        ::OnAfterInsert()

        RETURN .T.

    ENDIF

RETURN .F.

/*
    InsertRecord
    Teo. Mexico 2007
*/
METHOD PROCEDURE InsertRecord( origin ) CLASS TTable

    IF !::Insert() .OR. !::CopyRecord( origin )
        RETURN
    ENDIF

    ::Post()

RETURN

/*
    InsideScope
    Teo. Mexico 2008
*/
METHOD FUNCTION InsideScope() CLASS TTable

    IF ::Eof() .OR. ::Bof() .OR. ( ::MasterSource != NIL .AND. ::MasterSource:Eof() )
        RETURN .F.
    ENDIF

RETURN ::FIndex = NIL .OR. ::FIndex:InsideScope()

/*
    OnActiveSetKeyVal
    Teo. Mexico 2011
*/
METHOD FUNCTION OnActiveSetKeyVal( value ) CLASS TTable
    IF value == NIL
        RETURN ::FOnActiveSetKeyVal
    ENDIF
    ::FOnActiveSetKeyVal := value
RETURN value

/*
    OnDataChange
    Teo. Mexico 2010
*/
METHOD PROCEDURE OnDataChange() CLASS TTable
    IF ::OnDataChangeBlock != NIL
        ::OnDataChangeBlock:Eval( iif( ::OnDataChangeBlock_Param = NIL, Self, ::OnDataChangeBlock_Param ) )
    ENDIF
RETURN

/*
    Open
    Teo. Mexico 2008
*/
METHOD FUNCTION Open() CLASS TTable
    LOCAL masterSource := ::GetMasterSourceClassName()

    IF ::MasterSource == NIL .AND. !Empty( masterSource )

        RAISE ERROR "Table '" + ::ClassName() + "' needs a MasterSource of type '" + masterSource  + "'..."

    ENDIF

    ::FActive := .T.

    ::SetState( dsBrowse )

    /*
     * Try to sync with MasterSource (if any)
     */
    ::SyncFromMasterSourceFields()
    
    ::allowOnDataChange := .T.

    IF ::Alias != NIL
        ::FHasDeletedOrder := ::Alias:OrdNumber( "__AVAIL" ) > 0
    ENDIF
    
    ::OnDataChange()

    ::OnAfterOpen()

RETURN .T.

/*
    OrdCondSet
    Teo. Mexico 2010
*/
METHOD FUNCTION OrdCondSet( ... ) CLASS TTable
RETURN ::Alias:OrdCondSet( ... )

/*
    OrdCreate
    Teo. Mexico 2010
*/
METHOD PROCEDURE OrdCreate( ... ) CLASS TTable
    LOCAL scopeTop, scopeBottom
    LOCAL masterKeyVal
    LOCAL syncFromAlias := ::DisplayFields:__FSyncFromAlias
    LOCAL oDlg

    DbSelectArea( ::Alias:Name )

    IF !Empty( ::IndexName )
        masterKeyVal := ::Index:MasterKeyVal
        OrdSetFocus( ::IndexName )
        scopeTop := ordScope( 0, RTrim( masterKeyVal + ::Index:ScopeTop() ) )
        scopeBottom := ordScope( 1, masterKeyVal + ::Index:ScopeBottom() )
    ENDIF

    //DbGoTop()

    ::DisplayFields:__FSyncFromAlias := .T.

    CREATE DIALOG oDlg ;
        TITLE "Un momento..." ;
        PARENT ::Frame

    SHOW WINDOW oDlg CENTRE

    ::Alias:OrdCreate( ... )

    IF !Empty( ::IndexName )
        ordSetFocus( ::IndexName )
        ordScope( 0, scopeTop )
        ordScope( 1, scopeBottom )
    ENDIF

    DESTROY oDlg

    ::DisplayFields:__FSyncFromAlias := syncFromAlias

    ordCustom( NIL, NIL, .T. )

RETURN

/*
    Post
    Teo. Mexico 2010
*/
METHOD FUNCTION Post() CLASS TTable
    LOCAL AField
    LOCAL errObj
    LOCAL itm
    LOCAL postOk := .F.
    LOCAL aChangedFields := {}
    LOCAL changed := .F.

    IF AScan( { dsEdit, dsInsert }, ::State ) = 0
        ::Error_Table_Not_In_Edit_or_Insert_mode()
    ENDIF

    BEGIN SEQUENCE WITH ::ErrorBlock

        ::FSubState := dssPosting

        IF ::OnBeforePost()

            IF Len( ::DetailSourceList ) > 0
                FOR EACH itm IN ::DetailSourceList
                    IF AScan( { dsEdit, dsInsert }, itm:State ) > 0
                        itm:Post()
                    ENDIF
                NEXT
            ENDIF

            FOR EACH AField IN ::FieldList

                IF AField:Enabled
                    IF AField:Changed
                        IF AField:OnAfterPostChange != NIL
                            AAdd( aChangedFields, AField )
                        ENDIF
                        changed := .T.
                    ENDIF
                    IF !AField:Validate()
                        RAISE ERROR "Post: Invalid data on Field: <" + ::ClassName + ":" + AField:Name + ">: '" + AField:AsString + "'"
                    ENDIF
                ENDIF

            NEXT

            ::RecUnLock()

            postOk := .T.

        ENDIF

    RECOVER USING errObj

        ::Cancel()

        SHOW ERROR errObj

    ALWAYS

        ::FSubState := dssNone

    END SEQUENCE

    IF postOk
        ::OnAfterPost()
        IF Len( aChangedFields ) > 0
            FOR EACH AField IN aChangedFields
                AField:OnAfterPostChange:Eval( Self )
            NEXT
        ENDIF
        IF changed
            IF __ObjHasMsgAssigned( Self, "OnAfterChange" )
                __ObjSendMsg( Self, "OnAfterChange" )
            ENDIF
        ENDIF
    ENDIF

RETURN postOk

/*
    Process_TableName
    Teo. Mexico 2008
*/
METHOD PROCEDURE Process_TableName( tableName ) CLASS TTable
    LOCAL s, sHostPort

    IF tableName == NIL
        tableName := ::TableFileName
    ELSE
        ::FTableFileName := tableName
    ENDIF

    /*
        Process tableName to check if we need a RDOClient to an RDOServer
    */
    IF Upper( tableName ) = "RDO://"

        s := HB_TokenGet( ::TableFileName, 2, "://" )
        sHostPort := HB_TokenGet( s, 1, "/" )
        ::FTableFileName := SubStr( s, At( "/", s ) + 1 )

        ::FAddress := HB_TokenGet( sHostPort, 1, ":" )
        ::FPort := HB_TokenGet( sHostPort, 2, ":" )

        /*
            Checks if RDO Client is required
        */
        ::FRDOClient := TRDOClient():New( ::FAddress, ::FPort )
        IF !::FRDOClient:Connect()
            ::Error_ConnectToServer_Failed()
            RETURN
        ENDIF

    ENDIF

RETURN

/*
    RawGet4Seek
    Teo. Mexico 2009
*/
METHOD FUNCTION RawGet4Seek( direction, xField, keyVal, index, softSeek ) CLASS TTable
    LOCAL AIndex := ::FindIndex( index )

RETURN AIndex:RawGet4Seek( direction, ::GetField( xField ):FieldReadBlock, keyVal, softSeek )

/*
    RawSeek
    Teo. Mexico 2008
*/
METHOD FUNCTION RawSeek( Value, index ) CLASS TTable
RETURN ::FindIndex( index ):RawSeek( Value )

/*
    RecLock
    Teo. Mexico 2006
*/
METHOD FUNCTION RecLock() CLASS TTable
    LOCAL allowOnDataChange
    LOCAL result

    IF ::FState != dsBrowse
        ::Error_Table_Not_In_Browse_Mode()
        RETURN .F.
    ENDIF

    IF !::OnBeforeLock()
        RETURN .F.
    ENDIF

    IF ::FReadOnly
        wxhAlert( "Table '" + ::ClassName() + "' is marked as READONLY...")
        RETURN .F.
    ENDIF

    IF ::Eof()
        RAISE ERROR "Attempt to lock record at EOF..."
    ENDIF

    IF !::InsideScope .OR. !::Alias:RecLock()
        RETURN .F.
    ENDIF

    allowOnDataChange := ::allowOnDataChange
    ::allowOnDataChange := .F.

    result := ::GetCurrentRecord()

    IF result
        ::SetState( dsEdit )
    ELSE
        ::Alias:RecUnLock()
    ENDIF

    ::allowOnDataChange := allowOnDataChange

RETURN result

/*
    RecUnLock
    Teo. Mexico 2006
*/
METHOD FUNCTION RecUnLock() CLASS TTable
    LOCAL Result
    IF ( Result := ::Alias:RecUnLock() )
        ::SetState( dsBrowse )
        ::OnDataChange()
    ENDIF
RETURN Result

/*
    Refresh
    Teo. Mexico 2007
*/
METHOD PROCEDURE Refresh CLASS TTable
    IF ::FRecNo = ::Alias:RecNo
        RETURN
    ENDIF
    ::GetCurrentRecord()
RETURN

/*
    Reset
    Teo. Mexico 2006
*/
METHOD PROCEDURE Reset() CLASS TTable
    LOCAL AField

    ::FUnderReset := .T.

    FOR EACH AField IN ::FFieldList

        IF AField:FieldMethodType = "C" .AND. AField:Enabled
            IF AField:RawDefaultValue != NIL .OR. !AField:IsMasterFieldComponent
                AField:Reset()
            ENDIF
        ENDIF

    NEXT

    ::FUnderReset := .F.

RETURN

/*
    SetBaseKeyField
    Teo. Mexico 2011
*/
METHOD PROCEDURE SetBaseKeyField( baseKeyField ) CLASS TTable
    IF ::FBaseKeyField = NIL
        ::FBaseKeyField := baseKeyField
    ENDIF
RETURN

/*
    SetDataBase
    Teo. Mexico 2010
*/
METHOD PROCEDURE SetDataBase( dataBase ) CLASS TTable
    IF dataBase = NIL
        ::FDataBaseClass := NIL
    ELSE
        ::FDataBaseClass := dataBase:ClassName
        IF !HB_HHasKey( ::hDataBase, ::FDataBaseClass )
            ::hDataBase[ dataBase:ClassName ] := dataBase
        ENDIF
    ENDIF
RETURN

/*
    SetIndex
    Teo. Mexico 2010
*/
METHOD PROCEDURE SetIndex( index ) CLASS TTable
    IF !::FIndex == index
        ::FIndex := index
    ENDIF
RETURN

/*
    SetIndexName
    Teo. Mexico 2007
*/
METHOD PROCEDURE SetIndexName( indexName ) CLASS TTable
    LOCAL index

    IF !Empty( indexName )

        index := ::IndexByName( indexName )

        IF index != NIL
            ::Index := index
            RETURN
        ENDIF

        RAISE ERROR	 "<" + ::ClassName + ">: Index name '" + indexName + "' doesn't exist..."

    ENDIF

RETURN

/*
    SetKeyVal
    Teo. Mexico 2010
*/
METHOD FUNCTION SetKeyVal( keyVal ) CLASS TTable
    ::GetKeyField():SetKeyVal( keyVal )
RETURN Self

/*
    SetMasterSource
    Teo. Mexico 2007
*/
METHOD PROCEDURE SetMasterSource( masterSource ) CLASS TTable

    IF ::FMasterSource == masterSource
        RETURN
    ENDIF

    ::FMasterSource := masterSource

    SWITCH ValType( masterSource )
    CASE 'O'
        IF masterSource:IsDerivedFrom( "TTable" )
            ::FMasterSourceType := rxMasterSourceTypeTTable
        ELSEIF masterSource:IsDerivedFrom( "TObjectField" )
            ::FMasterSourceType := rxMasterSourceTypeTField
        ELSEIF masterSource:IsDerivedFrom( "TField" )
            RAISE ERROR "need to specify TField generic syncing..."
        ELSE
            RAISE ERROR "Invalid object in assigning MasterSource..."
        ENDIF
        EXIT
    CASE 'B'
        ::FMasterSourceType := rxMasterSourceTypeBlock
        EXIT
    CASE 'U'
        ::FMasterSourceType := rxMasterSourceTypeNone
        RETURN
    OTHERWISE
        RAISE ERROR "Invalid type in assigning MasterSource..."
    ENDSWITCH

    /*!
     * Check for a valid GetMasterSourceClassName (if any)
     */
    IF !Empty( ::GetMasterSourceClassName() )
        //IF !::MasterSource:IsDerivedFrom( ::GetMasterSourceClassName ) .AND. !::DataBase:TableIsChildOf( ::GetMasterSourceClassName, ::MasterSource:ClassName )
        //IF ! Upper( ::GetMasterSourceClassName ) == ::MasterSource:ClassName
        IF ! ::MasterSource:IsDerivedFrom( ::GetMasterSourceClassName() )
            RAISE ERROR "Table <" + ::TableClass + "> Invalid MasterSource Class Name: " + ::MasterSource:ClassName + ";Expected class type: <" + ::GetMasterSourceClassName() + ">"
        ENDIF
    ELSE
        RAISE ERROR "Table '" + ::ClassName() + "' has not declared the MasterSource '" + ::MasterSource:ClassName() + "' in the DataBase structure..."
    ENDIF

    /*
     * Check if another Self is already in the MasterSource DetailSourceList
     * and RAISE ERROR if another Self is trying to break the previous link
     */
    IF HB_HHasKey( ::MasterSource:DetailSourceList, Self:ObjectH )
        RAISE ERROR "Cannot re-assign DetailSourceList:<" + ::ClassName +">"
    ENDIF

    ::MasterSource:DetailSourceList[ Self:ObjectH ] := Self

    ::SyncFromMasterSourceFields()

RETURN

/*
    SetPrimaryIndex
    Teo. Mexico 2010
*/
METHOD PROCEDURE SetPrimaryIndex( primaryIndex ) CLASS TTable
    ::FPrimaryIndex := primaryIndex
RETURN

/*
    SetPrimaryIndexList
    Teo. Mexico 2011
*/
METHOD PROCEDURE SetPrimaryIndexList( clsName, name ) CLASS TTable
    ::FPrimaryIndexList[ clsName ] := name
RETURN

/*
    SetReadOnly
    Teo. Mexico 2009
*/
METHOD PROCEDURE SetReadOnly( readOnly ) CLASS TTable
    IF ! HB_IsLogical( readOnly )
        RAISE ERROR "Invalid value on SetReadOnly..."
    ENDIF
    IF ::FState = dsBrowse
        ::FReadOnly := readOnly
    ENDIF
RETURN

/*
    SetState
    Teo. Mexico 2009
*/
METHOD PROCEDURE SetState( state ) CLASS TTable
    LOCAL oldState

    oldState := ::FState
    ::FState := state

    IF state = dsEdit .OR. state = dsInsert
        ::FUndoList := HB_HSetCaseMatch( {=>}, .F. )
    ENDIF

    ::OnStateChange( oldState )

RETURN

/*
    SetValue
    Teo. Mexico 2011
*/
METHOD PROCEDURE SetValue( value ) CLASS TTable
    ::FBaseKeyField:Value := value
RETURN

/*
    SkipBrowse : BROWSE skipblock
    Teo. Mexico 2008
*/
METHOD FUNCTION SkipBrowse( n ) CLASS TTable
    LOCAL num_skipped := 0
    LOCAL recNo

    IF n = 0
        ::DbSkip( 0 )
        RETURN 0
    ENDIF

    IF n > 0
        WHILE !::Eof() .AND. num_skipped < n
            recNo := ::RecNo
            ::DbSkip( 1 )
            IF ::Eof()
                ::DbGoTo( recNo )
                EXIT
            ENDIF
            num_skipped++
        ENDDO
    ELSE
        WHILE !::Bof() .AND. num_skipped > n
            recNo := ::RecNo
            ::DbSkip( -1 )
            IF ::Bof()
                ::DbGoTo( recNo )
                EXIT
            ENDIF
            num_skipped--
        ENDDO
    ENDIF

RETURN num_skipped

/*
    SkipFilter
    Teo. Mexico 2010
*/
METHOD FUNCTION SkipFilter( n, index ) CLASS TTable
    LOCAL i
    LOCAL tagName
    LOCAL o
    LOCAL alias

    IF n = NIL
        n := 1
    ENDIF

    IF n > 0
        i := 1
    ELSEIF n < 0
        i := -1
    ELSE
        i := 0
    ENDIF

    n := Abs( n )

    IF index = NIL
        tagName := NIL
        o := Self
        alias := ::Alias
    ELSE
        tagName := index:TagName
        o := index
        alias := index:GetAlias()
    ENDIF

    WHILE .T.
        alias:DbSkip( i, tagName )
        IF ! o:GetCurrentRecord()
            RETURN .F.
        ENDIF
        IF ::FilterEval( index )
            --n
        ENDIF
        IF n <= 0
            EXIT
        ENDIF
    ENDDO

RETURN .T.

/*
    StatePop
    Teo. Mexico 2010
*/
METHOD PROCEDURE StatePop() CLASS TTable
    LOCAL cloneData
    LOCAL tbl

    FOR EACH cloneData IN ::tableState[ ::tableStateLen ]["CloneData"]
        ::FFieldList[ cloneData:__enumIndex ]:CloneData := cloneData
    NEXT

    ::FRecNo           := ::tableState[ ::tableStateLen ]["RecNo"]
    ::FBof             := ::tableState[ ::tableStateLen ]["Bof"]
    ::FEof             := ::tableState[ ::tableStateLen ]["Eof"]
    ::FFound           := ::tableState[ ::tableStateLen ]["Found"]
    ::FState           := ::tableState[ ::tableStateLen ]["State"]
    ::IndexName        := ::tableState[ ::tableStateLen ]["IndexName"]

    FOR EACH tbl IN ::DetailSourceList
        IF HB_HHasKey( ::tableState[ ::tableStateLen ]["DetailSourceList"], tbl:ObjectH )
            tbl:StatePop()
        ENDIF
    NEXT

    --::tableStateLen

    ::Alias:Pop()

RETURN

/*
    StatePush
    Teo. Mexico 2010
*/
METHOD PROCEDURE StatePush() CLASS TTable
    LOCAL fld
    LOCAL aCloneData := {}
    LOCAL hDSL := {=>}
    LOCAL tbl

    IF Len( ::tableState ) < ++::tableStateLen
        AAdd( ::tableState, {=>} )
    ENDIF

    FOR EACH fld IN ::FFieldList
        AAdd( aCloneData, fld:CloneData )
    NEXT

    ::tableState[ ::tableStateLen ]["CloneData"]        := aCloneData
    ::tableState[ ::tableStateLen ]["RecNo"]            := ::FRecNo
    ::tableState[ ::tableStateLen ]["Bof"]              := ::FBof
    ::tableState[ ::tableStateLen ]["Eof"]              := ::FEof
    ::tableState[ ::tableStateLen ]["Found"]            := ::FFound
    ::tableState[ ::tableStateLen ]["State"]            := ::FState
    ::tableState[ ::tableStateLen ]["IndexName"]        := ::IndexName
    ::tableState[ ::tableStateLen ]["DetailSourceList"] := hDSL

    FOR EACH tbl IN ::DetailSourceList
        hDSL[ tbl:ObjectH ] := NIL
        tbl:StatePush()
    NEXT

    ::FState := dsBrowse

    ::Alias:Push()

RETURN

/*
    SyncDetailSources
    Teo. Mexico 2007
*/
METHOD PROCEDURE SyncDetailSources( sender ) CLASS TTable
    LOCAL itm

    IF !Empty( ::DetailSourceList )
        FOR EACH itm IN ::DetailSourceList
            IF sender == NIL .OR. !sender == itm
                itm:SyncFromMasterSourceFields()
            ENDIF
        NEXT
    ENDIF

RETURN

/*
    SyncFromMasterSourceFields
    Teo. Mexico 2007
*/
METHOD PROCEDURE SyncFromMasterSourceFields() CLASS TTable

    IF ::FActive

        IF ::MasterSource != NIL

            IF ::MasterSource:Active

                ::OnSyncFromMasterSource()

                IF !::MasterSource:Eof() .AND. ::Alias != NIL

                    /* TField:Reset does the job */
                    IF ::MasterKeyField != NIL
                        IF ! ::MasterKeyField:Reset()
                            // raise error
                        ENDIF
                    ENDIF

                    IF ::InsideScope()
                        ::GetCurrentRecord()
                    ELSE
                        ::DbGoTop()
                    ENDIF

                ELSE

                    ::FEof := .T.
                    ::FBof := .T.
                    ::FFound := .F.

                    ::Reset()

                    ::SyncDetailSources()

                    IF ::allowOnDataChange
                        ::OnDataChange()
                    ENDIF

                ENDIF

            ENDIF

        ELSE

            ::GetCurrentRecord()

        ENDIF

    ENDIF

RETURN

/*
    SyncRecNo
    Teo. Mexico 2007
*/
METHOD PROCEDURE SyncRecNo( fromAlias ) CLASS TTable
    IF fromAlias == .T.
        ::Alias:SyncFromAlias()
    ELSE
        ::Alias:SyncFromRecNo()
    ENDIF
    IF ::FRecNo = ::Alias:RecNo
        RETURN
    ENDIF
    ::GetCurrentRecord()
RETURN

/*
    Validate
    Teo. Mexico 2009
*/
METHOD FUNCTION Validate( showAlert ) CLASS TTable
    LOCAL AField

    FOR EACH AField IN ::FFieldList
        IF AField:Enabled .AND. !AField:Validate( showAlert )
            RETURN .F.
        ENDIF
    NEXT

RETURN .T.

/*
    End Class TTable
*/
