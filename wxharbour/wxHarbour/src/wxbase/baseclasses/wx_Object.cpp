/*
 * $Id: wx_Object.cpp 660 2010-11-04 04:18:08Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_object: Implementation
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wx/hashset.h"
#include "wxh.h"

#include "wxbase/wx_Object.h"

/*
    TBaseClass::OnDestruct
    Teo. Mexico 2008
*/
HB_FUNC( TBASECLASS_HB_DESTRUCT )
{
    PHB_ITEM pSelf = hb_stackSelfItem();

    /* 1: delete the C++ wxObject */
    /* 2: dont try to release event codeblocks because they are already released */

    /* As we are here, it means that there not exist another PHB_ITEM's of this HB class
         So, we just need to call the C++ destructor of this object */

    xho_Item* pXho_Item = xho_itemListGet_PXHO_ITEM( pSelf );

    if( pXho_Item )
    {
        if( pXho_Item->nullObj )
        {
            pXho_Item->pSelf->type = HB_IT_NIL;
            hb_itemRelease( pXho_Item->pSelf );
        }
        pXho_Item->pSelf = NULL;
        delete pXho_Item;
    }
}

/*
    TBaseClass:__Destroy
    Teo. Mexico 2009
*/
HB_FUNC( TBASECLASS___DESTROY )
{
    xho_Item* pXho_Item = xho_itemListGet_PXHO_ITEM( hb_stackSelfItem() );

    if( pXho_Item )
    {
        delete pXho_Item;
    }
}

/*
    End TBaseClass
*/

/*
    wxObject:ObjectP
    Teo. Mexico 2009
*/
HB_FUNC( WXOBJECT_OBJECTP )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    wxObject* wxObj = xho_itemListGet_XHO( pSelf );

    if( wxObj )
        hb_retptr( wxObj );
}
