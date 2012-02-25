/*
 * $Id: wx_TaskBarIcon.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_TaskBarIcon: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wxh.h"

#include "wxbase/wx_TaskBarIcon.h"

#include "wxwin32x32.xpm"

/*
    ~wx_TaskBarIcon
    Teo. Mexico 2009
*/
wx_TaskBarIcon::~wx_TaskBarIcon()
{
    xho_itemListDel_XHO( this );
}

/*
    CreatePopupMenu
    Teo. Mexico 2009
*/
wxMenu* wx_TaskBarIcon::CreatePopupMenu()
{
    PHB_ITEM pTaskBarIcon = xho_itemListGet_HB( this );
    wxMenu* menu = NULL;

    if( pTaskBarIcon )
    {
        hb_objSendMsg( pTaskBarIcon, "CreatePopupMenu", 0 );
        menu = (wxMenu *) xho_itemListGet_XHO( hb_stackReturnItem() );
    }
    return menu;
}

HB_FUNC( WXTASKBARICON_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wx_TaskBarIcon* taskBarIcon = new wx_TaskBarIcon();

    objParams.Return( taskBarIcon );
}

/*
    wxTaskBarIcon:IsIconInstalled
    Teo. Mexico 2009
*/
HB_FUNC( WXTASKBARICON_ISICONINSTALLED )
{
    wxTaskBarIcon* taskBarIcon = (wxTaskBarIcon *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( taskBarIcon )
        hb_retl( taskBarIcon->IsIconInstalled() );
}

/*
    wxTaskBarIcon:IsOk
    Teo. Mexico 2009
*/
HB_FUNC( WXTASKBARICON_ISOK )
{
    wxTaskBarIcon* taskBarIcon = (wxTaskBarIcon *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( taskBarIcon )
        hb_retl( taskBarIcon->IsOk() );
}

/*
    wxTaskBarIcon:PopupMenu
    Teo. Mexico 2009
*/
HB_FUNC( WXTASKBARICON_POPUPMENU )
{
    wxTaskBarIcon* taskBarIcon = (wxTaskBarIcon *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( taskBarIcon )
    {
        wxMenu* menu = (wxMenu *) xho_par_XhoObject( 1 );

        if( menu )
            hb_retl( taskBarIcon->PopupMenu( menu ) );
    }
}

/*
    wxTaskBarIcon:RemoveIcon
    Teo. Mexico 2009
*/
HB_FUNC( WXTASKBARICON_REMOVEICON )
{
    wxTaskBarIcon* taskBarIcon = (wxTaskBarIcon *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( taskBarIcon )
        hb_retl( taskBarIcon->RemoveIcon() );
}

/*
    wxTaskBarIcon:SetIcon
    Teo. Mexico 2009
*/
HB_FUNC( WXTASKBARICON_SETICON )
{
    wxTaskBarIcon* taskBarIcon = (wxTaskBarIcon *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( taskBarIcon )
    {
        if( ISNIL( 1 ) )
        {
            hb_retl( taskBarIcon->SetIcon( wxIcon( wxwin32x32_xpm ), wxh_parc( 2 ) ) );
        }
        else
        {
            wxIcon* icon = (wxIcon *) xho_par_XhoObject( 1 );
            if( icon )
                hb_retl( taskBarIcon->SetIcon( *icon, wxh_parc( 2 ) ) );
        }
    }
}

