/*
 * $Id: filedlg.ch 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

//----------------------------------------------------------------------------
// wxFileDialog data
//----------------------------------------------------------------------------

/*
        The flags below must coexist with the following flags in m_windowStyle
        #define wxCAPTION               0x20000000
        #define wxMAXIMIZE              0x00002000
        #define wxCLOSE_BOX             0x00001000
        #define wxSYSTEM_MENU           0x00000800
        wxBORDER_NONE   =               0x00200000
        #define wxRESIZE_BORDER         0x00000040
*/

#define    wxFD_OPEN              0x0001
#define    wxFD_SAVE              0x0002
#define    wxFD_OVERWRITE_PROMPT  0x0004
#define    wxFD_FILE_MUST_EXIST   0x0010
#define    wxFD_MULTIPLE          0x0020
#define    wxFD_CHANGE_DIR        0x0080
#define    wxFD_PREVIEW           0x0100
