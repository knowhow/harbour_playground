/*
 * $Id: wxhPlatformInfo.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"

/*
    wxPlatformInfo
    Teo. Mexico 2006
*/
CLASS wxPlatformInfo FROM wxObject
PRIVATE:
PROTECTED:
PUBLIC:

    METHOD New()

    METHOD CheckOSVersion( major AS NUMERIC, minor AS NUMERIC )
    METHOD CheckToolkitVersion( major AS NUMERIC, minor AS NUMERIC )
//	METHOD Get()
    METHOD GetArch( arch AS STRING )
    METHOD GetArchName( arch )
    METHOD GetArchitecture()
    METHOD GetEndianness( end )
    METHOD GetEndiannessName( end )
    METHOD GetOSMajorVersion()
    METHOD GetOSMinorVersion()
    METHOD GetOperatingSystemFamilyName( os )
    METHOD GetOperatingSystemId( name )
    METHOD GetOperatingSystemIdName( os )
    METHOD GetPortId( portName )
    METHOD GetPortIdName( port, usingUniversal )
    METHOD GetPortIdShortName( port, usingUniversal )
    METHOD GetToolkitMajorVersion()
    METHOD GetToolkitMinorVersion()
    METHOD IsOk()
    METHOD IsUsingUniversalWidgets()
    METHOD SetArchitecture( n )
    METHOD SetEndianness( n )
    METHOD SetOSVersion( major, minor )
    METHOD SetOperatingSystemId( n )
    METHOD SetPortId( n )
    METHOD SetToolkitVersion( major, minor )
PUBLISHED:
ENDCLASS
/*
    End Class wxPlatformInfo
*/
