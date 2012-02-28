/*
 * $Id: wxhHtmlWindow.prg 649 2010-10-05 15:46:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2010 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2010 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxHtmlWindow
    Teo. Mexico 2010
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"

/*
    wxHtmlWindow
    Teo. Mexico 2010
*/
CLASS wxHtmlWindow FROM wxScrolledWindow
PRIVATE:
PROTECTED:
PUBLIC:

    METHOD New( parent, id, pos, size, style, name )

    //METHOD AddFilter
    METHOD AppendToPage( source )
    //METHOD GetInternalRepresentation
    METHOD GetOpenedAnchor()
    METHOD GetOpenedPage()
    //METHOD GetOpenedPageTitle()
    METHOD GetRelatedFrame()
    METHOD HistoryBack()
    METHOD HistoryCanBack()
    METHOD HistoryCanForward()
    METHOD HistoryClear()
    METHOD HistoryForward()
    //METHOD LoadFile
    METHOD LoadPage( location )
    //METHOD OnCellClicked
    //METHOD OnCellMouseHover
    //METHOD OnLinkClicked
    METHOD OnOpeningURL( type, url, redirect ) VIRTUAL
    METHOD OnSetTitle( title ) VIRTUAL
    //METHOD ReadCustomization
    METHOD SelectAll()
    METHOD SelectionToText()
    METHOD SelectLine( pos )
    METHOD SelectWord( pos )
    METHOD SetBorders( border )
    METHOD SetFonts( normal_face, fixed_face, sizes )
    METHOD SetPage( source )
    METHOD SetRelatedFrame( frame, format )
    METHOD SetRelatedStatusBar( bar )
    METHOD ToText()
    //METHOD WriteCustomization

PUBLISHED:
ENDCLASS

/*
    EndClass wxHtmlWindow
*/
