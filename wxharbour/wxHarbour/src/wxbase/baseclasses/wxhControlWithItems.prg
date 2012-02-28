/*
 * $Id: wxhControlWithItems.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

/*
    wxControlWithItems
    Teo. Mexico 2009
*/
CLASS wxControlWithItems FROM wxControl
PRIVATE:
    METHOD Append1( string )
    METHOD Append2( arrayOfStrings )
PROTECTED:
PUBLIC:
    METHOD Append
    METHOD Clear
    METHOD Delete( n )
    METHOD FindString( string, caseSensitive )
    METHOD GetCount
    METHOD GetSelection
    METHOD GetString( n )
    METHOD GetStrings
    METHOD GetStringSelection
    METHOD Insert( item, pos )
    METHOD IsEmpty
    METHOD Select( n ) INLINE ::SetSelection( n )
    METHOD SetSelection( n )
    METHOD SetString( n, string )
    METHOD SetStringSelection( string )
PUBLISHED:
ENDCLASS

/*
    Append
    Teo. Mexico 2009
*/
METHOD FUNCTION Append( p1 ) CLASS wxControlWithItems
    LOCAL Result

    IF HB_IsString( p1 )
        Result := ::Append1( p1 )
    ELSEIF HB_IsArray( p1 )
        ::Append2( p1 )
    ENDIF

RETURN Result

/*
    End Class wxControlWithItems
*/
