/*
 * $Id: TDatabase.prg 637 2010-06-26 15:56:06Z tfonrouge $
 * TDataBase
 */

STATIC aDBRelationCommands

#include "hbclass.ch"
#include "property.ch"
#include "raddox.ch"
#include "xerror.ch"

/*
    TDataBase
    Teo. Mexico 2008
*/
CLASS TDataBase FROM WXHBaseClass
PRIVATE:
    DATA FName INIT ""
    DATA FParentChildList INIT HB_HSetCaseMatch( {=>}, .F. )
    DATA FChildParentList INIT HB_HSetCaseMatch( {=>}, .F. )
    DATA FTableList	INIT HB_HSetCaseMatch( {=>}, .F. )
    DATA cmdLevel     INIT { NIL }
    METHOD SetName( name ) INLINE ::FName := name
PROTECTED:
    DATA FDirectory INIT ""
    METHOD DefineRelations VIRTUAL
    METHOD SetDirectory( directory ) INLINE ::FDirectory := directory
PUBLIC:
    DATA Driver    INIT "DBFCDX"
    DATA OpenBlock
    CONSTRUCTOR New( databaseName )
    METHOD AddParentChild( parentTableName, childTableName, indexName, virtual )

    METHOD cmdAddTable( tableName, indexName, virtual )
    METHOD cmdDefineChild()
    METHOD cmdEndChild()

    METHOD GetParentChildList( tableName, Result )
    METHOD TableIsChildOf( table, fromTable )

    PROPERTY ChildParentList READ FChildParentList
    PROPERTY Directory READ FDirectory WRITE SetDirectory
    PROPERTY ParentChildList READ FParentChildList
    PROPERTY TableList	   READ FTableList
PUBLISHED:
    PROPERTY Name READ FName WRITE SetName
ENDCLASS

/*
    New
    Teo. Mexico 2008
*/
METHOD New( databaseName ) CLASS TDataBase
    IF databaseName == NIL
        ::FName := ::ClassName
    ELSE
        ::FName := databaseName
    ENDIF
    ::DefineRelations()
RETURN Self

/*
    AddParentChild
    Teo. Mexico 2008
*/
METHOD AddParentChild( parentTableName, childTableName, indexName, virtual ) CLASS TDataBase

    IF ! HB_HHasKey( ::FParentChildList, parentTableName )
        ::FParentChildList[ parentTableName ] := {}
    ENDIF

    IF HB_HHasKey( ::FTableList, childTableName )
        ::Error_Table_already_defined()
    ENDIF

    ::FTableList[ childTableName ] := HB_HSetCaseMatch( {=>}, .F. )
    ::FTableList[ childTableName, "IndexName" ] := indexName
    ::FTableList[ childTableName, "Virtual"   ] := iif( virtual == NIL, .F., virtual )

    AAdd( ::FParentChildList[ parentTableName ], Upper( childTableName ) )

    ::FChildParentList[ childTableName ] := parentTableName

RETURN Self

/*
    cmdAddTable
    Teo. Mexico 2008
*/
METHOD PROCEDURE cmdAddTable( tableName, indexName, virtual ) CLASS TDataBase

    ::cmdLevel[ Len( ::cmdLevel ) ] := { tableName, indexName, virtual }

    IF Len( ::cmdLevel ) > 1
        ::AddParentChild( ::cmdLevel[ Len( ::cmdLevel ) - 1, 1 ], tableName, indexName, virtual )
    ENDIF

RETURN

/*
    cmdDefineChild
    Teo. Mexico 2008
*/
METHOD PROCEDURE cmdDefineChild() CLASS TDataBase
    AAdd( ::cmdLevel, { NIL } )
RETURN

/*
    cmdEndChild
    Teo. Mexico 2008
*/
METHOD PROCEDURE cmdEndChild() CLASS TDataBase
    ASize( ::cmdLevel, Len( ::cmdLevel ) - 1 )
RETURN

/*
    GetParentChildList
    Exclude VIRTUAL Tables
    Teo. Mexico 2008
*/
METHOD FUNCTION GetParentChildList( tableName, Result ) CLASS TDataBase
    LOCAL childTableName

    IF Result == NIL
        Result := {}
        /* If Table is VIRTUAL then search for childs in next child level
             Parent tables without parent aren't in the TableList
        */
        IF HB_HHasKey( ::FTableList, tableName ) .AND. ::FTableList[ tableName, "Virtual" ]
            IF HB_HHasKey( ::FParentChildList, tableName )
                FOR EACH childTableName IN ::FParentChildList[ tableName ]
                    ::GetParentChildList( childTableName, Result )
                NEXT
            ENDIF
            RETURN Result
        ENDIF
    ENDIF

    IF HB_HHasKey( ::FParentChildList, tableName )
        FOR EACH childTableName IN ::FParentChildList[ tableName ]
            IF ::FTableList[ childTableName, "Virtual" ]
                IF HB_HHasKey( ::FParentChildList, childTableName )
                    ::GetParentChildList( childTableName, Result )
                ENDIF
            ELSE
                AAdd( Result, childTableName )
            ENDIF
        NEXT
    ENDIF

RETURN Result

/*
    TableIsChildOf
    Teo. Mexico 2008
*/
METHOD FUNCTION TableIsChildOf( table, fromTable ) CLASS TDataBase
    LOCAL Result

    Result := HB_HHasKey( ::FParentChildList, fromTable ) .AND. AScan( ::FParentChildList[ fromTable ], {|e| e == Upper( table ) } ) > 0

RETURN Result

/*
    EndClass TDataBase
*/
