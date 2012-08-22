/*
 * $Id: evtdefcheck.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    Test to check defines in Harbour vs C++
    Teo. Mexico 2009
*/

#include "wxharbour.ch"

FUNCTION Main

    IMPLEMENT_APP( MyApp():New() )

RETURN NIL

CLASS MyApp FROM wxApp
    DATA oWnd
    METHOD OnInit
ENDCLASS

METHOD FUNCTION OnInit CLASS MyApp
    LOCAL hDefs
    LOCAL b

    hDefs := { ;
                        "wxEVT_COMMAND_SPINCTRL_UPDATED" => wxEVT_COMMAND_SPINCTRL_UPDATED,;
                        "wxEVT_SOCKET" => wxEVT_SOCKET,;
                        "wxEVT_TIMER" => wxEVT_TIMER,;
                        "wxEVT_IDLE" => wxEVT_IDLE,;
                        "wxEVT_DETAILED_HELP" => wxEVT_DETAILED_HELP,;
                        "wxEVT_KILL_FOCUS" => wxEVT_KILL_FOCUS,;
                        "wxEVT_MENU_OPEN" => wxEVT_MENU_OPEN,;
                        "wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGED" => wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGED,;
                        "wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGING" => wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGING,;
                        "wxTE_PROCESS_ENTER" => wxTE_PROCESS_ENTER,;
                        "wxEVT_UPDATE_UI" => wxEVT_UPDATE_UI,;
                        "wxEVT_INIT_DIALOG" => wxEVT_INIT_DIALOG,;
                        "wxEVT_GRID_COL_MOVE" => wxEVT_GRID_COL_MOVE;
                     }

    CREATE FRAME ::oWnd ;
                 WIDTH 600 ;
                 TITLE "Check wx* defines in Harbour vs C++"

    DEFINE MENUBAR
        DEFINE MENU "&Program"
            ADD MENUITEM E"Close\tCtrl+X" ID wxID_CLOSE ACTION ::oWnd:Close()
        ENDMENU
    ENDMENU

    @ BROWSE VAR b DATASOURCE hDefs

    b:DeleteAllColumns()

    ADD BCOLUMN ZERO TO b BLOCK {|n| n }
    ADD BCOLUMN TO b "Harbour" BLOCK {|key| hDefs[ key ] }
    ADD BCOLUMN TO b "C++" BLOCK {|key| wxh_GetwxDef( key ) }
    ADD BCOLUMN TO b BLOCK {|key| iif( wxh_GetwxDef( key ) == hDefs[ key ], "", "FALSE" ) }

    b:SetRowLabelSize( 250 )

    SHOW WINDOW ::oWnd CENTRE

RETURN .T.
