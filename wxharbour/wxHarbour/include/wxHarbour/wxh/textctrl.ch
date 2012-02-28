/*
 * $Id: textctrl.ch 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

// ----------------------------------------------------------------------------
// wxTextCtrl style flags
// ----------------------------------------------------------------------------
#ifndef _WXH_TEXTCTRL_CH_
#define _WXH_TEXTCTRL_CH_

#define wxTE_NO_VSCROLL     0x0002
#define wxTE_AUTO_SCROLL    0x0008

#define wxTE_READONLY       0x0010
#define wxTE_MULTILINE      0x0020
#define wxTE_PROCESS_TAB    0x0040

// alignment flags
#define wxTE_LEFT           0x0000                    // 0x0000
#define wxTE_CENTER         wxALIGN_CENTER_HORIZONTAL // 0x0100
#define wxTE_RIGHT          wxALIGN_RIGHT             // 0x0200
#define wxTE_CENTRE         wxTE_CENTER

// this style means to use RICHEDIT control and does something only under wxMSW
// and Win32 and is silently ignored under all other platforms
#define wxTE_RICH           0x0080

#define wxTE_PROCESS_ENTER  0x0400
#define wxTE_PASSWORD       0x0800

// automatically detect the URLs and generate the events when mouse is
// moved/clicked over an URL
//
// this is for Win32 richedit and wxGTK2 multiline controls only so far
#define wxTE_AUTO_URL       0x1000

// by default, the Windows text control doesn't show the selection when it
// doesn't have focus - use this style to force it to always show it
#define wxTE_NOHIDESEL      0x2000

// use wxHSCROLL to not wrap text at all, wxTE_CHARWRAP to wrap it at any
// position and wxTE_WORDWRAP to wrap at words boundary
//
// if no wrapping style is given at all, the control wraps at word boundary
#define wxTE_DONTWRAP       wxHSCROLL
#define wxTE_CHARWRAP       0x4000  // wrap at any position
#define wxTE_WORDWRAP       0x0001  // wrap only at words boundaries
#define wxTE_BESTWRAP       0x0000  // this is the default

#ifdef WXWIN_COMPATIBILITY_2_6
        // obsolete synonym
        #define wxTE_LINEWRAP       wxTE_CHARWRAP
#endif // WXWIN_COMPATIBILITY_2_6

// force using RichEdit version 2.0 or 3.0 instead of 1.0 (default) for
// wxTE_RICH controls - can be used together with or instead of wxTE_RICH
#define wxTE_RICH2          0x8000

// reuse wxTE_RICH2's value for CAPEDIT control on Windows CE
#if defined(__SMARTPHONE__) || defined(__POCKETPC__)
#define wxTE_CAPITALIZE     wxTE_RICH2
#else
#define wxTE_CAPITALIZE     0
#endif

#endif
