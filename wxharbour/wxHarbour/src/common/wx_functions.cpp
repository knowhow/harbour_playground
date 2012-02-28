/*
 * $Id: wx_functions.cpp 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wx/wx.h"
#include "wxh.h"

HB_FUNC( WXEVT_FIRST )
{
    hb_retnl( wxEVT_COMMAND_BUTTON_CLICKED + hb_parnl(1) - 1 );
}

/*
    wxGetFreeMemory
    Teo. Mexico 2010
*/
HB_FUNC( WXGETFREEMEMORY )
{
    hb_retnint( ( wxGetFreeMemory() ).ToLong() );
}

/*
    wxGetFullHostName
    Teo. Mexico 2009
*/
HB_FUNC( WXGETFULLHOSTNAME )
{
    wxh_retc( wxGetFullHostName() );
}

/*
 wxGetHomeDir
 Teo. Mexico 2010
 */
HB_FUNC( WXGETHOMEDIR )
{
    wxh_retc( wxGetHomeDir() );
}

/*
 wxGetHostName
 Teo. Mexico 2009
 */
HB_FUNC( WXGETHOSTNAME )
{
    wxh_retc( wxGetHostName() );
}

/*
 wxGetOsDescription
 Teo. Mexico 2007
 */
HB_FUNC( WXGETOSDESCRIPTION )
{
    wxh_retc( wxGetOsDescription() );
}

/*
 wxGetOsVersion
 Teo. Mexico 2010
 */
HB_FUNC( WXGETOSVERSION )
{
    hb_retni( wxGetOsVersion() );
}

/*
 wxIsPlatformLittleEndian
 Teo. Mexico 2010
 */
HB_FUNC( WXISPLATFORMLITTLEENDIAN )
{
    hb_retl( wxIsPlatformLittleEndian() );
}

/*
 wxIsPlatform64Bit
 Teo. Mexico 2010
 */
HB_FUNC( WXISPLATFORM64BIT )
{
    hb_retl( wxIsPlatform64Bit() );
}

/*
 wxGetUserHome
 Teo. Mexico 2010
 */
HB_FUNC( WXGETUSERHOME )
{
    wxh_retc( wxGetUserHome( wxh_parc( 1 ) ) );
}

/*
 wxGetUserId
 Teo. Mexico 2008
 */
HB_FUNC( WXGETUSERID )
{
    wxh_retc( wxGetUserId() );
}

/*
    wxGetUserName
    Teo. Mexico 2008
*/
HB_FUNC( WXGETUSERNAME )
{
    wxh_retc( wxGetUserName() );
}

/*
    wxNow
    Teo. Mexico 2007
*/
HB_FUNC( WXNOW )
{
    wxh_retc( wxNow() );
}
