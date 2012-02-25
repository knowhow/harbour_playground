/*
 * $Id: wxhFileDialog.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

/*
    wxFileDialog
    Teo. Mexico 2008
*/
CLASS wxFileDialog FROM wxDialog
PRIVATE:
PROTECTED:
PUBLIC:

    METHOD New( parent, message, defaultDir, defaultFile, wildcard, style, pos, size, name )

    METHOD GetDirectory
    METHOD GetFilename
    METHOD GetFilenames
    METHOD GetFilterIndex
    METHOD GetMessage
    METHOD GetPath
    METHOD GetPaths
    METHOD GetWildcard
    METHOD SetDirectory
    METHOD SetFilename
    METHOD SetFilterIndex
    METHOD SetMessage
    METHOD SetPath
    METHOD SetWildcard
    METHOD ShowModal

PUBLISHED:
ENDCLASS
