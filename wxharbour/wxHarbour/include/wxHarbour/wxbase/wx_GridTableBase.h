/*
 * $Id: wx_GridTableBase.h 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_GridTableBase: Interface
    Teo. Mexico 2009
*/

class wx_GridTableBase : public wxGridTableBase
{
private:
protected:
public:

    wx_GridTableBase() : wxGridTableBase() { m_numRows = 0; m_numCols = 0; gridDataIsOEM = false; }
    ~wx_GridTableBase();

    int GetNumberRows() { return m_numRows; }
    int GetNumberCols() { return m_numCols; }
    wxString  GetValue( int row, int col );
    wxString  GetColLabelValue( int col );
    wxString  GetRowLabelValue( int row );
    bool      IsEmptyCell( int row, int col );
    void      SetValue( int row, int col, const wxString& value );
    bool		gridDataIsOEM;

    size_t m_numCols;
    size_t m_numRows;

    bool AppendCols( size_t numCols = 1 );
    bool AppendRows( size_t numRows = 1 );
    bool DeleteCols( size_t pos = 0, size_t numCols = 1 );
    bool DeleteRows( size_t pos = 0, size_t numRows = 1 );
    bool InsertCols( size_t pos = 0, size_t numCols = 1 );
    bool InsertRows( size_t pos = 0, size_t numRows = 1 );

};
