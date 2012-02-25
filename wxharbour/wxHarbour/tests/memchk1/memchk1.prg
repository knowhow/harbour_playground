#include "wxharbour.ch"

CLASS MyApp FROM wxApp
PRIVATE:
PROTECTED:
PUBLIC:
    DATA frame
    METHOD OnInit()
PUBLISHED:
ENDCLASS

FUNCTION Main()

    IMPLEMENT_APP( MyApp():New() )

RETURN NIL

METHOD FUNCTION OnInit() CLASS MyApp
    LOCAL firstName, lastName
    LOCAL time := Time()
    LOCAL timerEvent
    
    firstName := "Juan"
    lastName := "Camaney"

    CREATE DIALOG ::frame ;
        TITLE "Frame1"

    BEGIN BOXSIZER VERTICAL
        @ SAY "First Name:" GET firstName
        @ SAY "Last Name:" GET lastName
        @ SAY "Time:" GET time
        @ BUTTON "Update" ACTION {|| ::frame:FindWindowByName("time"):SetValue( time := Time() ) }
        @ BUTTON ID wxID_OK
    END SIZER	

    timerEvent := wxTimer():New( ::frame, ::frame:GetId() )
    ::frame:ConnectTimerEvt( ::frame:GetId(), wxEVT_TIMER, ;
        {||
            ::frame:FindWindowByName("time"):SetValue( time := Time() )
            RETURN NIL
        } )
    
    timerEvent:Start()

    SHOW WINDOW ::frame MODAL FIT CENTRE
    
    timerEvent:Stop()
    
    DESTROY ::frame

RETURN .F.
