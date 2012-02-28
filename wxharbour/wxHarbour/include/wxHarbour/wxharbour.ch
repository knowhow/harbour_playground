/*
 * $Id: wxharbour.ch 799 2012-01-31 16:22:17Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxHarbour.ch
    Teo. Mexico 2009
*/

#ifndef _WXHARBOUR_H_
#define _WXHARBOUR_H_

#xcommand IMPLEMENT_APP( <app> ) => <app>:Implement()

#include "hbclass.ch"
#include "property.ch"
#include "raddox.ch"
#include "wx.ch"

#include "wxh/auibook.ch"
#include "wxh/button.ch"
#include "wxh/gauge.ch"
#include "wxh/notebook.ch"
#include "wxh/textctrl.ch"
#include "wxh/toolbar.ch"
#include "wxh/dateevt.ch"

#define wxhLABEL_QUIT           "Quit"
#define wxhLABEL_RETRY          "Retry"
#define wxhLABEL_DEFAULT        "Default"
#define wxhLABEL_ACCEPT			"Accept"

/* CheckBox 3 states */
#define wxCHK_UNCHECKED         0
#define wxCHK_CHECKED           1
#define wxCHK_UNDETERMINED      2

#define WXH_UNUSED( var )        ( var )

/*
    Validator macro
    Teo. Mexico 2009
*/
#xcommand @ PUSHVALIDATOR [<dataVar>] [ PICTURE <picture> ] [ VALIDATE <bValidate> ] [ WARN <warnMsg> ] [ ACTION <bAction> ] ;
            => ;
            containerObj():LastItem()\[ "wxhHBValidator" \] := wxhHBValidator():New( [<"dataVar">], [<dataVar>], NIL, [{|__localVal| iif( PCount() > 0, <dataVar> := __localVal, <dataVar> ) }], [<picture>], [<bValidate>], [<{bValidate}>], [<warnMsg>], [<{bAction}>] )

#xcommand @ PUSHVALIDATOR [<dataVar>] FIELD <fld> [ PICTURE <picture> ] [ VALIDATE <bValidate> ] [ WARN <warnMsg> ] [ ACTION <bAction> ] ;
            => ;
            containerObj():LastItem()\[ "wxhHBValidator" \] := wxhHBValidator():New( [<"dataVar"> + ":DataObj:" + <"fld">], [<dataVar>]:DataObj:<fld>, <dataVar>, [{|__localVal| iif( PCount() > 0, <dataVar>:DataObj:<fld> := __localVal, <dataVar>:DataObj:<fld> ) }], [<picture>], [<bValidate>], [<{bValidate}>], [<warnMsg>], [<{bAction}>] )

/*
    Calls ::__Destroy() to remove xho_Item associated to objects
    Teo. Mexico 2009
*/
#xcommand DESTROY <obj> => <obj>:__Destroy() ; <obj> := NIL

/*
    MessageBox
*/
#define wxhMessageBoxYesNo( title, mess, parent ) ;
                wxMessageBox( mess, title, HB_BitOr(wxYES_NO,wxICON_QUESTION), parent )

/*
    NTrim
*/
#define NTrim( n ) ;
                LTrim( Str( n ) )

/*!
 * Frame/Dialog
 */
#xcommand CREATE [<type: MDIPARENT,MDICHILD>] FRAME <oFrame> ;
                    [ CLASS <fromClass> ] ;
                    [ PARENT <parent> ] ;
                    [ ID <nID> ] ;
                    [ TITLE <cTitle> ] ;
                    [ FROM <nTop>, <nLeft> ] [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                    [ STYLE <nStyle> ] ;
                    [ NAME <cName> ] ;
                    [ ON CLOSE <onClose> ] ;
                    => ;
                    <oFrame> := __wxh_Frame( [<"type">], [<fromClass>], [<parent>], [<nID>], <cTitle>, {<nTop>,<nLeft>}, {<nWidth>,<nHeight>}, [<nStyle>], [<cName>], [<{onClose}>] )

#xcommand CREATE DIALOG <oDlg> ;
                    [ CLASS <fromClass> ] ;
                    [ PARENT <parent> ] ;
                    [ ID <nID> ] ;
                    [ TITLE <cTitle> ] ;
                    [ FROM <nTop>, <nLeft> ] [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                    [ STYLE <nStyle> ] ;
                    [ NAME <cName> ] ;
                    [ ON CLOSE <onClose> ] ;
                    [ ON INITDIALOG <initDlg> ] ;
                    => ;
                    <oDlg> := __wxh_Dialog( [<fromClass>], [<parent>], [<nID>], <cTitle>, {<nTop>,<nLeft>}, {<nWidth>,<nHeight>}, [<nStyle>], [<cName>], [<{onClose}>], [<initDlg>] )

#xcommand FIT WINDOW <oWnd> ;
                    => ;
                    iif( <oWnd>:GetSizer() != NIL, <oWnd>:GetSizer():SetSizeHints( <oWnd> ), NIL )

#xcommand CENTRE WINDOW <oWnd> ;
                    => ;
                    <oWnd>:Centre()

#xcommand SHOW WINDOW <oWnd> [<modal: MODAL>] [<fit: FIT>] [TO <var>] [<centre: CENTRE>];
                    => ;
                    [<var> := ] __wxh_ShowWindow( <oWnd>, <.modal.>, <.fit.>, <.centre.> )

/*
    Menues
*/
#xcommand DEFINE MENUBAR [ VAR <oMB>] [STYLE <nStyle>] [PARENT <parent>] ;
                    => ;
                    [<oMB> := ] __wxh_MenuBarBegin( [<parent>], [<nStyle>] )
                    
#xcommand DEFINE MENU [<cLabel>] [VAR <menu>] [PARENT <parent>] [FIRST_ID <firstId>] ;
                    => ;
                    [<menu> :=] __wxh_MenuBegin( [<cLabel>], [<parent>], [<firstId>] )

#xcommand DEFINE POPUPMENU [<clauses,...>] PARENT <parent> FIRST_ID <firstId> ;
    => ;
    DEFINE MENU [<clauses>] PARENT <parent> FIRST_ID <firstId>

#xcommand ADD MENUITEM <cLabel> ;
                            [VAR <menu>] ;
                            [ID <nID>] ;
                            [HELPLINE <cHelpString>] ;
                            [<kind: CHECK,RADIO>] ;
                            [BITMAP <bitmap> ] ;
                            [ACTION <bAction> ] ;
                            [ENABLED <enabled> ] ;
                    => ;
                    [<menu> :=] __wxh_MenuItemAdd( [<nID>], <cLabel>, [<cHelpString>], [wxITEM_<kind>], [<bitmap>], [<{bAction}>], [<enabled>] )

#xcommand ADD MENUSEPARATOR ;
                    => ;
                    __wxh_MenuItemAdd( wxID_SEPARATOR )

#xcommand ENDMENU ;
                    => ;
                    __wxh_MenuEnd()

/*
 * SIZERS
 *
 * TODO: On ALIGN CENTER we need to create a wxALIGN_CENTER_[HORIZONTAL|VERTICAL]
 *       in sync with the parent sizer, currently we do just wxALIGN_CENTER
 *
 */

#define wxALIGN_EXPAND  wxGROW
#define wxSTRETCH        1

#xcommand @ SIZERINFO ;
                    [ CHILD <child> ] ;
                    [ PARENTSIZER <parentSizer> ] ;
                    [ <stretch: STRETCH> ] ;
                    [ ALIGN <align: TOP, LEFT, BOTTOM, RIGHT, CENTRE, CENTRE_HORIZONTAL, CENTRE_VERTICAL, CENTER, CENTER_HORIZONTAL, CENTER_VERTICAL, EXPAND> ] ;
                    [ BORDER <border> ] ;
                    [ SIDEBORDERS <sideborders,...> ] ;
                    [ <useLast: LAST> ] ;
                    => ;
                    __wxh_SizerInfoAdd( ;
                        [ <child> ],;
                        [ <parentSizer> ],;
                        [ wx<stretch> ],;
                        [ wxALIGN_<align> ],;
                        [ <border> ],;
                        [ HB_BitOr(0,<sideborders>) ],;
                        NIL,;
                        [ <.useLast.> ],;
                        .T. ) /* No processing, sizer info to stack */
            
#xcommand BEGIN CUSTOM PARENT <parent> ;
                    => ;
                    __wxh_CustomParentBegin( <parent> )

#xcommand END CUSTOM PARENT ;
                    => ;
            __wxh_CustomParentEnd()

#xcommand BEGIN BOXSIZER <orient: VERTICAL, HORIZONTAL> ;
                    [ VAR <bs> ] ;
                    [ [LABEL] <label> ] ;
                    [ <stretch: STRETCH> ] ;
                    [ ALIGN <align: TOP, LEFT, BOTTOM, RIGHT, CENTRE, CENTRE_HORIZONTAL, CENTRE_VERTICAL, CENTER, CENTER_HORIZONTAL, CENTER_VERTICAL, EXPAND> ] ;
                    [ BORDER <border> ] ;
                    [ SIDEBORDERS <sideborders,...> ] ;
                    => ;
                    [ <bs> := ]__wxh_BoxSizerBegin( ;
                        [ <label> ], ;
                        wx<orient>,;
                        [ wx<stretch> ],;
                        [ wxALIGN_<align> ],;
                        [ <border> ],;
                        [ HB_BitOr(0,<sideborders>) ] ;
                    )

#xcommand BEGIN FLEXGRIDSIZER [ROWS <rows>] [COLS <cols>] [VGAP <vgap>] [HGAP <hgap>] ;
                    [ GROWABLECOLS <growableCols,...> ] ;
                    [ GROWABLEROWS <growableRows,...> ] ;
                    [ <stretch: STRETCH> ] ;
                    [ ALIGN <align: TOP, LEFT, BOTTOM, RIGHT, CENTRE, CENTRE_HORIZONTAL, CENTRE_VERTICAL, CENTER, CENTER_HORIZONTAL, CENTER_VERTICAL, EXPAND> ] ;
                    [ BORDER <border> ] ;
                    [ SIDEBORDERS <sideborders,...> ] ;
                    => ;
                    __wxh_FlexGridSizerBegin( ;
                        [ <rows> ],;
                        [ <cols> ],;
                        [ <vgap> ],;
                        [ <hgap> ],;
                        [ {<growableCols>} ],;
                        [ {<growableRows>} ],;
                        [ wx<stretch> ],;
                        [ wxALIGN_<align> ],;
                        [ <border> ],;
                        [ HB_BitOr(0,<sideborders>) ] ;
                    )

#xcommand BEGIN GRIDSIZER [ROWS <rows>] [COLS <cols>] [VGAP <vgap>] [HGAP <hgap>] ;
                    [ <stretch: STRETCH> ] ;
                    [ ALIGN <align: TOP, LEFT, BOTTOM, RIGHT, CENTRE, CENTRE_HORIZONTAL, CENTRE_VERTICAL, CENTER, CENTER_HORIZONTAL, CENTER_VERTICAL, EXPAND> ] ;
                    [ BORDER <border> ] ;
                    [ SIDEBORDERS <sideborders,...> ] ;
                    => ;
                    __wxh_GridSizerBegin( ;
                        [ <rows> ],;
                        [ <cols> ],;
                        [ <vgap> ],;
                        [ <hgap> ],;
                        [ wx<stretch> ],;
                        [ wxALIGN_<align> ],;
                        [ <border> ],;
                        [ HB_BitOr(0,<sideborders>) ] ;
                    )

#xcommand END SIZER ;
                    => ;
                    __wxh_SizerEnd()

#xcommand @ CREATE <bst: BUTTONSIZER, SEPARATEDBUTTONSIZER, STDDIALOGBUTTONSIZER> ;
                    FLAGS <flags> ;
                    [ VAR <var> ] ;
                    [ ON DIALOG <dlg> ];
                    [ <stretch: STRETCH> ] ;
                    [ ALIGN <align: TOP, LEFT, BOTTOM, RIGHT, CENTRE, CENTRE_HORIZONTAL, CENTRE_VERTICAL, CENTER, CENTER_HORIZONTAL, CENTER_VERTICAL, EXPAND> ] ;
                    [ BORDER <border> ] ;
                    [ SIDEBORDERS <sideborders,...> ] ;
                    => ;
    [<var> :=] __wxh_CreateDialogButtons( "Create" + <"bst">, <flags>, [<dlg>],;
                        [ wx<stretch> ],;
                        [ wxALIGN_<align> ],;
                        [ <border> ],;
                        [ HB_BitOr(0,<sideborders>) ] ;
                    )

#xcommand @ SPACER ;
                    [ WIDTH <width> ] ;
                    [ HEIGHT <height> ] ;
                    [ <stretch: STRETCH> ] ;
                    [ FLAG <flag> ] ;
                    [ BORDER <border> ] ;
                    => ;
                    __wxh_Spacer( ;
                        [<width>],;
                        [<height>],;
                        [ wx<stretch> ],;
                        [<flag>],;
                        [<border>] ;
                    )

/*
    End Sizers
*/

/*
    BROWSE
*/
#xcommand @ BROWSE [ VAR <wxBrw> ] ;
                        [ DATASOURCE <dataSource> ] ;
                        [ CLASS <fromClass> ] ;
                        [ LABEL <label> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ MINSIZE <minWidth>,<minHeight> ] ;
                        [ STYLE <style> ] ;
                        [ NAME <name> ] ;
                        [ ONKEY <onKey> ] ;
                        [ ONSELECTCELL <onSelectCell> ] ;
                        [ <readOnly: READONLY> ] ;
                    => ;
                        [<wxBrw>:=]__wxh_Browse( ;
                            [<fromClass>],;
                            [<dataSource>],;
                            [<parent>],;
                            [<id>],;
                            [<label>],;
                            ,;
                            [{<nWidth>,<nHeight>}],;
                            [{<minWidth>,<minHeight>}],;
                            [<style>],;
                            [<name>],;
                            [<onKey>],;
                            [<onSelectCell>], ;
                <.readOnly.> ;
                        )

#xcommand @ BROWSE [<bclauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ BROWSE [<bclauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
    BCOLUMN
*/
#xcommand ADD BCOLUMN [<zero: ZERO>] TO <wxBrw> [ [TITLE] <title>] BLOCK <block> [PICTURE <picture>] [WIDTH <width>] [AS <asBool: BOOL,NUMBER,FLOAT> [<width>,<precision>] ] [ COLOUR <colour> ] [ ONSETVALUE <onSetValue> ] ;
                    => ;
                    __wxh_BrowseAddColumn( <wxBrw>, <.zero.>, <title>, <block>, [<picture>], [<width>], [<"asBool">], [{<width>,<precision>}], [<colour>], [<onSetValue>] )

#xcommand ADD BCOLUMN TO <wxBrw> FIELD <field> [<noEditable: NOEDITABLE>] [ COLOUR <colour> ] [ ONSETVALUE <onSetValue> ] ;
                    => ;
            __wxh_BrowseAddColumnFromField( <wxBrw>, <field>, !<.noEditable.>, [<colour>], [<onSetValue>] )
            
/*
 * Button
 * Teo. Mexico 2009
 */
#xcommand @ BUTTON [<label>] ;
                        [ BITMAP <bmp> ] ;
                        [ VAR <btn> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ VALIDATOR <validator> ] ;
                        [ NAME <name> ] ;
                        [ <default: DEFAULT> ] ;
                        [ ACTION <bAction> ] ;
                    => ;
                    [ <btn> := ]__wxh_Button( ;
                        [<parent>],;
                        [<id>],;
                        [<label>],;
                        [<bmp>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<style>],;
                        [<validator>],;
                        [<name>],;
                        [<.default.>],;
                        [<{bAction}>] )

#xcommand @ BUTTON [<btnclauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ BUTTON [<btnclauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
 * CheckBox
 * Teo. Mexico 2009
 */
#xcommand @ CHECKBOX [<dataVar>] [ LABEL <label> ] ;
                        [ VAR <checkBox> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ NAME <name> ] ;
                        [ ACTION <bAction> ] ;
                    => ;
                    @ PUSHVALIDATOR [<dataVar>] [ ACTION <{bAction}> ] ;;
                    [ <checkBox> := ]__wxh_CheckBox( ;
                        [<parent>],;
                        [<id>],;
                        [<label>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<style>],;
                        [<name>] )

#xcommand @ CHECKBOX [<btnclauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ CHECKBOX [<btnclauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
 * Gauge
 * Teo. Mexico 2009
 */
#xcommand @ GAUGE ;
                        [ VAR <gauge> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ <type: HORIZONTAL, VERTICAL> ] ;
                        [ RANGE <range> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ VALIDATOR <validator> ] ;
                        [ NAME <name> ] ;
                        [ ACTION <bAction> ] ;
                    => ;
                    [ <gauge> := ]__wxh_Gauge( ;
                        [<parent>],;
                        [<id>],;
                        [<range>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<style>],;
                        [<validator>],;
                        [<name>],;
                        [wxGA_<type>] )

#xcommand @ GAUGE [<gaugeClauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ GAUGE [<gaugeClauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
 * RadioBox
 * Teo. Mexico 2009
 */
#xcommand @ RADIOBOX <dataVar> [ LABEL <label> ] ;
                        [ ITEMS <choices> ] ;
                        [ <specRC: ROWS, COLS> <nmaxRC> ] ;
                        [ VAR <radioBox> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ NAME <name> ] ;
                        [ ACTION <bAction> ] ;
                        [ ENABLED <enabled> ] ;
                    => ;
                    @ PUSHVALIDATOR <dataVar> [ ACTION <{bAction}> ] ;;
                    [ <radioBox> := ]__wxh_RadioBox( ;
                        [<parent>],;
                        [<id>],;
                        [<label>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<choices>],;
                        [wxRA_SPECIFY_<specRC>],[<nmaxRC>],;
                        [<style>],;
                        [<name>],;
                        [<enabled>] )

#xcommand @ RADIOBOX [<btnclauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ RADIOBOX [<btnclauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
 * Choice
 * Teo. Mexico 2009
 */
#xcommand @ CHOICE <dataVar> ;
                        [ ITEMS <choices> ] ;
                        [ VAR <choice> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ NAME <name> ] ;
                        [ ACTION <bAction> ] ;
                        [ ENABLED <enabled> ] ;
                    => ;
                @ PUSHVALIDATOR <dataVar> [ ACTION <{bAction}> ] ;;
                    [ <choice> := ]__wxh_Choice( ;
                        [<parent>],;
                        [<id>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<choices>],;
                        [<style>],;
                        [<name>],;
                        [<enabled>] )

#xcommand @ CHOICE [<btnclauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ CHOICE [<btnclauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
 * ComboBox
 * Teo. Mexico 2009
 */
#xcommand @ COMBOBOX <dataVar> ;
                        [ ITEMS <choices> ] ;
                        [ VAR <comboBox> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ VALUE <value> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ NAME <name> ] ;
                        [ ACTION <bAction> ] ;
                        [ ENABLED <enabled> ] ;
                    => ;
                @ PUSHVALIDATOR <dataVar> [ ACTION <{bAction}> ] ;;
                    [ <comboBox> := ]__wxh_ComboBox( ;
                        [<parent>],;
                        [<id>],;
                        [<value>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<choices>],;
                        [<style>],;
                        [<name>],;
                        [<enabled>] )

#xcommand @ COMBOBOX [<cbclauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ COMBOBOX [<cbclauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
 * wxDatePickCtrl
 */
#xcommand @ DATEPICKERCTRL [<dataVar>] ;
                        [ VAR <var> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ NAME <name> ] ;
                        [ PICTURE <picture> ] ;
                        [ WARN <warnMsg> ] [ VALIDATE <bValidate> ] ;
                        [ TOOLTIP <toolTip> ] ;
                        [ ACTION <bAction> ] ;
                        [ ENABLED <enabled> ] ;
                    => ;
                    @ PUSHVALIDATOR [<dataVar>] [ PICTURE <picture> ] [ VALIDATE <bValidate> ] [ WARN <warnMsg> ] [ ACTION <{bAction}> ] ;;
                    [<var> :=] __wxh_DatePickerCtrl(;
                        [<parent>],;
                        [<id>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<style>],;
                        [<name>],;
                        [<enabled>],;
                        [<{toolTip}>] )
                        
#xcommand @ DATEPICKERCTRL [<clauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ DATEPICKERCTRL [<clauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
    wxGrid
*/
#xcommand @ GRID [ VAR <grid> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ CLASS <fromClass> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ NAME <name> ] ;
                        [ ROWS <rows> ] ;
                        [ COLS <cols> ] ;
                        [ <readOnly: READONLY> ] ;
                    => ;
                        [<grid>:=]__wxh_Grid( ;
                            [<fromClass>], ;
                            [<parent>],;
                            [<id>],;
                            ,;
                            [{<nWidth>,<nHeight>}],;
                            [<style>],;
                            [<name>],;
                            [ <rows> ],;
                            [ <cols> ],;
                <.readOnly.> )

#xcommand @ GRID [<bclauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ GRID [<bclauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
 * HtmlWindow
 */
#xcommand @ HTMLWINDOW [ VAR <htmlWindow> ] ;
                       [ PARENT <parent> ] ;
                       [ ID <id> ] ;
                       [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                       [ STYLE <style> ] ;
                       [ NAME <name> ] ;
                    => ;
                    [ <htmlWindow> := ]__wxh_HtmlWindow( ;
                        [<parent>],;
                        [<id>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<style>],;
                        [<name>] )

#xcommand @ HTMLWINDOW [<hwClauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ HTMLWINDOW [<hwClauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
 * ListCtrl
 * Teo. Mexico 2009
 */
#xcommand @ LISTCTRL [<value>] ;
                        [ VAR <listCtrl> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ VALIDATOR <validator> ] ;
                        [ NAME <name> ] ;
                        [ ACTION <bAction> ] ;
                    => ;
                    [ <listCtrl> := ]__wxh_ListCtrl( ;
                        [<parent>],;
                        [<id>],;
                        [<value>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<style>],;
                        [<validator>],;
                        [<name>],;
                        [<{bAction}>] )

#xcommand @ LISTCTRL [<lcclauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ LISTCTRL [<lcclauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
    Notebook|Listbook
*/
#xcommand BEGIN <bookType: NOTEBOOK, LISTBOOK, AUINOTEBOOK> ;
                        [ VAR <nb> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ NAME <name> ] ;
                        [ ON PAGE CHANGED <opChanged> ] ;
                        [ ON PAGE CHANGING <opChanging> ] ;
                    => ;
                    [ <nb> := ]__wxh_BookBegin( wx<bookType>(), ;
                        [<parent>],;
                        [<id>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<style>],;
                        [<name>],;
                        [<opChanged>],;
                        [<opChanging>] )

#xcommand END <bookType: NOTEBOOK, LISTBOOK, AUINOTEBOOK> => __wxh_BookEnd( "wx"+<"bookType"> )

#xcommand BEGIN <bookType: NOTEBOOK, LISTBOOK, AUINOTEBOOK> [<nbclauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    BEGIN <bookType> [<nbclauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

#xcommand ADD BOOKPAGE [ [TITLE] <title> ] [<select: SELECT> ] [ IMAGEID <imageId> ] FROM ;
                    => ;
                    __wxh_BookAddPage( <title>, <.select.>, <imageId> )

/*
    Panel
*/
#xcommand BEGIN PANEL ;
                        [ VAR <panel> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ NAME <name> ] ;
                        [ ENABLED <enabled> ] ;
                        [ CLASS <fromClass> ] ;
                    => ;
                    [ <panel> := ]__wxh_PanelBegin( ;
                        [<parent>],;
                        [<id>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<style>],;
                        [<name>],;
                        [<enabled>],;
                        [<fromClass>] )

#xcommand END PANEL => __wxh_PanelEnd()

#xcommand BEGIN PANEL [<clauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    BEGIN PANEL [<clauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
 * SAY
 */
#xcommand @ SAY <label> ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style: LEFT, RIGHT, CENTRE, CENTER> ] ;
                        [ NAME <name> ] ;
                    => ;
                    __wxh_Say( ;
                        [<parent>],;
                        [<id>],;
                        <label>,;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [wxALIGN_<style>],;
                        [<name>] )

#xcommand @ SAY [<clauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ SAY [<clauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
 * GET
 */
#xcommand @ GET [<dataVar>] ;
                        [ VAR <var> ] ;
                        [ FIELD <fld> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ <mline: MULTILINE> ] ;
                        [ STYLE <style> ] ;
                        [ NAME <name> ] ;
                        [ <noEdit: NOEDITABLE> ] ;
                        [ TOOLTIP <toolTip> ] ;
                        [ ENABLED <enabled> ] ;
                        [ PICTURE <picture> ] ;
                        [ VALIDATE <bValidate> ] [ WARN <warnMsg> ]  ;
                        [ ACTION <bAction> ] ;
                    => ;
                    @ PUSHVALIDATOR [<dataVar>] [ FIELD <fld> ] [ PICTURE <picture> ] [ VALIDATE <bValidate> ] [ WARN <warnMsg> ] [ ACTION <{bAction}> ] ;;
                        [<var> :=] __wxh_TextCtrl(;
                        [<parent>],;
                        [<id>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<.mline.>],;
                        [<style>],;
                        [<name>],;
                        [<.noEdit.>], ;
                        [<{toolTip}>],;
                        [<enabled>] )
                        
#xcommand @ GET [<clauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ GET [<clauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

#xcommand @ SAY [<sayclauses,...>] GET [<getclauses,...>] ;
                    => ;
                    BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND ;;
                        @ SAY [<sayclauses>] STYLE RIGHT ;;
                        @ GET [<getclauses>] SIZERINFO STRETCH ;;
                    END SIZER

#xcommand @ SAY ABOVE [<sayclauses,...>] GET [<getclauses,...>] ;
                    => ;
                    BEGIN BOXSIZER VERTICAL ALIGN EXPAND ;;
                    @ SAY [<sayclauses>] SIZERINFO ALIGN LEFT ;;
                    @ GET [<getclauses>] SIZERINFO ALIGN EXPAND ;;
                    END SIZER

#xcommand @ SAY [<sayclauses,...>] CHOICE [<choiceclauses,...>] ;
                    => ;
                    BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND ;;
                    @ SAY [<sayclauses>] STYLE RIGHT ;;
                    @ CHOICE [<choiceclauses>] ;;
                    END SIZER

#xcommand @ SAY [<sayclauses,...>] SEARCHCTRL [<scclauses,...>] ;
                    => ;
                    BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND ;;
                    @ SAY [<sayclauses>] STYLE RIGHT ;;
                    @ SEARCHCTRL [<scclauses>] SIZERINFO STRETCH ;;
                    END SIZER
/*
    ScrollBar
    Teo. Mexico 2009
*/
#xcommand @ SCROLLBAR <orient: HORIZONTAL, VERTICAL>;
                        [ VAR <sb> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ VALIDATOR <validator> ] ;
                        [ NAME <name> ] ;
                        [ ACTION <bAction> ] ;
                    => ;
                    [ <sb> := ]__wxh_ScrollBar( ;
                        [<parent>],;
                        [<id>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [wxSB_<orient>],;
                        [<style>],;
                        [<validator>],;
                        [<name>],;
                        [<{bAction}>] )

#xcommand @ SCROLLBAR [<clauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ SCROLLBAR [<clauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
 * SpinCtrl
 * Teo. Mexico 2009
 */
#xcommand @ SPINCTRL [<dataVar>] ;
                        [ VAR <spinCtrl> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ MIN <min> ] ;
                        [ MAX <max> ] ;
                        [ NAME <name> ] ;
                        [ VALIDATE <bValidate> ] [ WARN <warnMsg> ]  ;
                        [ ACTION <bAction> ] ;
                    => ;
                    @ PUSHVALIDATOR [<dataVar>] [ VALIDATE <bValidate> ] [ WARN <warnMsg> ] [ ACTION <{bAction}>] ;;
                        [ <spinCtrl> := ]__wxh_SpinCtrl( ;
                        [<parent>],;
                        [<id>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<style>],;
                        [<min>],;
                        [<max>],;
                        [<name>] )

#xcommand @ SPINCTRL [<scclauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ SPINCTRL [<scclauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
 * StaticBitmap
 * Teo. Mexico 2009
 */
#xcommand @ STATICBITMAP [<label>] ;
                        [ VAR <staticBitmap> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ NAME <name> ] ;
                    => ;
                    [ <staticBitmap> := ]__wxh_StaticBitmap( ;
                        [<parent>],;
                        [<id>],;
                        [<label>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<style>],;
                        [<name>] )

#xcommand @ STATICBITMAP [<stClauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ STATICBITMAP [<stClauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
    StaticLine
    Teo. Mexico 2009
*/
#xcommand @ STATICLINE <orient: HORIZONTAL, VERTICAL>;
                        [ VAR <sl> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ NAME <name> ] ;
                    => ;
                    [ <sl> := ]__wxh_StaticLine( ;
                        [<parent>],;
                        [<id>],;
                        ,;
                        [wxLI_<orient>],;
                        [<name>])

#xcommand @ STATICLINE [<clauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ STATICLINE [<clauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
 * StaticText
 * Teo. Mexico 2009
 */
#xcommand @ STATICTEXT [<label>] ;
                        [ VAR <staticText> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ NAME <name> ] ;
                    => ;
                    [ <staticText> := ]__wxh_StaticText( ;
                        [<parent>],;
                        [<id>],;
                        [<label>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<style>],;
                        [<name>] )

#xcommand @ STATICTEXT [<stClauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ STATICTEXT [<stClauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
    StatusBar
*/
#xcommand @ STATUSBAR [ VAR <oSB> ] ;
                        [ ID <nID> ] ;
                        [ STYLE <nStyle> ] ;
                        [ NAME <cName> ] ;
                        [ FIELDS <nFields> ] ;
                        [ WIDTHS <aWidths,...> ] ;
                        [ PARENT <parent> ] ;
                    => ;
                    [ <oSB> := ] __wxh_StatusBar( ;
                        [<parent>], ;
                        [<nID>], ;
                        [<nStyle>], ;
                        [<cName>], ;
                        [<nFields>], ;
                        [{<aWidths>}] ) ;;

/*
 * SearchCtrl
 * Teo. Mexico 2009
 */
#xcommand @ SEARCHCTRL <dataVar> ;
                        [ VAR <searchCtrl> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ NAME <name> ] ;
                        [ ON SEARCH <onSearch> ] ;
                        [ ON CANCEL <onCancel> ] ;
                        [ PICTURE <picture> ] ;
                        [ VALIDATE <bValidate> ] [ WARN <warnMsg> ]  ;
                        [ ACTION <bAction> ] ;
                    => ;
                    @ PUSHVALIDATOR [<dataVar>] [ PICTURE <picture> ] [ VALIDATE <bValidate> ] [ WARN <warnMsg> ] [ ACTION <{bAction}> ] ;;
                        [ <searchCtrl> := ]__wxh_SearchCtrl( ;
                        [<parent>],;
                        [<id>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<style>],;
                        [<name>],;
                        [<onSearch>],;
                        [<onCancel>] )

#xcommand @ SEARCHCTRL [<tcclauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ SEARCHCTRL [<tcclauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
    TextCtrl
*/
#xcommand @ TEXTCTRL <tcClauses,...> => @ GET <tcClauses>

/*
    ToolBar
*/
#xcommand BEGIN [<toFrame: FRAME>] TOOLBAR ;
                        [ VAR <toolBar> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ NAME <name> ] ;
                    => ;
                        [ <toolBar> := ]__wxh_ToolBarBegin( ;
                        [<parent>],;
                        [<id>],;
                        [<.toFrame.>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<style>],;
                        [<name>] )

#xcommand END TOOLBAR => __wxh_ToolBarEnd()

#xcommand @ TOOL <type: CHECK, RADIO, BUTTON> ;
                        ID <id> ;
                        [ LABEL <label> ] ;
                        [ BITMAP <bitmap1> ] ;
                        [ DISBITMAP <bitmap2> ] ;
                        [ SHORTHELP <shortHelp> ] ;
                        [ LONGHELP <longHelp> ] ;
                        [ CLIENTDATA <clientData> ] ;
                        [ ACTION <bAction> ] ;
                        [ ENABLED <enabled> ] ;
                        => ;
                        __wxh_ToolAdd( ;
                            [<"type">],;
                            [<id>],;
                            [<label>],;
                            [<bitmap1>],;
                            [<bitmap2>],;
                            [<shortHelp>],;
                            [<longHelp>],;
                            [<clientData>],;
                            [<{bAction}>],;
                            [<enabled>] )

#xcommand @ TOOL SEPARATOR => __wxh_ToolAdd( "SEPARATOR" )

#xcommand BEGIN TOOLBAR [<clauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    BEGIN TOOLBAR [<clauses>] ;;
                    @ SIZERINFO [<sizerClauses>]

/*
 * TreeCtrl
 * Teo. Mexico 2009
 */
#xcommand @ TREECTRL [<label>] ;
                        [ VAR <btn> ] ;
                        [ PARENT <parent> ] ;
                        [ ID <id> ] ;
                        [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
                        [ STYLE <style> ] ;
                        [ VALIDATOR <validator> ] ;
                        [ NAME <name> ] ;
                        [ ACTION <bAction> ] ;
                    => ;
                    [ <btn> := ]__wxh_TreeCtrl( ;
                        [<parent>],;
                        [<id>],;
                        [<label>],;
                        ,;
                        [{<nWidth>,<nHeight>}],;
                        [<style>],;
                        [<validator>],;
                        [<name>],;
                        [<{bAction}>] )

#xcommand @ TREECTRL [<clauses,...>] SIZERINFO [<sizerClauses,...>] ;
                    => ;
                    @ TREECTRL [<clauses>] ;;
                    @ SIZERINFO [<sizerClauses>]
#endif
