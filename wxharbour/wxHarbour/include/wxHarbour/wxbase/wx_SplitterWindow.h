/*
 * $Id: wx_SplitterWindow.h 639 2010-06-30 18:09:09Z tfonrouge $
 */

/*
 wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2010 Teo Fonrouge
 
 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 
 (C) 2010 Teo Fonrouge <teo@windtelsoft.com>
 */

/*
 wx_SplitterWindow: Interface
 Teo. Mexico 2010
 */

#include <wx/splitter.h>

class wx_SplitterWindow : public wxSplitterWindow
{
private:
protected:
public:
    wx_SplitterWindow() : wxSplitterWindow() {}
    
    wx_SplitterWindow(wxWindow* parent, wxWindowID id, const wxPoint& point = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style = wxSP_3D, const wxString& name = wxT("splitterWindow") ) : wxSplitterWindow( parent, id, point, size, style, name ) {}
    
    ~wx_SplitterWindow();
};
