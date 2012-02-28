/*
 * $Id: toplevel.ch 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    toplevel.ch
    Teo. Mexico 2008
*/

#ifndef _WX_TOPLEVEL_H_
#define _WX_TOPLEVEL_H_

// ----------------------------------------------------------------------------
// constants
// ----------------------------------------------------------------------------

// style common to both wxFrame and wxDialog
#define wxSTAY_ON_TOP           0x8000
#define wxICONIZE               0x4000
#define wxMINIMIZE              wxICONIZE
#define wxMAXIMIZE              0x2000
#define wxCLOSE_BOX             0x1000

#define wxSYSTEM_MENU           0x0800
#define wxMINIMIZE_BOX          0x0400
#define wxMAXIMIZE_BOX          0x0200
#define wxTINY_CAPTION_HORIZ    0x0100
#define wxTINY_CAPTION_VERT     0x0080
#define wxRESIZE_BORDER         0x0040

// default style
//
// under Windows CE (at least when compiling with eVC 4) we should create
// top level windows without any styles at all for them to appear
// "correctly", i.e. as full screen windows with a "hide" button (same as
// "close" but round instead of squared and just hides the applications
// instead of closing it) in the title bar
#ifdef __WXWINCE__
        #ifdef __SMARTPHONE__
                #define wxDEFAULT_FRAME_STYLE (wxMAXIMIZE)
        #elifdef __WINCE_STANDARDSDK__
                #define wxDEFAULT_FRAME_STYLE HB_BitOr(wxMAXIMIZE,wxCLOSE_BOX)
        #else
                #define wxDEFAULT_FRAME_STYLE (wxNO_BORDER)
        #endif
#else // !__WXWINCE__
        #define wxDEFAULT_FRAME_STYLE ;
                        HB_BitOr( wxSYSTEM_MENU, ;
                                             wxRESIZE_BORDER, ;
                                             wxMINIMIZE_BOX, ;
                                             wxMAXIMIZE_BOX, ;
                                             wxCLOSE_BOX, ;
                                             wxCAPTION, ;
                                             wxCLIP_CHILDREN)
#endif

#endif
