/*
 * $Id: wx_Colour.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

 (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
 */

/*
 wx_Colour: Implementation
 Jamaj Brasil 2009
 */

#include "wx/wx.h"
#include "wxh.h"
#include "wxbase/wx_Colour.h"

/*
 ~wx_Colour
 Teo. Mexico 2009
 */
wx_Colour::~wx_Colour()
{
    xho_itemListDel_XHO( this );
}

/*
 New
 Teo. Mexico 2009
 */
HB_FUNC( WXCOLOUR_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );
    wx_Colour* colour = NULL;

    switch( hb_pcount() )
    {
    case 0 :
        {
            colour = new wx_Colour();
        }
        break;
    case 1 :
        {
            if( HB_ISCHAR( 1 ) )
            {
                const wxString& name = wxh_parc( 1 );
                colour = new wx_Colour( name );
                printf("char");
            }
            else if( HB_ISARRAY(1) )
            {
                PHB_ITEM pArray = hb_param( 1, HB_IT_ARRAY );
                if (hb_arrayLen( pArray ) == 3)
                {
                    unsigned char r,g,b;
                    r = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 1 ) );
                    g = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 2 ) );
                    b = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 3 ) );
                    colour = new wx_Colour( r, g, b, (unsigned char)255 );
                }
                else if (hb_arrayLen( pArray ) == 4)
                {
                    unsigned char r,g,b,a;
                    r = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 1 ) );
                    g = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 2 ) );
                    b = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 3 ) );
                    a = hb_itemGetNI( hb_arrayGetItemPtr( pArray, 4 ) );
                    colour = new wx_Colour( r, g, b, a );
                }
            }
            else
            {
                colour = new wx_Colour();
            }
        }
        break;
    case 3:
        {
            if( HB_ISNUM(1) && HB_ISNUM(2) && HB_ISNUM(3) )
            {
                colour = new wx_Colour( (unsigned char)hb_parni(1), (unsigned char)hb_parni(2), (unsigned char)hb_parni(3), (unsigned char)255 );
            }
            else
            {
                colour = new wx_Colour();
            }
        }
        break;
    case 4:
        {
            if( HB_ISNUM(1) && HB_ISNUM(2) && HB_ISNUM(3) && HB_ISNUM(4))
            {
                colour = new wx_Colour( (unsigned char)hb_parni(1), (unsigned char)hb_parni(2), (unsigned char)hb_parni(3), (unsigned char)hb_parni(4) );
            }
            else
            {
                colour = new wx_Colour();
            }
        }
        break;
    default :
        colour = new wx_Colour();
        break;
    }

    objParams.Return( colour );
}


