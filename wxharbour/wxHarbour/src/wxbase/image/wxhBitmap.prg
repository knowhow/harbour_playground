/*
 * $Id: wxhBitmap.prg 746 2011-08-05 18:55:31Z tfonrouge $
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
#include "wx.ch"

/*
    wxBitmap
    Teo. Mexico 2009
*/
CLASS wxBitmap FROM wxGDIObject
PRIVATE:
PROTECTED:
PUBLIC:

    /*
    Implemented:
    wxBitmap()									  -> New()
    wxBitmap( const char* const* bits )			  -> New( xpmData )
    wxBitmap( const wxString& name, long type )	  -> New( file/resourceName, type )
    */
    CONSTRUCTOR New()

    METHOD AddHandler( handler )
    METHOD CleanUpHandlers()
    METHOD ConvertToImage()
    METHOD CopyFromIcon( icon )
//METHOD FindHandler()
    METHOD GetDepth()
//METHOD GetHandlers()
    METHOD GetHeight()
    METHOD GetPalette()
    METHOD GetMask()
    METHOD GetWidth()
//METHOD GetSubBitmap( rect )
    METHOD InitStandardHandlers()
    METHOD InsertHandler( handler )
    METHOD LoadFile( name, type )
    METHOD IsOk()
    METHOD RemoveHandler( name )
    METHOD SaveFile( name, type, palette )
    METHOD SetDepth( depth )
    METHOD SetHeight( height )
    METHOD SetMask( mask )
    METHOD SetPalette( palette )
    METHOD SetWidth( width )

PUBLISHED:
ENDCLASS

/*
    End Class wxBitmap
*/
