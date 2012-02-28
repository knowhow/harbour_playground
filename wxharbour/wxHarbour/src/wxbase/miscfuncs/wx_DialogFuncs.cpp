/*
 * $Id: wx_DialogFuncs.cpp 743 2011-07-27 18:26:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx Dialog Functions
    Teo. Mexico 2008
*/

#include "wx/wx.h"
#include "wxh.h"

/*
    wxMessageBox
    Teo. Mexico 2008
*/
HB_FUNC( WXMESSAGEBOX )
{

    const wxString& message = wxh_parc( 1 );
    const wxString& caption = wxh_parc( 2 );
    int style = HB_ISNIL(3) ? wxOK : hb_parni(3);
    wxWindow* window = (wxWindow *) xho_par_XhoObject( 4 );
    int x = HB_ISNIL(5) ? -1 : hb_parni(5);
    int y = HB_ISNIL(6) ? -1 : hb_parni(6);

    hb_retni( wxMessageBox( message, caption, style, window, x, y ) );

}
