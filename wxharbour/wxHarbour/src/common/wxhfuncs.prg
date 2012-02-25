/*
 * $Id: wxhfuncs.prg 799 2012-01-31 16:22:17Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

#define nextCtrlOnEnter		.T.

/*
    wxhFuncs
    Teo. Mexico 2009
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"

#include "wxh/textctrl.ch"
#include "wxh/bitmap.ch"
#include "wxh/button.ch"

#include "wxharbour.ch"

REQUEST QQOUT
REQUEST WXTOOLBARTOOLBASE
REQUEST WXSTATICBOX

STATIC containerObj
STATIC menuData

/*
    wxh_Dummy
    Teo. Mexico 2010
*/
PROCEDURE WXH_SYMBOL_UNUSED()
RETURN

/*
    wxhAltD
    Teo. Mexico 2010
*/
FUNCTION wxhAltD( ... )
    HB_GCAll()
RETURN AltD( ... )

/*
    WXHBaseClass
    Teo. Mexico 2009
*/
CLASS WXHBaseClass
PRIVATE:
PROTECTED:
PUBLIC:
    METHOD ObjectH()        /* Harbour object handle */
PUBLISHED:
ENDCLASS
/*
    EndClass WXHBaseClass
*/

/*
    wxhHBValidator
    Teo. Mexico 2009
*/
CLASS wxhHBValidator FROM wxValidator
PRIVATE:
PROTECTED:
    DATA FBaseField EXPORTED
    DATA FBlock
    DATA FField
    DATA FFieldBlock
    DATA FName
    DATA FValidValues
    DATA FUsingFieldValidation INIT .F.
    DATA dontUpdateVar INIT .F.
    DATA updatedByTab INIT .F.
    METHOD GetBaseField
    METHOD GetField()
    METHOD GetMaxLength()
PUBLIC:

    DATA actionBlock
    DATA data
    DATA dataIsOEM INIT .T.
    DATA lastKey
    DATA onSearch
    DATA Picture
    DATA warnBlock
    DATA warningMessage

    CONSTRUCTOR New( name, var, baseField, block, picture, warning, warnBlock, warnMsg, actionBlock )

    METHOD AddPostInfo()
    METHOD AsString()
    METHOD EvalWarnBlock( parent, showWarning )
    METHOD GetChoices( xList )							/* returns a array of values */
    METHOD GetKeyValue( n )						/* returns key of ValidValues on TField (if any) */
    METHOD GetSelection							/* returns numeric index of ValidValues on TField (if any) */
    METHOD IsModified( control )
    METHOD PickList( event )
    METHOD TextValue( pictured )							/* Text Value for control */
    METHOD UpdateVar( event, force )

    /* wxValidator methods */
    METHOD TransferFromWindow()
    METHOD TransferToWindow()
    METHOD Validate( parent )

    PROPERTY BaseField READ GetBaseField
    PROPERTY Block READ FBlock
    PROPERTY Field READ GetField
    PROPERTY maxLength READ GetMaxLength
    PROPERTY Name READ FName

    PUBLISHED:
ENDCLASS

/*
    New
    Teo. Mexico 2009
*/
METHOD New( name, var, baseField, block, picture, warning, warnBlock, warnMsg, actionBlock ) CLASS wxhHBValidator

    ::FName	 := name

    IF HB_IsObject( var ) .AND. var:IsDerivedFrom("TField")
        ::FField := var
        ::FBaseField := baseField
        ::FFieldBlock := block
        block := {|__localVal| iif( PCount() > 0, ::Field:Value := __localVal, ::Field:Value ) }
        IF Empty( warning )
            ::FUsingFieldValidation := .T.
        ENDIF
        IF ::FField:picture != NIL
            ::Picture := ::FField:picture
        ENDIF
    ELSEIF HB_IsBlock( var )
        block := var
    ELSEIF Empty( name )
        block := {|__localVal| iif( PCount() > 0, ::data := __localVal, ::data ) }
    ENDIF

    ::FBlock := block

    IF picture != NIL
        ::Picture := picture
    ENDIF

    IF ! Empty( warning )
        SWITCH ValType( warning )
        CASE "O"
            ::warnBlock := warning
            EXIT
        CASE "B"
            ::warnBlock := warning
            EXIT
        OTHERWISE
            ::warnBlock := warnBlock
        ENDSWITCH
    ENDIF

    ::warningMessage := warnMsg

    IF actionBlock != NIL
        ::actionBlock := actionBlock
    ENDIF

RETURN Super:New()

/*
    AddPostInfo
    Teo. Mexico 2009
*/
METHOD PROCEDURE AddPostInfo() CLASS wxhHBValidator
    LOCAL contextListKey := wxGetApp():wxh_ContextListKey
    LOCAL parent := containerObj():LastParent()
    LOCAL control := ::GetWindow()

    /*
     * connect events for changes
     */
    /* @ CHECKBOX */
    IF control:IsDerivedFrom( "wxCheckBox" )
        control:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_CHECKBOX_CLICKED, {|event| ::UpdateVar( event ) } )

    /* @ CHOICE */
    ELSEIF control:IsDerivedFrom( "wxChoice" )
        control:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_CHOICE_SELECTED, {|event| ::UpdateVar( event ) } )

    /* @ COMBOBOX */
    ELSEIF control:IsDerivedFrom( "wxComboBox" )
        control:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_COMBOBOX_SELECTED, {|event| ::UpdateVar( event ) } )
        control:ConnectCommandEvt( control:GetID(), wxEVT_COMMAND_TEXT_UPDATED, {|event| ::UpdateVar( event ) } )

    /* @ DATEPICKERCTRL */
    ELSEIF control:IsDerivedFrom( "wxDatePickerCtrl" )
        control:ConnectCommandEvt( control:GetId(), wxEVT_DATE_CHANGED, {|event| ::UpdateVar( event ) } )

    /* @ GET */
    ELSEIF control:IsDerivedFrom( "wxTextCtrl" )

        control:ConnectFocusEvt( control:GetId(), wxEVT_SET_FOCUS, ;
            {|event|
                event:GetEventObject():ChangeValue( RTrim( ::TextValue( .F. ) ) )
                RETURN NIL
            } )

        control:ConnectKeyEvt( wxID_ANY, wxEVT_KEY_DOWN, ;
            {|event|
                ::lastKey := event:GetKeyCode()
                SWITCH ::lastKey
                CASE WXK_TAB
                    ::UpdateVar( event )
                    ::updatedByTab := .T.
                    EXIT
                OTHERWISE
                    ::updatedByTab := .F.
                ENDSWITCH
                event:Skip()
                RETURN NIL
            } )
        IF nextCtrlOnEnter .AND. !control:IsMultiLine()
            parent:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_TEXT_ENTER, {|event| wxh_AddNavigationKeyEvent( event:GetEventObject():GetParent() ) } )
        ENDIF
        IF control:IsDerivedFrom( "wxSearchCtrl" ) .AND. ::onSearch != NIL
            control:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_SEARCHCTRL_SEARCH_BTN, ::onSearch )
        ENDIF
        IF ::FField != NIL .AND. !::Field:PickList == NIL
            control:ConnectMouseEvt( control:GetId(), wxEVT_LEFT_DCLICK, {|event| ::PickList( event ) } )
            IF control:IsDerivedFrom( "wxSearchCtrl" ) .AND. ::onSearch = NIL
                control:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_SEARCHCTRL_SEARCH_BTN, {|event| ::PickList( event ) } )
            ENDIF
            IF contextListKey != NIL
                control:ConnectKeyEvt( wxID_ANY, wxEVT_KEY_DOWN, ;
                    {|event|
                        IF event:GetKeyCode() = contextListKey
                            ::PickList( event )
                            event:Skip( .F. )
                            RETURN NIL
                        ENDIF
                        event:Skip()
                        RETURN NIL
                    } )
            ENDIF
        ENDIF
        control:SetSelection()
        IF ::maxLength != NIL
            control:SetMaxLength( ::maxLength )
        ENDIF

    /* @ RADIOBOX */
    ELSEIF control:IsDerivedFrom( "wxRadioBox" )
        control:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_RADIOBOX_SELECTED, {|event| ::UpdateVar( event ) } )

    /* @ SPINCTRL */
    ELSEIF control:IsDerivedFrom( "wxSpinCtrl" )
        control:ConnectCommandEvt( control:GetId(), wxEVT_COMMAND_SPINCTRL_UPDATED, {|event| ::UpdateVar( event ) } )

    ENDIF

    /* TField attributes */
    IF ::FField != NIL
        IF control:IsEnabled() .AND. ::Field:IsReadOnly()
            control:Disable()
        ENDIF
    ENDIF

    /*
     * Common to all controls
     */
    /* update var on kill focus, All controls ? */
    control:ConnectFocusEvt( control:GetId(), wxEVT_KILL_FOCUS, ;
        {|event|
            IF ::updatedByTab
                ::updatedByTab := .F.
            ELSE
                ::UpdateVar( event )
            ENDIF
            RETURN NIL
        } )

    /* set default name if empty */
    IF Empty( control:GetName() )
        control:SetName( ::Name )
    ENDIF

RETURN

/*
    AsString
    Teo. Mexico 2009
*/
METHOD FUNCTION AsString() CLASS wxhHBValidator
    LOCAL value
    IF ::FFieldBlock != NIL
        value := ::Field:AsString()
    ELSE
        value := AsString( ::FBlock:Eval() )
    ENDIF
RETURN value

/*
    EvalWarnBlock
    Teo. Mexico 2009
*/
METHOD FUNCTION EvalWarnBlock( parent, showWarning ) CLASS wxhHBValidator
    LOCAL msg
    LOCAL warn
    LOCAL label
    LOCAL tblName := ""

    IF ::FUsingFieldValidation
        warn := .NOT. ::BaseField:Validate( .F. )
        IF warn
            tblName := ", at Table (" + ::BaseField:Table:ClassName() + ")"
            label := " '" + ::BaseField:Label + "' "
        ENDIF
    ELSE
        SWITCH ValType( ::warnBlock )
        CASE "O"
            warn := .NOT. ::warnBlock:Validate( .F. )
            EXIT
        CASE "B"
            warn := .NOT. ::warnBlock:Eval( ::FBlock:Eval() )
            EXIT
        OTHERWISE
            warn := .F.
        ENDSWITCH
        label := " "
    ENDIF

    IF warn
        IF showWarning == NIL .OR. showWarning
            msg := iif( Empty( ::warningMessage ), "Field" + label + "has invalid data...", ::warningMessage )
            IF parent = NIL
                parent := ::GetWindow():GetParent()
            ENDIF
            wxMessageBox( msg, "Warning" + tblName, HB_BitOr( wxOK, wxICON_EXCLAMATION ), parent )
        ENDIF
    ENDIF

RETURN warn

/*
    GetBaseField
    Teo. Mexico 2011
*/
METHOD FUNCTION GetBaseField CLASS wxhHBValidator
    IF ::FBaseField = NIL
        RETURN ::Field
    ENDIF
RETURN ::FBaseField

/*
    GetChoices
    Teo. Mexico 2009
*/
METHOD FUNCTION GetChoices( xList ) CLASS wxhHBValidator
    LOCAL Result
    LOCAL itm

    IF ::FField != NIL .AND. ::Field:ValidValues != NIL

        ::FValidValues := ::Field:GetValidValues()

    ELSEIF xList != NIL

        ::FValidValues := xList

    ENDIF

    IF ::FValidValues != NIL

        SWITCH ValType( ::FValidValues )
        CASE 'A'
            Result := {}
            FOR EACH itm IN ::FValidValues
                IF HB_IsArray( itm )
                    AAdd( Result, itm[ 1 ] )
                ELSE
                    AAdd( Result, itm )
                ENDIF
            NEXT
            EXIT
        CASE 'H'
            Result := {}
            FOR EACH itm IN ::FValidValues
                AAdd( Result, itm:__enumValue() )
            NEXT
            EXIT
        END

    ENDIF

RETURN Result

/*
    GetField
    Teo. Mexico 2011
*/
METHOD FUNCTION GetField() CLASS wxhHBValidator
    IF ::FFieldBlock != NIL
        RETURN ::FFieldBlock:Eval()
    ENDIF
RETURN ::FField

/*
    GetKeyValue
    Teo. Mexico 2009
*/
METHOD FUNCTION GetKeyValue( n ) CLASS wxhHBValidator
    LOCAL itm

    IF ::FField != NIL .AND. ::Field:ValidValues != NIL

        ::FValidValues := ::Field:GetValidValues()

    ENDIF

    IF ::FValidValues != NIL

        SWITCH ValType( ::FValidValues )
        CASE 'A'
            IF n > 0 .AND. n <= Len( ::FValidValues )
                IF ValType( ::Block:Eval() ) = "N"
                    RETURN n
                ELSE
                    itm := ::FValidValues[ n ]
                    IF HB_IsArray( itm )
                        RETURN itm[ 1 ]
                    ELSE
                        RETURN itm
                    ENDIF
                ENDIF
            ENDIF
            EXIT
        CASE 'H'
            itm := HB_HKeys( ::FValidValues )
            IF n > 0 .AND. n <= len( itm )
                RETURN itm[ n ]
            ENDIF
            EXIT
        ENDSWITCH

        IF ::FField != NIL
            RETURN ::Field:EmptyValue()
        ENDIF

    ENDIF

RETURN n

/*
    GetMaxLength
    Teo. Mexico 2009
*/
METHOD FUNCTION GetMaxLength() CLASS wxhHBValidator
    LOCAL maxLength

    IF ::FField != NIL .AND. ::Field:IsDerivedFrom("TStringField")
        maxLength := ::Field:Size
    ENDIF

RETURN maxLength

/*
    GetSelection
    Teo. Mexico 2009
*/
METHOD GetSelection CLASS wxhHBValidator
    LOCAL n := 0
    LOCAL itm
    LOCAL key

    key := ::FBlock:Eval()

    IF ::FField != NIL .AND. ::Field:ValidValues != NIL

        ::FValidValues := ::Field:GetValidValues()

    ENDIF

    IF ::FValidValues != NIL

        SWITCH ValType( ::FValidValues )
        CASE 'A'		/* Array */
            IF ValType( key ) = "N"
                IF key > 0 .AND. key <= len( ::FValidValues )
                    RETURN key
                ENDIF
            ELSE
                FOR EACH itm IN ::FValidValues
                    IF HB_IsArray( itm )
                        IF ValType( itm[ 1 ] ) == ValType( key ) .AND. itm[ 1 ] == key
                            RETURN itm:__enumIndex()
                        ENDIF
                    ELSE
                        IF ValType( itm ) == ValType( key ) .AND. itm == key
                            RETURN itm:__enumIndex()
                        ENDIF
                    ENDIF
                NEXT
            ENDIF
            EXIT
        CASE 'H'		/* Hash */
            n := HB_HPos( ::FValidValues, key )
            EXIT
        OTHERWISE
            EXIT
        END

    ELSE

        n := key

    ENDIF

RETURN n

/*
    IsModified
    Teo. Mexico 2009
*/
METHOD IsModified( control ) CLASS wxhHBValidator
    LOCAL modified

    // TODO: Check why TAB on a TextCtrl marks buffer as dirty
    // modified := control:IsModified()
    modified := .F.

    IF !modified
        IF ::dataIsOEM
            modified := ! wxh_wxStringToOEM( control:GetValue() ) == ::AsString()
        ELSE
            modified := ! control:GetValue() == ::AsString()
        ENDIF
    ENDIF

RETURN modified

/*
    PickList
    Teo. Mexico 2009
*/
METHOD PROCEDURE PickList( event ) CLASS wxhHBValidator
    LOCAL s
    LOCAL parentWnd
    LOCAL selectionMade
    LOCAL value, rawValue
    LOCAL control := event:GetEventObject()

    IF !control:IsDerivedFrom( "wxTextCtrl" ) .OR. control:IsEditable()

        parentWnd := control:GetParent()

        ::dontUpdateVar := .T.
        selectionMade := ::Field:OnPickList( parentWnd )
        ::dontUpdateVar := .F.

        IF selectionMade
            s := RTrim( ::Field:AsString )
            rawValue := control:GetValue()
            IF ::dataIsOEM
                value := RTrim( wxh_wxStringToOEM( rawValue ) )
            ELSE
                value := RTrim( rawValue )
            ENDIF
            IF s == value
                RETURN /* no changes */
            ENDIF
            control:ChangeValue( wxh_OEMTowxString( s ) )
            ::UpdateVar( event, .T. )
        ENDIF

        //control:SetFocus()

    ENDIF

RETURN

/*
    TextValue
    Teo. Mexico 2009
*/
METHOD FUNCTION TextValue( pictured ) CLASS wxhHBValidator
    LOCAL value

    value := ::Block:Eval()

    IF ValType( value ) = "C" .AND. ::FField != NIL .AND. ::Field:Table:dataIsOEM
        value := wxh_OEMTowxString( value )
    ENDIF

    IF pictured == .T. .AND. ::Picture != NIL
        RETURN Transform( value, ::Picture )
    ENDIF

    IF ::FField != NIL
        RETURN ::Field:AsString
    ENDIF

RETURN AsString( value )

/*
    TransferFromWindow
    Teo. Mexico 2009
*/
METHOD TransferFromWindow() CLASS wxhHBValidator
    LOCAL control
    LOCAL oldValue
    LOCAL value
    LOCAL Result := .T.
    LOCAL changed
    LOCAL checkEditable

    control := ::GetWindow()

    IF ::FField != NIL
        checkEditable := ::Field:CheckEditable( .T. )
    ENDIF

    IF control:IsDerivedFrom( "wxTextCtrl" )

        IF ::dataIsOEM
            value := wxh_wxStringToOEM( control:GetValue() )
        ELSE
            value := control:GetValue()
        ENDIF

        oldValue := ::FBlock:Eval()

        SWITCH ValType( oldValue )
        CASE 'C'
            IF ::FField != NIL .AND. ::Field:IsDerivedFrom("TMemoField")
                changed := !value == oldValue
            ELSE
                IF Len( value ) < Len( oldValue )
                    changed := ! PadR( value , Len( oldValue ) ) == oldValue
                ELSE
                    changed := .T.
                ENDIF
            ENDIF
            EXIT
        CASE 'N'
            value := Val( value )
            changed := value != oldValue
            EXIT
        CASE 'D'
            value := AsDate( value )
            changed := value != oldValue
            EXIT
        OTHERWISE
            changed := .F.
        ENDSWITCH

        IF changed

            ::FBlock:Eval( value )

            value := ::FBlock:Eval()

            SWITCH ValType( value )
            CASE 'C'
                EXIT
            CASE 'D'
                value := FDateS( value )
                EXIT
            CASE 'N'
                IF Empty( ::picture )
                    value := Str( value )
                ELSE
                    value := Transform( value, ::picture )
                ENDIF
                EXIT
            END

            control:ChangeValue( wxh_OEMTowxString( value ) )

        ENDIF

    ELSEIF control:IsDerivedFrom( "wxCheckBox" )

        ::FBlock:Eval( control:GetValue() )

    ELSEIF control:IsDerivedFrom( "wxChoice" )

        value := ::GetKeyValue( control:GetCurrentSelection() )

        ::FBlock:Eval( value )

    ELSEIF control:IsDerivedFrom( "wxComboBox" )

        value := control:GetValue()

        ::FBlock:Eval( value )

    ELSEIF control:IsDerivedFrom( "wxDatePickerCtrl" )

        value := control:GetValue()

        ::FBlock:Eval( value )

    ELSEIF control:IsDerivedFrom( "wxRadioBox" )

        value := ::GetKeyValue( control:GetSelection() )

        ::FBlock:Eval( value )

    ELSEIF control:IsDerivedFrom( "wxSpinCtrl" )

        ::FBlock:Eval( control:GetValue() )

    ELSE

        Result := .F.

    ENDIF

    IF ::FField != NIL
        ::Field:CheckEditable( checkEditable )
    ENDIF

RETURN Result

/*
    TransferToWindow
    Teo. Mexico 2009
*/
METHOD TransferToWindow() CLASS wxhHBValidator
    LOCAL control
    LOCAL Result := .T.

    control := ::GetWindow()

    IF control != NIL .AND. ::FBlock != NIL

        /*
         * Assign initial value
         */
        /* @ CHECKBOX */
        IF control:IsDerivedFrom( "wxCheckBox" )

            IF !control:Is3State()
                control:SetValue( ::Block:Eval() )
            ENDIF

        /* @ CHOICE */
        ELSEIF control:IsDerivedFrom( "wxChoice" )

            control:SetSelection( ::GetSelection() )

        /* @ COMBOBOX */
        ELSEIF control:IsDerivedFrom( "wxComboBox" )

            control:SetSelection( ::GetSelection() )

        /* @ DATEPICKERCTRL */
        ELSEIF control:IsDerivedFrom( "wxDatePickerCtrl" )

            control:SetValue( ::Block:Eval() )

        /* @ GET */
        ELSEIF control:IsDerivedFrom( "wxTextCtrl" )

            control:ChangeValue( RTrim( ::TextValue( .T. ) ) )
            control:SetInsertionPoint( 0 )
            control:ShowPosition( 0 )
            //control:SetSelection()

        /* @ RADIOBOX */
        ELSEIF control:IsDerivedFrom( "wxRadioBox" )

            control:SetSelection( ::GetSelection() )

        /* @ SPINCTRL */
        ELSEIF control:IsDerivedFrom( "wxSpinCtrl" )

            control:SetValue( ::Block:Eval() )

        ELSE

            Result := .F.

        ENDIF

    ELSE

        Result := .F.

    ENDIF

RETURN Result

/*
    UpdateVar
    Teo. Mexico 2009
*/
METHOD PROCEDURE UpdateVar( event, force ) CLASS wxhHBValidator
    LOCAL evtType
    LOCAL control
    LOCAL oldValue
    LOCAL newValue

    IF ::dontUpdateVar .OR. ::FBlock == NIL
        RETURN
    ENDIF

    evtType := event:GetEventType()
    control := event:GetEventObject()
    oldValue := ::FBlock:Eval()

    IF control:IsDerivedFrom( "wxTextCtrl" )
        IF AScan( { wxEVT_KILL_FOCUS, wxEVT_COMMAND_TEXT_ENTER, wxEVT_KEY_DOWN }, evtType ) > 0
            IF ::IsModified( control ) .OR. evtType == wxEVT_COMMAND_TEXT_ENTER
                ::TransferFromWindow()
            ENDIF
        ENDIF

    ELSEIF control:IsDerivedFrom( "wxCheckBox" )
        IF evtType = wxEVT_COMMAND_CHECKBOX_CLICKED
            ::TransferFromWindow()
        ENDIF

    ELSEIF control:IsDerivedFrom( "wxChoice" )
        IF evtType = wxEVT_COMMAND_CHOICE_SELECTED
            ::TransferFromWindow()
        ENDIF

    ELSEIF control:IsDerivedFrom( "wxComboBox" )
        IF evtType = wxEVT_COMMAND_COMBOBOX_SELECTED .OR. evtType = wxEVT_KILL_FOCUS
            ::TransferFromWindow()
        ENDIF

    ELSEIF control:IsDerivedFrom( "wxDatePickerCtrl" )
        IF evtType = wxEVT_DATE_CHANGED
            ::TransferFromWindow()
        ENDIF

    ELSEIF control:IsDerivedFrom( "wxRadioBox" )
        IF evtType = wxEVT_COMMAND_RADIOBOX_SELECTED
            ::TransferFromWindow()
        ENDIF

    ELSEIF control:IsDerivedFrom( "wxSpinCtrl" )
        IF evtType = wxEVT_COMMAND_SPINCTRL_UPDATED
            ::TransferFromWindow()
        ENDIF

    ELSE

        RETURN	// no control found

    ENDIF

    ::TransferToWindow()

    newValue := ::FBlock:Eval()

    /* changed ? */
    IF force == .T. .OR. ValType( oldValue ) != ValType( newValue ) .OR. !oldValue == newValue
        IF ::actionBlock != NIL
            ::actionBlock:Eval( event )
        ENDIF
        ::EvalWarnBlock( control:GetParent() )
    ENDIF

RETURN

/*
    Validate
    Teo. Mexico 2009
*/
METHOD Validate( parent ) CLASS wxhHBValidator
RETURN ! ::EvalWarnBlock( parent, .T. )

/*
    End Class wxGET
*/

/*
    ContainerObj
    Teo. Mexico 2009
*/
FUNCTION ContainerObj
    IF containerObj == NIL
        containerObj := TContainerObj():New()
    ENDIF
RETURN containerObj

/*
    __wxh_BookAddPage
    Teo. Mexico 2009
*/
PROCEDURE __wxh_BookAddPage( title, select, imageId )

    containerObj():AddToNextBookPage( {"title"=>title,"select"=>select,"imageId"=>imageId} )

RETURN

/*
    __wxh_BookBegin
    Teo. Mexico 2009
*/
FUNCTION __wxh_BookBegin( bookClass, parent, id, pos, size, style, name, opChanged, opChanging )
    LOCAL book

    IF parent == NIL
        parent := containerObj():LastParent()
    ENDIF

    book := bookClass:New( parent, id, pos, size, style, name )

    IF opChanged != NIL
        book:ConnectNotebookEvt( book:GetID(), wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGED, opChanged )
    ENDIF

    IF opChanging != NIL
        book:ConnectNotebookEvt( book:GetID(), wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGING, opChanging )
    ENDIF

    containerObj():SetLastChild( book )

    containerObj():AddToParentList( book )

RETURN book

/*
    __wxh_BookEnd
    Teo. Mexico 2009
*/
PROCEDURE __wxh_BookEnd( book )
    containerObj():RemoveLastParent( book )
RETURN

/*
 * __wxh_BoxSizerBegin
 * Teo. Mexico 2009
 */
FUNCTION __wxh_BoxSizerBegin( label, orient, stretch, align, border, sideBorders )
    LOCAL sizer
    LOCAL parent
    LOCAL lastSizer

    parent := containerObj():LastParent()
    lastSizer := containerObj():LastSizer()

    IF label == NIL
        sizer := wxBoxSizer():New( orient )
    ELSE
        sizer := wxStaticBoxSizer():New( orient, parent, label )
        //sizer := wxStaticBoxSizer():New( wxStaticBox():New( parent, , label ) , orient )
    ENDIF

    IF lastSizer == NIL
        IF parent == NIL
            wxhAlert( "Sizer declared with no parent on sight..." )
        ENDIF
        __wxh_SetSizer( parent, sizer )
    ELSE
        __wxh_SizerInfoAdd( sizer, lastSizer, stretch, align, border, sideBorders )
    ENDIF

    containerObj():AddToSizerList( sizer )

RETURN sizer

/*
    __wxh_Browse
    Teo. Mexico 2009
 */
FUNCTION __wxh_Browse( fromClass, dataSource, window, id, label, pos, size, minSize, style, name, OnKeyDownBlock, onSelectCell, readOnly )
    LOCAL browse
    LOCAL panel
    LOCAL boxSizerV
    LOCAL boxSizerH
    LOCAL scrollBar

    IF window == NIL
        window := containerObj():LastParent()
    ENDIF

    panel := wxPanel():New( window, wxID_ANY, pos, size, HB_BitOr( wxTAB_TRAVERSAL, wxBORDER_NONE ) ) /* container of type wxPanel */

    IF label == NIL
        boxSizerV := wxBoxSizer():New( wxVERTICAL )
    ELSE
        boxSizerV := wxStaticBoxSizer():New( wxVERTICAL, panel, label )
    ENDIF

    panel:SetSizer( boxSizerV )

    IF !Empty( fromClass )
        browse := __ClsInstFromName( fromClass ):New( panel, id, NIL, NIL, style, name )
    ELSE
        browse := wxhBrowse():New( panel, id, NIL, {200,150}, style, name )
    ENDIF

    IF !browse:IsDerivedFrom( "wxhBrowse" )
        browse:IsNotDerivedFrom_wxhBrowse()
    ENDIF

    browse:EnableEditing( ! readOnly )

    IF dataSource != NIL
        browse:DataSource := dataSource
    ENDIF

    IF OnKeyDownBlock != NIL
        browse:OnKeyDownBlock := OnKeyDownBlock
    ENDIF

    IF onSelectCell != NIL
        browse:OnSelectCellBlock := onSelectCell
    ENDIF

    IF minSize != NIL
        browse:SetMinSize( minSize )
    ENDIF

    boxSizerH := wxBoxSizer():New( wxHORIZONTAL )

    IF __ObjHasMsgAssigned( browse, "DefineToolBar" )
        containerObj():AddToParentList( panel )
        containerObj():AddToSizerList( boxSizerV )
        browse:DefineToolBar()
        containerObj():RemoveLastParent()
    ENDIF

    boxSizerV:Add( boxSizerH, 1, HB_BitOr( wxGROW, wxALL ), 0 )

//
    boxSizerH:Add( browse, 1, HB_BitOr( wxGROW, wxALL ), 0 )

    boxSizerH:Add( wxStaticLine():New( panel, wxID_ANY, NIL, NIL, wxLI_VERTICAL ), 0, wxGROW, 0 )

    scrollBar := wxScrollBar():New( panel, wxID_ANY, NIL, NIL, wxSB_VERTICAL )

    scrollBar:SetScrollBar( 0, 1, 100, 10 )

    boxSizerH:Add( scrollBar, 0, HB_BitOr( wxGROW, wxLEFT, wxRIGHT ), 0 )
//

    containerObj():SetLastChild( panel )

RETURN browse

/*
    __wxh_BrowseAddColumn
    Teo. Mexico 2009
*/
PROCEDURE __wxh_BrowseAddColumn( wxhBrw, zero, title, block, picture, width, type, wp, colour, onSetValue )
    LOCAL column := wxhBrowseColumn():New( wxhBrw, title, block )

    column:Picture := picture
    column:Width   := width

    IF zero
        wxhBrw:ColumnZero := column
    ELSE
        wxhBrw:AddColumn( column )
        IF colour != NIL
            wxhBrw:SetColAttr( wxhBrw:ColCount(), colour )
        ENDIF
    ENDIF

    IF type != NIL
        type := Upper( type )
        DO CASE
        CASE type == "BOOL"
            wxhBrw:SetColFormatBool( wxhBrw:ColCount() )
        CASE type == "NUMBER"
            wxhBrw:SetColFormatNumber( wxhBrw:ColCount() )
        CASE type == "FLOAT"
            IF wp != NIL
                wxhBrw:SetColFormatFloat( wxhBrw:ColCount(), wp[ 1 ], wp[ 2 ] )
            ENDIF
        ENDCASE
    ENDIF

    column:OnSetValue := onSetValue

RETURN

/*
    __wxh_BrowseAddColumnFromField
    Teo. Mexico 2009
*/
PROCEDURE __wxh_BrowseAddColumnFromField( wxhBrw, xField, editable, colour )
    LOCAL column
    LOCAL a,itm

    SWITCH ValType( xField )
    CASE 'B'
        EXIT
    CASE 'C'
        EXIT
    CASE 'O'
        EXIT
    OTHERWISE
        wxhAlert( "Invalid column browse ..." )
        RETURN
    ENDSWITCH

    column := wxhBrowseColumn():New( wxhBrw )

    column:Field := xField
    column:IsEditable := editable
    wxhBrw:AddColumn( column )

    IF ValType( column:Field:ValidValues ) = "H"
        a := {}
        FOR EACH itm IN column:Field:ValidValues
            AAdd( a, itm:__enumValue )
        NEXT
        wxhBrw:SetColCellChoiceEditor( wxhBrw:ColCount, a )
    ENDIF

    IF colour != NIL
        wxhBrw:SetColAttr( wxhBrw:ColCount(), colour )
    ENDIF

RETURN

/*
    __wxh_Button
    Teo. Mexico 2009
*/
FUNCTION __wxh_Button( window, id, label, bmp, pos, size, style, validator, name, default, actionBlock )
    LOCAL button
    LOCAL bitmap

    IF window == NIL
        window := containerObj():LastParent()
    ENDIF

    IF bmp != NIL
        bitmap := __wxh_GetBitmapResource( bmp )
    ENDIF

    IF bitmap == NIL
        button := wxButton():New( window, id, label, pos, size, style, validator, name )
    ELSE
        IF style == NIL
            style := wxBU_AUTODRAW
        ELSE
            style := HB_BitOr( style, wxBU_AUTODRAW )
        ENDIF
        button := wxBitmapButton():New( window, id, bitmap, pos, size, style, validator, name )
        IF label != NIL
            button:SetLabel( label )
        ENDIF
    ENDIF

    IF actionBlock != NIL
        button:ConnectCommandEvt( button:GetID(), wxEVT_COMMAND_BUTTON_CLICKED, actionBlock )
    ENDIF

    IF default == .T.
        button:SetDefault()
    ENDIF

    containerObj():SetLastChild( button )

RETURN button

/*
    __wxh_CheckBox
    Teo. Mexico 2009
*/
FUNCTION __wxh_CheckBox( window, id, label, pos, size, style, name )
    LOCAL checkBox
    LOCAL validator

    IF window == NIL
        window := containerObj():LastParent()
    ENDIF

    validator := containerObj():LastItem()[ "wxhHBValidator" ]

    checkBox := wxCheckBox():New( window, id, label, pos, size, style, validator, name )

    validator:AddPostInfo()

    containerObj():SetLastChild( checkBox )

RETURN checkBox

/*
    __wxh_Choice
    Teo. Mexico 2009
*/
FUNCTION __wxh_Choice( parent, id, point, size, choices, style, name, enabled )
    LOCAL choice
    LOCAL validator

    IF parent == NIL
        parent := containerObj():LastParent()
    ENDIF

    validator := containerObj():LastItem()[ "wxhHBValidator" ]

    choice := wxChoice():New( parent, id, point, size, validator:GetChoices( choices ), style, validator, name )

    validator:AddPostInfo()

    __wxh_EnableControl( containerObj():LastParent(), choice, choice:GetId(), enabled )

    containerObj():SetLastChild( choice )

RETURN choice

/*
    __wxh_ComboBox
    Teo. Mexico 2009
*/
FUNCTION __wxh_ComboBox( parent, id, value, point, size, choices, style, name, enabled )
    LOCAL comboBox
    LOCAL validator

    IF parent == NIL
        parent := containerObj():LastParent()
    ENDIF

    validator := containerObj():LastItem()[ "wxhHBValidator" ]

    IF value == NIL
        value := RTrim( validator:AsString() )
    ENDIF

    comboBox := wxComboBox():New( parent, id, value, point, size, validator:GetChoices( choices ), style, validator, name )

    validator:AddPostInfo()

    __wxh_EnableControl( containerObj():LastParent(), comboBox, comboBox:GetId(), enabled )

    containerObj():SetLastChild( comboBox )

RETURN comboBox

/*
    __wxh_CreateDialogButtons
    Teo. Mexico 2010
*/
FUNCTION __wxh_CreateDialogButtons( message, flags, dlg, stretch, align, border, sideborders )
    LOCAL sizer
    LOCAL lastSizer

    IF dlg = NIL
        dlg := containerObj():LastParent()
    ENDIF

    IF dlg:IsDerivedFrom( "wxDialog" )

        sizer := __ObjSendMsg( dlg, message, flags )

        lastSizer := containerObj():LastSizer

        IF lastSizer == NIL
            __wxh_SetSizer( dlg, sizer )
        ELSE
            __wxh_SizerInfoAdd( sizer, lastSizer, stretch, align, border, sideBorders )
        ENDIF

        containerObj():AddToSizerList( sizer )

    ELSE
        wxhAlert( "wxDialog not at sight to add dialog-buttons." )
    ENDIF

RETURN sizer

/*
    __wxh_CustomParentBegin
    Teo. Mexico 2009
*/
PROCEDURE __wxh_CustomParentBegin( parent )
    containerObj():AddToParentList( parent )
RETURN

/*
    __wxh_CustomParentEnd
    Teo. Mexico 2009
*/
PROCEDURE __wxh_CustomParentEnd()
    containerObj():RemoveLastParent()
RETURN

/*
 * __wxh_DatePickerCtrl
 * Teo. Mexico 2009
 */
FUNCTION __wxh_DatePickerCtrl( parent, id, pos, size, style, name, enabled, toolTip )
    LOCAL dateCtrl
    LOCAL validator

    IF parent == NIL
        parent := containerObj():LastParent()
    ENDIF

    validator := containerObj():LastItem()[ "wxhHBValidator" ]

    dateCtrl := wxDatePickerCtrl():New( parent, id, NIL, pos, size, style, validator, name )

    IF toolTip != NIL
        dateCtrl:SetToolTip( toolTip )
    ENDIF

    validator:AddPostInfo()

    __wxh_EnableControl( containerObj():LastParent(), dateCtrl, dateCtrl:GetId(), enabled )

    containerObj():SetLastChild( dateCtrl )

RETURN dateCtrl

/*
    __wxh_Dialog
    Teo. Mexico 2009
*/
FUNCTION __wxh_Dialog( fromClass, oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName, onClose, initDlg )
    LOCAL dlg

    IF Empty( fromClass )
        dlg := wxDialog():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
    ELSE
        dlg := __ClsInstFromName( fromClass ):New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
        IF !dlg:IsDerivedFrom( "wxDialog" )
            dlg:IsNotDerivedFrom_wxDialog()
        ENDIF
    ENDIF

    IF onClose != NIL
        dlg:ConnectCloseEvt( dlg:GetId(), wxEVT_CLOSE_WINDOW, onClose )
    ENDIF

    IF initDlg != NIL
        dlg:ConnectInitDialogEvt( dlg:GetId(), wxEVT_INIT_DIALOG, initDlg )
    ENDIF

    containerObj():AddToParentList( dlg )

RETURN dlg

/*
    __wxh_EnableControl
    Teo. Mexico 2009
*/
STATIC PROCEDURE __wxh_EnableControl( evtCtrl, ctrl, id, enabled )
    LOCAL vt := ValType( enabled )

    SWITCH vt
    CASE 'B'
        evtCtrl:ConnectUpdateUIEvt( id, wxEVT_UPDATE_UI, {|updateUIEvent| updateUIEvent:Enable( enabled:Eval() ) } )
        EXIT
    CASE 'L'
        IF ctrl != NIL
            ctrl:Enable( enabled )
        ENDIF
        EXIT
    END

RETURN

/*
 * __wxh_FlexGridSizerBegin
 * Teo. Mexico 2009
 */
PROCEDURE __wxh_FlexGridSizerBegin( rows, cols, vgap, hgap, growableCols, growableRows, stretch, align, border, sideBorders )
    LOCAL sizer
    LOCAL parent
    LOCAL lastSizer
    LOCAL itm

    sizer := wxFlexGridSizer():New( rows, cols, vgap, hgap )

    IF !Empty( growableRows )
        FOR EACH itm IN growableRows
            sizer:AddGrowableRow( itm )	 // ROW 1 becomes ROW 0
        NEXT
    ENDIF

    IF !Empty( growableCols )
        FOR EACH itm IN growableCols
            sizer:AddGrowableCol( itm )	 // COLUMN 1 becomes COLUMN 0
        NEXT
    ENDIF

    parent := containerObj():LastParent()
    lastSizer := containerObj():LastSizer

    IF lastSizer == NIL
        __wxh_SetSizer( parent, sizer )
    ELSE
        __wxh_SizerInfoAdd( sizer, lastSizer, stretch, align, border, sideBorders )
    ENDIF

    containerObj():AddToSizerList( sizer )

RETURN

/*
    __wxh_Frame
    Teo. Mexico 2009
*/
FUNCTION __wxh_Frame( frameType, fromClass, oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName, onClose )
    LOCAL oWnd

    IF Empty( fromClass )

        DO CASE
        CASE frameType == "MDIPARENT"
            oWnd := wxMDIParentFrame():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
        CASE frameType == "MDICHILD"
            oWnd := wxMDIChildFrame():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
        OTHERWISE
            oWnd := wxFrame():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
        ENDCASE

    ELSE

        oWnd := __ClsInstFromName( fromClass ):New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )

        DO CASE
        CASE frameType == "MDIPARENT"
            IF !oWnd:IsDerivedFrom( "wxMDIParentFrame" )
                oWnd:IsNotDerivedFrom_wxMDIParentFrame()
            ENDIF
        CASE frameType == "MDICHILD"
            IF !oWnd:IsDerivedFrom( "wxMDIChildFrame" )
                oWnd:IsNotDerivedFrom_wxMDIChildFrame()
            ENDIF
        OTHERWISE
            IF !oWnd:IsDerivedFrom( "wxFrame" )
                oWnd:IsNotDerivedFrom_wxFrame()
            ENDIF
        ENDCASE

    ENDIF

    IF onClose != NIL
        oWnd:ConnectCloseEvt( oWnd:GetId(), wxEVT_CLOSE_WINDOW, onClose )
    ENDIF

    containerObj():AddToParentList( oWnd )

RETURN oWnd

/*
    __wxh_Gauge
    Teo. Mexico 2009
*/
FUNCTION __wxh_Gauge( window, id, range, pos, size, style, validator, name, type )
    LOCAL gauge

    IF window == NIL
        window := containerObj():LastParent()
    ENDIF

    IF type != NIL
        IF style == NIL
            style := type
        ELSE
            style := HB_BitOr( style, type )
        ENDIF
    ENDIF

    gauge := wxGauge():New( window, id, range, pos, size, style, validator, name )

    containerObj():SetLastChild( gauge )

RETURN gauge

/*
    __wxh_GetBitmapResource
    Teo. Mexico 2009
*/
FUNCTION __wxh_GetBitmapResource( bmp )
    LOCAL bitmap

    SWITCH ValType( bmp )
    CASE 'C'
        IF File( bmp )
            bitmap := wxBitmap():New()
            IF Upper( Right( bmp, 3 ) ) == "XPM"
                bitmap:LoadFile( bmp, wxBITMAP_TYPE_XPM )
            ELSEIF Upper( Right( bmp, 3 ) ) == "BMP"
                bitmap:LoadFile( bmp, wxBITMAP_TYPE_BMP )
            ELSEIF Upper( Right( bmp, 3 ) ) == "GIF"
                bitmap:LoadFile( bmp, wxBITMAP_TYPE_GIF )
            ELSEIF Upper( Right( bmp, 3 ) ) == "XBM"
                bitmap:LoadFile( bmp, wxBITMAP_TYPE_XBM )
            ELSEIF Upper( Right( bmp, 3 ) ) == "JPG"
                bitmap:LoadFile( bmp, wxBITMAP_TYPE_JPEG )
            ELSEIF Upper( Right( bmp, 3 ) ) == "PNG"
                bitmap:LoadFile( bmp, wxBITMAP_TYPE_PNG )
            ELSEIF Upper( Right( bmp, 3 ) ) == "PCX"
                bitmap:LoadFile( bmp, wxBITMAP_TYPE_PCX )
            ENDIF
            IF bitmap:IsOk()
                EXIT
            ENDIF
        ENDIF
        bitmap := wxBitmap():New( 0 )	 // missing image
        EXIT
    CASE 'O'
        IF bmp:IsDerivedFrom("wxBitmap")
            bitmap := bmp
        ENDIF
        EXIT
    CASE 'N'
        bitmap := wxBitmap():New( bmp )
        EXIT
    OTHERWISE
        bitmap := wxBitmap():New( 0 )	 // missing image
    END

RETURN bitmap


/*
    __wxh_Grid
    Teo. Mexico 2009
 */
FUNCTION __wxh_Grid( fromClass, window, id, pos, size, style, name, rows, cols, readOnly )
    LOCAL grid

    IF window == NIL
        window := containerObj():LastParent()
    ENDIF

    IF fromClass = NIL
        grid := wxGrid()
    ELSE
        grid := __ClsInstFromName( fromClass )
    ENDIF
    
    grid:New( window, id, pos, size, style, name )

    grid:EnableEditing( ! readOnly )

    IF cols != NIL .OR. rows != NIL
        grid:CreateGrid( rows, cols )
    ENDIF

    containerObj():SetLastChild( grid )

RETURN grid

/*
 * __wxh_GridSizerBegin
 * Teo. Mexico 2009
 */
PROCEDURE __wxh_GridSizerBegin( rows, cols, vgap, hgap, stretch, align, border, sideBorders )
    LOCAL sizer
    LOCAL parent
    LOCAL lastSizer

    sizer := wxGridSizer():New( rows, cols, vgap, hgap )

    parent := containerObj():LastParent()
    lastSizer := containerObj():LastSizer

    IF lastSizer == NIL
        __wxh_SetSizer( parent, sizer )
    ELSE
        __wxh_SizerInfoAdd( sizer, lastSizer, stretch, align, border, sideBorders )
    ENDIF

    containerObj():AddToSizerList( sizer )

RETURN

/*
    __wxh_HtmlWindow
    Teo. Mexico 2010
*/
FUNCTION __wxh_HtmlWindow( parent, id, pos, size, style, name )
    LOCAL htmlWindow

    IF parent == NIL
        parent := containerObj():LastParent()
    ENDIF

    htmlWindow := wxHtmlWindow():New( parent, id, pos, size, style, name )

    containerObj():SetLastChild( htmlWindow )

RETURN htmlWindow

/*
    __wxh_ListCtrl
    Teo. Mexico 2009
*/
FUNCTION __wxh_ListCtrl( window, id, value, pos, size, style, validator, name, actionBlock )
    LOCAL listCtrl

    IF window == NIL
        window := containerObj():LastParent()
    ENDIF

    listCtrl := wxListCtrl():New( window, id, value, pos, size, style, validator, name )

    IF actionBlock != NIL
        listCtrl:ConnectCommandEvt( listCtrl:GetID(), wxEVT_COMMAND_TEXT_UPDATED, actionBlock )
    ENDIF

    containerObj():SetLastChild( listCtrl )

RETURN listCtrl

/*
    __wxh_MenuBarBegin
    Teo. Mexico 2009
*/
FUNCTION __wxh_MenuBarBegin( window, style )
    menuData := TGlobal():New()
    menuData:g_menuBar := wxMenuBar():New( style )
    IF window == NIL
        //menuData:g_window := __wxh_LastTopLevelWindow()
        menuData:g_window := containerObj():LastParent( "wxFrame" )
    ELSE
        menuData:g_window := window
    ENDIF
RETURN menuData:g_menuBar

/*
    __wxh_MenuBegin
    Teo. Mexico 2009
*/
FUNCTION __wxh_MenuBegin( title, evtHandler, firstId )
    LOCAL hData := {=>}
    LOCAL menu

    IF menuData == NIL
        menuData := TGlobal():New()
        AAdd( menuData:g_menuList, NIL ) /* a NULL MenuBar (1st item in array) */
    ENDIF

    IF firstId != NIL
        hData["lastMenuID"] := menuData:g_menuID
        menuData:g_menuID := firstId
    ENDIF

    IF evtHandler != NIL
        menuData:g_window := evtHandler
    ENDIF

    menu := wxMenu():New()
    hData["menu"] := menu
    hData["title"] := title
    AAdd( menuData:g_menuList, hData )

RETURN menu

/*
    __wxh_MenuEnd
    Teo. Mexico 2009
*/
PROCEDURE __wxh_MenuEnd
    LOCAL hData
    LOCAL menuListSize
    LOCAL menuItem
    LOCAL nLast
    LOCAL parentMenu

    IF Empty( menuData:g_menuList )
        menuData:g_window:SetMenuBar( menuData:g_menuBar )
        menuData := NIL
        RETURN
    ENDIF

    nLast := menuData:lenMenuList

    hData := menuData:g_menuList[ nLast ]

    menuListSize := Len( menuData:g_menuList )

    IF menuListSize = 1 /* Append to menuBar */

        menuData:g_menuBar:Append( hData["menu"], hData["title"] )

    ELSE								/* Append SubMenu */

        parentMenu := menuData:g_menuList[ nLast -1 ]

        IF parentMenu == NIL
            menuData := NIL
            RETURN
        ELSE
            menuItem := wxMenuItem():New( parentMenu["menu"], menuData:g_menuID++, hData["title"], "", wxITEM_NORMAL, hData["menu"] )
            parentMenu["menu"]:Append( menuItem )
        ENDIF

    ENDIF

    ASize( menuData:g_menuList, menuListSize - 1)

    /* pop last menu ID when FIRST_ID is specified in __wxh_MenuBegin */
    IF HB_HHasKey( hData, "lastMenuID" )
        menuData:g_menuID := hData["lastMenuID"]
    ENDIF

RETURN

/*
    __wxh_MenuItemAdd
    Teo. Mexico 2009
*/
FUNCTION __wxh_MenuItemAdd( id, text, helpString, kind, bmp, actionBlock, enabled )
    LOCAL menu
    LOCAL menuItem
    LOCAL nLast
    LOCAL bitmap

    IF id=NIL
        id := menuData:g_menuID++
    ENDIF

    IF menuData:g_menuList == NIL
        wxhAlert( "No Menu at sight to add this MenuItem. Check your DEFINE MENU and ADD MENUITEM definition at line " + LTrim(Str(ProcLine( 1 ))) + " on " + ProcName( 1 ) )
        RETURN NIL
    ENDIF

    nLast := menuData:lenMenuList
    menu := menuData:g_menuList[ nLast ]["menu"]

    menuItem := wxMenuItem():New( menu, id, text, helpString, kind )
    IF bmp != NIL
        bitmap := __wxh_GetBitmapResource( bmp )
        IF bitmap != NIL
            menuItem:SetBitmap( bitmap )
        ENDIF
    ENDIF

    menu:Append( menuItem )

    IF actionBlock = NIL
        menuItem:Enable( .F. )
    ELSE
        menuData:g_window:ConnectCommandEvt( id, wxEVT_COMMAND_MENU_SELECTED, actionBlock )
    ENDIF

    __wxh_EnableControl( containerObj():LastParent(), menuItem, id, enabled )

RETURN menuItem

/*
 * __wxh_PanelBegin
 * Teo. Mexico 2009
 */
FUNCTION __wxh_PanelBegin( parent, id, pos, size, style, name, bEnabled, fromClass )
    LOCAL panel

    IF parent == NIL
        parent := containerObj():LastParent()
    ENDIF

    IF !Empty( fromClass )
        panel := __ClsInstFromName( fromClass ):New( parent, id, pos, size, style, name )
    ELSE
        panel := wxPanel():New( parent, id, pos, size, style, name )
    ENDIF

    __wxh_EnableControl( parent, panel, panel:GetId(), bEnabled )

    containerObj():SetLastChild( panel )

    containerObj():AddToParentList( panel )

RETURN panel

/*
    __wxh_PanelEnd
    Teo. Mexico 2009
*/
PROCEDURE __wxh_PanelEnd
    containerObj():RemoveLastParent( "wxPanel" )
RETURN

/*
    __wxh_RadioBox
    Teo. Mexico 2009
*/
FUNCTION __wxh_RadioBox( parent, id, label, point, size, choices, specRC, majorDimension, style, name, enabled )
    LOCAL radioBox
    LOCAL validator

    IF parent == NIL
        parent := containerObj():LastParent()
    ENDIF

    validator := containerObj():LastItem()[ "wxhHBValidator" ]

    IF specRC != NIL
        IF style = NIL
            style := 0
        ENDIF
        style := HB_BitOr( style, specRC )
    ENDIF

    radioBox := wxRadioBox():New( parent, id, label, point, size, validator:GetChoices( choices ), majorDimension, style, validator, name )

    validator:AddPostInfo()

    __wxh_EnableControl( containerObj():LastParent(), radioBox, radioBox:GetId(), enabled )

    containerObj():SetLastChild( radioBox )

RETURN radioBox

/*
 * __wxh_SAY
 * Teo. Mexico 2009
 */
FUNCTION __wxh_SAY( window, id, label, pos, size, style, name )
    LOCAL Result

    IF window == NIL
        window := containerObj():LastParent()
    ENDIF

    __wxh_TransWidth( NIL, window, Len( label ), size )

    Result := wxStaticText():New( window, id, label, pos, size, style, name )

    containerObj():SetLastChild( Result )

RETURN Result

/*
    __wxh_ScrollBar
    Teo. Mexico 2009
*/
FUNCTION __wxh_ScrollBar( window, id, pos, size, orient, style, validator, name, actionBlock )
    LOCAL sb

    IF window == NIL
        window := containerObj():LastParent()
    ENDIF

    IF Empty( style )
        style := orient
    ELSE
        style := HB_BitOr( orient, style )
    ENDIF

    sb := wxScrollBar():New( window, id, pos, size, style, validator, name )
    sb:SetScrollbar( 0, 1, 100, 1)

    IF actionBlock != NIL
        sb:ConnectCommandEvt( sb:GetID(), wxEVT_COMMAND_BUTTON_CLICKED, actionBlock )
    ENDIF

    containerObj():SetLastChild( sb )

RETURN sb

/*
    __wxh_SearchCtrl
    Teo. Mexico 2009
*/
FUNCTION __wxh_SearchCtrl( window, id, pos, size, style, name, onSearch, onCancel )
    LOCAL searchCtrl
    LOCAL validator

    IF window == NIL
        window := containerObj():LastParent()
    ENDIF

    validator := containerObj():LastItem()[ "wxhHBValidator" ]

    /* nextCtrlOnEnter */
    /*
    IF nextCtrlOnEnter
        IF style == NIL
            style := wxTE_PROCESS_ENTER
        ELSE
            style := HB_BitOr( style, wxTE_PROCESS_ENTER )
        ENDIF
    ENDIF
    */

    searchCtrl := wxSearchCtrl():New( window, id, NIL, pos, size, style, validator, name )

    IF onSearch != NIL
        validator:onSearch := onSearch
    ENDIF

    IF onCancel != NIL
        searchCtrl:ConnectCommandEvt( searchCtrl:GetID(), wxEVT_COMMAND_SEARCHCTRL_CANCEL_BTN, onCancel )
    ENDIF

    validator:AddPostInfo()

    containerObj():SetLastChild( searchCtrl )

RETURN searchCtrl

/*
    __wxh_SetSizer
    Teo. Mexico 2009
*/
PROCEDURE __wxh_SetSizer( window, sizer )
    LOCAL bookCtrl
    LOCAL IsWindowBook := .F.

    FOR EACH bookCtrl IN containerObj():BookCtrls
        IF window:IsDerivedFrom( bookCtrl )
            IsWindowBook := .T.
        ENDIF
    NEXT

    IF IsWindowBook
        wxhAlert( "Sizer cannot be a direct child of a " + window:ClassName() + " control.;Check your Sizer definition at line " + LTrim(Str(ProcLine(2))) + " on " + ProcName( 2 ) )
    ENDIF

    window:SetSizer( sizer )

RETURN

/*
    __wxh_ShowWindow : shows wxFrame/wxDialog
    Teo. Mexico 2009
*/
FUNCTION __wxh_ShowWindow( oWnd, modal, fit, centre )
    LOCAL Result
    LOCAL ctrl

    containerObj():ClearData()

    IF fit
        IF oWnd:GetSizer() != NIL
            oWnd:GetSizer():SetSizeHints( oWnd )
        ENDIF
    ENDIF

    IF centre
        oWnd:Centre()
    ENDIF

    /* Transfer data to windows for wxFrame's (this in wxDialog's are automatically) */
    IF oWnd:IsDerivedFrom("wxFrame")
        oWnd:TransferDataToWindow()
    ENDIF

    IF .T. /* Focus on first available control */
        FOR EACH ctrl IN oWnd:GetChildren()
            IF ctrl != NIL .AND. ctrl:IsDerivedFrom("wxTextCtrl")
                ctrl:SetFocus()
                EXIT
            ENDIF
        NEXT
    ENDIF

    IF modal
        IF !oWnd:IsDerivedFrom("wxDialog")
            oWnd:IsNotDerivedFrom_wxDialog()
        ENDIF
        Result := oWnd:ShowModal()
    ELSE
        Result := oWnd:Show( .T. )
    ENDIF

RETURN Result

/*
 * __wxh_SizerEnd
 * Teo. Mexico 2009
 */
PROCEDURE __wxh_SizerEnd
    containerObj():RemoveLastSizer()
RETURN

/*
 * __wxh_SizerInfoAdd
 * Teo. Mexico 2009
 */
PROCEDURE __wxh_SizerInfoAdd( child, parentSizer, stretch, align, border, sideBorders, flag, useLast, addSizerInfoToLastItem )
    LOCAL sizerInfo

    IF Empty( containerObj():ParentList )
        RETURN
    ENDIF

    IF HB_HHasKey( containerObj():LastItem(), "ignoreSizerInfoAdd" )
        HB_HDel( containerObj():LastItem(), "ignoreSizerInfoAdd" )
        RETURN
    ENDIF

    IF child == NIL .AND. ! ( addSizerInfoToLastItem == .T. )

        /* Check if last child has been processed */
        IF containerObj():GetLastChild()[ "processed" ]
            RETURN
        ENDIF

        child := containerObj():GetLastChild()[ "child" ]
        sizerInfo := containerObj():GetLastChild()[ "sizerInfo" ]

        /* no sizerInfo available */
        IF sizerInfo == NIL
            RETURN
        ENDIF

        containerObj():GetLastChild()[ "processed" ] := .T. /* mark processed */

        stretch			:= sizerInfo[ "stretch" ]
        align				:= sizerInfo[ "align" ]
        border			:= sizerInfo[ "border" ]
        sideBorders := sizerInfo[ "sideBorders" ]
        flag				:= sizerInfo[ "flag" ]

    ENDIF

    /* collect default parentSizer */
    IF parentSizer == NIL
        /* check if we have a parent control */
        IF containerObj():GetLastChild()[ "child" ] == NIL
            IF containerObj():GetLastParent( -1 ) != NIL
                parentSizer := ATail( containerObj():GetLastParent( -1 )[ "sizers" ] )
            ENDIF
        ELSE
            parentSizer := containerObj():LastSizer()
        ENDIF
    ENDIF

    IF parentSizer == NIL
        //wxhAlert( "No parent Sizer available.", {"QUIT"})
        //TRACE "Child:", child:ClassName, "No parent Sizer available"
        RETURN
    ENDIF

    IF stretch == NIL
        stretch := 0
    ENDIF

    IF align == NIL
        IF parentSizer != NIL
            IF parentSizer:IsDerivedFrom("wxGridSizer")
                align := HB_BitOr( wxALIGN_CENTER_HORIZONTAL, wxALIGN_CENTER_VERTICAL )
            ELSE
                IF parentSizer:GetOrientation() = wxVERTICAL
                    align := HB_BitOr( wxALIGN_CENTER_HORIZONTAL, wxALL )
                ELSE
                    align := HB_BitOr( wxALIGN_CENTER_VERTICAL, wxALL )
                ENDIF
            ENDIF
        ELSE
            align := 0
        ENDIF
    ENDIF

    /* TODO: Make a more configurable way to do this */
    IF parentSizer != NIL .AND. parentSizer:IsDerivedFrom("wxGridSizer")
        align := HB_BitOr( align, wxALIGN_CENTER_VERTICAL )
    ENDIF

    IF sideBorders == NIL
        sideBorders := wxALL
    ENDIF

    IF border == NIL
        border := 5
    ENDIF

    IF flag == NIL
        flag := 0
    ENDIF

    /* just add to last item */
    IF addSizerInfoToLastItem == .T.

        IF ! useLast == .T.
            sizerInfo := { "stretch"=>stretch, "align"=>align, "border"=>border, "sideBorders"=>sideBorders, "flag"=>flag }
            containerObj():AddSizerInfoToLastItem( sizerInfo )
        ENDIF

        RETURN

    ENDIF

    containerObj():SizerAddOnLastChild()

    parentSizer:Add( child, stretch, HB_BitOr( align, sideBorders, flag ), border )

RETURN

/*
 * __wxh_Spacer
 * Teo. Mexico 2009
 */
PROCEDURE __wxh_Spacer( width, height, stretch, align, border )
    LOCAL lastSizer

    containerObj():SizerAddOnLastChild()

    lastSizer := containerObj():LastSizer()

    IF lastSizer == NIL
        wxhAlert( "No Sizer available to add a Spacer",{"QUIT"})
        RETURN
    ENDIF

    IF width == NIL
        width := 5
    ENDIF

    IF height == NIL
        height := 5
    ENDIF

    IF stretch == NIL
        stretch := 1
    ENDIF

    IF align == NIL
        IF lastSizer:IsDerivedFrom("wxBoxSizer")
            IF !lastSizer:GetOrientation() = wxHORIZONTAL
                align := HB_BitOr( wxALIGN_CENTER_HORIZONTAL, wxALL )
            ELSE
                align := HB_BitOr( wxALIGN_CENTER_VERTICAL, wxALL )
            ENDIF
        ENDIF
    ENDIF

    IF border == NIL
        border := 5
    ENDIF

    lastSizer:Add( width, height, stretch, align, border )

RETURN

/*
    __wxh_SpinCtrl
    Teo. Mexico 2009
*/
FUNCTION __wxh_SpinCtrl( parent, id, pos, size, style, min, max, name )
    LOCAL spinCtrl
    LOCAL validator

    IF parent == NIL
        parent := containerObj():LastParent()
    ENDIF

    validator := containerObj():LastItem()[ "wxhHBValidator" ]

    spinCtrl := wxSpinCtrl():New( parent, id, /* value */, pos, size, style, min, max, 0 /* initial */, name )

    spinCtrl:SetValidator( validator )

    validator:AddPostInfo()

    containerObj():SetLastChild( spinCtrl )

RETURN spinCtrl

/*
    __wxh_StaticBitmap
    Teo. Mexico 2009
*/
FUNCTION __wxh_StaticBitmap( parent, id, label, pos, size, style, name )
    LOCAL staticBitmap
    LOCAL bmp

    IF parent == NIL
        parent := containerObj():LastParent()
    ENDIF

    bmp := __wxh_GetBitmapResource( label )

    staticBitmap := wxStaticBitmap():New( parent, id, bmp, pos, size, style, name )

    containerObj():SetLastChild( staticBitmap )

RETURN staticBitmap

/*
    __wxh_StaticLine
    Teo. Mexico 2009
*/
FUNCTION __wxh_StaticLine( window, id, pos, orient, name )
    LOCAL sl

    IF window == NIL
        window := containerObj():LastParent()
    ENDIF

    sl := wxStaticLine():New( window, id, pos, NIL, orient, name )

    containerObj():SetLastChild( sl )

RETURN sl

/*
    __wxh_StaticText
    Teo. Mexico 2009
*/
FUNCTION __wxh_StaticText( parent, id, label, pos, size, style, name )
    LOCAL staticText

    IF parent == NIL
        parent := containerObj():LastParent()
    ENDIF

    staticText := wxStaticText():New( parent, id, label, pos, size, style, name )

    containerObj():SetLastChild( staticText )

RETURN staticText

/*
    __wxh_StatusBar
    Teo. Mexico 2009
*/
FUNCTION __wxh_StatusBar( oW, id, style, name, fields, widths )
    LOCAL sb

    IF oW == NIL
        oW := containerObj():LastParent()
    ENDIF

    sb := wxStatusBar():New( oW, id, style, name )

    IF widths!=NIL .AND. fields=NIL
        fields := Len( widths )
    ENDIF

    IF fields != NIL
        sb:SetFieldsCount( fields, widths )
    ENDIF

    oW:SetStatusBar( sb )

RETURN sb

/*
 * __wxh_TextCtrl
 * Teo. Mexico 2009
 */
FUNCTION __wxh_TextCtrl( parent, id, pos, size, multiLine, style, name, noEditable, toolTip, enabled )
    LOCAL textCtrl
    LOCAL validator
    LOCAL pickBtn

    IF parent == NIL
        parent := containerObj():LastParent()
    ENDIF

    validator := containerObj():LastItem()[ "wxhHBValidator" ]

    IF multiLine == .T.
        IF Empty( style )
            style := wxTE_MULTILINE
        ELSE
            style := HB_BitOr( wxTE_MULTILINE, style )
        ENDIF
    ENDIF

    //__wxh_TransWidth( NIL, window, Len( wxhHBValidator:AsString ), size )

    /* nextCtrlOnEnter */
    /*
    IF nextCtrlOnEnter
        IF style == NIL
            style := wxTE_PROCESS_ENTER
        ELSE
            style := HB_BitOr( style, wxTE_PROCESS_ENTER )
        ENDIF
    ENDIF
    */

    pickBtn := validator:Field != NIL .AND. !validator:Field:PickList == NIL

    IF size != NIL .AND. HB_IsChar( size[ 1 ] )
        size[ 1 ] := Val( size[ 1 ] ) * parent:GetPointSize()
    ENDIF

    IF pickBtn
#ifdef HB_OS_MAC
        textCtrl := wxSearchCtrl():New( parent, id, NIL, pos, size, style, validator, name )
#else
        /* TODO: Fix this, using wxSearchCtrl with wxMSW */
        textCtrl := wxTextCtrl():New( parent, id, NIL, pos, size, style, validator, name )
#endif
    ELSE
        textCtrl := wxTextCtrl():New( parent, id, NIL, pos, size, style, validator, name )
    ENDIF

    IF noEditable != NIL
        textCtrl:SetEditable( .F. )
    ENDIF

    IF toolTip != NIL
        textCtrl:SetToolTip( toolTip )
    ENDIF

    validator:AddPostInfo()

    __wxh_EnableControl( containerObj():LastParent(), textCtrl, textCtrl:GetId(), enabled )

    containerObj():SetLastChild( textCtrl )

RETURN textCtrl

/*
    __wxh_ToolAdd
    Teo. Mexico 2009
*/
PROCEDURE __wxh_ToolAdd( type, toolId, label, bmp1, bmp2, shortHelp, longHelp, clientData, actionBlock, enabled )
    LOCAL toolBar
    LOCAL tbtb		// toolBarToolBase
    LOCAL bitmap1, bitmap2

    toolBar := containerObj:LastParent()

    IF toolBar != NIL .AND. toolBar:IsDerivedFrom("wxToolBar")

        IF type == "SEPARATOR"

            toolBar:AddSeparator()

        ELSE

            bitmap1 := __wxh_GetBitmapResource( bmp1 )
            bitmap2 := __wxh_GetBitmapResource( bmp2 )

            IF type == "CHECK"
                tbtb := toolBar:AddCheckTool( toolId, label, bitmap1, bitmap2, shortHelp, longHelp, clientData )
            ELSEIF type == "RADIO"
                tbtb := toolBar:AddRadioTool( toolId, label, bitmap1, bitmap2, shortHelp, longHelp, clientData )
            ELSEIF type == "BUTTON"
                tbtb := toolBar:AddTool( toolId, label, bitmap1, bitmap2, NIL, shortHelp, longHelp, clientData )
            ENDIF

            IF tbtb != NIL
                IF actionBlock != NIL
                    toolBar:ConnectCommandEvt( toolId, wxEVT_COMMAND_MENU_SELECTED, actionBlock )
                ENDIF
                __wxh_EnableControl( toolBar, tbtb, toolId, enabled )
            ENDIF

        ENDIF

    ELSE

        wxhAlert( "ToolBar control not in sight..." )

    ENDIF

RETURN

/*
 * __wxh_ToolBarBegin
 * Teo. Mexico 2009
 */
FUNCTION __wxh_ToolBarBegin( parent, id, toFrame, pos, size, style, name )
    LOCAL toolBar

    IF parent == NIL
        parent := containerObj():LastParent()
    ENDIF

    IF style = NIL
        style := HB_BitOr( wxTB_HORIZONTAL, wxNO_BORDER, wxTB_TEXT )
    ENDIF

    IF toFrame == .T.
        IF parent:IsDerivedFrom("wxFrame")
            toolBar := parent:CreateToolBar( style, id, name )
        ELSE
            wxhAlert( "Frame not in sight..." )
        ENDIF
    ELSE
        toolBar := wxToolBar():New( parent, id, pos, size, style, name )
    ENDIF

    containerObj():SetLastChild( toolBar )

    containerObj():AddToParentList( toolBar )

RETURN toolBar

/*
    __wxh_ToolBarEnd
    Teo. Mexico 2009
*/
PROCEDURE __wxh_ToolBarEnd()
    LOCAL toolBar

    toolBar := containerObj():LastParent()
    toolBar:Realize()

    containerObj():RemoveLastParent( "wxToolBar" )

RETURN

/*
    __wxh_TransWidth
    Teo. Mexico 2009
*/
STATIC FUNCTION __wxh_TransWidth( width, window, defaultWidth, aSize )
    LOCAL pointSize

    IF window != NIL

        pointSize := window:GetPointSize() - 3

        IF aSize != NIL
            width := aSize[ 1 ]
        ENDIF

        IF width == NIL
            width := -1
        ENDIF

        IF HB_ISCHAR( width )
            width := pointSize * Val( width )
        ELSEIF ( width == NIL .OR. ( HB_ISNUMERIC( width ) .AND. width = -1 ) ) .AND. defaultWidth != NIL
            width := pointSize * defaultWidth
        ENDIF

        IF aSize != NIL
            aSize[ 1 ] := width
        ENDIF

    ENDIF

RETURN width

/*
    __wxh_TreeCtrl
    Teo. Mexico 2009
 */
FUNCTION __wxh_TreeCtrl( window, id, pos, size, style, validator, name )
    LOCAL Result

    IF window == NIL
        window := ContainerObj():LastParent()
    ENDIF

    Result := wxTreeCtrl():New( window, id, pos, size, style, validator, name )

    containerObj():SetLastChild( Result )

RETURN Result

/*
    wxhInspectVar
    Teo. Mexico 2009
*/
PROCEDURE wxhInspectVar( xVar )
    LOCAL oDlg
    LOCAL aMsg
    LOCAL value
    LOCAL cMsg,msgAccs
    LOCAL a,aMethods
    LOCAL oErr

    SWITCH ValType( xVar )
    CASE 'O'
        aMsg := xVar:ClassSel()
        ASort( aMsg,,, {|x,y| PadR( x, 64 ) < PadR( y, 64 ) } )
        a := {}
        aMethods := {}

        FOR EACH cMsg IN aMsg
            msgAccs := SubStr( cMsg, 2 )
            IF cMsg = "_" .AND. AScan( aMsg, msgAccs,,, .T. ) != 0
                BEGIN SEQUENCE WITH {|oErr| break( oErr ) }
                    //value := AsString( __wxh_objGetDataValue( xVar, msgAccs ) )
                    value := "xVar:msgAccs"
                RECOVER USING oErr
                    value := oErr:Description
                END SEQUENCE
                AAdd( a, { msgAccs, value })
            ELSEIF AScan( aMsg, "_" + msgAccs,,, .T. ) = 0
                AAdd( aMethods, msgAccs )
            ENDIF
        NEXT
        a := __objGetValueList( xVar, .T., 0 )
        EXIT
    END

    IF Empty( a )
        wxMessageBox("Cannot inspect value.","wxhInspectVar", HB_BitOr( wxOK, wxICON_EXCLAMATION ) )
        RETURN
    ENDIF

    CREATE DIALOG oDlg ;
                 HEIGHT 800 WIDTH 600 ;
                 TITLE "Inspecting Var: "

    BEGIN BOXSIZER VERTICAL
        @ BROWSE DATASOURCE a ;
            SIZERINFO ALIGN EXPAND STRETCH
        BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
            @ BUTTON ID wxID_CLOSE ACTION oDlg:Close()
        END SIZER
    END SIZER

    SHOW WINDOW oDlg MODAL CENTRE

RETURN

/*
    TContainerObj
    Teo. Mexico 2009
*/
CLASS TContainerObj
PRIVATE:
    DATA FMainContainerStack INIT {}
    METHOD GetParentList INLINE ATail( ::FMainContainerStack )
PROTECTED:
PUBLIC:
    DATA BookCtrls INIT { "wxNotebook", "wxListbook", "wxAuiNotebook" }
    METHOD AddSizerInfoToLastItem( sizerInfo )
    METHOD AddToNextBookPage( hInfo )
    METHOD AddToParentList( parent )
    METHOD AddToSizerList( sizer )
    METHOD CheckForAddPage
    METHOD ClearData
    METHOD GetLastChild
    METHOD GetLastParent( index )
    METHOD LastItem INLINE ATail( ATail( ::FMainContainerStack ) )
    METHOD LastParent
    METHOD LastSizer
    METHOD RemoveLastParent
    METHOD RemoveLastSizer
    METHOD SetLastChild( child )
    METHOD SizerAddOnLastChild
    PROPERTY ParentList READ GetParentList
PUBLISHED:
ENDCLASS

/*
    AddSizerInfoToLastItem
    Teo. Mexico 2009
*/
METHOD PROCEDURE AddSizerInfoToLastItem( sizerInfo ) CLASS TContainerObj

    /* if has not child yet defined then is a parent ctrl */
    IF ATail( ::ParentList )[ "lastChild" ][ "child" ] == NIL
        /* control is in lastChild in the previuos Parent list */
        IF ::GetLastParent( -1 ) != NIL
            ::GetLastParent( -1 )[ "lastChild" ][ "sizerInfo" ] := sizerInfo
        ENDIF
    ELSE
        ATail( ::ParentList )[ "lastChild" ][ "sizerInfo" ] := sizerInfo
    ENDIF

RETURN

/*
    AddToNextBookPage
    Teo. Mexico 2009
*/
METHOD PROCEDURE AddToNextBookPage( hInfo ) CLASS TContainerObj
    LOCAL bookCtrl
    LOCAL IsParentBook := .F.

    FOR EACH bookCtrl IN ::BookCtrls
        IF ::LastParent():IsDerivedFrom( bookCtrl )
            IsParentBook := .T.
        ENDIF
    NEXT

    IF !IsParentBook
        wxhAlert( "Previuos page not a " + bookCtrl + " control" )
        RETURN
    ENDIF

    ATail( ::ParentList )[ "pageInfo" ] := hInfo

RETURN

/*
    AddToParentList
    Teo. Mexico 2009
*/
METHOD PROCEDURE AddToParentList( parent ) CLASS TContainerObj
    LOCAL runtime

    IF Empty( ::ParentList )
        runtime := !parent:IsDerivedFrom("wxTopLevelWindow")
    ELSE
        runtime := ::LastItem["runtime"]
    ENDIF

    IF parent:IsDerivedFrom( "wxFrame" ) .OR. ;
         parent:IsDerivedFrom( "wxDialog" ) .OR. ;
         ::ParentList == NIL
        AAdd( ::FMainContainerStack, {} )
    ENDIF
    IF parent == NIL
        wxhAlert( "Trying to add a NIL value to the ParentList stack",{"QUIT"})
        ::QUIT()
    ENDIF

    parent:SetExtraStyle( wxWS_EX_VALIDATE_RECURSIVELY )

    AAdd( ::ParentList, { "parent"=>parent, "sizers"=>{}, "pageInfo"=>NIL, "lastChild"=>{ "child"=>NIL, "processed"=>.F., "sizerInfo"=>NIL, "wxhHBValidator"=>NIL }, "runtime"=>runtime } )
RETURN

/*
    AddToSizerList
    Teo. Mexico 2009
*/
METHOD PROCEDURE AddToSizerList( sizer ) CLASS TContainerObj
    AAdd( ATail( ::ParentList )[ "sizers" ], sizer )
RETURN

/*
    ClearData
    Teo. Mexico 2009
*/
METHOD PROCEDURE ClearData CLASS TContainerObj
    HB_ADel( ::FMainContainerStack, Len( ::FMainContainerStack ), .T. )
RETURN

/*
    CheckForAddPage
    Teo. Mexico 2009
*/
METHOD PROCEDURE CheckForAddPage( window ) CLASS TContainerObj
    LOCAL hInfo
    LOCAL bookCtrl
    LOCAL IsParentBook := .F.

    FOR EACH bookCtrl IN ::BookCtrls
        IF ::LastParent():IsDerivedFrom( bookCtrl )
            IsParentBook := .T.
        ENDIF
    NEXT

    IF IsParentBook
        hInfo := ATail( ::ParentList )[ "pageInfo" ]
        IF	hInfo != NIL
            ::LastParent():AddPage( window, hInfo["title"], hInfo["select"], hInfo["imageId"] )
            ATail( ::ParentList )[ "pageInfo" ] := NIL
        ELSE
            ::LastParent():AddPage( window, "Tab" )
        ENDIF
    ENDIF

RETURN

/*
    GetLastChild
    Teo. Mexico 2009
*/
METHOD FUNCTION GetLastChild CLASS TContainerObj
    IF Empty( ::ParentList )
        RETURN NIL
    ENDIF
RETURN ATail( ::ParentList )[ "lastChild" ]

/*
    GetLastParent
    Teo. Mexico 2009
*/
METHOD FUNCTION GetLastParent( index ) CLASS TContainerObj
    IF Empty( index )
        RETURN ATail( ::ParentList )
    ENDIF
    index := Len( ::ParentList ) + index
    IF index < 1 .OR. index > Len( ::ParentList )
        RETURN NIL
    ENDIF
RETURN ::ParentList[ index ]

/*
    LastParent
    Teo. Mexico 2009
*/
METHOD FUNCTION LastParent CLASS TContainerObj
    IF Empty( ::ParentList )
        RETURN NIL
    ENDIF
RETURN ATail( ::ParentList )[ "parent" ]

/*
    LastSizer
    Teo. Mexico 2009
*/
METHOD FUNCTION LastSizer CLASS TContainerObj
    IF Empty( ::ParentList )
        RETURN NIL
    ENDIF
RETURN ATail( ATail( ::ParentList )[ "sizers" ] )

/*
    RemoveLastParent
    Teo. Mexico 2009
*/
METHOD PROCEDURE RemoveLastParent( className ) CLASS TContainerObj
    LOCAL lastParent

    /* do some checking */
    IF className != NIL
        IF ! ATail( ::ParentList )[ "parent" ]:IsDerivedFrom( className )
            wxhAlert("Attempt to remove wrong parent on stack (ClassName not equal).;"+Upper( ATail( ::ParentList )[ "parent" ]:ClassName ) + "==" + Upper( className )+";"+"Check for missing/wrong END ... clauses to your controls definition.")
            ::QUIT()
        ENDIF
    ENDIF

    IF ::LastItem["runtime"] .AND. Len( ::ParentList ) <= 2
        lastParent := ::LastItem["parent"]
    ENDIF

    ASize( ::ParentList, Len( ::ParentList ) - 1 )

    ::SizerAddOnLastChild()

    IF lastParent != NIL
        lastParent:Layout()
        IF Empty( ::ParentList )
            lastParent:TransferDataToWindow() /* this will be enough for all child ctrls */
        ENDIF
    ENDIF

RETURN

/*
    RemoveLastSizer
    Teo. Mexico 2009
*/
METHOD PROCEDURE RemoveLastSizer CLASS TContainerObj
    LOCAL a
    a := ATail( ::ParentList )[ "sizers" ]
    IF Empty( a )
        wxhAlert("Attempt to remove a Sizer on a empty sizers stack.",{"QUIT"})
        //::QUIT()
    ENDIF
    ::SizerAddOnLastChild()
    ASize( a, Len( a ) - 1 )
RETURN

/*
    SetLastChild
    Teo. Mexico 2009
*/
METHOD PROCEDURE SetLastChild( child ) CLASS TContainerObj
    LOCAL parent

    IF Empty( ::ParentList )
        RETURN
    ENDIF

    IF ::GetLastChild()[ "child" ] == child
        RETURN
    ENDIF

    parent := ::LastParent()

    IF parent != NIL .AND. parent:IsDerivedFrom("wxToolBar")
        parent:AddControl( child )
    ENDIF

    ::SizerAddOnLastChild()

    ::CheckForAddPage( child )

    ::GetLastChild()[ "child" ] := child
    ::GetLastChild()[ "processed" ] := .F.

RETURN

/*
    SizerAddOnLastChild
    Teo. Mexico 2009
*/
METHOD PROCEDURE SizerAddOnLastChild CLASS TContainerObj
    LOCAL child
    LOCAL sizerInfo

    IF Empty( ::ParentList )
        RETURN
    ENDIF

    child := ::GetLastChild()[ "child" ]

    IF child != NIL .AND. ! ::GetLastChild()[ "processed" ]

        ::GetLastChild()[ "processed" ] := .T. /* avoid infinite recursion */

        sizerInfo := ::GetLastChild()[ "sizerInfo" ]
        ::GetLastChild()[ "sizerInfo" ] := NIL

        IF sizerInfo == NIL
            __wxh_SizerInfoAdd( child )
        ELSE
            __wxh_SizerInfoAdd( child, NIL, sizerInfo[ "stretch" ], sizerInfo[ "align" ], sizerInfo[ "border" ], sizerInfo[ "sideBorders" ], sizerInfo[ "flag" ] )
        ENDIF

    ENDIF

RETURN

/*
    End Class TContainerObj
*/

/*
    TGlobal class to hold global vars...
    Teo. Mexico 2009
*/
CLASS TGlobal
PRIVATE:
PROTECTED:
PUBLIC:
    DATA g_menuID INIT 1
    DATA g_menuList
    DATA g_menuBar
    DATA g_window

    CONSTRUCTOR New()

    METHOD lenMenuList INLINE Len( ::g_menuList )
PUBLISHED:
ENDCLASS

/*
    New
    Teo. Mexico 2009
*/
METHOD New() CLASS TGlobal
    ::g_menuList := {}
RETURN Self

/*
    End Class TGlobal
*/

/*
    wxhDebug
    Teo. Mexico 2011
*/
PROCEDURE wxhDebug( ... )
    STATIC wnd
    STATIC editCtrl
    LOCAL i,value
    
    IF wnd = NIL

        CREATE FRAME wnd ;
            TITLE "Debug Output" ;
            PARENT wxApp():GetTopWindow()
        
        BEGIN BOXSIZER VERTICAL STRETCH

            @ GET VAR editCtrl MULTILINE NOEDITABLE ;
                SIZERINFO ALIGN EXPAND STRETCH

        END SIZER
        
        SHOW WINDOW wnd CENTRE

    ENDIF

    IF PCount() > 0

        FOR i:=1 TO PCount()
        
            value := HB_PValue( i )
        
            SWITCH ValType( value )
            CASE "M"
            CASE "C"
                EXIT
            CASE "N"
                value := NTrim( value )
                EXIT
            CASE "D"
                value := DToC( value )
                EXIT
            CASE "T"
                value := HB_TSToStr( value )
                EXIT
            CASE "L"
                value := iif( value, ".T.", ".F." )
                EXIT
            OTHERWISE
                value := "Unkown: <" + ValType( value ) + ">"
            ENDSWITCH

            editCtrl:AppendText( value + E"\t" )
            
        NEXT
        
        editCtrl:AppendText( E"\n" )
    
    ENDIF
    
RETURN
