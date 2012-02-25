/*
 * $Id: wx_EvtHandler.cpp 775 2011-10-12 21:04:17Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_EvtHandler
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_Frame.h"

#include "wx/timer.h"

static void ParseConnectParams( PCONN_PARAMS pConnParams );

/*
    __OnEvent
    Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::__OnEvent( wxEvent &event )
{
    PHB_ITEM pEvent = hb_itemNew( hb_stackReturnItem() );
    xho_ObjParams objParams = xho_ObjParams( pEvent );

    objParams.Return( &event );

    if( objParams.pXho_Item )
    {
        objParams.pXho_Item->delete_Xho = false;
        xho_Item* pXho_Item = xho_itemListGet_PXHO_ITEM( this );

        if( pXho_Item )
        {
            for( vector<PCONN_PARAMS>::iterator it = pXho_Item->evtList.begin(); it < pXho_Item->evtList.end(); it++ )
            {
                PCONN_PARAMS pConnParams = *it;
                if( event.GetEventType() == pConnParams->eventType ) /* TODO: this check is needed ? */
                {
                    if( pConnParams->force || ( event.GetId() == wxID_ANY ) || ( event.GetId() >= pConnParams->id && event.GetId() <= pConnParams->lastId ) )
                    {
                        hb_vmEvalBlockV( pConnParams->pItmActionBlock, 1 , pEvent );
                    }
                }
            }
        }
    }

    xho_itemListDel_XHO( &event );
    hb_itemRelease( pEvent );
}

/*
    OnActivateEvent
    Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnActivateEvent( wxActivateEvent& event )
{
    HB_FUNC_EXEC( WXACTIVATEEVENT );
    __OnEvent( event );
}

/*
    OnCloseEvent
    Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnCloseEvent( wxCloseEvent& event )
{
    HB_FUNC_EXEC( WXCLOSEEVENT );
    __OnEvent( event );
}

/*
    OnCommandEvent
    Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnCommandEvent( wxCommandEvent& event )
{
    HB_FUNC_EXEC( WXCOMMANDEVENT );
    __OnEvent( event );
}

/*
    OnFocusEvent
    Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnFocusEvent( wxFocusEvent& event )
{
    HB_FUNC_EXEC( WXFOCUSEVENT );
    __OnEvent( event );
}

/*
    OnGridEvent
    Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnGridEvent( wxGridEvent& event )
{
    HB_FUNC_EXEC( WXGRIDEVENT );
    __OnEvent( event );
}

/*
 OnInitDialogEvent
 Teo. Mexico 2009
 */
template <class T>
void hbEvtHandler<T>::OnInitDialogEvent( wxInitDialogEvent& event )
{
    HB_FUNC_EXEC( WXINITDIALOGEVENT );
    __OnEvent( event );
}

/*
 OnKeyEvent
 Teo. Mexico 2009
 */
template <class T>
void hbEvtHandler<T>::OnKeyEvent( wxKeyEvent& event )
{
    HB_FUNC_EXEC( WXKEYEVENT );
    __OnEvent( event );
}

/*
    OnMenuEvent
    Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnMenuEvent( wxMenuEvent& event )
{
    HB_FUNC_EXEC( WXMENUEVENT );
    __OnEvent( event );
}

/*
    OnMouseEvent
    Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnMouseEvent( wxMouseEvent& event )
{
    HB_FUNC_EXEC( WXMOUSEEVENT );
    __OnEvent( event );
}

/*
    OnNotebookEvent
    Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnNotebookEvent( wxNotebookEvent& event )
{
    HB_FUNC_EXEC( WXNOTEBOOKEVENT );
    __OnEvent( event );
}

/*
    OnSocketEvent
    Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnSocketEvent( wxSocketEvent& event )
{
    HB_FUNC_EXEC( WXSOCKETEVENT );
    __OnEvent( event );
}

/*
    OnTaskBarIconEvent
    Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnTaskBarIconEvent( wxTaskBarIconEvent& event )
{
    HB_FUNC_EXEC( WXTASKBARICONEVENT );
    __OnEvent( event );
}

/*
    OnTimerEvent
    Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnTimerEvent( wxTimerEvent& event )
{
    HB_FUNC_EXEC( WXTIMEREVENT );
    __OnEvent( event );
}

/*
    OnUpdateUIEvent
    Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::OnUpdateUIEvent( wxUpdateUIEvent& event )
{
    HB_FUNC_EXEC( WXUPDATEUIEVENT );
    __OnEvent( event );
}

/*
    wxConnect
    Teo. Mexico 2009
*/
template <class T>
void hbEvtHandler<T>::wxhConnect( int evtClass, PCONN_PARAMS pConnParams )
{
    wxObjectEventFunction objFunc = NULL;

    switch( evtClass )
    {
        case WXH_ACTIVATEEVENT:
            objFunc = wxActivateEventHandler( hbEvtHandler<T>::OnActivateEvent );
            break;
        case WXH_CLOSEEVENT:
            objFunc = wxCloseEventHandler( hbEvtHandler<T>::OnCloseEvent );
            break;
        case WXH_COMMANDEVENT:
            objFunc = wxCommandEventHandler( hbEvtHandler<T>::OnCommandEvent );
            break;
        case WXH_FOCUSEVENT:
            objFunc = wxFocusEventHandler( hbEvtHandler<T>::OnFocusEvent );
            pConnParams->force = true;
            break;
        case WXH_GRIDEVENT:
            objFunc = wxGridEventHandler( hbEvtHandler<T>::OnGridEvent );
            break;
        case WXH_INITDIALOGEVENT:
            objFunc = wxInitDialogEventHandler( hbEvtHandler<T>::OnInitDialogEvent );
            break;
        case WXH_KEYEVENT:
            objFunc = wxKeyEventHandler( hbEvtHandler<T>::OnKeyEvent );
            pConnParams->force = true;
            break;
        case WXH_MENUEVENT:
            objFunc = wxMenuEventHandler( hbEvtHandler<T>::OnMenuEvent );
            break;
        case WXH_MOUSEEVENT:
            objFunc = wxMouseEventHandler( hbEvtHandler<T>::OnMouseEvent );
            break;
        case WXH_NOTEBOOKEVENT:
            objFunc = wxNotebookEventHandler( hbEvtHandler<T>::OnNotebookEvent );
            break;
        case WXH_SOCKETEVENT:
            objFunc = wxSocketEventHandler( hbEvtHandler<T>::OnSocketEvent );
            break;
        case WXH_TASKBARICONEVENT:
            objFunc = wxTaskBarIconEventHandler( hbEvtHandler<T>::OnTaskBarIconEvent );
            break;
        case WXH_TIMEREVENT:
            objFunc = wxTimerEventHandler( hbEvtHandler<T>::OnTimerEvent );
            break;
        case WXH_UPDATEUIEVENT:
            objFunc = wxUpdateUIEventHandler( hbEvtHandler<T>::OnUpdateUIEvent );
            break;
        default:
            objFunc = NULL;
    }

    if( objFunc )
    {
        xho_Item* pXho_Item = xho_itemListGet_PXHO_ITEM( this );

        if( pXho_Item )
        {
            pXho_Item->evtList.push_back( pConnParams );
            this->Connect( pConnParams->id, pConnParams->lastId, pConnParams->eventType, objFunc );
        }
    }
}

/*
 * end hbEvtHandler<T> implemention
 */

/*
    Connect
    Teo. Mexico 2009
*/
static void Connect( int evtClass )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    PCONN_PARAMS pConnParams = new CONN_PARAMS;
    pConnParams->force = false;
    
    ParseConnectParams( pConnParams );

    hbEvtHandler<wxEvtHandler>* evtHandler = (hbEvtHandler<wxEvtHandler> *) xho_itemListGet_XHO( pSelf );

    if( !( pSelf && evtHandler ) )
        return;

    evtHandler->wxhConnect( evtClass, pConnParams );

}

/*
    ParseConnectParams
    Teo. Mexico 2009
*/
static void ParseConnectParams( PCONN_PARAMS pConnParams )
{
    int iParams = hb_pcount();

    if( iParams == 4 )
    {
        pConnParams->id = hb_parni( 1 );
        pConnParams->lastId = hb_parni( 2 );
        pConnParams->eventType = hb_parni( 3 );
        pConnParams->pItmActionBlock = hb_itemNew( hb_param( 4, HB_IT_BLOCK ) );
    }else if( iParams == 3 )
    {
        pConnParams->id = hb_parni( 1 );
        pConnParams->lastId = hb_parni( 1 );
        pConnParams->eventType = hb_parni( 2 );
        pConnParams->pItmActionBlock = hb_itemNew( hb_param( 3, HB_IT_BLOCK ) );
    }else if( iParams == 2 )
    {
        pConnParams->id = wxID_ANY;
        pConnParams->lastId = wxID_ANY;
        pConnParams->eventType = hb_parni( 1 );
        pConnParams->pItmActionBlock = hb_itemNew( hb_param( 2, HB_IT_BLOCK ) );
    }
}

/*
    ConnectActivateEvt
    Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTACTIVATEEVT )
{

    Connect( WXH_ACTIVATEEVENT );

}

/*
    ConnectCloseEvt
    Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTCLOSEEVT )
{

    Connect( WXH_CLOSEEVENT );

}

/*
    ConnectCommandEvt
    Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTCOMMANDEVT )
{

    Connect( WXH_COMMANDEVENT );

}

/*
    ConnectCommandEvt
    Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTFOCUSEVT )
{
    Connect( WXH_FOCUSEVENT );
}

/*
    ConnectCommandEvt
    Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTGRIDEVT )
{
    Connect( WXH_GRIDEVENT );
}

/*
 ConnectInitDialogEvt
 Teo. Mexico 2009
 */
HB_FUNC( WXEVTHANDLER_CONNECTINITDIALOGEVT )
{
    Connect( WXH_INITDIALOGEVENT );
}

/*
 ConnectKeyEvt
 Teo. Mexico 2009
 */
HB_FUNC( WXEVTHANDLER_CONNECTKEYEVT )
{
    Connect( WXH_KEYEVENT );
}

/*
    ConnectMenuEvt
    Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTMENUEVT )
{
    Connect( WXH_MENUEVENT );
}

/*
    ConnectMouseEvt
    Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTMOUSEEVT )
{
    Connect( WXH_MOUSEEVENT );
}

/*
    ConnectNotebookEvt
    Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTNOTEBOOKEVT )
{
    Connect( WXH_NOTEBOOKEVENT );
}

/*
    ConnectSocketEvt
    Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTSOCKETEVT )
{
    Connect( WXH_SOCKETEVENT );
}

/*
    ConnectTaskBarIconEvt
    Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTTASKBARICONEVT )
{
    Connect( WXH_TASKBARICONEVENT );
}

/*
    ConnectTimerEvt
    Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTTIMEREVT )
{
    Connect( WXH_TIMEREVENT );
}

/*
    ConnectUpdateUIEvt
    Teo. Mexico 2009
*/
HB_FUNC( WXEVTHANDLER_CONNECTUPDATEUIEVT )
{
    Connect( WXH_UPDATEUIEVENT );
}
