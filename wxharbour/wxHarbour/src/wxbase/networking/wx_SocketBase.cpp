/*
 * $Id: wx_SocketBase.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_SocketBase: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_SocketBase.h"

/*
    Constructor
    Teo. Mexico 2009
*/
wx_SocketBase::wx_SocketBase()
{
}

/*
    ~wx_SocketBase
    Teo. Mexico 2009
*/
wx_SocketBase::~wx_SocketBase()
{
    xho_itemListDel_XHO( this );
}

/*
    Constructor: Object
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_SocketBase* socketBase;

    socketBase = new wx_SocketBase;

    objParams.Return( socketBase );
}

/*
    void Close
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_CLOSE )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        socketBase->Close();
}

/*
    bool Destroy
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_DESTROY )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        hb_retl( socketBase->Destroy() );
}

/*
    self Discard
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_DISCARD )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( pSelf );

    if( socketBase )
    {
        socketBase->Discard();
        hb_itemReturn( pSelf );
    }
}

/*
    bool Error
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_ERROR )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        hb_retl( socketBase->Error() );
}

/*
    void GetClientData
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_GETCLIENTDATA )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        hb_retptr( socketBase->GetClientData() );
}

/*
    bool GetLocal
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_GETLOCAL )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wx_SocketBase* socketBase = (wx_SocketBase*) objParams.Get_xhoObject();

    wxObject* object = (wxObject *) objParams.param( 1 );

    if( socketBase && object )
        hb_retl( socketBase->GetLocal( (wxSockAddress &) *object ) );
}

/*
    wxSocketFlags GetFlags
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_GETFLAGS )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        hb_retnl( socketBase->GetFlags() );
}

/*
    bool GetPeer
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_GETPEER )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wx_SocketBase* socketBase = (wx_SocketBase*) objParams.Get_xhoObject();

    wxObject* object = (wxObject *) objParams.param( 1 );

    if( socketBase && object )
        hb_retl( socketBase->GetPeer( (wxSockAddress &) *object ) );
}

/*
    void InterruptWait
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_INTERRUPTWAIT )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        socketBase->InterruptWait();
}

/*
    bool IsConnected
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_ISCONNECTED )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        hb_retl( socketBase->IsConnected() );
}

/*
    bool IsData
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_ISDATA )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        hb_retl( socketBase->IsData() );
}

/*
    bool IsDisconnected
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_ISDISCONNECTED )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        hb_retl( socketBase->IsDisconnected() );
}

/*
    wxUint32 LastCount
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_LASTCOUNT )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        hb_retnl( socketBase->LastCount() );
}

/*
    wxSocketError LastError
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_LASTERROR )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        hb_retnl( socketBase->LastError() );
}

/*
    void Notify
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_NOTIFY )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        socketBase->Notify( hb_parl( 1 ) );
}

/*
    bool IsOk
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_ISOK )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        hb_retl( socketBase->IsOk() );
}

/*
    wxSocketBase Peek
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_PEEK )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( pSelf );

    PHB_ITEM pBuffer = hb_param( 1, HB_IT_STRING );
    wxUint32 nbytes = hb_parnl( 2 );

    if( pBuffer == NULL || !ISBYREF( 1 ) )
    {
//     hb_errRT_BASE_SubstR( EG_ARG, 3012, NULL, &hb_errFuncName, HB_ERR_ARGS_BASEPARAMS );
        return;
    }

    pBuffer = hb_itemUnShareString( pBuffer );

    if( socketBase )
    {
        socketBase->Peek( (char *) hb_itemGetCPtr( pBuffer ), nbytes );
        hb_itemReturn( pSelf );
    }
}

/*
    wxSocketBase_ReadBase
    Teo. Mexico 2009
*/
void wxSocketBase_ReadBase( BYTE type )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( pSelf );

    PHB_ITEM pBuffer = hb_param( 1, HB_IT_STRING );

    if( pBuffer == NULL || !ISBYREF( 1 ) )
    {
        hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 10, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
        return;
    }

    if( socketBase )
    {
        pBuffer = hb_itemUnShareString( pBuffer );

        wxUint32 nbytes = ISNIL( 2 ) ?  hb_itemGetCLen( pBuffer ) : hb_parnl( 2 );

        if( nbytes > 0 )
        {
            if( nbytes > hb_itemGetCLen( pBuffer ) )
                hb_itemReSizeString( pBuffer, nbytes );

            if( type == '0' )
                socketBase->Read( (char *) hb_itemGetCPtr( pBuffer ), nbytes );
            else
                socketBase->ReadMsg( (char *) hb_itemGetCPtr( pBuffer ), nbytes );

            wxUint32 uiLastCount = socketBase->LastCount();

            if( uiLastCount < hb_itemGetCLen( pBuffer ) )
//         hb_itemGetCLen( pBuffer ) = uiLastCount;
                hb_itemReSizeString( pBuffer, uiLastCount );

        }else
            hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 10, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );

        hb_itemReturn( pSelf );
    }
}

/*
    wxSocketBase Read
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_READ )
{
    wxSocketBase_ReadBase( '0' );
}

/*
    wxSocketBase ReadMsg
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_READMSG )
{
    wxSocketBase_ReadBase( '1' );
}

/*
    void RestoreState
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_RESTORESTATE )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        socketBase->RestoreState();
}

/*
    void SaveState
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_SAVESTATE )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        socketBase->SaveState();
}

/*
    void SetClientData
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_SETCLIENTDATA )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
        socketBase->SetClientData( hb_parptr( 1 ) );
}

/*
    void SetEventHandler
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_SETEVENTHANDLER )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wx_SocketBase* socketBase = (wx_SocketBase*) objParams.Get_xhoObject();

    wxEvtHandler* evtHandler = (wxEvtHandler *) objParams.paramParent( 1 );

    if( socketBase && evtHandler )
    {
        int id = ISNUM( 2 ) ? hb_parni( 2 ) : -1 ;
        socketBase->SetEventHandler( *evtHandler, id );
    }
}

/*
    void SetFlags
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_SETFLAGS )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    wxSocketFlags flags = hb_parnl( 1 );
    if( socketBase )
        socketBase->SetFlags( flags );
}

/*
    bool SetLocal
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_SETLOCAL )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wx_SocketBase* socketBase = (wx_SocketBase*) objParams.Get_xhoObject();

    wxIPV4address* local = (wxIPV4address *) objParams.param( 1 );

    if( socketBase && local )
    {
        hb_retl( socketBase->SetLocal( *local ) );
    }
}

/*
    void SetNotify
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_SETNOTIFY )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
    {
        wxSocketEventFlags flags = hb_parnl( 1 );
        socketBase->SetNotify( flags );
    }
}

/*
    void SetTimeOut
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_SETTIMEOUT )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
    {
        int seconds = hb_parni( 1 );
        socketBase->SetTimeout( seconds );
    }
}

/*
    wxSocketBase Unread
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_UNREAD )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( pSelf );

    PHB_ITEM pBuffer = hb_param( 1, HB_IT_STRING );
    wxUint32 nbytes = hb_parnl( 2 );

    if( pBuffer == NULL || !ISBYREF( 1 ) )
    {
//     hb_errRT_BASE_SubstR( EG_ARG, 3012, NULL, &hb_errFuncName, HB_ERR_ARGS_BASEPARAMS );
        return;
    }

    pBuffer = hb_itemUnShareString( pBuffer );

    if( socketBase )
    {
        socketBase->Unread( (char *) hb_itemGetCPtr( pBuffer ), nbytes );
        hb_itemReturn( pSelf );
    }
}

/*
    bool Wait
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_WAIT )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
    {
        long seconds = ISNUM( 1 ) ? hb_parnl( 1 ) : -1;
        long millisecond = hb_parnl( 2 );
        hb_retl( socketBase->Wait( seconds, millisecond ) );
    }
}

/*
    bool WaitForLost
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_WAITFORLOST )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
    {
        long seconds = ISNUM( 1 ) ? hb_parnl( 1 ) : -1;
        long millisecond = hb_parnl( 2 );
        hb_retl( socketBase->WaitForLost( seconds, millisecond ) );
    }
}

/*
    bool WaitForRead
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_WAITFORREAD )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
    {
        long seconds = ISNUM( 1 ) ? hb_parnl( 1 ) : -1;
        long millisecond = hb_parnl( 2 );
        hb_retl( socketBase->WaitForRead( seconds, millisecond ) );
    }
}

/*
    bool WaitForWrite
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_WAITFORWRITE )
{
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( socketBase )
    {
        long seconds = ISNUM( 1 ) ? hb_parnl( 1 ) : -1;
        long millisecond = hb_parnl( 2 );
        hb_retl( socketBase->WaitForWrite( seconds, millisecond ) );
    }
}

/*
    wxSocketBase Write
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_WRITE )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( pSelf );

    if( socketBase )
    {
        PHB_ITEM pBuffer = hb_param( 1, HB_IT_STRING );
        wxUint32 nbytes = ISNIL( 2 ) ? hb_itemGetCLen( pBuffer ) : hb_parnl( 2 );
        socketBase->Write( (char *) hb_itemGetCPtr( pBuffer ), nbytes );
        hb_itemReturn( pSelf );
    }
}

/*
    wxSocketBase WriteMsg
    Teo. Mexico 2009
*/
HB_FUNC( WXSOCKETBASE_WRITEMSG )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wx_SocketBase* socketBase = (wx_SocketBase*) xho_itemListGet_XHO( pSelf );

    if( socketBase )
    {
        PHB_ITEM pBuffer = hb_param( 1, HB_IT_STRING );
        wxUint32 nbytes = ISNIL( 2 ) ? hb_itemGetCLen( pBuffer ) : hb_parnl( 2 );
        socketBase->WriteMsg( (char *) hb_itemGetCPtr( pBuffer ), nbytes );
        hb_itemReturn( pSelf );
    }
}

// revisar pedido 7663 gilberto gamboa
