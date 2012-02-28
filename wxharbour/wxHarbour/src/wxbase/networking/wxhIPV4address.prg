/*
 * $Id: wxhIPV4address.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxIPV4address
    Teo. Mexico 2008
*/

#include "hbclass.ch"
#include "property.ch"

/*
    wxIPV4address
    Teo. Mexico 2008
*/
CLASS wxIPV4address FROM wxObject
PRIVATE:
PROTECTED:
PUBLIC:
    CONSTRUCTOR New
    METHOD Hostname( hostname )
    METHOD IPAddress
    METHOD Service( service )
    METHOD AnyAddress
    METHOD LocalHost

    /* Implemented on wxIPaddress */
    METHOD IsLocalHost

    /* Implemented on wxSockAddress */
    METHOD Clear
    //METHOD SockAddrLen
PUBLISHED:
ENDCLASS

/*
    End Class wxIPV4address
*/
