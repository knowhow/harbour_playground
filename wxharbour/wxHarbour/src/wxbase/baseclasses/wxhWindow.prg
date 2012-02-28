/*
 * $Id: wxhWindow.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2010 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2010 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

/*
    wxWindow
    Teo. Mexico 2010
*/
CLASS wxWindow FROM wxEvtHandler
PRIVATE:
PROTECTED:
PUBLIC:

    CONSTRUCTOR New( parent, id, pos, size, style, name )

    /* Harbour specific */
    METHOD GetPointSize()
    /* Harbour specific */

    METHOD Centre( direction )
    METHOD Close( force )
    METHOD Destroy()
    METHOD DestroyChildren()
    METHOD Disable
    METHOD DragAcceptFiles( accept )
    METHOD Enable( enable )
    METHOD FindFocus
    METHOD FindWindowById( id, parent )
    METHOD FindWindowByLabel( label, parent )
    METHOD FindWindowByName( name, parent )
    METHOD FitInside()
    METHOD Freeze
    METHOD GetClientSize()
    METHOD GetChildren()
    METHOD GetExtraStyle()
    METHOD GetFont
    METHOD GetGrandParent()
    METHOD GetId
    METHOD GetLabel
    METHOD GetName
    METHOD GetParent
    METHOD GetSize()
    METHOD GetSizer
    METHOD GetValidator()
    METHOD Hide( Value )
    METHOD IsEnabled
    METHOD IsShown
    METHOD Layout()
    METHOD MakeModal( flag )
    METHOD PopupMenu( menu, pos )
            /* PopupMenu( menu, x, y ) */
    METHOD Raise
    METHOD Refresh()
    METHOD SetExtraStyle( exStyle )
    METHOD SetFocus
    METHOD SetId( id )
    METHOD SetLabel( label )
    METHOD SetMaxSize( size )
    METHOD SetMinSize( size )
    METHOD SetName( name )
    METHOD SetSizer( sizer, deleteOld )
    METHOD SetToolTip
    METHOD SetValidator( validator )
    METHOD Show( Value /* defaults to TRUE */ )
    METHOD Thaw()
    METHOD TransferDataToWindow()
    METHOD Validate()
PUBLISHED:
ENDCLASS

/*
    End Class wxWindow
*/
