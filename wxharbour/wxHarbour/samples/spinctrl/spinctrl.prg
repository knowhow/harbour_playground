/*
 * $Id: spinctrl.prg 637 2010-06-26 15:56:06Z tfonrouge $
 */

/*
    (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxTimer sample
    Teo. Mexico 2009
*/

#include "wxharbour.ch"

#include "wxh/textctrl.ch"

/*
    Main : Needed in all wx* apps
    Teo. Mexico 2009
*/
FUNCTION Main()

    IMPLEMENT_APP( MyApp():New() )

RETURN NIL

/*
    MyApp
    Teo. Mexico 2009
*/
CLASS MyApp FROM wxApp
PRIVATE:
    DATA timerEvent
    DATA timerNotify
PROTECTED:
PUBLIC:
    DATA textCtrlEvent
    DATA textCtrlNotify
    DATA spinCtrlEvent
    DATA spinCtrlNotify
    METHOD OnInit
    METHOD OnTimerEvent INLINE ::textCtrlEvent:AppendText( Str( seconds() ) + E" from Event\n" )
    METHOD StartStopTimers( event )
PUBLISHED:
ENDCLASS

/*
    EndClass MyApp
*/

CLASS MyTimer FROM wxTimer
    METHOD Notify
ENDCLASS

METHOD PROCEDURE Notify CLASS MyTimer
    wxGetApp():textCtrlNotify:AppendText( Str( seconds() ) + E" from Notify\n" )
RETURN

/*
    OnInit
    Teo. Mexico 2009
*/
METHOD FUNCTION OnInit() CLASS MyApp
    LOCAL frame
    LOCAL sc1 := 1000
    LOCAL sc2 := 1000

    CREATE FRAME frame ;
                 WIDTH 640 HEIGHT 400 ;
                 TITLE "Timer Sample"

    BEGIN BOXSIZER VERTICAL
        BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND STRETCH
            BEGIN BOXSIZER VERTICAL "Timer by Event" ALIGN EXPAND STRETCH
                BEGIN BOXSIZER HORIZONTAL
                    @ SAY "Milliseconds"
                    @ SPINCTRL sc1 VAR ::spinCtrlEvent NAME "spinEvent" MIN 50 MAX 10000 ACTION {|| wxMessageBox( "!", "", HB_BitOr( wxOK, wxICON_INFORMATION ) ) }
                    @ BUTTON "Start" NAME "BtnEvent" ACTION {|event| ::StartStopTimers( event ) }
                END SIZER
                @ GET VAR ::textCtrlEvent MULTILINE STYLE wxTE_READONLY SIZERINFO ALIGN EXPAND STRETCH
            END SIZER
            BEGIN BOXSIZER VERTICAL "Timer by Notify" ALIGN EXPAND STRETCH
                BEGIN BOXSIZER HORIZONTAL
                    @ SAY "Milliseconds"
                    @ SPINCTRL sc2 VAR ::spinCtrlNotify NAME "spinNotify" MIN 50 MAX 10000
                    @ BUTTON "Start" NAME "BtnNotify" ACTION {|event| ::StartStopTimers( event ) }
                END SIZER
                @ GET VAR ::textCtrlNotify MULTILINE STYLE wxTE_READONLY SIZERINFO ALIGN EXPAND STRETCH
            END SIZER
        END SIZER
        BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
            @ BUTTON ID wxID_OK ACTION frame:Close()
        END SIZER
    END SIZER

    SHOW WINDOW frame FIT CENTRE

    /* timer by Event */
    ::timerEvent:= wxTimer():New( frame, frame:GetId() )
    frame:ConnectTimerEvt( frame:GetId(), wxEVT_TIMER, {|| ::OnTimerEvent() } )

    /* timer by Notify on wxTimer descendant class */
    ::timerNotify := MyTimer():New()

RETURN .T.

METHOD PROCEDURE StartStopTimers( event ) CLASS MyApp
    LOCAL button
    LOCAL timer
    LOCAL label
    LOCAL textCtrl
    LOCAL spinCtrl

    button := event:GetEventObject()

    IF button:GetName() == "BtnEvent"
        timer := ::timerEvent
        textCtrl := ::textCtrlEvent
        spinCtrl := ::spinCtrlEvent
    ELSE
        timer := ::timerNotify
        textCtrl := ::textCtrlNotify
        spinCtrl := ::spinCtrlNotify
    ENDIF

    IF timer:IsRunning()
        label := "Start"
        timer:Stop()
    ELSE
        label := "Stop"
        timer:Start( spinCtrl:GetValue() )
    ENDIF

    textCtrl:AppendText( button:GetLabel() + E"\n" )
    button:SetLabel( label )

RETURN
