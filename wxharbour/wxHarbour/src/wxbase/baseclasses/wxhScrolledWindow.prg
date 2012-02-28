/*
 * $Id: wxhScrolledWindow.prg 654 2010-10-08 02:37:18Z tfonrouge $
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
    wxScrolledWindow
    Teo. Mexico 2010
*/
CLASS wxScrolledWindow FROM wxPanel
PRIVATE:
PROTECTED:
PUBLIC:

    CONSTRUCTOR New( parent, id, pos, size, style, name )

    METHOD CalcScrolledPosition( x, y, xx, yy )
    METHOD CalcUnscrolledPosition( x, y, xx, yy )
    //wxScrolledWindow::Create
    METHOD EnableScrolling( xScrolling, yScrolling )
    METHOD GetScrollPixelsPerUnit( xUnit, yUnit )
    METHOD GetViewStart( x, y )
    METHOD GetVirtualSize( x, y )
    METHOD IsRetained()
    //wxScrolledWindow::DoPrepareDC
    //wxScrolledWindow::OnDraw
    //wxScrolledWindow::PrepareDC
    METHOD Scroll( x, y )
    METHOD SetScrollbars( pixelsPerUnitX, pixelsPerUnitY, noUnitsX, noUnitsY, xPos, yPos, noRefresh )
    METHOD SetScrollRate( xStep, yStep )
    METHOD SetTargetWindow( window )

PUBLISHED:
ENDCLASS

/*
    End Class wxScrolledWindow
*/
