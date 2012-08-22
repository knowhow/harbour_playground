#include "wxharbour.ch"
#include "hbclass.ch"
#include "hblang.ch"
#include "color.ch"
#include "common.ch"
#include "setcurs.ch"
#include "getexit.ch"
#include "inkey.ch"
#include "button.ch"

#define GET_CLR_UNSELECTED      0
#define GET_CLR_ENHANCED        1
#define GET_CLR_CAPTION         2
#define GET_CLR_ACCEL           3

FUNCTION Main
    LOCAL wxGetSample
    wxGetSample := wxGetSample():New()
    IMPLEMENT_APP( wxGetSample )
RETURN NIL

/*
    wxGetSample
    jamaj Brasil 2009
*/
CLASS wxGetSample FROM wxApp
PRIVATE:
PROTECTED:
PUBLIC:
    METHOD OnInit
PUBLISHED:
ENDCLASS

REQUEST HB_CODEPAGE_PTISO


METHOD FUNCTION OnInit() CLASS wxGetSample
    LOCAL oDlg, oTextCtrl, oTextCtrl1, oTextCtrl2

    LOCAL edtNombre := "jamaj corporation", data := date(), edtLog := Space(100), salary := 12345678.34
    
    HB_CDPSELECT("PTISO")
    SET DATE TO BRITISH
    SET CENTURY ON 

    CREATE DIALOG oDlg ;
                 WIDTH 640 HEIGHT 400 ;
                 TITLE "Text Sample"

    BEGIN BOXSIZER VERTICAL 
        BEGIN BOXSIZER VERTICAL ALIGN EXPAND STRETCH
            BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND STRETCH
                @ SAY "Your Name is:" 
                oTextCtrl := TEditGet():New( oDlg, 123, "get1", edtNombre, {|_v_| IIF(pcount() > 0, edtNombre := _v_, edtNombre)  } ,"@!", "B/W,W/b" )
                containerObj():SetLastChild( oTextCtrl )
            END SIZER
            BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND STRETCH
                @ SAY "Your birthday is:" 
                oTextCtrl1 := TEditGet():New( oDlg, 124, "get2", data, {|_v_| IIF(pcount() > 0, data := _v_, data)  } ,"99/99/9999", "R/BG,G/W" )
                oTextCtrl1:SetToolTip( "birthday" )	
                containerObj():SetLastChild( oTextCtrl1 )
            END SIZER
            BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND STRETCH
                @ SAY "Your salary is:" 
                oTextCtrl2 := TEditGet():New( oDlg, 125, "get2", salary, {|_v_| IIF(pcount() > 0, salary := _v_, salary)  } , "@E 999,999,999.99", "G/GR,W/R" )
                oTextCtrl2:SetToolTip( "salary" )	
                containerObj():SetLastChild( oTextCtrl2 )
            END SIZER
            @ SAY "Multi Line:" GET edtLog NAME "Multi" MULTILINE STYLE wxTE_PROCESS_ENTER //SIZERINFO STRETCH
        END SIZER
        @ BUTTON ID wxID_OK ACTION oDlg:Close()
    END SIZER

    SHOW WINDOW oDlg FIT MODAL CENTRE
    oDlg:Destroy()

    ? "Variable's data:"
    ? "edtNombre:", edtNombre
    ? "birthday:", data
    ? "salary:", salary 

RETURN .T.

CLASS TEditGet FROM THackGet,wxTextCtrl
PRIVATE:
PROTECTED:
        DATA 	bAction  	
        DATA	bOnGFocus	
        DATA	bOnLFocus	
        DATA	bOnChar	
        DATA	bOnKeyDown	
        DATA	bOnKeyUp		
PUBLIC:
        DATA  oColor_U_F
        DATA  oColor_U_B
        DATA  oColor_S_F
        DATA  oColor_S_B
        DATA  lInsert INIT .t.
        DATA  plvl
        METHOD New( parent, id, name, var, block, picture, cColor, bAction, bOnGFocus, bOnLFocus, bOnChar, bOnKeyDown, bOnKeyUp  ) CONSTRUCTOR
        METHOD display()
PUBLISHED:
ENDCLASS


METHOD New( parent, id, name, var, block, picture, cColor, bAction, bOnGFocus, bOnLFocus, bOnChar, bOnKeyDown, bOnKeyUp  ) CLASS TEditGet
            Local cClrPair

            ::wxTextCtrl:New( parent, id, var, NIL, NIL, wxTE_PROCESS_ENTER, NIL, name )
            ::THackGet:New( 10, 10, block, var, picture , cColor )

            bAction 		:= IIF( bAction == NIL, { | event | OnAction(event) }, bAction )
            bOnGFocus		:= IIF( bOnGFocus == NIL,  { | event | OnGFocus(SELF,event) }, bOnGFocus )
            bOnLFocus		:= IIF( bOnLFocus == NIL,  { | event | OnLFocus(SELF,event) }, bOnLFocus )
            bOnChar			:= IIF( bOnChar == NIL,  { | event | OnChar(SELF, event)   }, bOnChar )
            bOnKeyDown	:= IIF( bOnKeyDown == NIL, { | event | OnKeyDown( event) }, bOnKeyDown )
            bOnKeyUp		:= IIF( bOnKeyUp == NIL,  { | event | OnKeyUp( event)  }, bOnKeyUp )

            ::bAction		 := bAction
            ::bOnGFocus	 := bOnGFocus
            ::bOnLFocus	 := bOnLFocus
            ::bOnChar		 := bOnChar 
            ::bOnKeyDown := bOnKeyDown
            ::bOnKeyUp   := bOnKeyDown
            
            ::ConnectFocusEvt( ::GetId(), wxEVT_KILL_FOCUS,   ::bOnLFocus )
            ::ConnectFocusEvt( ::GetId(), wxEVT_SET_FOCUS, 	  ::bOnGFocus )
            ::ConnectKeyEvt( 	 wxID_ANY, wxEVT_KEY_DOWN, 		::bOnKeyDown )
            ::ConnectKeyEvt( 	 wxID_ANY, wxEVT_KEY_UP, 			::bOnKeyUp )
            ::ConnectKeyEvt( 	 wxID_ANY, wxEVT_CHAR, 				::bOnChar	 )

            cClrPair :=  hb_ColorIndex( ::colorspec, GET_CLR_UNSELECTED )
            ::oColor_U_B := wxColour():New(ClrToRGB(GetClrBack( cClrPair )))
            ::oColor_U_F := wxColour():New(ClrToRGB(GetClrFore( cClrPair )))

            ::SetBackgroundColour(ClrToRGB(GetClrBack( cClrPair )))   
            ::SetForegroundColour(ClrToRGB(GetClrFore( cClrPair ))) 

            //::SetForegroundColour(::oColor_U_F) 
            //::SetBackgroundColour(::oColor_U_B) 

            cClrPair :=  hb_ColorIndex( ::colorspec, GET_CLR_ENHANCED )
            ::oColor_S_B := wxColour():New(ClrToRGB(GetClrBack( cClrPair )))
            ::oColor_S_F := wxColour():New(ClrToRGB(GetClrFore( cClrPair )))

            ::setfocus()
            ::updatebuffer()

RETURN Self

function ClrToRGB(cClr)
        Local aRGB, nI
        Local aClrs := 	{ ;
                                            {"N", 	{000,000,000} },;
                                            {"B",		{000,000,255} },;
                                            {"G",		{000,255,000} },;
                                            {"BG",	{000,255,255} },;
                                            {"R",		{255,000,000} },;
                                            {"RB",	{255,000,255} },;
                                            {"GR",	{255,255,000} },;
                                            {"W",		{255,255,255} },;
                                            {"N+",	{000,000,000} },;
                                            {"B+",	{000,000,255} },;
                                            {"G+",	{000,255,000} },;
                                            {"BG+",	{000,255,255} },;
                                            {"R+",	{255,000,000} },;
                                            {"RB+",	{255,000,255} },;
                                            {"GR+",	{255,255,000} },;
                                            {"W+",	{255,255,255}	};
                                         }
        nI := aScan( aClrs, { | x | x[1] == upper(alltrim(cClr)) } )		
        aRGB := IIF( nI > 0, aClrs[nI][2], { 0,0,0} )		
return aRGB

METHOD display() CLASS TEditGet
        LOCAL cBuffer
        LOCAL nDispPos
        LOCAL cValue

        IF ::hasFocus
            cBuffer   := ::cBuffer
        ELSE
            ::cType   := ValType( ::xVarGet := ::varGet() )
            ::picture := ::cPicture
            cBuffer   := ::PutMask( ::xVarGet )
        ENDIF

        ::nMaxLen := Len( cBuffer )
        ::nDispLen := iif( ::nPicLen == NIL, ::nMaxLen, ::nPicLen )

        IF ::cType == "N" .AND. ::hasFocus .AND. ! ::lMinusPrinted .AND. ;
            ::decPos != 0 .AND. ::lMinus2 .AND. ;
            ::nPos > ::decPos .AND. Val( Left( cBuffer, ::decPos - 1 ) ) == 0
            /* Display "-." only in case when value on the left side of
                 the decimal point is equal 0 */
            cBuffer := SubStr( cBuffer, 1, ::decPos - 2 ) + "-." + SubStr( cBuffer, ::decPos + 1 )
        ENDIF

        IF ::nDispLen != ::nMaxLen .AND. ::nPos != 0 /* ; has scroll? */
            IF ::nDispLen > 8
                 nDispPos := Max( 1, Min( ::nPos - ::nDispLen + 4       , ::nMaxLen - ::nDispLen + 1 ) )
            ELSE
                 nDispPos := Max( 1, Min( ::nPos - Int( ::nDispLen / 2 ), ::nMaxLen - ::nDispLen + 1 ) )
            ENDIF
        ELSE
            nDispPos := 1
        ENDIF

        /* Display the GET */
        IF !::lSuppDisplay .OR. nDispPos != ::nOldPos
            cValue := iif( ::lHideInput, PadR( Replicate( SubStr( ::cStyle, 1, 1 ), Len( RTrim( cBuffer ) ) ), ::nDispLen ), SubStr( cBuffer, nDispPos, ::nDispLen ) )
            IIF(HB_ISSTRING(::buffer),::ChangeValue(HB_StrToUTF8(cValue)),NIL)
        ENDIF

        IIF(HB_ISSTRING(::buffer),::SetInsertionPoint(::pos-1),NIL)

        ::nOldPos := nDispPos
        ::lSuppDisplay := .F.

        #ifdef _DEBUG_
        ? "TEditGet:Display() =>" , " Buffer: " , ::buffer , " Len(Buffer) = " , IIF(HB_ISSTRING(::buffer), Alltrim(Str(Len(::buffer))),0) , " Cursor: " , Alltrim(Str(::pos)) , "/" , Alltrim(Str(::GetInsertionPoint()))
        //altd()	
        #endif
RETURN Self


FUNCTION OnAction(event)	
    LOCAL lRet := .t.
    ? "OnAction" 
    event:skip()
RETURN lRet

FUNCTION OnGFocus(g,event)
    Local cClrPair
    g:SetFocus()
    g:updatebuffer()

    cClrPair :=  hb_ColorIndex( g:colorspec, GET_CLR_ENHANCED )
    g:SetBackgroundColour(ClrToRGB(GetClrBack( cClrPair )))   
    g:SetForegroundColour(ClrToRGB(GetClrFore( cClrPair ))) 

    //::SetForegroundColour(::oColor_S_F) 
    //::SetBackgroundColour(::oColor_S_B) 

    #ifdef _DEBUG_
        ? "OnGFocus", " Buffer: " , g:buffer , " Len(Buffer) = " , IIF(HB_ISSTRING(g:buffer), Alltrim(Str(Len(g:buffer))),0) , " Cursor: " , Alltrim(Str(g:pos)) , "/" , Alltrim(Str(g:GetInsertionPoint()))
    #endif
    event:skip()
RETURN NIL

FUNCTION OnLFocus(g,event)
    Local cClrPair
    g:assign()
    g:killfocus()

    cClrPair :=  hb_ColorIndex( g:colorspec, GET_CLR_UNSELECTED )
    g:SetBackgroundColour(ClrToRGB(GetClrBack( cClrPair )))   
    g:SetForegroundColour(ClrToRGB(GetClrFore( cClrPair ))) 

    #ifdef _DEBUG_
        ? "OnLFocus" , " Buffer: " , g:buffer , " Len(Buffer) = " , IIF(HB_ISSTRING(g:buffer), Alltrim(Str(Len(g:buffer))),0) , " Cursor: " , Alltrim(Str(g:pos)) , "/" , Alltrim(Str(g:GetInsertionPoint()))
    #endif
    event:skip()
RETURN NIL

FUNCTION OnChar(g,event)
    LOCAL lSkip
    #ifdef _DEBUG_
        ? ("OnChar key=" + Str(event:GetKeyCode()) + "-" + GetKeyName(event:GetKeyCode()) + " " + "UnicodeKey=" + Str(event:GetUnicodeKey()))
    #endif
    lSkip := Typer(g,event)
    event:skip(lSkip)
RETURN .f.

FUNCTION OnKeyDown(event)
    #ifdef _DEBUG_
    ? ("OnKeyDown key=" + Str(event:GetKeyCode()) + "-" + GetKeyName(event:GetKeyCode()) +" " + "UnicodeKey=" + Str(event:GetUnicodeKey()))
    #endif
    event:skip(.t.)
RETURN .t.

FUNCTION OnKeyUp(event)
    LOCAL lRet := .t.
    //LOCAL keycode := 
    #ifdef _DEBUG_
    LOCAL ctrlDown := event:ControlDown()
    ? ("OnKeyUp key=" + Str(event:GetKeyCode()) + "-" + IIF(ctrlDown,"CTRL+","") + GetKeyName(event:GetKeyCode()) +" " + "UnicodeKey=" + Str(event:GetUnicodeKey()) )
    #endif
    event:skip(.t.)
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

CLASS THackGet FROM GET
    METHOD New( nRow, nCol, bVarBlock, cVarName, cPicture, cColorSpec ) CONSTRUCTOR
ENDCLASS

METHOD New( nRow, nCol, bVarBlock, cVarName, cPicture, cColorSpec ) CLASS THackGet
    Super:New( nRow, nCol, bVarBlock, cVarName, cPicture, cColorSpec )
RETURN Self

FUNCTION Typer(g,event)
    LOCAL lSkip:=.f., cKey, lValidOk
    LOCAL nKey := event:GetUnicodeKey()
    LOCAL ctrlDown := event:ControlDown()
    g:SetFocus()

    #ifdef _DEBUG_
    ? "Typer(A): GET pos= " + alltrim(str(g:pos)) + " " + "EDIT pos=" + alltrim(str((g:GetInsertionPoint())	))
    #endif

    do case
        case ( nKey == K_ENTER  )
        case ( nKEY == WXK_TAB )
            if ( g:type == "D" )
                lValidOk := !g:badDate
            else
                lValidOk := .t.
            endif
            lSkip := lValidOk
        case ( nKey == WXK_ESCAPE  )
            lSkip := .t.
        case ( nKEY == K_CTRL_U )
            g:Undo()
        case ( nKey == WXK_INSERT )
            g:lInsert := !g:lInsert
            Set( _SET_INSERT, g:lInsert )
            lSkip := .t.
        case ( nKey == WXK_HOME )
            g:Home()
        case ( nKey == WXK_END )
            g:End()
        case ( nKey == WXK_RIGHT .and. !ctrlDown )
            g:Right()
        case ( nKey == WXK_LEFT .and. !ctrlDown)
            g:Left()
        case ( nKey == WXK_RIGHT .and. ctrlDown )
            g:WordRight()
        case ( nKey == WXK_LEFT .and. ctrlDown)
            g:WordLeft()
        case ( nKey == WXK_BACK )
            g:backSpace()
        case ( nKey == WXK_DELETE )
            g:delete()
        case ( nKey == K_CTRL_T )
            g:DelWordRight()
        case ( nKey == K_CTRL_Y )
            g:DelEnd()
        otherwise
            if ( wxIsprint(nKey) )
                // data key
                cKey := Chr( nKey )
                if ( g:Type == "N" .and. ;
                    ( cKey == "." .or. cKey == "," ) )
                    // go to decimal point
                    g:ToDecPos()
                else
                    // send it to the get
                    if ( g:lInsert )
                        g:Insert( cKey )
                    else
                        g:Overstrike( cKey )
                    end
                    lSkip := .f.
                end
            elseif ( nKey != 0 )
                    lSkip  := .t.
            end
        endcase
        
    #ifdef _DEBUG_
        ? "Typer(A): GET pos= " + alltrim(str(g:pos)) + " " + "EDIT pos=" + alltrim(str((g:GetInsertionPoint())	))
    #endif
RETURN (lSkip)
