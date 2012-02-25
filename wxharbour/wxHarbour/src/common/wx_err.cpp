/*
 * $Id: wx_err.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2010 Teo Fonrouge

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

 (C) 2010 Teo Fonrouge <teo@windtelsoft.com>
 */

#include "wxh.h"

/*
 Incorrect number of params on obj method call
 Teo. Mexico 2010
 */
void wxh_errRT_ParamNum()
{
    char szDescription[ 128 ] = "";
    char szOperation[ 128 ] = "";
    PHB_SYMB pSymbol = hb_itemGetSymbol( hb_stackBaseItem() );

    strcat( szDescription, "Incorrect number of params" );
    strcat( szOperation, hb_clsName( hb_objGetClass( hb_stackSelfItem() ) ) );
    strcat( szOperation, ":" );

    if( pSymbol )
    {
        strcat( szOperation, pSymbol->szName );
    }
    else
    {
        strcat( szOperation, "???" );
    }

    hb_errRT_BASE_SubstR( EG_ARG, 0, szDescription, szOperation, HB_ERR_ARGS_SELFPARAMS );
}
