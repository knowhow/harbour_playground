/*
 * $Id: platinfo.ch 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2010 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2010 Teo Fonrouge <teo@windtelsoft.com>
*/

//----------------------------------------------------------------------------
// platinfo
//----------------------------------------------------------------------------

#ifndef _PLATINFO_CH_
#define _PLATINFO_CH_

#define wxOS_UNKNOWN	0						// returned on error

#define wxOS_MAC_OS			HB_BitShift( 1, 0 )	// Apple Mac OS 8/9/X with Mac paths
#define wxOS_MAC_OSX_DARWIN HB_BitShift( 1, 1 )	// Apple Mac OS X with Unix paths
#define wxOS_MAC			HB_BitOr( wxOS_MAC_OS, wxOS_MAC_OSX_DARWIN )

#define wxOS_WINDOWS_9X		HB_BitShift( 1, 2 )	// Windows 9x family (95/98/ME)
#define wxOS_WINDOWS_NT		HB_BitShift( 1, 3 )	// Windows NT family (NT/2000/XP)
#define wxOS_WINDOWS_MICRO	HB_BitShift( 1, 4 )	// MicroWindows
#define wxOS_WINDOWS_CE		HB_BitShift( 1, 5 )	// Windows CE (Window Mobile)
#define wxOS_WINDOWS		HB_BitOr( wxOS_WINDOWS_9X, wxOS_WINDOWS_NT, wxOS_WINDOWS_MICRO, wxOS_WINDOWS_CE )

#define wxOS_UNIX_LINUX		HB_BitShift( 1, 6 )	// Linux
#define wxOS_UNIX_FREEBSD	HB_BitShift( 1, 7 )	// FreeBSD
#define wxOS_UNIX_OPENBSD	HB_BitShift( 1, 8 )	// OpenBSD
#define wxOS_UNIX_NETBSD	HB_BitShift( 1, 9 )	// NetBSD
#define wxOS_UNIX_SOLARIS	HB_BitShift( 1,10 )	// SunOS
#define wxOS_UNIX_AIX		HB_BitShift( 1,11 )	// AIX
#define wxOS_UNIX_HPUX		HB_BitShift( 1,12 )	// HP/UX
#define wxOS_UNIX			HB_BitOr( wxOS_UNIX_LINUX, wxOS_UNIX_FREEBSD, wxOS_UNIX_OPENBSD, wxOS_UNIX_NETBSD, wxOS_UNIX_SOLARIS, wxOS_UNIX_AIX, wxOS_UNIX_HPUX )

    // 1<<13 and 1<<14 available for other Unix flavours

#define wxOS_DOS			HB_BitShift( 1,15 )	// Microsoft DOS
#define wxOS_OS2			HB_BitShift( 1,16 )	// OS/2

#endif
