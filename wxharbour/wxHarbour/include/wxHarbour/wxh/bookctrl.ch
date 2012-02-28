/*
 * $Id: bookctrl.ch 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

//----------------------------------------------------------------------------
// bookctrl
//----------------------------------------------------------------------------

#ifndef _BOOKCTRL_CH_
#define _BOOKCTRL_CH_

#define wxBK_DEFAULT            0x0000
#define wxBK_TOP                0x0010
#define wxBK_BOTTOM             0x0020
#define wxBK_LEFT               0x0040
#define wxBK_RIGHT              0x0080
#define wxBK_ALIGN_MASK         HB_BitOr( wxBK_TOP, wxBK_BOTTOM, wxBK_LEFT, wxBK_RIGHT )

#endif
