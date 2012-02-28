/*
 * $Id: wx_Browse.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "wx/wx.h"
#include "wx/grid.h"
#include "wxh.h"

#include "wxbase/wx_GridTableBase.h"
#include "wxbase/wx_Grid.h"
#include "wxbase/wx_StaticLine.h"
#include "wxbase/wx_Browse.h"

HB_FUNC_EXTERN( WXGRIDEVENT);
HB_FUNC_EXTERN( WXKEYEVENT);

BEGIN_EVENT_TABLE( wxhBrowse, wxScrolledWindow )
    EVT_KEY_DOWN( wxhBrowse::OnKeyDown )
    EVT_SIZE( wxhBrowse::OnSize )
    EVT_GRID_CMD_SELECT_CELL( wxID_ANY, wxhBrowse::OnSelectCell )
END_EVENT_TABLE()

/*
    OnKeyDown
    Teo. Mexico 2009
*/
void wxhBrowse::OnKeyDown( wxKeyEvent& event )
{
    if ( m_inOnKeyDown )
    {
        // shouldn't be here - we are going round in circles...
        //
        //wxFAIL_MSG( wxT("wxhBrowse::OnKeyDown called while already active") );
    }

    m_inOnKeyDown = true;

    // propagate the event up and see if it gets processed
    wxWindow *parent = GetParent();
    wxKeyEvent keyEvt( event );
    keyEvt.SetEventObject( parent );

    if ( !parent->GetEventHandler()->ProcessEvent( keyEvt ) )
    {
        if (GetLayoutDirection() == wxLayout_RightToLeft)
        {
            if (event.GetKeyCode() == WXK_RIGHT)
                event.m_keyCode = WXK_LEFT;
            else if (event.GetKeyCode() == WXK_LEFT)
                event.m_keyCode = WXK_RIGHT;
        }

        /* process event on our hbclass wxhBrowse:OnKeyDown, returns true if processed */
        PHB_ITEM pGridBrowse = xho_itemListGet_HB( this );
        if( pGridBrowse )
        {
            HB_FUNC_EXEC( WXKEYEVENT );
            PHB_ITEM pKeyEvent = hb_stackReturnItem();
            xho_ObjParams objParams = xho_ObjParams( pKeyEvent );

            objParams.Return( &event );

            hb_objSendMsg( pGridBrowse, "OnKeyDown", 1, pKeyEvent );

            xho_itemListDel_XHO( &event );
        }
    }

    m_inOnKeyDown = false;
}

/*
    OnSelectCell
    Teo. Mexico 2009
*/
void wxhBrowse::OnSelectCell( wxGridEvent& gridEvent )
{

    PHB_ITEM pWxhBrowse = xho_itemListGet_HB( this );

    if( pWxhBrowse )
    {
        HB_FUNC_EXEC( WXGRIDEVENT );
        PHB_ITEM pGridEvent = hb_stackReturnItem();
        xho_ObjParams objParams = xho_ObjParams( pGridEvent );

        objParams.Return( &gridEvent );

        hb_objSendMsg( pWxhBrowse, "OnSelectCell", 1, pGridEvent );

        xho_itemListDel_XHO( &gridEvent );
    }
    else
        gridEvent.Skip();

}

/*
    OnSize
    Teo. Mexico 2009
*/
void wxhBrowse::OnSize( wxSizeEvent& event )
{
    if (m_targetWindow != this)
    {
        PHB_ITEM pGridBrowse = xho_itemListGet_HB( this );

        if( pGridBrowse )
        {
            PHB_ITEM pSize = hb_itemNew( NULL );
            hb_arrayNew( pSize, 2 );
            hb_arraySetNI( pSize, 1, event.GetSize().GetWidth() );
            hb_arraySetNI( pSize, 2, event.GetSize().GetHeight() );
            hb_objSendMsg( pGridBrowse, "OnSize", 1, pSize );
            hb_itemRelease( pSize );

            event.Skip();
        }
    }
}

/*
    Constructor: wxhBrowse Object
    Teo. Mexico 2009
*/
HB_FUNC( WXHBROWSE_NEW )
{
    xho_ObjParams objParams = xho_ObjParams( NULL );

    wxhBrowse* browse = ( wxhBrowse* ) objParams.paramParent( 1 );
    wxWindowID id = HB_ISNIL( 2 ) ? wxID_ANY : hb_parni( 2 );
    wxPoint pos = wxh_par_wxPoint( 3 );
    wxSize size = wxh_par_wxSize( 4 );
    long style = HB_ISNIL( 5 ) ? wxWANTS_CHARS : hb_parnl( 5 );
    const wxString& name = HB_ISNIL( 6 ) ? wxString( _T("wxhBrowse") ) : wxh_parc( 6 );

    wxhBrowse* gridBrowse = new wxhBrowse( browse, id, pos, size, style, name );

    gridBrowse->m_maxRows = 0;
    gridBrowse->m_gridWindowHeight = 0;
    gridBrowse->m_rowCount = 0;
    gridBrowse->m_selectedRow = 0;

    objParams.Return( gridBrowse );

}

/*
    wxhBrowse:CalcRowCount
    Teo. Mexico 2009
*/
HB_FUNC( WXHBROWSE_CALCMAXROWS )
{
    wxhBrowse* gridBrowse = (wxhBrowse *) xho_itemListGet_XHO( hb_stackSelfItem() );

    int maxRows = 0;

    if( gridBrowse )
    {
        gridBrowse->CalcDimensions();

        wxSize size = gridBrowse->GetGridWindow()->GetSize();

        /* needed to calculate cell row height */
        if( gridBrowse->GetNumberRows() == 0 )
        {
            gridBrowse->AppendRows( 1 );
        }

        gridBrowse->m_gridWindowHeight = size.GetHeight();

        wxRect cellRect( gridBrowse->CellToRect( 0, 0 ) );

        int top,bottom;
        top = cellRect.GetTop();
        bottom = cellRect.GetBottom();

        gridBrowse->m_maxRows = HB_MAX( 0, ( ( gridBrowse->m_gridWindowHeight - 10 ) / ( bottom - top ) ) - 2 );
        maxRows = gridBrowse->m_maxRows;
    }

    hb_retni( maxRows );
}

/*
    SetColCellChoiceEditor
    Teo. Mexico 2011
 */
HB_FUNC( WXHBROWSE_SETCOLCELLCHOICEEDITOR )
{
    wxhBrowse* gridBrowse = (wxhBrowse *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridBrowse )
    {
        int col;

        if( hb_param( 1, HB_IT_NUMERIC ) )
        {
            col = hb_parni( 1 );
        }
        else
        {
            col = gridBrowse->GetNumberCols();
        }

        const wxArrayString& choices = wxh_par_wxArrayString( 2 );
        wxGridCellChoiceEditor* choiceEditor = new wxGridCellChoiceEditor( choices );
        wxGridCellAttr* gridCellAttr = new wxGridCellAttr;
        gridCellAttr->SetEditor( choiceEditor );
        gridBrowse->SetColAttr( col - 1, gridCellAttr );
    }
}

/*
    wxhBrowse:MaxRows
    Teo. Mexico 2009
*/
HB_FUNC( WXHBROWSE_GETMAXROWS )
{
    wxhBrowse* gridBrowse = (wxhBrowse *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridBrowse )
    {
        hb_retnl( gridBrowse->m_maxRows );
    }
}

/*
    wxhBrowse:RowCount
    Teo. Mexico 2009
*/
HB_FUNC( WXHBROWSE_GETROWCOUNT )
{
    wxhBrowse* gridBrowse = (wxhBrowse *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridBrowse )
    {
        hb_retnl( gridBrowse->m_rowCount );
    }
}

/*
    wxhBrowse:SetColWidth
    Teo. Mexico 2009
*/
HB_FUNC( WXHBROWSE_SETCOLWIDTH )
{
    wxhBrowse* gridBrowse = (wxhBrowse *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridBrowse )
    {
        int col = hb_parni( 1 ) - 1;
        int pointSize = ( gridBrowse->GetCellFont( 0, col ) ).GetPointSize() - 3;
        int width = hb_parni( 2 );
        gridBrowse->SetColSize( col, pointSize * width );
    }
}

/*
    wxhBrowse:SetRowCount
    Teo. Mexico 2009
*/
HB_FUNC( WXHBROWSE_SETROWCOUNT )
{
    wxhBrowse* gridBrowse = (wxhBrowse *) xho_itemListGet_XHO( hb_stackSelfItem() );
    int rowCount = hb_parni( 1 );

    if( gridBrowse && ( rowCount != gridBrowse->m_rowCount ) )
    {
        if( rowCount > gridBrowse->m_rowCount )
            gridBrowse->AppendRows( rowCount - gridBrowse->m_rowCount );
        else
            gridBrowse->DeleteRows( rowCount - 1, gridBrowse->m_rowCount - rowCount );
        gridBrowse->m_rowCount = rowCount;
    }
}

/*
    ShowRow
    Teo. Mexico 2010
 */
HB_FUNC( WXHBROWSE_SHOWROW )
{
    wxhBrowse* gridBrowse = (wxhBrowse *) xho_itemListGet_XHO( hb_stackSelfItem() );

    if( gridBrowse )
    {
        int row = HB_ISNIL( 1 ) ? gridBrowse->GetGridCursorRow() : hb_parni( 1 );
        bool select = HB_ISNIL( 2 ) ? true : hb_parl( 2 );

        if( gridBrowse->m_selectedRow >= 0 && gridBrowse->m_selectedRow < gridBrowse->GetNumberRows() )
        {
            wxGridCellAttr *attrDefaultColour;
            attrDefaultColour = new wxGridCellAttr;
            attrDefaultColour->SetBackgroundColour( gridBrowse->GetDefaultCellBackgroundColour() );
            gridBrowse->SetRowAttr( gridBrowse->m_selectedRow, attrDefaultColour );
        }

        if( row >= 0 && row < gridBrowse->GetNumberRows() )
        {
            wxColour colour;

            if( select )
            {
                colour.Set( _T("RGB(194,222,251)") );
            }
            else
            {
                colour = gridBrowse->GetDefaultCellBackgroundColour();
            }

            wxGridCellAttr *attr;
            attr = new wxGridCellAttr;
            attr->SetBackgroundColour( colour );
            gridBrowse->SetRowAttr( row, attr );
            gridBrowse->m_selectedRow = row;
        }
        gridBrowse->Refresh();
    }
}
