/*
 * $Id: sysdefs.cpp 746 2011-08-05 18:55:31Z tfonrouge $
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2008 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxharbour:
    Teo. Mexico 2008
*/

#include "wxh.h"

#include "wx/srchctrl.h"
#include "wx/dateevt.h"
#include "wx/spinctrl.h"

#define wxdllimpexp_base        9953
#define wxdllimpexp_adv         8586

/*
    __WXH_WXDLLIMPEXP_ADV : WXDLLIMPEXP_ADV
    Teo. Mexico 2009
*/
HB_FUNC( __WXH_WXDLLIMPEXP_ADV )
{
    hb_retni( wxEVT_TASKBAR_MOVE - 1550 );
}

/*
    wxh_TRANSLATE_EVT_DEFS
    Teo. Mexico 2008
*/
HB_FUNC( WXH_TRANSLATE_EVT_DEFS )
{
    int wxh_EvtNumber = hb_parni( 1 );
    int evtNumber;

    switch( wxh_EvtNumber )
    {
        case 1 : evtNumber = wxEVT_COMMAND_BUTTON_CLICKED; break;
        case 2 : evtNumber = wxEVT_COMMAND_CHECKBOX_CLICKED; break;
        case 3 : evtNumber = wxEVT_COMMAND_CHOICE_SELECTED; break;
        case 4 : evtNumber = wxEVT_COMMAND_LISTBOX_SELECTED; break;
        case 5 : evtNumber = wxEVT_COMMAND_LISTBOX_DOUBLECLICKED; break;
        case 6 : evtNumber = wxEVT_COMMAND_CHECKLISTBOX_TOGGLED; break;
        // now they are in wx/textctrl.h
#ifdef WXWIN_COMPATIBILITY_EVENT_TYPES
        case 7 : evtNumber = wxEVT_COMMAND_TEXT_UPDATED; break;
        case 8 : evtNumber = wxEVT_COMMAND_TEXT_ENTER; break;
        case 13 : evtNumber = wxEVT_COMMAND_TEXT_URL; break;
        case 14 : evtNumber = wxEVT_COMMAND_TEXT_MAXLEN; break;
#endif // WXWIN_COMPATIBILITY_EVENT_TYPES
        case 9 : evtNumber = wxEVT_COMMAND_MENU_SELECTED; break;
        case 10 : evtNumber = wxEVT_COMMAND_SLIDER_UPDATED; break;
        case 11 : evtNumber = wxEVT_COMMAND_RADIOBOX_SELECTED; break;
        case 12 : evtNumber = wxEVT_COMMAND_RADIOBUTTON_SELECTED; break;

        // wxEVT_COMMAND_SCROLLBAR_UPDATED is now obsolete since we use
        // wxEVT_SCROLL... events

/*    case 13 : evtNumber = wxEVT_COMMAND_SCROLLBAR_UPDATED; break;
        case 14 : evtNumber = wxEVT_COMMAND_VLBOX_SELECTED; break;*/
        case 15 : evtNumber = wxEVT_COMMAND_COMBOBOX_SELECTED; break;
        case 16 : evtNumber = wxEVT_COMMAND_TOOL_RCLICKED; break;
        case 17 : evtNumber = wxEVT_COMMAND_TOOL_ENTER; break;
        case 18 : evtNumber = wxEVT_COMMAND_SPINCTRL_UPDATED; break;

                // Sockets and timers send events, too
//     DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_BASE, wxEVT_SOCKET, 50)
        case wxdllimpexp_base + 50 : evtNumber = wxEVT_SOCKET; break;
        case 80 : evtNumber = wxEVT_TIMER; break;

                // Mouse event types
        case 100 : evtNumber = wxEVT_LEFT_DOWN; break;
        case 101 : evtNumber = wxEVT_LEFT_UP; break;
        case 102 : evtNumber = wxEVT_MIDDLE_DOWN; break;
        case 103 : evtNumber = wxEVT_MIDDLE_UP; break;
        case 104 : evtNumber = wxEVT_RIGHT_DOWN; break;
        case 105 : evtNumber = wxEVT_RIGHT_UP; break;
        case 106 : evtNumber = wxEVT_MOTION; break;
        case 107 : evtNumber = wxEVT_ENTER_WINDOW; break;
        case 108 : evtNumber = wxEVT_LEAVE_WINDOW; break;
        case 109 : evtNumber = wxEVT_LEFT_DCLICK; break;
        case 110 : evtNumber = wxEVT_MIDDLE_DCLICK; break;
        case 111 : evtNumber = wxEVT_RIGHT_DCLICK; break;
        case 112 : evtNumber = wxEVT_SET_FOCUS; break;
        case 113 : evtNumber = wxEVT_KILL_FOCUS; break;
        case 114 : evtNumber = wxEVT_CHILD_FOCUS; break;
        case 115 : evtNumber = wxEVT_MOUSEWHEEL; break;

                // Non-client mouse events
    /*
        case 200 : evtNumber = wxEVT_NC_LEFT_DOWN; break;
        case 201 : evtNumber = wxEVT_NC_LEFT_UP; break;
        case 202 : evtNumber = wxEVT_NC_MIDDLE_DOWN; break;
        case 203 : evtNumber = wxEVT_NC_MIDDLE_UP; break;
        case 204 : evtNumber = wxEVT_NC_RIGHT_DOWN; break;
        case 205 : evtNumber = wxEVT_NC_RIGHT_UP; break;
        case 206 : evtNumber = wxEVT_NC_MOTION; break;
        case 207 : evtNumber = wxEVT_NC_ENTER_WINDOW; break;
        case 208 : evtNumber = wxEVT_NC_LEAVE_WINDOW; break;
        case 209 : evtNumber = wxEVT_NC_LEFT_DCLICK; break;
        case 210 : evtNumber = wxEVT_NC_MIDDLE_DCLICK; break;
        case 211 : evtNumber = wxEVT_NC_RIGHT_DCLICK; break;
     */

                // Character input event type
        case 212 : evtNumber = wxEVT_CHAR; break;
        case 213 : evtNumber = wxEVT_CHAR_HOOK; break;
        case 214 : evtNumber = wxEVT_NAVIGATION_KEY; break;
        case 215 : evtNumber = wxEVT_KEY_DOWN; break;
        case 216 : evtNumber = wxEVT_KEY_UP; break;
#ifdef wxUSE_HOTKEY
//     case 217 : evtNumber = wxEVT_HOTKEY; break;
#endif
                // Set cursor event
        case 230 : evtNumber = wxEVT_SET_CURSOR; break;

                // wxScrollBar and wxSlider event identifiers
        case 300 : evtNumber = wxEVT_SCROLL_TOP; break;
        case 301 : evtNumber = wxEVT_SCROLL_BOTTOM; break;
        case 302 : evtNumber = wxEVT_SCROLL_LINEUP; break;
        case 303 : evtNumber = wxEVT_SCROLL_LINEDOWN; break;
        case 304 : evtNumber = wxEVT_SCROLL_PAGEUP; break;
        case 305 : evtNumber = wxEVT_SCROLL_PAGEDOWN; break;
        case 306 : evtNumber = wxEVT_SCROLL_THUMBTRACK; break;
        case 307 : evtNumber = wxEVT_SCROLL_THUMBRELEASE; break;
        case 308 : evtNumber = wxEVT_SCROLL_CHANGED; break;

                // Scroll events from wxWindow
        case 320 : evtNumber = wxEVT_SCROLLWIN_TOP; break;
        case 321 : evtNumber = wxEVT_SCROLLWIN_BOTTOM; break;
        case 322 : evtNumber = wxEVT_SCROLLWIN_LINEUP; break;
        case 323 : evtNumber = wxEVT_SCROLLWIN_LINEDOWN; break;
        case 324 : evtNumber = wxEVT_SCROLLWIN_PAGEUP; break;
        case 325 : evtNumber = wxEVT_SCROLLWIN_PAGEDOWN; break;
        case 326 : evtNumber = wxEVT_SCROLLWIN_THUMBTRACK; break;
        case 327 : evtNumber = wxEVT_SCROLLWIN_THUMBRELEASE; break;

                // System events
        case 400 : evtNumber = wxEVT_SIZE; break;
        case 401 : evtNumber = wxEVT_MOVE; break;
        case 402 : evtNumber = wxEVT_CLOSE_WINDOW; break;
        case 403 : evtNumber = wxEVT_END_SESSION; break;
        case 404 : evtNumber = wxEVT_QUERY_END_SESSION; break;
        case 405 : evtNumber = wxEVT_ACTIVATE_APP; break;
        // 406..408 are power events
        case 409 : evtNumber = wxEVT_ACTIVATE; break;
        case 410 : evtNumber = wxEVT_CREATE; break;
        case 411 : evtNumber = wxEVT_DESTROY; break;
        case 412 : evtNumber = wxEVT_SHOW; break;
        case 413 : evtNumber = wxEVT_ICONIZE; break;
        case 414 : evtNumber = wxEVT_MAXIMIZE; break;
        case 415 : evtNumber = wxEVT_MOUSE_CAPTURE_CHANGED; break;
        case 416 : evtNumber = wxEVT_MOUSE_CAPTURE_LOST; break;
        case 417 : evtNumber = wxEVT_PAINT; break;
        case 418 : evtNumber = wxEVT_ERASE_BACKGROUND; break;
        case 419 : evtNumber = wxEVT_NC_PAINT; break;
        //case 420 : evtNumber = wxEVT_PAINT_ICON; break;
        case 421 : evtNumber = wxEVT_MENU_OPEN; break;
        case 422 : evtNumber = wxEVT_MENU_CLOSE; break;
        case 423 : evtNumber = wxEVT_MENU_HIGHLIGHT; break;
        case 424 : evtNumber = wxEVT_CONTEXT_MENU; break;
        case 425 : evtNumber = wxEVT_SYS_COLOUR_CHANGED; break;
        case 426 : evtNumber = wxEVT_DISPLAY_CHANGED; break;
        //case 427 : evtNumber = wxEVT_SETTING_CHANGED; break;
        case 428 : evtNumber = wxEVT_QUERY_NEW_PALETTE; break;
        case 429 : evtNumber = wxEVT_PALETTE_CHANGED; break;
        case 430 : evtNumber = wxEVT_JOY_BUTTON_DOWN; break;
        case 431 : evtNumber = wxEVT_JOY_BUTTON_UP; break;
        case 432 : evtNumber = wxEVT_JOY_MOVE; break;
        case 433 : evtNumber = wxEVT_JOY_ZMOVE; break;
        case 434 : evtNumber = wxEVT_DROP_FILES; break;
        //case 435 : evtNumber = wxEVT_DRAW_ITEM; break;
        //case 436 : evtNumber = wxEVT_MEASURE_ITEM; break;
        //case 437 : evtNumber = wxEVT_COMPARE_ITEM; break;
        case 438 : evtNumber = wxEVT_INIT_DIALOG; break;
//     DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_BASE, wxEVT_IDLE, 439)
        case wxdllimpexp_base + 439 :evtNumber = wxEVT_IDLE; break;
        case 440 : evtNumber = wxEVT_UPDATE_UI; break;
        case 441 : evtNumber = wxEVT_SIZING; break;
        case 442 : evtNumber = wxEVT_MOVING; break;
        case 443 : evtNumber = wxEVT_HIBERNATE; break;
        // more power events follow -- see wx/power.h

                // Clipboard events
        case 444 : evtNumber = wxEVT_COMMAND_TEXT_COPY; break;
        case 445 : evtNumber = wxEVT_COMMAND_TEXT_CUT; break;
        case 446 : evtNumber = wxEVT_COMMAND_TEXT_PASTE; break;

                // Generic command events
                // Note: a click is a higher-level event than button down/up
        case 500 : evtNumber = wxEVT_COMMAND_LEFT_CLICK; break;
        case 501 : evtNumber = wxEVT_COMMAND_LEFT_DCLICK; break;
        case 502 : evtNumber = wxEVT_COMMAND_RIGHT_CLICK; break;
        case 503 : evtNumber = wxEVT_COMMAND_RIGHT_DCLICK; break;
        case 504 : evtNumber = wxEVT_COMMAND_SET_FOCUS; break;
        case 505 : evtNumber = wxEVT_COMMAND_KILL_FOCUS; break;
        case 506 : evtNumber = wxEVT_COMMAND_ENTER; break;

                // Notebook events
        case 802 : evtNumber = wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGED; break;
        case 803 : evtNumber = wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGING; break;
                // Help events
        case 1050 : evtNumber = wxEVT_HELP; break;
        case 1051 : evtNumber = wxEVT_DETAILED_HELP; break;

        /* datePickerCtrl events */
        case wxdllimpexp_adv + 1101 : evtNumber = wxEVT_DATE_CHANGED; break;

            // SearchCtrl events
        case 1119 : evtNumber = wxEVT_COMMAND_SEARCHCTRL_CANCEL_BTN; break;
        case 1120 : evtNumber = wxEVT_COMMAND_SEARCHCTRL_SEARCH_BTN; break;

        /* grid events */
        case wxdllimpexp_adv + 1580 : evtNumber = wxEVT_GRID_CELL_LEFT_CLICK; break;
        case wxdllimpexp_adv + 1581 : evtNumber = wxEVT_GRID_CELL_RIGHT_CLICK; break;
        case wxdllimpexp_adv + 1582 : evtNumber = wxEVT_GRID_CELL_LEFT_DCLICK; break;
        case wxdllimpexp_adv + 1583 : evtNumber = wxEVT_GRID_CELL_RIGHT_DCLICK; break;
        case wxdllimpexp_adv + 1584 : evtNumber = wxEVT_GRID_LABEL_LEFT_CLICK; break;
        case wxdllimpexp_adv + 1585 : evtNumber = wxEVT_GRID_LABEL_RIGHT_CLICK; break;
        case wxdllimpexp_adv + 1586 : evtNumber = wxEVT_GRID_LABEL_LEFT_DCLICK; break;
        case wxdllimpexp_adv + 1587 : evtNumber = wxEVT_GRID_LABEL_RIGHT_DCLICK; break;
        case wxdllimpexp_adv + 1588 : evtNumber = wxEVT_GRID_ROW_SIZE; break;
        case wxdllimpexp_adv + 1589 : evtNumber = wxEVT_GRID_COL_SIZE; break;
        case wxdllimpexp_adv + 1590 : evtNumber = wxEVT_GRID_RANGE_SELECT; break;
        case wxdllimpexp_adv + 1591 : evtNumber = wxEVT_GRID_CELL_CHANGE; break;
        case wxdllimpexp_adv + 1592 : evtNumber = wxEVT_GRID_SELECT_CELL; break;
        case wxdllimpexp_adv + 1593 : evtNumber = wxEVT_GRID_EDITOR_SHOWN; break;
        case wxdllimpexp_adv + 1594 : evtNumber = wxEVT_GRID_EDITOR_HIDDEN; break;
        case wxdllimpexp_adv + 1595 : evtNumber = wxEVT_GRID_EDITOR_CREATED; break;
        case wxdllimpexp_adv + 1596 : evtNumber = wxEVT_GRID_CELL_BEGIN_DRAG; break;
#if wxVERSION > 20804
        case wxdllimpexp_adv + 1597 : evtNumber = wxEVT_GRID_COL_MOVE; break;
#endif

        default : evtNumber = 0;
    }

    hb_retni( evtNumber );

}
