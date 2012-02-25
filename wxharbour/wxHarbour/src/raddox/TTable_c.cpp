/*
 * $Id: TTable_c.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wxh.h"

#include "wxbase/wx_SocketBase.h"

#include "rdodefs.h"

/*
    TTable:SendToServer
    Teo. Mexico 2008
*/
HB_FUNC( TTABLE_SENDTOSERVER )
{
    PHB_ITEM pSelf = hb_stackSelfItem();

    char pBuffer[ SND_BUFFERSIZE ];
    ULONG bufSize, ulLen;

    bufSize = sizeof( ULONG );
    ulLen = sizeof( hb_arrayId( pSelf ) );

    cout << endl << "*** " << hb_arrayId( pSelf ) << " ***" << endl;
    memcpy( pBuffer + bufSize, (HB_BASEARRAY *) hb_arrayId( pSelf ), ulLen );
    bufSize += ulLen;

    hb_procname( 1, pBuffer + bufSize + 1, FALSE );
    ulLen = strlen( pBuffer + bufSize + 1 );
    pBuffer[ bufSize ] = BYTE( ulLen + 1 );
    bufSize += ulLen + 2;

    USHORT iPCount = hb_pcount();

    memcpy( pBuffer + bufSize, &iPCount, sizeof( iPCount ) );
    bufSize += sizeof( iPCount );

    if( iPCount )
    {
        char* pBuf;
        ULONG ulSize;
        for( int i = 1; i <= iPCount; i++ )
        {
            pBuf = hb_itemSerialize( hb_param( i, HB_IT_ANY ), FALSE, &ulSize );
            memcpy( pBuffer + bufSize, &ulSize, sizeof( ulSize ) );
            bufSize += sizeof( ulSize );
            memcpy( pBuffer + bufSize, pBuf, ulSize );
            bufSize += ulSize;
            hb_xfree( pBuf );
        }
    }

    memcpy( pBuffer, &bufSize, sizeof( bufSize ) );

    hb_objSendMsg( pSelf, "RDOClient", 0 );
    PHB_ITEM pRDOClient = hb_stackReturnItem();
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( pRDOClient );

    if( socketBase )
    {
        socketBase->Write( pBuffer, bufSize );
    }
    else
        hb_objSendMsg( pSelf, "Error_SocketBase", 0 );

    socketBase->Read( &bufSize, sizeof( bufSize ) );
    socketBase->Read( pBuffer, bufSize );

    cout << endl;
    cout << pBuffer;

    const char *p = pBuffer;
    hb_itemReturnRelease( hb_itemDeserialize( &p, &bufSize ) );

}
