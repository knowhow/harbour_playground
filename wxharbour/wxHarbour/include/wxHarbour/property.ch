/*
 * $Id: property.ch 648 2010-10-01 20:10:37Z tfonrouge $
 */

/*
    PROPERTY
    Teo Mexico 2006
*/

#ifndef _PROPERTY_H_
#define _PROPERTY_H_

#xcommand PRIVATE: => HIDDEN:
#xcommand PUBLIC: => EXPORTED:
//#xcommand PUBLISHED: => nScope := HB_BitOr( HB_OO_CLSTP_EXPORTED, HB_OO_CLSTP_PERSIST ) ; HB_SYMBOL_UNUSED( nScope )
#xcommand PUBLISHED: => PUBLIC:

// With INDEX
// With READ
// With WRITE
#xcommand PROPERTY <name> [AS <astype>] INDEX <i> [READ <rm>] [WRITE <wm>] ;
                    => ;
                    METHOD <name> INLINE ::<rm>( <i> ) ;;
                    METHOD _<name>( xNewVal ) INLINE ::<wm>( <i>, xNewVal )

// With INDEX
// With READ
// Without WRITE
#xcommand PROPERTY <name> [AS <astype>] INDEX <i> [READ <rm>] ;
                    => ;
                    METHOD <name> INLINE ::<rm>( <i> )

// With INDEX
// Without READ
// With WRITE
#xcommand PROPERTY <name> [AS <astype>] INDEX <i> [WRITE <wm>] ;
                    => ;
                    METHOD _<name>( xNewVal ) INLINE ::<wm>( <i>, xNewVal )

// Without INDEX
// With READ
// With WRITE
#xcommand PROPERTY <name> [AS <astype>] [READ <rm>] [WRITE <wm>] ;
                    [<scope: EXPORTED, EXPORT, VISIBLE, PUBLIC, PROTECTED, HIDDEN, PRIVATE, READONLY, RO, PUBLISHED >] ;
                    => ;
                    METHOD <name> INLINE ::<rm> [<scope>] ;;
                    METHOD _<name>( xNewVal ) INLINE ::<wm>( xNewVal ) [<scope>]

// Without INDEX
// With READ
// Without WRITE
#xcommand PROPERTY <name> [AS <astype>] [READ <rm>] ;
                    => ;
                    METHOD <name> INLINE ::<rm>

// Without INDEX
// Without READ
// With WRITE
#xcommand PROPERTY <name> [AS <astype>] [WRITE <wm>] ;
                    => ;
                    METHOD _<name>( xNewVal ) INLINE ::<wm>( xNewVal )
                    //MESSAGE _<name>( xNewVal ) METHOD <wm>( xNewVal )

// Without INDEX
// Without READ
// Without WRITE
#xcommand PROPERTY <name> [AS <astype>] ;
                    => ;
                    METHOD <name> INLINE Super:<name> ;;
                    METHOD _<name> INLINE Super:_<name>

#xcommand PROPERTY <name> DEFAULT <value> ;
                    => ;
                    DATA F<name> INIT <value> PROTECTED


#xcommand PROCEDURE <ProcedureNameParams> CLASS <className> => ERROR

// Simple VAR varname TO object
//#xcommand VAR <DataName> TO <oObject> => VAR <DataName> IS <DataName> TO <oObject>
#xcommand DATA <DataName> IS <OtherName> => VAR <DataName> IS <OtherName>
#xcommand DATA <DataName> IS <OtherName> TO <oObject> => VAR <DataName> IS <OtherName> TO <oObject>
#xcommand DATA <DataName> TO <oObject> => VAR <DataName> IS <DataName> TO <oObject>

#xcommand DEFAULT <uVar1> := <uVal1> ;
                                    [, <uVarN> := <uValN> ] => ;
                                         <uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
                                     [ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]

#xcommand EXTEND OBJECT <Obj> WITH MESSAGE <Msg> INLINE <code,...> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
    __clsAddMsg( <Obj>:ClassH, <Msg>, {|Self| <code> }, HB_OO_MSG_INLINE, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

#xcommand EXTEND OBJECT <Obj> WITH MESSAGE <Msg>( <params,...> ) INLINE <code,...> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
    __clsAddMsg( <Obj>:ClassH , "_"+<Msg>, {|Self, <params>| <code> }, HB_OO_MSG_INLINE, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

#xcommand EXTEND OBJECT <Obj> WITH MESSAGE <Msg> BLOCK <codeBlock> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
    __clsAddMsg( <Obj>:ClassH, <Msg>, <codeBlock>, HB_OO_MSG_INLINE, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent.>, <.Case.> )

#xcommand TRACE <clauses,...> => ? "TRACE: "+ProcName()+"()["+LTrim(Str(ProcLine()))+"]: ", <clauses>

#xcommand SINGLETON CLASS <!clsName!> [ FROM <!fromCls1!> [,<!fromClsN!>] ] => ;
FUNCTION <clsName>() ;;
STATIC obj, once ;;
IF obj == NIL ;;
   hb_threadOnce( @once, {|| obj := __S_<clsName>() } ) ;;
END ;;
RETURN obj;;
CLASS <clsName> [ FROM <fromCls1> ] [, <fromClsN> ] STATIC FUNCTION __S_<clsName>

#endif
