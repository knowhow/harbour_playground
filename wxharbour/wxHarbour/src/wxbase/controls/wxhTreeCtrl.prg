/*
 * $Id: wxhTreeCtrl.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxTreeCtrl
    Teo. Mexico 2008
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"

/*
    wxTreeCtrl
    Teo. Mexico 2008
*/
CLASS wxTreeCtrl FROM wxControl
PRIVATE:
PROTECTED:
PUBLIC:

    CONSTRUCTOR New( parent, id, pos, size, style, validator, name )

    METHOD AddRoot( text, image, selImage, data )
    METHOD AppendItem( parent, text, image, selImage, data )
    METHOD Delete( item )
    METHOD DeleteAllItems
    METHOD DeleteChildren( item )
    METHOD Collapse( item )
    METHOD CollapseAll
    METHOD CollapseAllChildren( item )
    METHOD EnsureVisible( item )
    METHOD Expand( item )
    METHOD ExpandAll
    METHOD ExpandAllChildren( item )
    METHOD GetChildrenCount( item, recursively )
    METHOD GetCount
    METHOD GetFirstChild( item, cookie ) // cookie must be a reference var (@)
    METHOD GetLastChild( item )
    METHOD GetItemParent( item )
    METHOD GetNextChild( item, cookie ) // cookie must be a reference var (@)
    METHOD GetNextSibling( item )
    METHOD GetNextVisible( item )
    METHOD GetPrevSibling( item )
    METHOD GetRootItem
    METHOD IsEmpty
    METHOD IsExpanded( item )
    METHOD IsSelected( item )
    METHOD IsVisible( item )
    METHOD ItemHasChildren( item )

PUBLISHED:
ENDCLASS

/*
    EndClass wxTreeCtrl
*/
