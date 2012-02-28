/*
 * $Id: wx_App.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxwApp: Implementation
    Teo. Mexico 2006
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_App.h"

#include "wx/image.h"

static PHB_ITEM hb_App = NULL;

/*
    wxGetApp
    Teo. Mexico 2008
*/
HB_FUNC( WXGETAPP )
{
    hb_itemReturn( hb_App );
}

/*
    wxInitialize
    Teo. Mexico 2009
 */
HB_FUNC( WXINITIALIZE )
{
    hb_retl( wxInitialize() );
}

HB_FUNC_EXTERN( __QUIT );
HB_FUNC_EXTERN( WXHERRORSYS );

/*
    wxSafeYield
    Teo. Mexico 2009
*/
HB_FUNC( WXSAFEYIELD )
{
    hb_retl( wxSafeYield( (wxWindow *) xho_itemListGet_XHO( hb_param( 1, HB_IT_OBJECT ) ), hb_parl( 2 ) ) );
}

HB_FUNC_EXTERN( __QUIT );
HB_FUNC_EXTERN( WXHERRORSYS );

/*
    OnExit
    Teo. Mexico 2008
*/
int wx_App::OnExit()
{
    int iResult = hb_itemGetNI( hb_objSendMsg( hb_App, "OnExit", 0 ) );
    HB_FUNC_EXEC( __QUIT );
    return iResult;
}

/*
    destructor
    Teo. Mexico 2009
*/
wx_App::~wx_App()
{
    xho_itemListReleaseAll();
    hb_itemRelease( hb_App );
}

/*
    OnInit
    Teo. Mexico 2006
*/
bool wx_App::OnInit()
{

#if wxUSE_XPM
    wxImage::AddHandler(new wxXPMHandler);
#endif
#if wxUSE_LIBPNG
    wxImage::AddHandler(new wxPNGHandler);
#endif
#if wxUSE_LIBJPEG
    wxImage::AddHandler(new wxJPEGHandler);
#endif
#if wxUSE_GIF
    wxImage::AddHandler(new wxGIFHandler);
#endif

    /* set our error handler */
    HB_FUNC_EXEC( WXHERRORSYS );
    return hb_itemGetL( hb_objSendMsg( hb_App, "OnInit", 0 ) );
}

/*
    end class wx_App
*/

IMPLEMENT_APP_NO_MAIN( wx_App )
IMPLEMENT_CLASS( wx_App, wxApp )

/*
    New
    Teo. Mexico 2008
*/
HB_FUNC( WXAPP_NEW )
{
    PHB_ITEM pSelf = hb_stackSelfItem();

    hb_App = hb_itemNew( pSelf );

    hb_itemReturn( pSelf );

}

/*! \brief wxApp initializacion, we don't link here the wxApp c++ because we can get it right from the wxGetApp function
        \param wxApp HBCLASS
        \return The wxApp Harbour object
    Constructor: wxApp Object
    Teo. Mexico 2006
*/
HB_FUNC( WXAPP_IMPLEMENT )
{
    int i_args = 0;
    char **p_args = NULL;

    wxEntry( i_args, p_args );

}

/*
    wxApp::GetTopWindow
    Teo. Mexico 2008
*/
HB_FUNC( WXAPP_GETTOPWINDOW )
{
    wxWindow *window = wxGetApp().GetTopWindow();
    if( window )
        xho_itemReturn( window );
    else
        hb_ret();
}

/*
    wxApp::ExitMainLoop
    Teo. Mexico 2008
*/
HB_FUNC( WXAPP_EXITMAINLOOP )
{
    wxGetApp().ExitMainLoop();
}

/*
    wxApp::Yield
    Teo. Mexico 2008
*/
HB_FUNC( WXAPP_YIELD )
{
    hb_retl( wxGetApp().Yield( hb_parl( 1 ) ) );
}
