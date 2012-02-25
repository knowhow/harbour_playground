/*
    $Id: Tbl_Name.prg 639 2010-06-30 18:09:09Z tfonrouge $
    Tbl_Name : Table to contain names
*/

#include "wxharbour.ch"

#include "AddressBook.ch"

CLASS Tbl_Name FROM Tbl_Common
PRIVATE:
PROTECTED:
PUBLIC:

    DATA autoEdit INIT .T.
    DATA panelDetail

    PROPERTY TableFileName DEFAULT "names"
    
    CALCFIELD Age()
    CALCFIELD FullName()

    DEFINE FIELDS
    DEFINE INDEXES

    METHOD OnAfterOpen()
    METHOD OnDataChange()

PUBLISHED:
ENDCLASS

/*
    FIELDS
*/
BEGIN FIELDS CLASS Tbl_Name

    ADD INTEGER FIELD "RecId" ;
        //PRIVATE

    ADD STRING FIELD "FName" NAME "FirstName" SIZE 40 ;
        REQUIRED ;
        LABEL "First Name" 

    ADD STRING FIELD "LName" NAME "LastName" SIZE 40 ;
        REQUIRED ;
        LABEL "Last Name"
    
    ADD STRING FIELD "Genre" SIZE 1 ;
        VALIDVALUES {"F"=>"Female","M"=>"Male"}

    ADD DATETIME FIELD "DoB" ;
        REQUIRED ;
        LABEL "Day of birth"
        
    ADD OBJECT FIELD "Country" ;
        OBJTYPE "Tbl_Country"
        
    ADD MEMO FIELD "Memo"
        
    /* Calculated Field's */
    ADD CALCULATED STRING FIELD "FullName" SIZE 81 ;
        LABEL "Name"
        
    ADD CALCULATED FLOAT FIELD "Age"

END FIELDS CLASS

/*
    INDEXES
*/
BEGIN INDEXES CLASS Tbl_Name
    DEFINE PRIMARY INDEX "Primary" KEYFIELD "RecId" AUTOINCREMENT
    DEFINE SECONDARY INDEX "Name" KEYFIELD {"FirstName","LastName"} UNIQUE NO_CASE_SENSITIVE
    DEFINE SECONDARY INDEX "DoB" KEYFIELD "DoB"
END INDEXES CLASS

/*
    CalcField_Age
*/
CALCFIELD Age() CLASS Tbl_Name
RETURN ( Date() - ::Field_DoB:Value ) / 365.25

/*
    CalcField_FullName
*/
CALCFIELD FullName() CLASS Tbl_Name
RETURN RTrim( ::Field_FirstName:Value ) + " " + RTrim( ::Field_LastName:Value )

/*
    OnAfterOpen
*/
METHOD PROCEDURE OnAfterOpen() CLASS Tbl_Name
    ::IndexName := "Name"
RETURN

/*
    OnDataChange
*/
METHOD PROCEDURE OnDataChange() CLASS Tbl_Name

    IF ::panelDetail != NIL
        ::panelDetail:TransferDataToWindow()
    ENDIF
    
    //Super:OnDataChange()

RETURN
