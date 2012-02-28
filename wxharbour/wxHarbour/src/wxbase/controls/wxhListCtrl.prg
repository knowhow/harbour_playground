/*
 * $Id: wxhListCtrl.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxListCtrl
    Teo. Mexico 2009
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"

/*
    wxListCtrl
    Teo. Mexico 2009
*/
CLASS wxListCtrl FROM wxControl
PRIVATE:
PROTECTED:
PUBLIC:

    CONSTRUCTOR New( parent, id, value, pos, size, style, validator, name )

    METHOD Arrange( flag )
    METHOD AssignImageList( imageList, which )
    METHOD ClearAll()
    METHOD DeleteAllItems()
    METHOD DeleteColumn( col )
    METHOD DeleteItem( item )
    METHOD EditLabel( item )
    METHOD EnsureVisible( item )
    METHOD FindItem( start, str, partial )

// wxListCtrl::GetColumn
// wxListCtrl::GetColumnCount
// wxListCtrl::GetColumnWidth
// wxListCtrl::GetCountPerPage
// wxListCtrl::GetEditControl
// wxListCtrl::GetImageList
// wxListCtrl::GetItem
// wxListCtrl::GetItemBackgroundColour
// wxListCtrl::GetItemCount
// wxListCtrl::GetItemData
// wxListCtrl::GetItemFont
// wxListCtrl::GetItemPosition
// wxListCtrl::GetItemRect
// wxListCtrl::GetSubItemRect
// wxListCtrl::GetItemSpacing
// wxListCtrl::GetItemState
// wxListCtrl::GetItemText
// wxListCtrl::GetItemTextColour
// wxListCtrl::GetNextItem
// wxListCtrl::GetSelectedItemCount
// wxListCtrl::GetTextColour
// wxListCtrl::GetTopItem
// wxListCtrl::GetViewRect
// wxListCtrl::HitTest
// wxListCtrl::InsertColumn
// wxListCtrl::InsertItem
// wxListCtrl::OnGetItemAttr
// wxListCtrl::OnGetItemImage
// wxListCtrl::OnGetItemColumnImage
// wxListCtrl::OnGetItemText
// wxListCtrl::RefreshItem
// wxListCtrl::RefreshItems
// wxListCtrl::ScrollList
// wxListCtrl::SetBackgroundColour
// wxListCtrl::SetColumn
// wxListCtrl::SetColumnWidth
// wxListCtrl::SetImageList
// wxListCtrl::SetItem
// wxListCtrl::SetItemBackgroundColour
// wxListCtrl::SetItemCount
// wxListCtrl::SetItemData
// wxListCtrl::SetItemFont
// wxListCtrl::SetItemImage
// wxListCtrl::SetItemColumnImage
// wxListCtrl::SetItemPosition
// wxListCtrl::SetItemPtrData
// wxListCtrl::SetItemState
// wxListCtrl::SetItemText
// wxListCtrl::SetItemTextColour
// wxListCtrl::SetSingleStyle
// wxListCtrl::SetTextColour
// wxListCtrl::SetWindowStyleFlag
// wxListCtrl::SortItems

PUBLISHED:
ENDCLASS

/*
    EndClass wxListCtrl
*/
