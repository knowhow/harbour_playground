/*
 * $Id: wxhToolBar.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxToolBar
    Teo. Mexico 2009
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"

/*
    wxToolBar
    Teo. Mexico 2009
*/
CLASS wxToolBar FROM wxToolBarBase
PRIVATE:
PROTECTED:
PUBLIC:

    CONSTRUCTOR New( parent, id, pos, size, style, name )

    METHOD AddCheckTool( toolId, label, bitmap1, bitmap2, shortHelpString, longHelpString, clientData )
    METHOD AddControl( control )
    METHOD AddSeparator()
    
    /*
    wxToolBarToolBase* AddTool(int toolId, const wxString& label, const wxBitmap& bitmap1, const wxString& shortHelpString = "", wxItemKind kind = wxITEM_NORMAL)
    
    wxToolBarToolBase* AddTool(int toolId, const wxString& label, const wxBitmap& bitmap1, const wxBitmap& bitmap2 = wxNullBitmap, wxItemKind kind = wxITEM_NORMAL, const wxString& shortHelpString = "", const wxString& longHelpString = "", wxObject* clientData = NULL)
    
    wxToolBarToolBase* AddTool(wxToolBarToolBase* tool)
    */
    METHOD AddTool()
    METHOD AddRadioTool( toolId, label, bitmap1, bitmap2, shortHelpString, longHelpString, clientData )
    METHOD ClearTools()
    METHOD DeleteTool( toolId )
    METHOD DeleteToolByPos( pos )
    METHOD EnableTool( toolId, enable )
    METHOD FindById( id )
    METHOD FindControl( id )
    METHOD FindToolForPosition( x, y )
    METHOD GetToolsCount()
    METHOD GetToolSize()
    METHOD GetToolBitmapSize()
    METHOD GetMargins()
    METHOD GetToolClientData( toolId )
    METHOD GetToolEnabled( toolId )
    METHOD GetToolLongHelp( toolId )
    METHOD GetToolPacking()
    METHOD GetToolPos( toolId )
    METHOD GetToolSeparation()
    METHOD GetToolShortHelp( toolId )
    METHOD GetToolState( toolId )
    METHOD InsertControl( pos, control )
    METHOD InsertSeparator( pos )
    
    //METHOD OnLeftClick( toolId, toggleDown )
    //METHOD OnMouseEnter( toolId )
    //METHOD OnRightClick( toolId, x, y )
    METHOD Realize()
    METHOD RemoveTool( id )
#ifdef _WINCE  // TODO: Check for valid def for Harbour/xHarbour
    METHOD SetBitmapResource( resourceId )
#endif
    METHOD SetMargins( size )
    METHOD SetToolBitmapSize( size )
    METHOD SetToolClientData( id, clientData )
    METHOD SetToolDisabledBitmap( id, bitmap )
    METHOD SetToolLongHelp( toolId, helpString )
    METHOD SetToolPacking( packing )
    METHOD SetToolShortHelp( toolId, helpString )
    METHOD SetToolNormalBitmap( toolId, helpString )
    METHOD SetToolSeparation( separation )
    METHOD ToggleTool( toolId, toggle )

PUBLISHED:
ENDCLASS

/*
    EndClass wxToolBar
*/
