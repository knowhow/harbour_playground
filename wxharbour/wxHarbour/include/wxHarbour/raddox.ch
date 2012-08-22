/*
 * $Id: raddox.ch 786 2011-11-28 16:46:31Z tfonrouge $
 */

/*
    Arelds.ch
    Teo. Mexico 2008
*/

#ifndef _RADDOX_H_
#define _RADDOX_H_

#include "rdodefs.h"

#define dsInactive  0
#define dsBrowse    1
#define dsInsert    2
#define dsEdit      4

#define dssNone     0
#define dssAdding   1
#define dssPosting  2

#define ftBase      0
#define ftObject    1

/* Events for TTable */
#xtranslate EVENT ONAFTEROPEN => METHOD OnAfterOpen()
#xtranslate EVENT ONAFTEROPEN CLASS <className> => METHOD PROCEDURE OnAfterOpen() CLASS <className>

#xtranslate EVENT ONAFTERINSERT => METHOD OnAfterInsert()
#xtranslate EVENT ONAFTERINSERT CLASS <className> => METHOD PROCEDURE OnAfterInsert() CLASS <className>

/* Events for TField's */
#xtranslate EVENT ONBEFORECHANGE FIELD <!name!> ;
    => ;
    METHOD OnBeforeChange_Field_<name>( field_<name>, value )

#xtranslate DEFINE RELATIONS ;
    => ;
    METHOD DefineRelations()

#xtranslate BEGIN RELATIONS CLASS <className> ;
    => ;
    METHOD PROCEDURE DefineRelations() CLASS <className>

#xtranslate END RELATIONS CLASS ;
    => ;
    RETURN

#xtranslate ADD TABLE <tableName> [ <vt: VIRTUAL> ] [ INDEX <indexName> ] [ <auto: AUTODELETE> ] ;
            => ;
            ::cmdAddTable( <tableName>, [ <indexName> ], <.vt.>, <.auto.> )

#xtranslate DEFINE CHILD ;
            => ;
            ::cmdDefineChild()

#xtranslate END CHILD ;
            => ;
            ::cmdEndChild()

#xtranslate ADD TABLE <parentTableName> CHILD <childTableName> [ INDEX <indexName> ];
            => ;
            ::AddParentChild( <parentTableName>, <childTableName>, [ <indexName> ] )

/* To REQUIRE SIZE in TStringField */
#xtranslate ADD [<clauses0,...>] STRING FIELD <xFieldMethod> [<clauses1,...>] SIZE <nsize> [<clauses2,...>] ;
                        => ;
                        ADD [<clauses0>] _STRING FIELD <xFieldMethod> [<clauses1>] SIZE <nsize> [<clauses2>]
#xtranslate T_StringField => TStringField

/* To REQUIRE LEN DEC in TNumericField */
#xtranslate ADD [<clauses0,...>] NUMERIC FIELD <xFieldMethod> [<clauses1,...>] LEN <nLen> DEC <nDec> [<clauses2,...>] ;
                        => ;
                        ADD [<clauses0>] _NUMERIC FIELD <xFieldMethod> [<clauses1>] LEN <nLen> DEC <nDec> [<clauses2>]
#xtranslate T_NumericField => TNumericField

/* To REQUIRE CLASS in TObjectField */
#xtranslate ADD [<clauses0,...>] OBJECT FIELD <xFieldMethod> [<clauses1,...>] CLASS <objClass> [<clauses2,...>] ;
                        => ;
                        ADD [<clauses0>] _OBJECT FIELD <xFieldMethod> [<clauses1>] CLASS <objClass> [<clauses2>]
#xtranslate T_ObjectField => TObjectField

#xtranslate ADD [<calc: CALCULATED>] <type: _STRING, MEMO, _NUMERIC, FLOAT, INTEGER, LOGICAL, DATE, DATETIME, MODTIME, _OBJECT, VARIANT> FIELD [<xFieldMethod>] ;
                        [ NAME <cName> ] ;
                        [ LABEL <label> ] ;
                        [ <ro: READONLY> ] ;
                        [ DEFAULT <xDefault> ] ;
                        [ READ <readblock,...> ] ;
                        [ WRITE <writeblock,...> ] ;
                        [ <rq: REQUIRED> ] ;
                        [ GROUP <cGroup> ] ;
                        [ DESCRIPTION <cDesc> ] ;
                        [ PICKLIST <pickList> ] ;
                        [ SIZE <nSize> ] ;
                        [ LEN <nLen> ] ;
                        [ DEC <nDec> ] ;
                        [ PICTURE <pict> ] ;
                        [ <pv: PRIVATE> ] ;
                        [ INCREMENT <incrementBlock> ] ;
                        [ MASTERSOURCE <linkedTableMasterSource> ] ;
                        [ CLASS <objClass> ] ;
                        [ ON GETTEXT <bOnGetText> ] ;
                        [ ON SETTEXT <bOnSetText> ] ;
                        [ ON SETVALUE <bOnSetValue> ] ;
                        [ ON VALIDATE <bOnValidate> [ WARN <warnMsg> ] ] ;
                        [ ON SEARCH <bOnSearch> ] ;
                        [ ON AFTER CHANGE <bOnAfterChange> ] ;
                        [ ON AFTER POST CHANGE <bOnAfterPostChange> ] ;
                        [ ON DATA CHANGE <bOnDataChange> ] ;
                        [ VALIDVALUES [<vvl: LABEL>] <validValues> ] ;
                        [ USING <usingField> ] ;
                        [ <ruf: REUSEFIELD> ] ;
                        [ ENABLED <enabled> ] ;
                        [ EDITABLE <editable> ] ;
                        [ INDEXEXPRESSION <indexExp> ] ;
                     => ;
                        WITH OBJECT T<type>Field():New( Self, ::curClassField ) ;;
                            [ :Name := <cName> ] ;;
                            [ :Label := <label> ] ;;
                            [ :ReadOnly := <.ro.> ] ;;
                            [ :ReUseField := <.ruf.> ] ;;
                            [ :ObjClass := <objClass> ] ;;
                            [ :Size := <nSize> ] ;;
                            [ :SetFieldMethod( <xFieldMethod>, <.calc.> ) ] ;;
                            [ :ReadBlock := {|| <readblock> } ] ;;
                            [ :WriteBlock := {|Value| <writeblock> } ] ;;
                            [ :DefaultValue := <xDefault> ] ;;
                            [ :Required := <.rq.> ] ;;
                            [ :Group := <cGroup> ] ;;
                            [ :Description := <cDesc> ] ;;
                            [ :PickList := <pickList> ] ;;
                            [ :DBS_LEN := <nLen> ] ;;
                            [ :DBS_DEC := <nDec> ] ;;
                            [ :Picture := <pict> ] ;;
                            [ :Published := !<.pv.> ] ;;
                            [ :IncrementBlock := <incrementBlock> ] ;;
                            [ :LinkedTableMasterSource := <linkedTableMasterSource> ] ;;
                            [ :OnGetText := {|field,Text| <bOnGetText> } ] ;;
                            [ :OnSetText := {|field,Text| <bOnSetText> } ] ;;
                            [ :OnSetValue := {|field,Value| <bOnSetValue> } ] ;;
                            [ :OnValidate := <bOnValidate> ] ;;
                            [ :OnValidateWarn := <warnMsg> ] ;;
                            [ :OnSearch := <bOnSearch> ] ;;
                            [ :OnAfterChange := <bOnAfterChange> ] ;;
                            [ :OnAfterPostChange := <bOnAfterPostChange> ] ;;
                            [ :OnDataChange := <bOnDataChange> ] ;;
                            [ :SetValidValues( <validValues>, <.vvl.> ) ] ;;
                            [ :UsingField := <usingField> ] ;;
                            [ :Enabled := <enabled> ] ;;
                            [ :Editable := <editable> ] ;;
                            [ :SetIndexExpression( <indexExp> ) ] ;;
                            :AddFieldMessage() ;;
                            :ValidateFieldInfo() ;;
                        ENDWITH
                        
                        
#xtranslate ADD ALIAS FIELD <aliasFldName> FROM <fld> ;
            => ;
            ::AddFieldAlias( <aliasFldName>, <fld> )

#xtranslate DEFINE MASTERDETAIL FIELDS => METHOD DefineMasterDetailFields

#xtranslate DEFINE FIELDS ;
    => ;
    DATA curClassField HIDDEN ;;
    METHOD __DefineFields()
#xtranslate DEFINE INDEXES ;
    => ;
    DATA curClassIndex HIDDEN ;;
    METHOD __DefineIndexes()

#xtranslate BEGIN FIELDS CLASS <className>;
                        => ;
                        METHOD PROCEDURE __DefineFields() CLASS <className> ;;
                        ::curClassField := <(className)> ;;
                        Super:__DefineFields() 

#xtranslate END FIELDS CLASS ;
                        => ;
                        RETURN

#xtranslate BEGIN INDEXES CLASS <className> ;
                        => ;
            METHOD PROCEDURE __DefineIndexes() CLASS <className> ;;
            ::curClassIndex := <(className)> ;;
            Super:__DefineIndexes() ;;

#xtranslate END INDEXES CLASS ;
                        => ;
            RETURN
            
#xtranslate BEGIN MASTERDETAIL FIELDS CLASS <className> => ;
                        METHOD PROCEDURE DefineMasterDetailFields CLASS <className>
#xtranslate ADD MASTER <cMaster> DETAIL <cDetail> => ;
                        ::MasterDetailFieldList\[ <cMaster> \] := <cDetail>
#xtranslate END MASTERDETAIL FIELDS => ;
                        RETURN

#xtranslate CALCFIELD <clcField> => METHOD CalcField_<clcField>
#xtranslate CALCFIELD <clcField> CLASS <className> ;
    => ;
    METHOD FUNCTION CalcField_<clcField> CLASS <className>
#xtranslate CALCFIELD <clcField>( [<params,...>] ) CLASS <className> ;
    => ;
    METHOD FUNCTION CalcField_<clcField>( [<params>] ) CLASS <className>

/* TODO: Implement this, needs to use a index declared in ancestor class
#xtranslate DEFINE PRIMARY INDEX <cName> ;
            => ;
            TIndex():New( Self, <cName>, "PRIMARY" )
*/

#xtranslate DEFINE <type: PRIMARY,SECONDARY> INDEX [TAG] <tagName> [NAME <name>] ;
                        [ MASTERKEYFIELD <cMasterKeyField> ] ;
                        [ KEYFIELD <cKeyField> ] ;
                        [ FOR <ForKey> ] ;
                        [ <ncs: NO_CASE_SENSITIVE> ] ;
                        [ <de: DESCENDING> ] ;
                        [ <cu: CUSTOM> ] ;
                        [ <un: UNIQUE> ] ;
                        [ <ai: AUTOINCREMENT> ] ;
                        [ <tm: TEMPORARY> ] ;
                        [ USEINDEX <useIndex> ] ;
                        [ <acceptEmptyUnique: ACCEPT_EMPTY_UNIQUE> ] ;
                        => ;
                        WITH OBJECT TIndex():New( Self , <tagName>, [<name>], <"type">, ::curClassIndex ) ;;
                                :AddIndex( [<cMasterKeyField>], [<.ai.>], [<.un.>], [<cKeyField>], [<ForKey>], !<.ncs.>, [<.de.>], [<.acceptEmptyUnique.>], [<useIndex>], [<.tm.>], [<.cu.>] ) ;;
                        ENDWITH
                        
#xtranslate DEFINE EXTERNAL INDEX <name> WITH <table> GET_RECNO <getRecNo> SET_RECNO <setRecNo> ;
    => ;
    ::AssociateTableIndex( <table>, <name>, <getRecNo>, <setRecNo> )

#xtranslate CREATE [<custom: CUSTOM>] INDEX ON <expKey> TAG <ordName> ;
    [BAG <bagName>] ;
    [FOR <forKey>] ;
    [WHILE <whileBlk>] ;
    [<unique: UNIQUE>] ;
    [EVAL <evalBlk>] ;
    [EACH <intVal>] ;
    [<descend: DESCENDING>] ;
    [<additive: ADDITIVE>] ;
    [<current: USECURRENT>] ;
    [<temporary: TEMPORARY>] ;
    => ;
    OrdCondSet( ;
        <(forKey)>, ;
        iif(<.forKey.>, <{forKey}>, NIL ), ;
        NIL, ;
        <{whileBlk}>, ;
        <{evalBlk}>, ;
        <intVal>, ;
        NIL, ;
        NIL, ;
        NIL, ;
        NIL, ;
        <.descend.>, ;
        NIL, ;
        <.additive.>, ;
        <.current.>, ;
        <.custom.>, ;
        NIL, ;
        NIL, ;
        <.temporary.> ) ;;
    OrdCreate( [<bagName>], <ordName>, <expKey>, <expKey>, <.unique.> )

#endif
