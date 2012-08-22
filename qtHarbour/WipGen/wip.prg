/*
 * $Id: wip.prg 117 2011-04-07 03:46:22Z tfonrouge $
 *
 * Simple cpp source generator for qtHarbour bindings
 *
 * (C) 2011. qtHarbour     http://sourceforge.net/projects/qth/
 * (C) 2011. Teo Fonrouge  <tfonrouge/at/gmail/dot/com>
 *
 */

#ifdef __HBDEBUG
#pragma debuginfo=on
#endif

#define wipVer  "v0.1"
#define wipRev  "$Revision: 117 $"
#define wipFullVer  wipVer + "-" + Token( wipRev, " ", 2 )

#include "hbclass.ch"

#define QTH_ARGUMENT_ERROR  "qth_errRT_PARAM();"

STATIC fhCPP
STATIC clsName
STATIC parentClass
STATIC varName := "obj"
STATIC indentVal := "    "
STATIC nHeaders
STATIC aMethods := {}
STATIC maxFuncLen := 0
STATIC idString := ""
STATIC sCredits := ;
    E" * (C) 2011. qtHarbour     http://sourceforge.net/projects/qth/\n" + ;
    E" * (C) 2011. Teo Fonrouge  <tfonrouge/at/gmail/dot/com>\n"

STATIC hEquiv := ;
    { ;
        "AutoFormatting"                        => "int",;
        "ButtonRole"                            => "int",;
        "Direction"                             => "int",;
        "DockOptions"                           => "int",;
        "DragDropMode"                          => "int",;
        "EditTriggers"                          => "int",;
        "Encoding"                              => "int",;
        "Format"                                => "int",;
        "Icon"                                  => "int",;
        "InsertPolicy"                          => "int",;
        "LineWrapMode"                          => "int",;
        "MessageIcon"                           => "int",;
        "qreal"                                 => "double",;
        "RenderFlags"                           => "int",;
        "Scope"                                 => "int",;
        "ScrollHint"                            => "int",;
        "ScrollMode"                            => "int",;
        "Shadow"                                => "int",;
        "Shape"                                 => "int",;
        "SizeAdjustPolicy"                      => "int",;
        "SizeConstraint"                        => "int",;
        "StandardButton"                        => "int",;
        "StandardButtons"                       => "int",;
        "Status"                                => "int",;
        "TabPosition"                           => "int",;
        "TabShape"                              => "int",;
        "QAbstractItemView::ScrollHint"         => "int",;
        "QAbstractItemView::SelectionBehavior"  => "int",;
        "QAbstractItemView::SelectionMode"      => "int",;
        "QEventLoop::ProcessEventsFlags"        => "int",;
        "QItemSelectionModel::SelectionFlags"   => "int",;
        "QPalette::ColorRole"                   => "int",;
        "QProgressBar::Direction"               => "int",;
        "QSizePolicy::Policy"                   => "int",;
        "QSizePolicy::ControlTypes"             => "int",;
        "QTabWidget::TabPosition"               => "int",;
        "QTabWidget::TabShape"                  => "int",;
        "QTextCursor::MoveMode"                 => "int",;
        "QTextCursor::MoveOperation"            => "int",;
        "QTextDocument::FindFlags"              => "int",;
        "QTextDocument::FindFlags"              => "int",;
        "QTextOption::WrapMode"                 => "int",;
        "QTreeWidgetItem::ChildIndicatorPolicy" => "int",;
        "Qt::Alignment"                         => "int",;
        "Qt::ApplicationAttribute"              => "int",;
        "Qt::AspectRatioMode"                   => "int",;
        "Qt::BrushStyle"                        => "int",;
        "Qt::CheckState"                        => "int",;
        "Qt::ConnectionType"                    => "int",;
        "Qt::ContextMenuPolicy"                 => "int",;
        "Qt::Corner"                            => "int",;
        "Qt::CursorShape"                       => "int",;
        "Qt::DockWidgetArea"                    => "int",;
        "Qt::DockWidgetAreas"                   => "int",;
        "Qt::DropAction"                        => "int",;
        "Qt::FocusPolicy"                       => "int",;
        "Qt::FocusReason"                       => "int",;
        "Qt::GestureFlags"                      => "int",;
        "Qt::GestureType"                       => "int",;
        "Qt::GlobalColor"                       => "int",;
        "Qt::HANDLE"                            => "void*",;
        "Qt::InputMethodHints"                  => "int",;
        "Qt::InputMethodQuery"                  => "int",;
        "Qt::ItemFlags"                         => "int",;
        "Qt::KeyboardModifiers"                 => "int",;
        "Qt::LayoutDirection"                   => "int",;
        "Qt::MatchFlags"                        => "int",;
        "Qt::MouseButtons"                      => "int",;
        "Qt::NavigationMode"                    => "int",;
        "Qt::Orientation"                       => "int",;
        "Qt::Orientations"                      => "int",;
        "Qt::PenStyle"                          => "int",;
        "Qt::ScrollBarPolicy"                   => "int",;
        "Qt::ShortcutContext"                   => "int",;
        "Qt::SortOrder"                         => "int",;
        "Qt::TextElideMode"                     => "int",;
        "Qt::TextFormat"                        => "int",;
        "Qt::TextInteractionFlags"              => "int",;
        "Qt::ToolBarArea"                       => "int",;
        "Qt::ToolButtonStyle"                   => "int",;
        "Qt::UIEffect"                          => "int",;
        "Qt::WidgetAttribute"                   => "int",;
        "Qt::WindowFlags"                       => "int",;
        "Qt::WindowModality"                    => "int",;
        "Qt::WindowStates"                      => "int",;
        "Qt::WindowType"                        => "int",;
        "Type"                                  => "int" ;
    }

FUNCTION Main( wipFile, cppFile )
    LOCAL pm
    LOCAL aText,aTmp,inHeaders
    LOCAL itm,line,lline
    LOCAL lastStrFunc
    LOCAL x,y,nFuncs
    LOCAL s,cppClassName
    LOCAL _dump_ := .F.
    LOCAL _public_types_ := .F.
    LOCAL _defined_types_ := .F.
    LOCAL fhWIP

#ifdef __HBDEBUG
    SetMode( 40, 100 )
#endif

    cppClassName := SubStr( HB_FNameName( wipFile ), 4 )

    IF !Empty( wipFile )

        ? "Wip: generating bindings for " + wipFile + ": "

        x := Row()
        y := Col()
        nFuncs := 0

        fhCPP := HB_FCreate( cppFile )

        aText := Text2Array( wipFile )

        IF nHeaders != NIL
            aTmp := {}
            inHeaders := .F.
            FOR EACH line IN aText
                IF LTrim( line ) = "// QTH_BEGIN_HEADERS"
                    inHeaders := .T.
                    LOOP
                ENDIF
                IF LTrim( line ) = "// QTH_END_HEADERS"
                    inHeaders := .F.
                    LOOP
                ENDIF
                IF inHeaders
                    IF !Empty( line )
                        AAdd( aTmp, "_begin_" )
                        AAdd( aTmp, "    " + LTrim( line ) )
                        AAdd( aTmp, "_end_" )
                        AAdd( aTmp, "" )
                    ENDIF
                ELSE
                    AAdd( aTmp, line )
                ENDIF
            NEXT
            aText := aTmp
            aTmp := NIL
            fhWIP := HB_FCreate ( wipFile )
            FOR EACH line IN aText
                FWrite( fhWIP, line + E"\n" )
            NEXT
            FClose( fhWIP )
        ENDIF

        FWrite( fhCPP, E"/*\n")
        FWrite( fhCPP, idString + E"\n *\n" )
        FWrite( fhCPP, E" * File autogenerated by Wip utility " + wipFullVer + E"\n * Do not edit this file.\n *\n" + sCredits + E" *\n */\n\n" )
        FWrite( fhCPP, E"#include \42qtharbour.h\42\n\n" )

        FWrite( fhCPP, E"#include \42hbxvm.h\42\n\n" )

        FWrite( fhCPP, E"#include <" + cppClassName + E">\n\n" )

        FOR EACH itm IN aText

            line := RTrim( LTrim( itm ) )

            lline := Lower ( line )

            IF lastStrFunc != NIL
                lastStrFunc := NIL
            ENDIF

            IF lline = "_begin_dump_"
                FWrite( fhCPP, E"/*\n * Wip: Dump Section INIT\n */\n\n" )
                _dump_ := .T.
                LOOP
            ENDIF

            IF lline = "_begin_public_types_"
                _public_types_ := .T.
                LOOP
            ENDIF
            
            IF lline = "_begin_defined_types_"
                _defined_types_ := .T.
                LOOP
            ENDIF
            
            IF lline = ":varname:"
                s := LTrim( RTrim( Token( line, ":", 2 ) ) )
                IF !Empty( s )
                    varName := s
                ENDIF
                LOOP
            ENDIF

            IF _dump_
                IF lline = "_end_dump_"
                    _dump_ := .F.
                    FWrite( fhCPP, E"/*\n * Wip: Dump Section END\n */\n\n" )
                    LOOP
                ENDIF
                FWrite( fhCPP, itm + E"\n" )

            ELSEIF _public_types_

                IF lline = "_end_public_types_"
                    _public_types_ := .F.
                    LOOP
                ENDIF
                
                SWITCH Token( lline, " ", 1 )
                CASE "enum"
                CASE "flags"
                    IF "::" $ line
                        hEquiv[ Token( line, " ", 2 ) ] := "int"
                    ELSE
                        s := Token( line, " ", 2 )
                        hEquiv[ s ] := "int"
                    ENDIF
                    EXIT
                OTHERWISE
                    s := Token( line, ": ", 2 )
                ENDSWITCH

                IF !Empty( s )
                    FWrite( fhCPP, "#define " + PadR( s, 40 ) + cppClassName + "::" + s + E"\n" )
                ENDIF

                LOOP
            
            ELSEIF _defined_types_

                IF lline = "_end_defined_types_"
                    _defined_types_ := .F.
                    LOOP
                ENDIF
                
                hEquiv[ Token( line, " ", 1 ) ] := Token( line, " ", 2 )

                LOOP

            ELSE

                IF lline = "_begin_"
                    pm := TParseMethod():New()
                    LOOP
                ENDIF

                IF lline = "class"
                    clsName := LTrim( RTrim( Token( line, " ", 2 ) ) )
                    parentClass := Upper( SubStr( line, At( "FROM", line ) + 5 ) )
                    WriteClassDefinition( Upper( clsName ) )
                ENDIF

                IF lline = "_end_" .AND. pm != NIL
                    IF pm:isConstructor
                        lastStrFunc := "New"
                    ELSE
                        lastStrFunc := pm:funcName
                    ENDIF
                    pm:WriteFunc()
                    pm := NIL
                    @ x,y SAY LTrim( Str( ++nFuncs ) + " method's" )
                    LOOP
                ENDIF
                IF pm != NIL
                    pm:ProcessLine( line )
                ENDIF
            ENDIF
        NEXT

        FWrite( fhCPP, E"/*\n * Wip: Method's Declaration Section END\n */\n\n" )

        Write_RegisterMethods()

        ?? "   Done."
        ?
        ?

    ENDIF

    FClose( fhCPP )

RETURN NIL

/*
    WriteClassDefinition
    Teo. Mexico 2011
*/
STATIC PROCEDURE WriteClassDefinition( clsName )
    LOCAL i,s
    LOCAL aParentClass := {}
    LOCAL hbClsTpl
    LOCAL hTokens
    LOCAL line,token
    LOCAL numParentCls

    numParentCls := NumToken( parentClass, " ," )

    FOR i := 1 TO numParentCls
        s := Token( parentClass, " ,", i )
        AAdd( aParentClass, s )
    NEXT

    hTokens := ;
        { "@QTH_CLASSNAME@" => clsName, ;
          "@QTH_CLASSNAME_LEN@" => LTrim( Str( Len( clsName ) ) ), ;
          "@NUM_PARENTCLS@" => LTrim( Str( numParentCls ) ) }

    hbClsTpl := Text2Array( "WipGen/templates/qth_HBClass.tpl" )

    FWrite( fhCPP, E"\n" )

    FWrite( fhCPP, E"/*\n * Wip: Class Creation & Object Instantiation Section INIT\n */\n" )

    FOR EACH line IN hbClsTpl

        FOR EACH token IN hTokens
            WHILE token:__enumKey $ line
                line := StrTran( line, token:__enumKey, token:__enumValue )
            ENDDO
        NEXT

        IF LTrim( line ) = "@FUNC_EXTERN_PARENTCLS@"
            FOR EACH s IN aParentClass
                FWrite( fhCPP, "HB_FUNC_EXTERN( " + s + E" );\n" )
            NEXT
            LOOP
        ENDIF

        IF LTrim( line ) = "@SYMBOLTABLE_PARENTCLS@"
            FOR EACH s IN aParentClass
                FWrite( fhCPP, E"{ \42" + s + E"\42, { HB_FS_PUBLIC }, { HB_FUNCNAME( " + s + E" ) }, NULL },\n" )
            NEXT
            LOOP
        ENDIF

        FWrite( fhCPP, line + E"\n" )

    NEXT
    
    FWrite( fhCPP, E"/*\n * Wip: Class Creation & Object Instantiation Section END\n */\n" )

    FWrite( fhCPP, E"\n" )

    FWrite( fhCPP, E"/*\n * Wip: Method's Declaration Section INIT\n */\n" )

RETURN

/*
    Write_RegisterMethods
    Teo. Mexico 2011
*/
STATIC PROCEDURE Write_RegisterMethods()
    LOCAL itm
    LOCAL indentLocal

    FWrite( fhCPP, E"/*\n * Wip: Register Harbour Method's Section INIT\n */\n" )
    //FWrite( fhCPP, E"static void s_registerMethods( HB_USHORT uiClass )\n" )
    FWrite( fhCPP, E"HB_FUNC_STATIC( S_REGISTERMETHODS )\n" )
    FWrite( fhCPP, E"{\n" )
    
    indentLocal := Replicate( indentVal, 1 )

    FWrite( fhCPP, indentLocal + E"HB_USHORT uiClass = hb_itemGetNI( hb_param( 1, HB_IT_NUMERIC ) );\n\n" )

    FOR EACH itm IN aMethods
        FWrite( fhCPP, indentLocal + E"hb_clsAdd( uiClass, " + PadR( E"\42" + itm + E"\42", maxFuncLen ) + E", HB_FUNCNAME( " + PadR( itm, maxFuncLen - 2 ) + E" ) );\n" )
    NEXT

    FWrite( fhCPP, E"}\n" )

    FWrite( fhCPP, E"/*\n * Wip: Register Harbour Method's Section END\n */\n" )

RETURN

CLASS TStruct
HIDDEN:
PROTECTED:
EXPORTED:

    DATA paramCheckList INIT ""
    DATA paramCount INIT 0
    DATA paramCountNoDef INIT 0
    DATA paramString INIT ""
    DATA list INIT {=>}
    DATA retFooter INIT {}
    DATA retHeader INIT {}
    DATA parPrefix INIT {}
    //DATA retPrefix INIT ""
    DATA retSuffix INIT ""
    DATA retString INIT ""

    METHOD getList( type, nParam )
    METHOD setList( type, nParam, key, value )

ENDCLASS

METHOD FUNCTION getList( type, nParam )
    IF !HB_HHasKey( ::list, type ) .OR. !HB_HHasKey( ::list[ type ], nParam )
        RETURN NIL
    ENDIF
RETURN ::list[ type, nParam ]

METHOD PROCEDURE setList( type, nParam, key, value ) CLASS TStruct

    IF !HB_HHasKey( ::list, type )
        ::list[ type ] := {=>}
    ENDIF

    IF !HB_HHasKey( ::list[ type ], nParam )
        ::list[ type, nParam ] := HB_HSetCaseMatch( HB_HSetOrder( {=>}, .T. ), .F. )
    ENDIF

    ::list[ type, nParam, key ] := value

RETURN

CLASS TParseMethod
HIDDEN:
PROTECTED:
    DATA indentLevel
    DATA tkReturnStr
    METHOD GetParamsStr( line )
    METHOD GetReturnStr( line, type, baseType )
    METHOD ParseParam( defValue, nParam, type, baseType, varName )
    METHOD ParseType( line, type, baseType, varName )
    METHOD WriteStruct( curIf )
EXPORTED:

    DATA curMethod
    DATA funcName
    DATA isConstructor INIT .F.
    DATA methodList

    CONSTRUCTOR New

    METHOD ParseLine( line )
    METHOD ProcessLine( line )
    METHOD WriteFunc()
ENDCLASS

METHOD New CLASS TParseMethod
    ::curMethod := TStruct():New()
    ::methodList := HB_HSetOrder( { => }, .T. )
RETURN Self

METHOD PROCEDURE GetParamsStr( line ) CLASS TParseMethod
    LOCAL tk
    LOCAL paramSecc
    LOCAL c
    LOCAL param := ""
    LOCAL nParam := 0
    LOCAL ptLevel := 0
    LOCAL lDone := .F.
    LOCAL defValue
    LOCAL type, baseType, varName

    tk := Token( line, "(", 1 )

    paramSecc := LTrim( RTrim( SubStr( line, Len( tk ) + 1 ) ) )

    FOR EACH c IN paramSecc

        IF c = "="
            defValue := ""
            LOOP
        ENDIF

        IF defValue != NIL
            defValue += c
        ENDIF

        IF c = ")"
            --ptLevel
            IF ptLevel > 0
                LOOP
            ENDIF
            lDone := .T.
            IF defValue != NIL
                defValue := Left( defValue, Len( defValue ) - 1 )
            ENDIF
        ELSEIF c = "("
            ++ptLevel
            IF defValue = NIL
                ::curMethod:paramString += c
            ENDIF
            LOOP
        ENDIF

        IF c $ "),"
            IF !Empty( param )
                IF defValue != NIL
                    IF c = ","
                        defValue := Left( defValue, Len( defValue ) - 1 )
                    ENDIF
                    defValue := LTrim( RTrim( defValue ) )
                ENDIF

                param := LTrim( RTrim( param ) )

                ::ParseType( param, @type, @baseType, @varName )

                ::ParseParam( defValue, ++nParam, type, baseType, varName )

                param := ""
                defValue := NIL
                IF c = ")"
                    ::curMethod:paramString += " "
                ENDIF
            ENDIF
            ::curMethod:paramString += c
        ELSE
            IF defValue = NIL
                param += c
            ELSE
                //defValue += c
            ENDIF
        ENDIF

        IF lDone
            EXIT
        ENDIF

    NEXT

RETURN

METHOD FUNCTION GetReturnStr( line, type, baseType ) CLASS TParseMethod
    LOCAL pList
    LOCAL index0 := ""
    LOCAL commonBase
    LOCAL retPrefix := ""
    LOCAL s_retString := ""
    LOCAL s_clsName := ""
    LOCAL itm,key
    LOCAL QTH_ITEM_Flag := ""

    IF ::funcName = NIL
        ::funcName := Token( Token( line, "(", 1 ), " ", -1 )
        ::isConstructor := Upper( ::funcName ) == Upper( clsName )
    ENDIF

    pList := ::curMethod:getList( "return", 1 )

    IF HB_HHasKey( hEquiv, baseType )
        commonBase := hEquiv[ baseType ]
    ELSE
        commonBase := baseType
    ENDIF

    SWITCH commonBase
    CASE "bool"
        retPrefix := "hb_retl( "
        EXIT
    CASE "int"
        IF pList != NIL
            IF HB_HHasKey( pList, "index0" )
                index0 := " + 1"
            ENDIF
        ENDIF
        retPrefix := "hb_retni( "
        EXIT
    CASE "long"
        retPrefix := "hb_retnl( "
        EXIT
    CASE "double"
        retPrefix := "hb_retnd( "
        EXIT
    CASE "void*"
        retPrefix := "hb_retptr( "
        EXIT
    CASE "void"
        EXIT
    CASE "QList"
    CASE "QVector"
        retPrefix := "qth_ret_" + commonBase +  "<" + Token( type, "<*>", 2 ) + ">( "
        EXIT
    CASE "QString"
    CASE "WId"
        retPrefix := "qth_ret_" + baseType + "( "
        EXIT
    OTHERWISE
        IF pList != NIL
            FOR EACH itm IN pList
                key := Upper( itm:__enumKey )
                SWITCH key
                CASE "TRANSFER"
                CASE "TRANSFERBACK"
                    QTH_ITEM_Flag := ", QTHI_" + key
                    EXIT
                ENDSWITCH
            NEXT
        ENDIF
        retPrefix := "qth_ret"
        IF Right( type, 1 ) $ "&*"
            IF Right( type, 1 ) = "&"
                retPrefix += "Ref"
            ELSE /* "*" */
                IF Token( type, " ", 1 ) = "const"
                    retPrefix += "Const"
                ELSE
                    s_clsName := ", " + Chr( 34 ) + baseType + Chr( 34 )
                ENDIF
                retPrefix += "Ptr"
            ENDIF
            retPrefix += "<" + baseType + ">( "
        ELSE
            s_clsName := iif( ::isConstructor, "", " ), " + Chr( 34 ) + baseType + Chr( 34 ) )
            retPrefix += "( new " + baseType + "( "
        ENDIF

    ENDSWITCH

    IF !Empty( retPrefix )
        ::curMethod:retSuffix := index0 + s_clsName + QTH_ITEM_Flag + " )"
    ENDIF

    IF !Empty( s_retString )
        ::curMethod:retString += retPrefix + s_retString
    ELSE
        ::curMethod:retString := retPrefix + varName + "->" + ::funcName
    ENDIF

RETURN .T.

METHOD PROCEDURE ParseLine( line ) CLASS TParseMethod
    LOCAL type, baseType

    ::ParseType( line, @type, @baseType )

    IF ::GetReturnStr( line, type, baseType )
        ::GetParamsStr( line )
    ENDIF

RETURN

METHOD PROCEDURE ParseParam( defValue, nParam, type, baseType, varName ) CLASS TParseMethod
    LOCAL pList
    LOCAL commonBase
    LOCAL varType
    LOCAL cGetParam := ""
    LOCAL cParamType := ""
    LOCAL cnParam
    LOCAL cParamCheck
    LOCAL itm, key
    LOCAL QTH_ITEM_Flag
    LOCAL _it_, _isnum_,_var_
    LOCAL _numeric_ := .F., _numByRef_ := .F.
    LOCAL _parn_, _storn_

    cnParam := LTrim( Str( nParam, 0 ) )

    pList := ::curMethod:getList( "params", varName )

    IF HB_HHasKey( hEquiv, baseType )
        commonBase := hEquiv[ baseType ]
    ELSE
        commonBase := baseType
    ENDIF

    IF pList != NIL
        /* QTH_ITEM flags */
        FOR EACH itm IN pList
            key := Upper( itm:__enumKey )
            SWITCH key
            CASE "TRANSFER"
            CASE "TRANSFERBACK"
                QTH_ITEM_Flag := "QTHI_" + key
            ENDSWITCH
        NEXT
    ENDIF

    SWITCH commonBase
    CASE "void"
        cParamType := " HB_IT_POINTER"
        cGetParam := " hb_parptr( " + cnParam + " )"
        cParamCheck := "HB_ISPOINTER"
        EXIT
    CASE "bool"

        cParamType := " HB_IT_LOGICAL"
        cGetParam := " hb_parl( " + cnParam + " )"

        IF Right( type, 1 ) = "*"
            cParamCheck := "HB_ISBYREF"
        ELSE
            cParamCheck := "HB_ISLOG"
        ENDIF

        EXIT
    CASE "WId"
    CASE "int"
    CASE "long"
    CASE "double"

        _numeric_ := .T.

        SWITCH commonBase
        CASE "WId"
            _parn_ := " qth_par_WId( "
        CASE "int"
            _it_ := " HB_IT_INTEGER"
            _isnum_ := "QTH_ISNUM_INTEGER"
            IF _parn_ = NIL
                _parn_ := " hb_parni( "
            ENDIF
            _storn_ := "hb_storni( "
            cGetParam := _parn_ + cnParam + " )"
            EXIT
        CASE "long"
            _it_ := " HB_IT_NUMERIC"
            _isnum_ := "QTH_ISNUM_LONG"
            _parn_ := " hb_parnl( "
            _storn_ := "hb_stornl( "
            cGetParam := _parn_ + cnParam + " )"
            EXIT
        CASE "double"
            _it_ := " HB_IT_DOUBLE"
            _isnum_ := "QTH_ISNUM_DOUBLE"
            _parn_ := " hb_parnd( "
            _storn_ := "hb_stornd( "
            cGetParam := _parn_ + cnParam + " )"
            EXIT
        ENDSWITCH

        IF pList != NIL
            IF HB_HHasKey( pList, "index0" )
                cGetParam += " - 1"
            ENDIF
        ENDIF

        IF !baseType == commonBase
            cGetParam := " (" + baseType + ")" + cGetParam
        ENDIF

        IF Right( type, 1 ) = "*"
            cParamCheck := "HB_ISBYREF"
            _numByRef_ := .T.
            _it_ := " HB_IT_BYREF"
        ELSE
            cParamCheck := _isnum_
        ENDIF

        cParamType := _it_

        EXIT
    CASE "char"
        cParamType := " HB_IT_STRING"
        cGetParam := " hb_parc( " + cnParam + " )"

        cParamCheck := "HB_ISCHAR"

        EXIT
    CASE "QString"
        cParamType := " HB_IT_STRING"
        
        IF Right( type, 1 ) = "*"
            cGetParam := " &" + varName + cnParam
        ELSE
            cGetParam := " qth_par_QString( " + cnParam + " )"
        ENDIF

        cParamCheck := "HB_ISCHAR"

        EXIT
    CASE "QList"
    CASE "QVector"
        cParamType := " HB_IT_OBJECT"
        cGetParam := " qth_par_" + commonBase
        IF "*" $ type
            cGetParam += "Ptr"
        ENDIF
        cGetParam += "<" + Token( type, "<*>", 2 ) + ">( " + cnParam + " )"

        cParamCheck := "HB_ISOBJECT"

        EXIT
    CASE "QVariant"
        cParamType := " HB_IT_ANY"
        cGetParam := " qth_par_QVariant( " + cnParam + " )"

        cParamCheck := "qth_IsVariant"

        EXIT
    OTHERWISE

        cGetParam := " qth_par"
        IF Token( type, " ", 1 ) = "const"
            cGetParam += "Const"
        ENDIF
        IF Right( type, 1 ) = "&"
            cGetParam += "Ref"
        ELSEIF Right( type, 1 ) = "*"
            cGetParam += "Ptr"
        ENDIF

        SWITCH commonBase
        CASE "QStringList"
            cParamType := " HB_IT_ARRAY"
            cParamCheck := "HB_ISARRAY"
            cGetParam += "_" + baseType + "( " + cnParam
            EXIT
        OTHERWISE
            cParamType := " HB_IT_OBJECT"
            cParamCheck := "HB_ISOBJECT"
            cGetParam += "<" + baseType + ">( " + cnParam
            IF !Empty( QTH_ITEM_Flag )
                cGetParam += ", " + QTH_ITEM_Flag
            ENDIF
        ENDSWITCH

        cGetParam += " )"

    ENDSWITCH

    IF !Empty( ::curMethod:paramCheckList )
        ::curMethod:paramCheckList += " && "
    ENDIF

    ++::curMethod:paramCount

    IF defValue != NIL // optional parameter with defaule value
        varType := "(" + type + ") "

        _var_ := varName

        IF _numeric_ .AND. _numByRef_
            AAdd( ::curMethod:retHeader, baseType + " " + varName + " =" + _parn_ + cnParam + E" );\n" )
            cGetParam := " &" + varName
            _var_ := varName + cnParam
        ENDIF

        IF type == "QString*"
            AAdd( ::curMethod:retHeader, "QString " + varName + cnParam + " = hb_parc( " + cnParam + E" );\n" )
        ENDIF

        AAdd( ::curMethod:retHeader, type + " " + _var_ + " = hb_param( " + cnParam + "," + cParamType + " )" + " ?" + cGetParam + " : " + varType + defValue + E";\n" )
    
        cGetParam := " " + varName
        ::curMethod:paramCountNoDef := NIL
        IF cParamCheck == "HB_ISOBJECT"
            ::curMethod:paramCheckList += "qth_par_def( " + cnParam + ", " + Chr( 34 ) + baseType + Chr( 34 ) + " )"
        ELSE
            ::curMethod:paramCheckList +=  "qth_par_def( " + cnParam + "," + cParamType + " )"
        ENDIF
    ELSE
        IF cParamCheck == "HB_ISOBJECT"
            ::curMethod:paramCheckList += "qth_IsObject( " + cnParam + ", " + Chr( 34 ) + baseType + Chr( 34 ) + " )"
        ELSEIF cParamCheck == "HB_ISARRAY"
            ::curMethod:paramCheckList += "qth_IsArray( " + cnParam + " )"
        ELSE
            ::curMethod:paramCheckList += cParamCheck + "( " + cnParam + " )"
        ENDIF
        IF ::curMethod:paramCountNoDef != NIL
            ++::curMethod:paramCountNoDef
        ENDIF
    ENDIF

    IF _numeric_ .AND. _numByRef_
        IF defValue = NIL
            AAdd( ::curMethod:retHeader, baseType + " " + varName + " =" + cGetParam + E";\n" )
            cGetParam := " &" + varName
            AAdd( ::curMethod:retFooter, _storn_ + varName + ", " + cnParam + E" );\n" )
        ELSE
            //AAdd( ::curMethod:retHeader, "int " + varName + " =" + cGetParam + E";\n" )
            cGetParam := " &" + varName
            AAdd( ::curMethod:retFooter, "if( " + varName + cnParam + E" )\n" )
            AAdd( ::curMethod:retFooter, E"{\n" )
            AAdd( ::curMethod:retFooter, indentVal + _storn_ + varName + ", " + cnParam + E" );\n" )
            AAdd( ::curMethod:retFooter, E"}\n" )
        ENDIF
    ENDIF

    ::curMethod:paramString += cGetParam

RETURN

METHOD PROCEDURE ParseType( line, type, baseType, varName ) CLASS TParseMethod
    LOCAL tk
    LOCAL isConst := .F.

    tk := RTrim( Token( line, "(", 1 ) )

    varName := Token( tk, " ", -1 )

    WHILE .T.

        IF tk = "const"
            tk := SubStr( tk, 7 )
            isConst := .T.
            LOOP
        ENDIF

        IF tk = "virtual"
            tk := SubStr( tk, 9 )
            LOOP
        ENDIF

        EXIT

    ENDDO

    IF ">" $ tk
        type := StrTran( Left( tk, Len( Token( tk, ">", 1 ) ) + 1 ), " ", "" )
        baseType := Token( type, "<", 1 )
    ELSEIF "&" $ tk .OR. "*" $ tk
        type := StrTran( Left( tk, Len( Token( tk, "&*", 1 ) ) + 1 ), " ", "" )
        baseType := Token( type, "&*", 1 )
    ELSE
        type := Token( tk, " ", 1 )
        baseType := type
    ENDIF

    IF isConst
        type := "const " + type
    ENDIF

RETURN

METHOD PROCEDURE ProcessLine( line ) CLASS TParseMethod
    LOCAL tk

    IF Empty( line ) .OR. line = "{" .OR. line = "//" .OR. line = "#"

        RETURN

    ELSEIF line = ":"

        tk := RTrim( Token( line, ":", 1 ) )

        SWITCH tk
        CASE "if"
            ::curMethod:setList( "if", 1, LTrim( RTrim( Token( line, ":", 2 ) ) ) )
            EXIT
        CASE "param"
            ::curMethod:setList( "params", LTrim( RTrim( Token( line, ":", 2 ) ) ), LTrim( RTrim( Token( line, ":", 3 ) ) ) )
            EXIT
        CASE "return"
            ::curMethod:setList( "return", 1, LTrim( RTrim( Token( line, ":", 2 ) ) ) )
            EXIT
        CASE "register"
            AAdd( aMethods, Upper( LTrim( RTrim( Token( line, ":", 2 ) ) ) ) )
            EXIT
        ENDSWITCH

    ELSE

        ::methodList[ line ] := ::curMethod

        ::ParseLine( line )

        ::curMethod := TStruct():New()

    ENDIF

RETURN

METHOD FUNCTION WriteFunc() CLASS TParseMethod
    LOCAL curIf
    LOCAL itm
    LOCAL hVar
    LOCAL funcName

    IF !Empty( ::funcName )

        funcName := iif( ::isConstructor, "NEW", ::funcName )

        AAdd( aMethods, Upper( funcName ) )

        maxFuncLen := Max( maxFuncLen, Len( funcName ) + 2 )

        FWrite( fhCPP, "HB_FUNC_STATIC( " + Token( Upper( funcName ), " (", 1 ) + E" )\n" )
        FWrite( fhCPP, E"{\n" )

        IF ::isConstructor
            //FWrite( fhCPP, indentVal + E"qth_ObjParams objParams = qth_ObjParams( NULL );\n\n" )
            ::indentLevel := 1
        ELSE
            FWrite( fhCPP, indentVal + clsName + "* " + varName + " = (" + clsName + " *) qth_itemListGet_CPP( hb_stackSelfItem() );"+ E"\n\n" )
            FWrite( fhCPP, indentVal + "if( " + varName + E" )\n" )
            FWrite( fhCPP, indentVal + E"{\n" )
            ::indentLevel := 2
        ENDIF

        FOR EACH curIf IN ::methodList

            hVar := curIf:getList( "if", 1 )

            IF !Empty( hVar )
                FOR EACH itm IN hVar
                    FWrite( fhCPP, "#if " + itm:__enumKey() + E"\n" )
                NEXT
            ENDIF

            FWrite( fhCPP, Replicate( indentVal, ::indentLevel ) )
            FWrite( fhCPP, E"/* " + curIf:__enumKey + E" */\n" )

            FWrite( fhCPP, Replicate( indentVal, ::indentLevel ) )
            
            IF Empty( curIf:paramCheckList )
                FWrite( fhCPP, E"if( hb_pcount() == 0 )\n" )
            ELSE
                FWrite( fhCPP, "if( " )
                IF !Empty( curIf:paramCountNoDef )
                    FWrite( fhCPP, "( hb_pcount() == " + LTrim( Str( curIf:paramCountNoDef ) ) + " ) && " )
                ELSE
                    FWrite( fhCPP, "( hb_pcount() <= " + LTrim( Str( curIf:paramCount ) ) + " ) && " )
                ENDIF
                FWrite( fhCPP, curIf:paramCheckList + E" )\n" )
            ENDIF

            FWrite( fhCPP, Replicate( indentVal, ::indentLevel ) + E"{\n" )
            FWrite( fhCPP, Replicate( indentVal, ++::indentLevel ) )

            ::WriteStruct( curIf )

            FWrite( fhCPP, Replicate( indentVal, ::indentLevel ) + E"return;\n" )
            FWrite( fhCPP, Replicate( indentVal, --::indentLevel ) + E"}\n" )

            IF !Empty( hVar )
                FOR EACH itm IN hVar DESCEND
                    FWrite( fhCPP, E"#endif  /* " + itm:__enumKey() + E" */\n" )
                NEXT
            ENDIF

        NEXT

        FWrite( fhCPP, Replicate( indentVal, ::indentLevel ) + QTH_ARGUMENT_ERROR + E"\n" )

        IF !::isConstructor
            FWrite( fhCPP, indentVal + E"}\n" )
        ENDIF

        FWrite( fhCPP, E"}\n\n" )

    ENDIF

RETURN .T.

METHOD PROCEDURE WriteStruct( curIf ) CLASS TParseMethod
    LOCAL line

    FOR EACH line IN curIf:parPrefix
        FWrite( fhCPP, line )
        FWrite( fhCPP, Replicate( indentVal, ::indentLevel ) )
    NEXT

    FOR EACH line IN curIf:retHeader
        FWrite( fhCPP, line )
        FWrite( fhCPP, Replicate( indentVal, ::indentLevel ) )
    NEXT

    IF ::isConstructor
        FWrite( fhCPP, "qth_itemPushReturn( new " + ::funcName )
    ELSE
        FWrite( fhCPP, curIf:retString )
    ENDIF

    IF !Empty( curIf:paramString )
        FWrite(fhCPP, curIf:paramString )
    ENDIF

    FWrite( fhCPP, curIf:retSuffix + E";\n" )

    FOR EACH line IN curIf:retFooter
        FWrite( fhCPP, Replicate( indentVal, ::indentLevel ) )
        FWrite( fhCPP, line )
    NEXT

RETURN

STATIC FUNCTION Text2Array( fileName )
    LOCAL a := {}
    LOCAL s
    LOCAL n
    LOCAL cText
    
    cText := HB_MemoRead( fileName )

    // solo LF como EOL
    cText := StrTran( cText, Chr(13)+Chr(10), Chr(10) )
    cText := StrTran( cText, Chr(9), "  " )

    WHILE !cText==""
        IF (n:=At( Chr(10), cText )) = 0
            n := Len( cText ) + 1
        ENDIF
        s := SubStr( cText, 1, n-1 )
        AAdd( a, s )
        IF s = "// QTH_BEGIN_HEADERS"
            nHeaders := Len( a )
        ENDIF
        IF "$Id:" $ s
            idString := s
        ENDIF
        cText := SubStr( cText, n+1 )
    ENDDO

RETURN a
