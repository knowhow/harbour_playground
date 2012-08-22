/*
 * $Id: wx_MDIChildFrame.h 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_MDIChildFrame: Interface
    Teo. Mexico 2006
*/

class wx_MDIChildFrame : public hbWindow<wxMDIChildFrame>
{
private:
protected:
public:
    wx_MDIChildFrame( wxMDIParentFrame* parent, wxWindowID id = wxID_ANY, const wxString& title = wxT(""), const wxPoint& pos = wxPoint(-1,-1), const wxSize& size = wxSize(-1,-1), long style = wxDEFAULT_FRAME_STYLE, const wxString& name = wxT("") );
};
