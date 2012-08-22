/*
 * $Id: toolbar.ch 350 2009-07-08 22:12:11Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

//----------------------------------------------------------------------------
// toolbar.ch
//----------------------------------------------------------------------------

#ifndef _WXH_TOOLBAR_CH_
#define _WXH_TOOLBAR_CH_

#include "defs.ch"

// ----------------------------------------------------------------------------
// wxToolBar style flags
// ----------------------------------------------------------------------------

    // lay out the toolbar horizontally
#define    wxTB_HORIZONTAL  wxHORIZONTAL    // == 0x0004
#define    wxTB_TOP         wxTB_HORIZONTAL

    // lay out the toolbar vertically
#define    wxTB_VERTICAL    wxVERTICAL      // == 0x0008
#define    wxTB_LEFT        wxTB_VERTICAL

    // show 3D buttons (wxToolBarSimple only)
#define    wxTB_3DBUTTONS   0x0010

    // "flat" buttons (Win32/GTK only)
#define    wxTB_FLAT        0x0020

    // dockable toolbar (GTK only)
#define    wxTB_DOCKABLE    0x0040

    // don't show the icons (they're shown by default)
#define    wxTB_NOICONS     0x0080

    // show the text (not shown by default)
#define    wxTB_TEXT        0x0100

    // don't show the divider between toolbar and the window (Win32 only)
#define    wxTB_NODIVIDER   0x0200

    // no automatic alignment (Win32 only, useless)
#define    wxTB_NOALIGN     0x0400

    // show the text and the icons alongside, not vertically stacked (Win32/GTK)
#define    wxTB_HORZ_LAYOUT 0x0800
#define    wxTB_HORZ_TEXT   HB_BitOr( wxTB_HORZ_LAYOUT | wxTB_TEXT )

    // don't show the toolbar short help tooltips
#define    wxTB_NO_TOOLTIPS 0x1000

    // lay out toolbar at the bottom of the window
#define    wxTB_BOTTOM       0x2000

    // lay out toolbar at the right edge of the window
#define    wxTB_RIGHT        0x4000

#endif
