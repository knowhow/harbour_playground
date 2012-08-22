/*
 * $Id: wxhTextCtrl.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxTextCtrl
    Teo. Mexico 2006
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"

/*
    wxTextCtrl
    Teo. Mexico 2006
*/
CLASS wxTextCtrl FROM wxControl
PRIVATE:
PROTECTED:
PUBLIC:

    CONSTRUCTOR New( parent, id, value, pos, size, style, validator, name )

    METHOD AppendText( text )
    METHOD ChangeValue( value )
    METHOD Clear()
    METHOD DiscardEdits()
    METHOD GetInsertionPoint()
    METHOD GetLastPosition()
    METHOD GetLineLength( line )
    METHOD GetLineText( line ) AS STRING
    METHOD GetNumberOfLines()
    METHOD GetRange( from, to )
    METHOD GetStringSelection() AS STRING
    METHOD GetValue() AS STRING
    METHOD IsEditable()
    METHOD IsEmpty()
    METHOD IsModified()
    METHOD IsMultiLine()
    METHOD IsSingleLine()
    METHOD LoadFile( filename )
    METHOD MarkDirty()
    METHOD SaveFile( filename )
    METHOD SetEditable( editable )
    METHOD SetInsertionPoint( pos )
    METHOD SetInsertionPointEnd()
    METHOD SetMaxLength( len )
    METHOD SetModified( modified )
    METHOD SetSelection( from, to )
    METHOD SetValue( value ) // deprecated
    METHOD ShowPosition( pos )
    METHOD WriteText( text )
    METHOD SetBackgroundColour( red, green, blue, alpha )
    METHOD SetForegroundColour( red, green, blue, alpha )

PUBLISHED:
ENDCLASS

/*
    EndClass wxTextCtrl
*/
