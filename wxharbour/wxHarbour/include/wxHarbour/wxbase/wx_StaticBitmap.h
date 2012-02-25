/*
 * $Id: wx_StaticBitmap.h 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge
 
 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 
 (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
 */

/*
 wx_StaticBitmap: Interface
 Teo. Mexico 2009
 */

#include "wx/bitmap.h"

class wx_StaticBitmap : public wxStaticBitmap
    {
    private:
    protected:
    public:

    wx_StaticBitmap(wxWindow* parent, wxWindowID id, const wxBitmap& label, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = 0, const wxString& name = _T("staticBitmap") ) : wxStaticBitmap( parent, id, label, pos, size, style, name ) {}
    
    ~wx_StaticBitmap();
    
    };
