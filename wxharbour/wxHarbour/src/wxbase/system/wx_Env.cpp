/*
 * $Id: wx_Env.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2010 Teo Fonrouge

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

 (C) 2010 Teo Fonrouge <teo@windtelsoft.com>
 */

#include "wx/wx.h"
#include "wxh.h"

/*
 * wxGetEnv( var ) -> returns string with "var" environment value
 * wxGetEnv( var, @value ) -> returns true if "var" exists, value is asigned by reference
 */
HB_FUNC( WXGETENV )
{
    if( hb_pcount() > 1 )
    {
        PHB_ITEM hbpValue = hb_param( 2, HB_IT_BYREF );
        wxString value;
        wxString* pValue = NULL;

        if( hbpValue )
        {
            pValue = &value ;
        }

        hb_retl( wxGetEnv( wxh_parc( 1 ), pValue ) );

        if( pValue )
        {
            hb_itemPutC( hbpValue, value.mb_str() );
        }
    }
    else
        wxh_retc( wxGetenv( wxh_parc( 1 ) ) );
}

/*
 * wxSetEnv( var, value ) -> returns true if "value" was added to "var" environment
 */
HB_FUNC( WXSETENV )
{
    hb_retl( wxSetEnv( wxh_parc( 1 ), wxh_parc( 2 ) ) );
}

/*
 * wxUnsetEnv( var ) -> returns true on success
 */
HB_FUNC( WXUNSETENV )
{
    hb_retl( wxUnsetEnv( wxh_parc( 1 ) ) );
}
