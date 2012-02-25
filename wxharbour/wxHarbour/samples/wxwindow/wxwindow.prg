#include "wxharbour.ch"
#include "hbclass.ch"
#include "hblang.ch"
#include "color.ch"
#include "common.ch"
#include "setcurs.ch"
#include "getexit.ch"
#include "inkey.ch"
#include "button.ch"


FUNCTION Main
    LOCAL wxWinSample
    wxWinSample := wxWinSample():New()
    IMPLEMENT_APP( wxWinSample )
RETURN NIL

/*
    wxWinSample
    jamaj Brasil 2009
*/
CLASS wxWinSample FROM wxApp
PRIVATE:
PROTECTED:
PUBLIC:
    METHOD OnInit
PUBLISHED:
ENDCLASS

METHOD FUNCTION OnInit() CLASS wxWinSample
    Local oDlg, oWnd
//	Local parent, id, pos, size, name
    Local style := wxBORDER_SIMPLE

    

    CREATE DIALOG oDlg ;
                 WIDTH 640 HEIGHT 400 ;
                 TITLE "Text Sample"

    BEGIN BOXSIZER VERTICAL 
        oWnd := TEditGet():New(oDlg, wxID_ANY, NIL, NIL, style, "wxWinSampleWindow")	
        containerObj():SetLastChild( oWnd )
        @ BUTTON ID wxID_OK ACTION oDlg:Close()
    END SIZER
    SHOW WINDOW oDlg MODAL CENTRE
    oDlg:Destroy()

RETURN .F.

// When using the last derivation, from wxTextCtrl, the special characters Onchar events are not sent!!!
CLASS TEditGet FROM wxWindow
//CLASS TEditGet FROM wxControl
//CLASS TEditGet FROM wxTextCtrl
PRIVATE:
    DATA 	bAction  	
    DATA	bOnGFocus	
    DATA	bOnLFocus	
    DATA	bOnChar	
    DATA	bOnKeyDown	
    DATA	bOnKeyUp		
    DATA  g
PROTECTED:
PUBLIC:
        DATA  plvl
        METHOD New( parent, id, pos, size, style, validator, name  ) CONSTRUCTOR
PUBLISHED:
ENDCLASS


METHOD New( parent, id, pos, size, style, validator, name  ) CLASS TEditGet

            ::wxWindow:New( parent, id, pos, size, style, validator, name )
//			::wxControl:New( parent, id, pos, size, style, validator, name )
//			::wxTextCtrl:New( parent, id, pos, size, style, validator, name )

            ::bOnGFocus		:= IIF( ::bOnGFocus == NIL,  { | event | OnGFocus(SELF,event) }, ::bOnGFocus )
            ::bOnLFocus		:= IIF( ::bOnLFocus == NIL,  { | event | OnLFocus(SELF,event) }, ::bOnLFocus )
            ::bOnChar			:= IIF( ::bOnChar == NIL,  { | event | OnChar(SELF, event)   }, ::bOnChar )
            ::bOnKeyDown	:= IIF( ::bOnKeyDown == NIL, { | event | OnKeyDown(SELF, event) }, ::bOnKeyDown )
            ::bOnKeyUp		:= IIF( ::bOnKeyUp == NIL,  { | event | OnKeyUp(SELF, event)  }, ::bOnKeyUp )
            
            ::ConnectFocusEvt( ::GetId(), wxEVT_KILL_FOCUS,   ::bOnLFocus )
            ::ConnectFocusEvt( ::GetId(), wxEVT_SET_FOCUS, 	  ::bOnGFocus )
            ::ConnectKeyEvt( 	 ::GetId(), wxEVT_KEY_DOWN, 		::bOnKeyDown )
            ::ConnectKeyEvt( 	 ::GetId(), wxEVT_KEY_UP, 			::bOnKeyUp )
            ::ConnectKeyEvt( 	 wxID_ANY, wxEVT_CHAR, 				::bOnChar	 )

RETURN Self


FUNCTION OnGFocus(SELF,event)
    LOCAL lRet := .t.
    (SELF)
    ? "OnGFocus"
    event:skip()
RETURN lRet

FUNCTION OnLFocus(SELF,event)
    LOCAL lRet := .t.
    (SELF)
    ? "OnLFocus"
    event:skip()
RETURN lRet


FUNCTION OnChar(SELF,event)
    LOCAL lRet := .t.
    LOCAL keycode := event:GetKeyCode()
//	LOCAL ctrlDown := event:ControlDown()
    (SELF)
    //altd()
    ? ("OnChar key=" + Str(keycode) + "-" + GetKeyName(keycode) + " " + "UnicodeKey=" + Str(event:GetUnicodeKey()))
    event:skip(.t.)
RETURN lRet

FUNCTION OnKeyDown(SELF,event)
    LOCAL lRet := .t.
    LOCAL keycode := event:GetKeyCode()
    (SELF)
    //LOCAL ctrlDown := event:ControlDown()
    ? ("OnKeyDown key=" + Str(keycode) + "-" + GetKeyName(keycode) +" " + "UnicodeKey=" + Str(event:GetUnicodeKey()))
    event:skip(.t.)
RETURN lRet

FUNCTION OnKeyUp(SELF,event)
    LOCAL lRet := .t.
    LOCAL keycode := event:GetKeyCode()
    LOCAL ctrlDown := event:ControlDown()
    (SELF)
    //LOCAL shiftDown := event:ShiftDown() => Not yet implemented in wxharbour
    //LOCAL altDown := event:AltDown()		=> Not yet implemented in wxharbour	
    ? ("OnKeyUp key=" + Str(keycode) + "-" + IIF(ctrlDown,"CTRL+","") + GetKeyName(keycode) +" " + "UnicodeKey=" + Str(event:GetUnicodeKey()) )
    event:skip()
RETURN lRet


FUNCTION GetKeyName(keycode)
    LOCAL cKey :=  ""

    SWITCH keycode
        case WXK_BACK
            cKey +=("BACK")
            EXIT
        case WXK_TAB
            cKey +=("TAB")
            EXIT
        case WXK_RETURN 
            cKey +=("RETURN") 
            EXIT
        case WXK_ESCAPE   
            cKey +=("ESCAPE") 
            EXIT
        case WXK_SPACE   
            cKey +=("SPACE") 
            EXIT
        case WXK_DELETE   
            cKey +=("DELETE") 
            EXIT
        case WXK_START   
            cKey +=("START") 
            EXIT
        case WXK_LBUTTON   
            cKey +=("LBUTTON") 
            EXIT
        case WXK_RBUTTON   
            cKey +=("RBUTTON") 
            EXIT
        case WXK_CANCEL   
            cKey +=("CANCEL") 
            EXIT
        case WXK_MBUTTON   
            cKey +=("MBUTTON") 
            EXIT
        case WXK_CLEAR   
            cKey +=("CLEAR") 
            EXIT
        case WXK_SHIFT   
            cKey +=("SHIFT") 
            EXIT
        case WXK_ALT   
            cKey +=("ALT") 
            EXIT
        case WXK_CONTROL   
            cKey +=("CONTROL") 
            EXIT
        case WXK_MENU   
            cKey +=("MENU") 
            EXIT
        case WXK_PAUSE   
            cKey +=("PAUSE") 
            EXIT
        case WXK_CAPITAL   
            cKey +=("CAPITAL") 
            EXIT
        case WXK_END   
            cKey +=("END") 
            EXIT
        case WXK_HOME   
            cKey +=("HOME") 
            EXIT
        case WXK_LEFT   
            cKey +=("LEFT") 
            EXIT
        case WXK_UP   
            cKey +=("UP") 
            EXIT
        case WXK_RIGHT   
            cKey +=("RIGHT") 
            EXIT
        case WXK_DOWN   
            cKey +=("DOWN") 
            EXIT
        case WXK_SELECT   
            cKey +=("SELECT") 
            EXIT
        case WXK_PRINT   
            cKey +=("PRINT") 
            EXIT
        case WXK_EXECUTE   
            cKey +=("EXECUTE") 
            EXIT
        case WXK_SNAPSHOT   
            cKey +=("SNAPSHOT") 
            EXIT
        case WXK_INSERT   
            cKey +=("INSERT") 
            EXIT
        case WXK_HELP   
            cKey +=("HELP") 
            EXIT
        case WXK_NUMPAD0   
            cKey +=("NUMPAD0") 
            EXIT
        case WXK_NUMPAD1   
            cKey +=("NUMPAD1") 
            EXIT
        case WXK_NUMPAD2   
            cKey +=("NUMPAD2") 
            EXIT
        case WXK_NUMPAD3   
            cKey +=("NUMPAD3") 
            EXIT
        case WXK_NUMPAD4   
            cKey +=("NUMPAD4") 
            EXIT
        case WXK_NUMPAD5   
            cKey +=("NUMPAD5") 
            EXIT
        case WXK_NUMPAD6   
            cKey +=("NUMPAD6") 
            EXIT
        case WXK_NUMPAD7   
            cKey +=("NUMPAD7") 
            EXIT
        case WXK_NUMPAD8   
            cKey +=("NUMPAD8") 
            EXIT
        case WXK_NUMPAD9   
            cKey +=("NUMPAD9") 
            EXIT
        case WXK_MULTIPLY   
            cKey +=("MULTIPLY") 
            EXIT
        case WXK_ADD   
            cKey +=("ADD") 
            EXIT
        case WXK_SEPARATOR   
            cKey +=("SEPARATOR") 
            EXIT
        case WXK_SUBTRACT   
            cKey +=("SUBTRACT") 
            EXIT
        case WXK_DECIMAL   
            cKey +=("DECIMAL") 
            EXIT
        case WXK_DIVIDE   
            cKey +=("DIVIDE") 
            EXIT
        case WXK_F1   
            cKey +=("F1") 
            EXIT
        case WXK_F2   
            cKey +=("F2") 
            EXIT
        case WXK_F3   
            cKey +=("F3") 
            EXIT
        case WXK_F4   
            cKey +=("F4") 
            EXIT
        case WXK_F5   
            cKey +=("F5") 
            EXIT
        case WXK_F6   
            cKey +=("F6") 
            EXIT
        case WXK_F7   
            cKey +=("F7") 
            EXIT
        case WXK_F8   
            cKey +=("F8") 
            EXIT
        case WXK_F9   
            cKey +=("F9") 
            EXIT
        case WXK_F10   
            cKey +=("F10") 
            EXIT
        case WXK_F11   
            cKey +=("F11") 
            EXIT
        case WXK_F12   
            cKey +=("F12") 
            EXIT
        case WXK_F13   
            cKey +=("F13") 
            EXIT
        case WXK_F14   
            cKey +=("F14") 
            EXIT
        case WXK_F15   
            cKey +=("F15") 
            EXIT
        case WXK_F16   
            cKey +=("F16") 
            EXIT
        case WXK_F17   
            cKey +=("F17") 
            EXIT
        case WXK_F18   
            cKey +=("F18") 
            EXIT
        case WXK_F19   
            cKey +=("F19") 
            EXIT
        case WXK_F20   
            cKey +=("F20") 
            EXIT
        case WXK_F21   
            cKey +=("F21") 
            EXIT
        case WXK_F22   
            cKey +=("F22") 
            EXIT
        case WXK_F23   
            cKey +=("F23") 
            EXIT
        case WXK_F24   
            cKey +=("F24") 
            EXIT
        case WXK_NUMLOCK   
            cKey +=("NUMLOCK") 
            EXIT
        case WXK_SCROLL   
            cKey +=("SCROLL") 
            EXIT
        case WXK_PAGEUP   
            cKey +=("PAGEUP") 
            EXIT
        case WXK_PAGEDOWN   
            cKey +=("PAGEDOWN") 
            EXIT
        case WXK_NUMPAD_SPACE   
            cKey +=("NUMPAD_SPACE") 
            EXIT
        case WXK_NUMPAD_TAB   
            cKey +=("NUMPAD_TAB") 
            EXIT
        case WXK_NUMPAD_ENTER   
            cKey +=("NUMPAD_ENTER") 
            EXIT
        case WXK_NUMPAD_F1   
            cKey +=("NUMPAD_F1") 
            EXIT
        case WXK_NUMPAD_F2   
            cKey +=("NUMPAD_F2") 
            EXIT
        case WXK_NUMPAD_F3   
            cKey +=("NUMPAD_F3") 
            EXIT
        case WXK_NUMPAD_F4   
            cKey +=("NUMPAD_F4") 
            EXIT
        case WXK_NUMPAD_HOME   
            cKey +=("NUMPAD_HOME") 
            EXIT
        case WXK_NUMPAD_LEFT   
            cKey +=("NUMPAD_LEFT") 
            EXIT
        case WXK_NUMPAD_UP   
            cKey +=("NUMPAD_UP") 
            EXIT
        case WXK_NUMPAD_RIGHT   
            cKey +=("NUMPAD_RIGHT") 
            EXIT
        case WXK_NUMPAD_DOWN   
            cKey +=("NUMPAD_DOWN") 
            EXIT
        case WXK_NUMPAD_PAGEUP   
            cKey +=("NUMPAD_PAGEUP") 
            EXIT
        case WXK_NUMPAD_PAGEDOWN   
            cKey +=("NUMPAD_PAGEDOWN") 
            EXIT
        case WXK_NUMPAD_END   
            cKey +=("NUMPAD_END") 
            EXIT
        case WXK_NUMPAD_BEGIN   
            cKey +=("NUMPAD_BEGIN") 
            EXIT
        case WXK_NUMPAD_INSERT   
            cKey +=("NUMPAD_INSERT") 
            EXIT
        case WXK_NUMPAD_DELETE   
            cKey +=("NUMPAD_DELETE") 
            EXIT
        case WXK_NUMPAD_EQUAL   
            cKey +=("NUMPAD_EQUAL") 
            EXIT
        case WXK_NUMPAD_MULTIPLY   
            cKey +=("NUMPAD_MULTIPLY") 
            EXIT
        case WXK_NUMPAD_ADD   
            cKey +=("NUMPAD_ADD") 
            EXIT
        case WXK_NUMPAD_SEPARATOR   
            cKey +=("NUMPAD_SEPARATOR") 
            EXIT
        case WXK_NUMPAD_SUBTRACT   
            cKey +=("NUMPAD_SUBTRACT") 
            EXIT
        case WXK_NUMPAD_DECIMAL   
            cKey +=("NUMPAD_DECIMAL") 
            EXIT
        OTHERWISE
             IF ( wxIsprint(keycode) )
                 cKey :=  "'" + CHR(keycode) + "'"
             ELSEIF ( keycode > 0 .and. keycode < 27 )
                 cKey :=  "'" + "Ctrl-" + CHR( ASC( "A" )+keycode-1 ) + "'"
             ELSE
                 cKey :=  "unknown ("+ Alltrim(Str(keycode)) +")"
            ENDIF
    END
RETURN (cKey)


