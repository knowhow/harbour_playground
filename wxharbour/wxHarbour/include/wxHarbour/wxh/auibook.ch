/*
 * $Id: auibook.ch 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

//----------------------------------------------------------------------------
// wxAuiNotebook
//----------------------------------------------------------------------------

#ifndef _WXAUINOTEBOOK_CH_
#define _WXAUINOTEBOOK_CH_

#define wxAUI_NB_TOP                    0x0001  //= 1 << 0,
#define wxAUI_NB_LEFT                   0x0002  //= 1 << 1,  // not implemented yet
#define wxAUI_NB_RIGHT                  0x0004  //= 1 << 2,  // not implemented yet
#define wxAUI_NB_BOTTOM                 0x0008  //= 1 << 3,
#define wxAUI_NB_TAB_SPLIT              0x0010  //= 1 << 4,
#define wxAUI_NB_TAB_MOVE               0x0020  //= 1 << 5,
#define wxAUI_NB_TAB_EXTERNAL_MOVE      0x0040  //= 1 << 6,
#define wxAUI_NB_TAB_FIXED_WIDTH        0x0080  //= 1 << 7,
#define wxAUI_NB_SCROLL_BUTTONS         0x0100  //= 1 << 8,
#define wxAUI_NB_WINDOWLIST_BUTTON      0x0200  //= 1 << 9,
#define wxAUI_NB_CLOSE_BUTTON           0x0400  //= 1 << 10,
#define wxAUI_NB_CLOSE_ON_ACTIVE_TAB    0x0800  //= 1 << 11,
#define wxAUI_NB_CLOSE_ON_ALL_TABS      0x1000  //= 1 << 12,
#define wxAUI_NB_MIDDLE_CLICK_CLOSE     0x2000  //= 1 << 13,

#define wxAUI_NB_DEFAULT_STYLE         HB_BitOr( wxAUI_NB_TOP ,;
                                                                                                    wxAUI_NB_TAB_SPLIT ,;
                                                                                                    wxAUI_NB_TAB_MOVE ,;
                                                                                                    wxAUI_NB_SCROLL_BUTTONS ,;
                                                                                                    wxAUI_NB_CLOSE_ON_ACTIVE_TAB ,;
                                                                                                    wxAUI_NB_MIDDLE_CLICK_CLOSE )

#endif
