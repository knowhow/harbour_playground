/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: class TSalXLS  Basado en TReport de Ignacio Ortiz          ³
³               usa clas Filexls de Ramon Avendano                         ³
³         File: TSalXLS.PRG                                                ³
³       Author: RenOmaS                                                    ³
³         Date: 01/08/2002                                                 ³
³         Time: 20:20:07                                                   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

#include "FileXLS.ch"
//#include "FiveWin.ch"
//#include "Report.ch"

//----------------------------------------------------------------------------//

CLASS TSalXLS

   DATA oRpt
   DATA oXls
   DATA cFile
   DATA aFont
   DATA aFormat

   DATA nRow

   METHOD New( ) CONSTRUCTOR
   METHOD cFormat( cPicture, cType )
   METHOD cFont( nFont )
   METHOD FormatColumns()
   METHOD Save()
   METHOD SayHeader()
   METHOD SayTitle()

   METHOD Play()
   METHOD ColTitle()
   METHOD PageTotal()
   METHOD Say()
   METHOD StartLine( nHeight )
   METHOD EndLine( nHeight )
   METHOD StartGroup( nGroup )
   METHOD EndGroup( nGroup )
   METHOD StartPage()
   METHOD EndPage()
   METHOD TotalLine()   VIRTUAL

   METHOD TotalGroup( nGroup )
   METHOD SayData( nCol, nLine )
   METHOD Stabilize()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oRpt, cFile ) CLASS TSalXLS

   LOCAL nFor, nFor1, ;
         nLen := LEN ( oRpt:aColumns ), ;
         oFont, oCol, ;
         cPicture:= '', ;
         nPos, ;
         nHeight

   DEFAULT cFile:= "MyFile.xls"

   ::aFont  := {}
   ::aFormat:= {}
   ::cFile  := cFile
   ::oRpt   := oRpt

   ::nRow   := 0

   If ::oRpt:bPreInit != NIl
      Eval( ::oRpt:bPreInit, ::oRpt )
   Else
      DbGoTop()
   ENDIF

   // Definiendo Fonts
   FOR nFor:= 1 TO LEN( ::oRpt:aFont )

       oFont  := ::oRpt:aFont[ nFor ]
       nHeight:= Round( oFont:nHeight * 72 / ::oRpt:nLogPixY, 0 ) // Volviendo a su estado normal

       AADD( ::aFont, XLSFONT( oFont:cFaceName, nHeight, oFont:lBold, oFont:lItalic, ;
                               oFont:lUnderLine, oFont:lStrikeOut ) )
   NEXT

   // extraendo format de datos
   FOR nFor:= 1 TO nLen
       oCol := ::oRpt:aColumns[ nFor ]

       FOR nFor1:= 1 TO len( oCol:aPicture )

           cPicture:= oCol:aPicture[ nFor1 ]

           IF !empty( cPicture )
              cPicture:= ChangePicture( cPicture, VALTYPE( EVAL( oCol:aData[ nFor1 ] ) ) )

              IF ascan( ::aFormat, { |x| x[2] == cPicture } ) == 0
                 aadd( ::aFormat, { XLSFORMAT( cPicture ), cPicture } )
              ENDIF
           ENDIF
       NEXT

       oCol:nTotal:= 0   // poniendo total a 0 por siaca :D

   NEXT

   ::oXls := TFileXLS():New( ::cFile, , , .F., .T. )

   Return Self


METHOD Save() CLASS TSalXLS

   IF len( ::oRpt:aGroups) > 0
      DO WHILE eval( ::oRpt:bWhile ) .AND. !eval( ::oRpt:bFor )
         SysRefresh()
         ::oRpt:Skip( 1 )
      ENDDO
   ENDIF

   MsgRun( "Generando Archivo Excel.... espere ", , {|| ::Stabilize(), ;
                                                        ::FormatColumns(), ;
                                                        ::Play() } )

   SET XLS TO DISPLAY ;
       OF ::oXLS

   ::oXLS:End()

   RETURN Self


METHOD FormatColumns() CLASS TSalXLS
   LOCAL nFor
   LOCAL nLen:= LEN ( ::oRpt:aColumns )
   LOCAL nWidth
   Local oCol

   FOR nFor:= 1 TO nLen

       oCol  := ::oRpt:aColumns[ nFor ]

       nWidth:= oCol:nWidth / 18.85    // 18.85 calculado abitrario

       XLS COL nFor WIDTH nWidth OF ::oXLS
//       ::oXLS:_Col( nFor, , ::oRpt:aColumns[ nFor ]:nWidth )
   NEXT

   RETURN Nil


METHOD SayHeader() CLASS TSalXLS
   LOCAL nFor
   Local oHeader  := ::oRpt:oHeader
   Local nColumns := Len( ::oRpt:aColumns )
   LOCAL nCol:= 1
   LOCAL nRow, nMax:= 0
   LOCAL uVal
   LOCAL nFont
   LOCAL nAlignament := ALING_NULL
   LOCAL aRow:= {}

   FOR nFor:= 1 TO LEN( oHeader:aLine )

      uVal := Eval( oHeader:aLine[ nFor ] )

      IF !empty( uVal )

           DO CASE
              CASE oHeader:aPad[ nFor ] == RPT_LEFT
                   nCol := 1
                   nAlignament := ALING_LEFT

              CASE oHeader:aPad[ nFor ] == RPT_CENTER
                   nCol := Round( nColumns / 2, 0 )
                   nAlignament := ALING_CENTER

              CASE oHeader:aPad[ nFor ] == RPT_RIGHT
                   nCol := nColumns
                   nAlignament := ALING_RIGHT
           ENDCASE

           nFont:= ::cFont( EVAL( oHeader:aFont[ nFor ] ) )

           IF ( nRow:= ascan( aRow, { |x| x == oHeader:aRow[ nFor ] } ) ) == 0
              aadd( aRow, oHeader:aRow[ nFor ] )
              nRow := len( aRow )
           ENDIF

           nRow += ::nRow

           @ nRow, nCol XLS SAY uVal OF ::oXLS ;
                            FONT nFont  ;
                            ALIGNAMENT nAlignament

           nMax:= MAX( nMax, nRow )
      ENDIF

   NEXT

   ::nRow := MAX( ::nRow, nMax )

   RETURN Nil


METHOD SayTitle() CLASS TSalXLS
   LOCAL nFor
   Local oTitle := ::oRpt:oTitle
   Local nColumns := len( ::oRpt:aColumns )
   LOCAL nCol:= 1
   LOCAL uVal
   LOCAL nFont
   LOCAL nAlignament := ALING_NULL
   LOCAL nMaxRow:= 1

   FOR nFor:= 1 TO len( oTitle:aLine )

       uVal := Eval( oTitle:aLine[ nFor ] )

       IF ! empty( uVal )

          DO CASE
             CASE oTitle:aPad[ nFor ] == RPT_LEFT
                  nCol := 1
                  nAlignament := ALING_LEFT

             CASE oTitle:aPad[ nFor ] == RPT_CENTER
                  nCol := round( nColumns / 2, 0 )
                  nAlignament := ALING_CENTER

             CASE oTitle:aPad[ nFor ] == RPT_RIGHT
                  nCol := nColumns
                  nAlignament := ALING_RIGHT
          ENDCASE

          nFont:= ::cFont( EVAL( oTitle:aFont[ nFor ] ) )

          @ ::nRow + nFor, nCol XLS SAY uVal OF ::oXLS ;
                                FONT nFont  ;
                                ALIGNAMENT nAlignament

          nMaxRow:= MAX( nMaxRow, ::nRow + nFor )
       ENDIF
   NEXT

   ::nRow := nMaxRow + 1

   RETURN Nil


METHOD ColTitle() CLASS TSalXLS
   LOCAL nFor1, nFor2
   LOCAL nColumns := Len( ::oRpt:aColumns )
   Local oCol
   LOCAL uVal
   LOCAL nFont
   LOCAL nAlignament := ALING_NULL
   LOCAL nMaxRow:= 1
   LOCAL nBorder := BORDER_NONE, ;
         nBorTop := BORDER_NONE, ;
         nBorBot := BORDER_NONE

   IF ::oRpt:nTitleUpLine != RPT_NOLINE
      nBorTop:= BORDER_TOP
   ENDIF

   IF ::oRpt:nTitleDnLine != RPT_NOLINE
      nBorBot:= BORDER_BOTTOM
   ENDIF

   FOR nFor1 := 1 TO ::oRpt:nMaxTitle

      IF ::oRpt:nMaxTitle > 1
         IF nFor1 == 1
            nBorder:= nBorTop
         ELSEIF nFor1 == ::oRpt:nMaxTitle
            nBorder:= nBorBot
         ELSE
            nBorder:= BORDER_NONE
         ENDIF
      ELSE
         nBorder:= nOr( nBorTop, nBorBot )
      ENDIF

      FOR nFor2 := 1 TO nColumns
          oCol := ::oRpt:aColumns[ nFor2 ]

          IF nFor1 <= len( oCol:aTitle )

             uVal := Eval( oCol:aTitle[ nFor1 ] )

             If Empty( uVal )
                @ ::nRow + nFor1, nFor2 XLS SAY NIL OF ::oXLS ;
                                        BORDER nBorder
             Else
                nFont:= ::cFont( EVAL( oCol:bTitleFont ) )

                DO CASE
                   CASE oCol:nPad == RPT_LEFT
                        nAlignament := ALING_LEFT
                   CASE oCol:nPad == RPT_CENTER
                        nAlignament := ALING_CENTER
                   CASE oCol:nPad == RPT_RIGHT
                        nAlignament := ALING_RIGHT
                ENDCASE

                @ ::nRow + nFor1, nFor2 XLS SAY uVal ;
                                        FONT nFont OF ::oXLS ;
                                        ALIGNAMENT nAlignament ;
                                        BORDER nBorder
             EndIf
          ELSE
             @ ::nRow + nFor1, nFor2 XLS SAY NIL OF ::oXLS ;
                                     BORDER nBorder
          ENDIF
      NEXT
      nMaxRow:= MAX( nMaxRow, ::nRow + nFor1 )
   NEXT

   ::nRow := nMaxRow + 1

   ++::nRow

   RETURN Nil


METHOD Play() CLASS TSalXLS

   LOCAL nColumns := len( ::oRpt:aColumns ), ;
         nGroups  := len( ::oRpt:aGroups ), ;
         oCol, ;
         nFor1, ;
         nFor2, ;
         nFor3, ;
         nTotalvalue

   ::StartPage()

   ASend( ::oRpt:aGroups, "Reset" )

   Aeval( ::oRpt:aGroups, { |val,elem| ::oRpt:StartGroup( elem ) } )

   DO WHILE eval( ::oRpt:bWhile )

      SysRefresh()

      IF !eval( ::oRpt:bFor )
         ::oRpt:Skip( 1 )
         LOOP
      ENDIF

      IF ::oRpt:lGroup
         ASend( ::oRpt:aGroups, "Evaluate" )
      ENDIF

      IF ::oRpt:bStartRecord != Nil
         eval( ::oRpt:bStartRecord, ::oRpt )
      ENDIF

      FOR nFor1 := 1 TO ::oRpt:nMaxData

         FOR nFor2 := 1 TO nColumns

             oCol:= ::oRpt:aColumns [ nFor2 ]

             IF !::oRpt:lSummary
                 ::SayData( nFor2, nFor1 )
             ENDIF

             IF ::oRpt:lTotal              .AND. ;
                oCol:lTotal                .AND. ;
                ( ! oCol:lTotalExpr         .OR. ;
                  eval( oCol:bTotalExpr ) )

                nTotalValue := eval( ::oRpt:aData[ nFor2 ][ nFor1 ] )

                IF valtype( nTotalValue ) == "N"

                     oCol:nTotal += nTotalValue

                     IF ::oRpt:lGroup
                        FOR nFor3 := 1 TO nGroups
                           ::oRpt:aGroups[nFor3]:aTotal[nFor2] += nTotalValue
                        NEXT
                     ENDIF

                ENDIF
             ENDIF

         NEXT

         IF !::oRpt:lSummary
            ++::nRow
         ENDIF

      NEXT

      ::oRpt:Skip(1)

      IF ::oRpt:lGroup

         DO WHILE eval( ::oRpt:bWhile ) .AND. !eval( ::oRpt:bFor )
            SysRefresh()
            ::oRpt:Skip(1)
         ENDDO

         FOR nFor1 := nGroups TO 1 STEP -1
            IF ::oRpt:aGroups[nFor1]:Check()
               ::EndGroup( nFor1 )
            ENDIF
         NEXT

         FOR nFor1 := 1 TO nGroups
            IF ::oRpt:aGroups[ nFor1 ]:lNeedStart
               ::StartGroup( nFor1 )
            ENDIF
         NEXT

       ENDIF

   ENDDO

   IF ::oRpt:lGroup
      FOR nFor1 := nGroups TO 1 STEP -1
         IF !Empty( ::oRpt:aGroups[nFor1]:nCounter )
            ::EndGroup( nFor1 )
         ENDIF
      NEXT
   ENDIF

   ::oRpt:lFinish := .T.

   IF ::oRpt:bEnd != nil
      Eval( ::oRpt:bEnd, ::oRpt )
   ENDIF

   ::EndPage()

   RETURN NIL


METHOD StartGroup( nGroup ) CLASS TSalXLS
   Local uVal, nFont
   LOCAL oGroup:= ::oRpt:aGroups[ nGroup ]

   STATIC lRunning := .F.

   oGroup:lNeedStart := .F.

   IF !Eval( ::oRpt:bWhile )
      RETURN NIL
   ENDIF

   IF ::oRpt:bStartGroup != nil .AND. !lRunning
      lRunning := .T.
      Eval( ::oRpt:bStartGroup, oGroup, nGroup )
      lRunning := .F.
   ENDIF

   IF oGroup:lHeader

      uVal := Eval( oGroup:bHeader )
      nFont:= ::cFont( Eval( oGroup:bHeadFont ) )

      @ ++::nRow, 1 XLS SAY uVal FONT nFont OF ::oXLS
      ++::nRow   // Kleyber Derick - 22/12/2006 

      IF Eval( oGroup:bFooter ) == "" .AND. ::oRpt:lSummary
         ::TotalGroup( oGroup )
      ENDIF

   ENDIF

   RETURN NIL


METHOD EndGroup( nGroup ) CLASS TSalXLS
   Local uVal, nFont
   LOCAL oGroup:= ::oRpt:aGroups[ nGroup ]
   LOCAL nBorder := BORDER_NONE

   STATIC lRunning := .F.

   IF ::oRpt:bEndGroup != nil .AND. !lRunning
      lRunning := .T.
      Eval( ::oRpt:bEndGroup, oGroup )
      lRunning := .F.
   ENDIF

   IF !::oRpt:lSummary .and. ::oRpt:lTotal
      nBorder := BORDER_TOP
   ENDIF

   IF oGroup:lFooter

      uVal := Eval( oGroup:bFooter )
      nFont:= ::cFont( Eval( oGroup:bFootFont ) )

      ::TotalGroup( oGroup, nBorder )

      @ ::nRow, 1 XLS SAY uVal FONT nFont OF ::oXLS BORDER nBorder

   ELSE
      IF !::oRpt:lSummary
         ::TotalGroup( oGroup, nBorder )
      ENDIF
   ENDIF

   If !::oRpt:lSummary
      ++::nRow
   EndIf

   IF ::oRpt:bPostGroup != nil .AND. !lRunning
      lRunning := .T.
      Eval( ::oRpt:bPostGroup, oGroup, nGroup )
      lRunning := .F.
   ENDIF

   IF oGroup:lEject         .AND. ;
      eval( ::oRpt:bWhile ) .AND. ;
      eval( ::oRpt:bFor )
      ::EndPage()
   Else
      ++::nRow
   ENDIF

   oGroup:Reset()
   oGroup:lNeedStart := .T.

   RETURN NIL


METHOD TotalGroup( oGroup, nBorder )  CLASS TSalXLS

     LOCAL nFont, ;
           nFor, ;
           nColumns:= len( ::oRpt:aColumns ), ;
           nAlignament:= ALING_NULL, ;
           uVal, ;
           nFormat

     IF !( ::oRpt:lTotal )
        RETURN NIL
     ENDIF

     DEFAULT nBorder := BORDER_NONE

     FOR nFor := 1 TO nColumns

          IF ::oRpt:aColumns[ nFor ]:lTotal

             nFont := ::cFont( eval( ::oRpt:aColumns[ nFor ]:bTotalFont ) )

             DO CASE
                CASE ::oRpt:aColumns[ nFor ]:nPad == RPT_LEFT
                     nAlignament := ALING_LEFT

                CASE ::oRpt:aColumns[ nFor ]:nPad == RPT_RIGHT
                     nAlignament := ALING_RIGHT

                CASE ::oRpt:aColumns[ nFor ]:nPad == RPT_CENTER
                     nAlignament := ALING_CENTER
             ENDCASE

             uVal := oGroup:aTotal[ nFor ]

             nFormat := ::cFormat( ::oRpt:aColumns[ nFor ]:cTotalPict, 'N' )

             @ ::nRow, nFor XLS SAY uVal OF ::oXLS ;
                                      FORMAT nFormat ;
                                      FONT nFont     ;
                                      ALIGNAMENT nAlignament ;
                                      BORDER nBorder
         ELSE
             @ ::nRow, nFor XLS SAY NIL OF ::oXLS ;
                                      BORDER nBorder
         ENDIF
     NEXT

     RETURN NIL


METHOD SayData( nCol, nLine ) CLASS TSalXLS

     LOCAL nFont, ;
           nFor, ;
           oCol := ::oRpt:aColumns[ nCol ], ;
           nAlignament:= ALING_NULL, ;
           uVal, ;
           nFormat := 0

     IF nLine > len( oCol:aData)
        RETURN NIL
     ENDIF

     nFont := ::cFont( eval( oCol:bDataFont ) )

     DO CASE
        CASE oCol:nPad == RPT_LEFT
             nAlignament := ALING_LEFT

        CASE oCol:nPad == RPT_RIGHT
             nAlignament := ALING_RIGHT

        CASE oCol:nPad == RPT_CENTER
             nAlignament := ALING_CENTER
     ENDCASE

     uVal := Eval( oCol:aData[ nLine ] )

     IF !empty( oCol:aPicture[ nLine ] )
        nFormat := ::cFormat( oCol:aPicture[ nLine ], valtype( uVal ) )
     ENDIF

     @ ::nRow, nCol XLS SAY uVal OF ::oXLS ;
                              FORMAT nFormat ;
                              FONT nFont     ;
                              ALIGNAMENT nAlignament
     RETURN NIL


METHOD cFormat( cPicture, cType ) CLASS TSalXLS
   LOCAL nFormat:= 0,;
         nPos

   cPicture:= ChangePicture( cPicture, cType )

   IF ( nPos:= ascan( ::aFormat, { |x|  x[2] == cPicture } ) ) != 0
      nFormat:= ::aFormat[ nPos, 1 ]
   ENDIF

   RETURN nFormat


METHOD cFont( nFont ) CLASS TSalXLS

   IF nFont > Len( ::aFont )
      nFont := 0
   ELSE
      nFont := ::aFont[ nFont ]
   ENDIF

   RETURN nFont

METHOD StartLine( nHeight, lSeparator ) CLASS TSalXLS

   STATIC lRunning := .F.

   DEFAULT nHeight    := ::oRpt:nStdLineHeight ,;
           lSeparator := .F.

   IF nHeight == 0
      RETURN NIL
   ENDIF

/*   IF ( nHeight+::nRow ) >= ::nBottomRow
      ::EndPage()
      lSeparator := .F.
   ENDIF
*/
   IF lSeparator
//      ::Separator()
   ENDIF

//   ::Shadow(nHeight)
//   ::Grid(nHeight)

   IF ::oRpt:bStartLine != nil .AND. !lRunning
      lRunning := .T.
      Eval( ::oRpt:bStartLine, ::oRpt )
      lRunning := .F.
   ENDIF

RETURN nil


METHOD EndLine( nHeight ) CLASS TSalXLS

   STATIC lRunning := .F.

   DEFAULT nHeight := ::oRpt:nStdLineHeight

   IF ::oRpt:bEndLine != nil .AND. !lRunning
      lRunning := .T.
      Eval( ::oRpt:bEndLine, ::oRpt )
      lRunning := .F.
   ENDIF

   ++::nRow

//   ::nRow      += nHeight
//   ::lFirstRow := .F.

//   IF ::NeedNewPage()
//      ::EndPage()
//   ENDIF

RETURN nil


METHOD StartPage() CLASS TSalXLS

   STATIC lRunning := .F.

   IF ::oRpt:bStartPage != nil .AND. !lRunning
       lRunning := .T.
       Eval( ::oRpt:bStartPage, ::oRpt )
       lRunning := .F.
   ENDIF

   ::SayHeader()
   ::SayTitle()
   ::ColTitle()

   ::oRpt:lFirstRow := .T.

   RETURN NIL

METHOD EndPage()  CLASS TSalXLS

   STATIC lRunning := .F.

   IF ::oRpt:bEndPage != nil .AND. !lRunning
       lRunning := .T.
       Eval( ::oRpt:bEndPage, ::oRpt )
       lRunning := .F.
   ENDIF

   ::PageTotal()
//   ::oFooter:Say()

   IF ::oRpt:bPostPage != nil .AND. !lRunning
       lRunning := .T.
       Eval( ::oRpt:bPostPage, ::oRpt )
       lRunning := .F.
   ENDIF

   IF  ::oRpt:lFinish .AND. ::oRpt:bPostEnd != nil .AND. !lRunning
       lRunning := .T.
       Eval( ::oRpt:bPostEnd, ::oRpt )
       lRunning := .F.
   ENDIF

   ++::nRow
   XLS PAGE BREAK AT ::nRow OF ::oXLS
   --::nRow

   IF !(::oRpt:lFinish)
       ::StartPage()
   ENDIF

   RETURN NIL


METHOD PageTotal() CLASS TSalXLS

   LOCAL nFor, ;
         nColumns := len( ::oRpt:aColumns ), ;
         nBorder  := BORDER_TOP, ;
         uVal, ;
         nFont := 0, ;
         nAlignamen := 0, ;
         nFormat    := 0, ;
         oCol

   IF !( ::oRpt:lTotal) .or. (!::oRpt:lPageTotal .and. !::oRpt:lFinish)
      IF ::oRpt:lSeparator .OR. ::oRpt:lJoin
         FOR nFor := 1 TO nColumns
             @ ::nRow, nFor XLS SAY NIL OF ::oXLS ;
                            BORDER nBorder
         NEXT
      ENDIF
      RETURN NIL
   ENDIF

   IF ::oRpt:lBoxOnTotal
      nBorder := BORDER_ALL
   ENDIF

   nFont:= ::cFont( EVAL( ::oRpt:bStdFont ) )

   FOR nFor := 1 TO nColumns

       oCol:= ::oRpt:aColumns[ nFor ]

       IF oCol:lTotal
          nFont := ::cFont( eval( oCol:bTotalFont ) )

          DO CASE
             CASE oCol:nPad == RPT_LEFT
                  nAlignament := ALING_LEFT

             CASE oCol:nPad == RPT_RIGHT
                  nAlignament := ALING_RIGHT

             CASE oCol:nPad == RPT_CENTER
                  nAlignament := ALING_CENTER
          ENDCASE

          uVal := oCol:nTotal

          nFormat := ::cFormat( oCol:cTotalPict, 'N' )

          @ ::nRow, nFor XLS SAY uVal OF ::oXLS ;
                             FORMAT nFormat ;
                             FONT nFont     ;
                             ALIGNAMENT nAlignament ;
                             BORDER nBorder
      ELSE  // solo lineas
          @ ::nRow, nFor XLS SAY NIL OF ::oXLS ;
                             BORDER nBorder
      ENDIF
   NEXT

   IF ::oRpt:lFinish
      IF !empty( ::oRpt:cGrandTotal )
          @ ::nRow, 1 XLS SAY ::oRpt:cGrandTotal     ;
                            FONT nFont OF ::oXLS  ;
                            ALIGNAMENT ALING_LEFT ;
                            BORDER nBorder

      ENDIF
   ELSE
      IF !empty( ::oRpt:cPageTotal)
          @ ::nRow, 1 XLS SAY ::oRpt:cPageTotal      ;
                            FONT nFont OF ::oXLS  ;
                            ALIGNAMENT ALING_LEFT ;
                            BORDER nBorder
      ENDIF
   ENDIF


   RETURN NIL


METHOD Say( nCol, xText, nFont, nPad, nRow, cPicture )   CLASS TSalXLS

   LOCAL uVal, ;
         nAlignamen := 0, ;
         nFormat    := 0

   DEFAULT xText := '', ;
           nFont := 1, ;
           nPad  := RPT_LEFT


   nFont:= ::cFont( nFont )

   DO CASE
      CASE nPad == RPT_LEFT
           nAlignament := ALING_LEFT

      CASE nPad == RPT_RIGHT
           nAlignament := ALING_RIGHT

      CASE nPad == RPT_CENTER
           nAlignament := ALING_CENTER
   ENDCASE

   IF !empty( cPicture )
      nFormat := ::cFormat( cPicture, valtype( xText ) )
   ENDIF

   @ ::nRow, nCol XLS SAY xText OF ::oXLS ;
                                FONT nFont     ;
                                FORMAT nFormat ;
                                ALIGNAMENT nAlignament

   Return Nil


METHOD Stabilize() CLASS TSalXLS

   LOCAL nColumns := len( ::oRpt:aColumns ), ;
         nFor1, ;
         nFor2

   ::oRpt:nMaxTitle := 0
   ::oRpt:nMaxData  := 0

   AEval( ::oRpt:aColumns, {|Val| ::oRpt:nMaxTitle := Max( len( Val:aTitle), ::oRpt:nMaxTitle) } )
   AEval( ::oRpt:aColumns, {|Val| ::oRpt:nMaxData  := Max( len( Val:aData), ::oRpt:nMaxData) } )

   ::oRpt:aText := Array(nColumns, ::oRpt:nMaxTitle )

   FOR nFor1 := 1 TO nColumns
      FOR nFor2 := 1 TO ::oRpt:nMaxTitle
         IF len( ::oRpt:aColumns[nFor1]:aTitle) < nFor2
               ::oRpt:aText[nFor1][nFor2] := {|| "" }
         ELSE
               ::oRpt:aText[nFor1][nFor2] := ::oRpt:aColumns[nFor1]:aTitle[nFor2]
         ENDIF
      NEXT
   NEXT

   ::oRpt:aData    := Array( nColumns,::oRpt:nMaxData )

   FOR nFor1 := 1 TO nColumns
      FOR nFor2 := 1 TO ::oRpt:nMaxData
         IF len( ::oRpt:aColumns[nFor1]:aData) < nFor2
               ::oRpt:aData[nFor1][nFor2] := {|| "" }
         ELSE
               ::oRpt:aData[nFor1][nFor2] := ::oRpt:aColumns[nFor1]:aData[nFor2]
         ENDIF
      NEXT
   NEXT

   ::oRpt:lGroup := ( len( ::oRpt:aGroups ) > 0 )

   FOR nFor1:= 1 TO len( ::oRpt:aGroups )
       ::oRpt:aGroups[ nFor1 ]:aTotal    := Afill( Array( len( ::oRpt:aColumns ) ), 0 )
       ::oRpt:aGroups[ nFor1 ]:cOldValue := cValToChar( Eval( ::oRpt:aGroups[ nFor1 ]:bGroup ) )
       ::oRpt:aGroups[ nFor1 ]:cValue    := ::oRpt:aGroups[ nFor1 ]:cOldValue
   NEXT

   ::oRpt:lTotal := .F.
   aeval( ::oRpt:aColumns,{ |Val| if( Val:lTotal, ::oRpt:lTotal := .T., NIL ) } )

   ::oRpt:lStable := .T.
   ::oRpt:lFinish := .F.

   RETURN Nil


STATIC FUNCTION ChangePicture( cPicture, cType )
   Local nPunto
   Local cDec

   DO CASE
      CASE cType == 'C'
           cPicture := 'General'
      CASE cType == 'N'
           nPunto:= AT( ".", cPicture )
           If nPunto > 0
              cDec:= AllTrim( SUBSTR( cPicture, nPunto + 1 ) )
              cDec := Replicate( '0', Len( cDec ) )
              cPicture := '#,##0.' + cDec
           Else
              cPicture:= '#.##0'
           EndIf

      CASE cType == 'D'
           cPicture:= 'dd/mm/yyyy'
      OTHERWISE
           cPicture := 'General'
   ENDCASE

   RETURN cPicture
