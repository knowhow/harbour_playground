/*
 * $Id: wxhFrame.prg 637 2010-06-26 15:56:06Z tfonrouge $
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
    wxFrame
    Teo. Mexico 2009
*/
CLASS wxFrame FROM wxTopLevelWindow
PRIVATE:
PROTECTED:
PUBLIC:

    CONSTRUCTOR New( parent, id, title, pos, size, style, name )

    METHOD Centre( direction )
    METHOD CreateToolBar( style, id, name )
    METHOD OnCreateToolBar( style, id, name )
    METHOD SetMenuBar( menuBar )
    METHOD SetStatusBar( statusBar )

PUBLISHED:
ENDCLASS

/*
    OnCreateToolBar
    Teo. Mexico 2009
*/
METHOD FUNCTION OnCreateToolBar( style, id, name ) CLASS wxFrame
RETURN wxToolBar():New( Self, id, NIL, NIL, style, name )

/*
    End Class wxFrame
*/

/*
    wxMDIParentFrame
    Teo. Mexico 2009
*/
CLASS wxMDIParentFrame FROM wxFrame
PRIVATE:
PROTECTED:
PUBLIC:
    CONSTRUCTOR New( parent, id, title, pos, size, style, name )
    METHOD Cascade
PUBLISHED:
ENDCLASS

/*
    End Class wxMDIParentFrame
*/

/*
    wxMDIChildFrame
    Teo. Mexico 2009
*/
CLASS wxMDIChildFrame FROM wxFrame
PRIVATE:
PROTECTED:
PUBLIC:
    CONSTRUCTOR New( parent, id, title, pos, size, style, name )
    METHOD Activate
    METHOD Maximize( maximize )
    METHOD Restore
PUBLISHED:
ENDCLASS

/*
    End Class wxMDIParentFrame
*/
