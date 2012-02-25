/*
 * $Id: wx_MessageDialog.h 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wx_MessageDialog: Interface
    Teo. Mexico 2008
*/

#include <wx/msgdlg.h>

class wx_MessageDialog : public wxMessageDialog
{
private:
protected:
public:

    wx_MessageDialog(wxWindow* parent, const wxString& message, const wxString& caption = wxT("Message box"), long style = wxOK | wxCANCEL, const wxPoint& pos = wxDefaultPosition ) : wxMessageDialog( parent, message, caption, style, pos ) {};

    ~wx_MessageDialog();

};
