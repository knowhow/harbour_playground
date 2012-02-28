/*
 * $Id: wxhApp.prg 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

/*
    wxApp
    Teo. Mexico 2006
*/
CLASS wxApp FROM wxEvtHandler
PRIVATE:
PROTECTED:
PUBLIC:

    /* wxh specific */
    DATA wxh_ContextListKey
    /* wxh specific */

    CONSTRUCTOR New

    /* wxHarbour */
    METHOD Implement

    /* wxWidgets */
    METHOD ExitMainLoop
    METHOD GetTopWindow
    METHOD Yield( onlyIfNeeded )

    METHOD OnExit VIRTUAL
    METHOD OnInit VIRTUAL

PUBLISHED:
ENDCLASS

/*
    End Class wxApp
*/
