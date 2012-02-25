/*
 * $Id: wxh.h 661 2010-11-04 13:22:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxh.h
    Teo. Mexico 2009
*/

/*
    Harbour related include files
*/
#include "hbvmint.h"

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbapicls.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapierr.h"

#include "hbchksum.h"

#include "wx/grid.h"
#include "wxhevtdefs.h"
#include "wx/socket.h"
#include "wx/timer.h"
#include "wx/taskbar.h"
#include "wx/notebook.h"

#ifdef __VISUALC__

#pragma warning(disable : 4800) // forcing value to bool ...

#endif

#ifndef wxVERSION
#define wxVERSION ( wxMAJOR_VERSION * 10000 + wxMINOR_VERSION * 100 + wxRELEASE_NUMBER )
#endif

#include <iostream>

#include <vector>

#define WXH_ERRBASE     8000

using namespace std;

//typedef wxObject    xhoObject;
#define xhoObject wxObject
#define xhoEventType wxEventType
#define xhoTopLevelWindow   "WXTOPLEVELWINDOW"

class xho_Item;

/* PHB_BASEARRAY keys, xho_Item* values */
WX_DECLARE_HASH_MAP( PHB_BASEARRAY, xho_Item*, wxPointerHash, wxPointerEqual, MAP_PHB_BASEARRAY );

/* wxObject* keys, xho_Item* values */
WX_DECLARE_HASH_MAP( wxObject*, xho_Item*, wxPointerHash, wxPointerEqual, MAP_XHOOBJECT );

/* long keys (crc32), xho_Item* values */
WX_DECLARE_HASH_MAP( long, xho_Item*, wxIntegerHash, wxIntegerEqual, MAP_CRC32 );

/* PHB_ITEM key, wxObject* values */
WX_DECLARE_HASH_MAP( PHB_ITEM, bool, wxPointerHash, wxPointerEqual, MAP_PHB_ITEM );

#include "xho_classes.h"

HB_FUNC_EXTERN( WXACTIVATEEVENT );
HB_FUNC_EXTERN( WXCLOSEEVENT );
HB_FUNC_EXTERN( WXCOMMANDEVENT );
HB_FUNC_EXTERN( WXFOCUSEVENT );
HB_FUNC_EXTERN( WXGRIDEVENT );
HB_FUNC_EXTERN( WXINITDIALOGEVENT );
HB_FUNC_EXTERN( WXKEYEVENT );
HB_FUNC_EXTERN( WXMENUEVENT );
HB_FUNC_EXTERN( WXMOUSEEVENT );
HB_FUNC_EXTERN( WXNOTEBOOKEVENT );
HB_FUNC_EXTERN( WXSOCKETEVENT );
HB_FUNC_EXTERN( WXTASKBARICONEVENT );
HB_FUNC_EXTERN( WXTIMEREVENT );
HB_FUNC_EXTERN( WXUPDATEUIEVENT );

wxArrayString wxh_par_wxArrayString( int param );
wxColour      wxh_par_wxColour( int param );
wxDateTime    wxh_par_wxDateTime( int param );
wxPoint       wxh_par_wxPoint( int param );
wxSize        wxh_par_wxSize( int param );
wxString      wxh_parc( int param );
void		  wxh_ret_wxPoint( const wxPoint& point );
void		  wxh_ret_wxSize( wxSize* size );
void		  wxh_retc( const wxString & string );

wxString      wxh_CTowxString( const char * szStr, bool convOEM = false );
PHB_ITEM      wxh_itemNullObject( PHB_ITEM pSelf );
#define		  wxh_wxStringToC( string ) \
                (string).mb_str( wxConvUTF8 )
void          TRACEOUT( const char* fmt, const void* val);
void          TRACEOUT( const char* fmt, long int val);

/* wxharbour error handling */
void wxh_errRT_ParamNum();   // error at wrong number of params

/*
    template for send event handling to harbour objects
    Teo. Mexico 2009
*/
template <class T>
class hbEvtHandler : public T
{
private:
    void __OnEvent( wxEvent &event );
public:

    void OnActivateEvent( wxActivateEvent& event );
    void OnCloseEvent( wxCloseEvent& event );
    void OnCommandEvent( wxCommandEvent& event );
    void OnFocusEvent( wxFocusEvent& event );
    void OnGridEvent( wxGridEvent& event );
    void OnInitDialogEvent( wxInitDialogEvent& event );
    void OnKeyEvent( wxKeyEvent& event );
    void OnMenuEvent( wxMenuEvent& event );
    void OnMouseEvent( wxMouseEvent& event );
    void OnNotebookEvent( wxNotebookEvent& event );
    void OnSocketEvent( wxSocketEvent& event );
    void OnTaskBarIconEvent( wxTaskBarIconEvent& event );
    void OnTimerEvent( wxTimerEvent& event );
    void OnUpdateUIEvent( wxUpdateUIEvent& event );

    void wxhConnect( int evtClass, PCONN_PARAMS pConnParams );

    ~hbEvtHandler<T>();
};

/*
    ~hbEvtHandler
    Teo. Mexico 2009
*/
template <class T>
hbEvtHandler<T>::~hbEvtHandler()
{
    xho_Item* pXho_Item = xho_itemListGet_PXHO_ITEM( this );

    if( pXho_Item )
    {
        pXho_Item->delete_Xho = false;
        //delete pXho_Item;
    }
}

/*
 template for wxWindow
 Teo. Mexico 2009
 */
template <class tW>
class hbWindow : public hbEvtHandler<tW>
    {
    };
