// FileXLS Library by Ramón Avendaño
// 30-12-99

//#include "FiveWin.ch"
//#include "Constant.ch"

#include "hbclass.ch"

#include "XLSError.ch"
#include "FileIO.ch"
#include "FileXLS.ch"

//#define _MSLINK_

static nInfo, cInfo := "FileXLS Library Ramón Avendaño (c) 1999"

// Cell alignament
#define ALIGN_NULL       0
#define ALIGN_LEFT       1
#define ALIGN_CENTER     2
#define ALIGN_RIGHT      3
#define ALIGN_FILL       4

// Cell border
#define BORDER_NONE      0
#define BORDER_LEFT      8
#define BORDER_RIGHT    16
#define BORDER_TOP      32
#define BORDER_BOTTOM   64
#define BORDER_ALL     120  // nOR( BORDER_LEFT, BORDER_RIGHT, BORDER_TOP, BORDER_BOTTOM )

// XLS font def
#define XLSFONT_HEIGHT     1
#define XLSFONT_BOLD       2
#define XLSFONT_ITALIC     3
#define XLSFONT_UNDERLINE  4
#define XLSFONT_STRIKEOUT  5
#define XLSFONT_NAME       6

// XLS error code
#define XLSERROR_NULL      0
#define XLSERROR_DIV0      7
#define XLSERROR_VALUE    15
#define XLSERROR_REF      23
#define XLSERROR_NAME     29
#define XLSERROR_NUM      36
#define XLSERROR_N_A      42

EXTERNAL _XLSGenError

#ifdef _MSLINK_
EXTERNAL xlsCELL, xlsSUM, xlsMULT
EXTERNAL xlsABS, xlsINTE, xlsMOD, xlsROUND, xlsSIGN, xlsSQRT, xlsEXP, xlsLN, xlsLOG, ;
         xlsPI, xlsRANDOM, xlsSIN, xlsCOS, xlsTAN, xlsASIN, xlsACOS, xlsATAN
#else
EXTERNAL _CELL, _SUM, _MULT
EXTERNAL _ABS, _INTE, _MOD, _ROUND, _SIGN, _SQRT, _EXP, _LN, _LOG, ;
         _PI, _RANDOM, _SIN, _COS, _TAN, _ASIN, _ACOS, _ATAN
#endif

static aFonts := {}, aFormats := {}

static aOperators := { "", "", "+", "-", "*", "/", "^" }

//----------------------------------------------------------------------------//

CLASS TFileXLS

   DATA   cName
   DATA   hFile

   DATA   oWnd

   DATA   lProtect
   DATA   lAutoexec

   DATA   aHBreaks, aVBreaks

   METHOD New( cFileName, lAutomatic, nIterations,;
               lProtect, lAutoexec, oWnd ) CONSTRUCTOR

   METHOD End()

   //

   METHOD SetDisplay( nTop, nLeft, nBottom, nRight, lHidden, ;
                      lFormulas, lGridLines, lHeaders, lNoZero )

   METHOD SetPrinter( cHeader, cFooter, nLeft, nRight, nTop, nBottom, ;
                      lHeaders, lGredlines )

   //

   METHOD _Row( nRow, nHeight )
   METHOD _Col( nFirstCol, nLastCol, nWidth )

   //

   METHOD Blank( nRow, nCol, ;
                 lHidden, lLocked, nFont, nFormat, lShaded, ;
                 nBorder, nAlignament )

   METHOD Number( nRow, nCol, nNumber, ;
                  lHidden, lLocked, nFont, nFormat, lShaded, ;
                  nBorder, nAlignament )

   METHOD String( nRow, nCol, cString, ;
                  lHidden, lLocked, nFont, nFormat, lShaded, ;
                  nBorder, nAlignament )

   METHOD _Date( nRow, nCol, dDate, ;
                 lHidden, lLocked, nFont, nFormat, lShaded, ;
                 nBorder, nAlignament )

   METHOD Boolean( nRow, nCol, lBoolean, ;
                   lHidden, lLocked, nFont, nFormat, lShaded, ;
                   nBorder, nAlignament )

   METHOD Formula( nRow, nCol, nNumber, lRecalc, cFormula, ;
                   lHidden, lLocked, nFont, nFormat, lShaded, ;
                   nBorder, nAlignament )

   METHOD Say( nRow, nCol, uVal, ;
               lHidden, lLocked, nFont, nFormat, lShaded, ;
               nBorder, nAlignament )

   METHOD Error( nRow, nCol, nError, ;
                 lHidden, lLocked, nFont, nFormat, lShaded, ;
                 nBorder, nAlignament )

   //

   METHOD Note( nRow, nCol, cNote )

   METHOD AddBreak( cCourse, aPos )

   //

   METHOD PutCoors( nRow, nCol )

   METHOD PutAttributes( lHidden, lLocked, nFont, nFormat, lShaded, ;
                         nBorder, nAlignament, nReserved )
   //

   METHOD Info() INLINE Alert( cInfo )

   METHOD Protec() INLINE nInfo := 0, ;
                          AEval( Array( len( cInfo ) ), ;
                          {| a, n | nInfo += Asc( SubStr( cInfo, n, 1 ) ) + n } ), ;
                          nInfo

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cFileName, lAutomatic, nIterations,;
            lProtect, lAutoexec, oWnd ) CLASS TFileXLS

   local n, nByte
   local nLen

   //if ::Protec() != 4311
   //   MsgStop( "FileXLS Library" + CRLF + "Copyright violation !" )
   //   quit
   //endif

   if cFileName == NIL
        cFileName := cTempFile() + ".xls"
   endif

   ::cName = cFileName
   ::hFile = FCreate( cFileName, FC_NORMAL )

   ::lProtect  = lProtect
   ::lAutoexec = lAutoexec

   ::oWnd      = oWnd

   ::aHBreaks := {}
   ::aVBreaks := {}

   DEFAULT lAutomatic := .t.

   DEFAULT nIterations := 0

   FWrite( ::hFile, Chr( 09 ) + Chr( 00 ), 2 )      // BOF
   FWrite( ::hFile, Chr( 04 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, Chr( 05 ) + Chr( 00 ) + Chr( 16 ) + Chr( 00 ), 4 )

   FWrite( ::hFile, Chr( 13 ) + Chr( 00 ), 2 )      // CALCMODE
   FWrite( ::hFile, Chr( 02 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, Chr( if( lAutomatic, 1, 0 ) ) + Chr( 00 ), 2 )

   FWrite( ::hFile, Chr( 12 ) + Chr( 00 ), 2 )      // CALCCOUNT
   FWrite( ::hFile, Chr( 02 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, I2Bin( if( nIterations != 0, nIterations, 1 ) ), 2 )

   FWrite( ::hFile, Chr( 15 ) + Chr( 00 ), 2 )      // REFMODE
   FWrite( ::hFile, Chr( 02 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, Chr( 01 ) + Chr( 00 ), 2 )

   FWrite( ::hFile, Chr( 17 ) + Chr( 00 ), 2 )      // ITERATION
   FWrite( ::hFile, Chr( 02 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, Chr( if( nIterations != 0, 1, 0 ) ) + Chr( 00 ), 2 )

   FWrite( ::hFile, Chr( 16 ) + Chr( 00 ), 2 )      // DELTA
   FWrite( ::hFile, Chr( 08 ) + Chr( 00 ), 2 )      // 0.001
   FWrite( ::hFile, D2Bin( 0.001 ), 8 )
   FWrite( ::hFile, Chr( 14 ) + Chr( 00 ), 2 )      // PRECISION
   FWrite( ::hFile, Chr( 02 ) + Chr( 00 ), 2 )      // full
   FWrite( ::hFile, Chr( 01 ) + Chr( 00 ), 2 )

   FWrite( ::hFile, Chr( 34 ) + Chr( 00 ), 2 )      // 1904
   FWrite( ::hFile, Chr( 02 ) + Chr( 00 ), 2 )      // anything
   FWrite( ::hFile, Chr( 00 ) + Chr( 00 ), 2 )

   FWrite( ::hFile, Chr( 37 ) + Chr( 00 ), 2 )      // DEFAULT ROW HEIGHT
   FWrite( ::hFile, Chr( 02 ) + Chr( 00 ), 2 )      // 33023
   FWrite( ::hFile, I2Bin( 33023 ), 2 )

   FWrite( ::hFile, Chr( 49 ) + Chr( 00 ), 2 )                    // FONT 0
   FWrite( ::hFile, Chr( 10 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, Chr( 200 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, Chr( 00 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, Chr( 05 ), 1 )
   FWrite( ::hFile, "Arial", 5 )

   For n := 1 to 3
       if n > len( aFonts )
          FWrite( ::hFile, Chr( 49 ) + Chr( 00 ), 2 )             // FONT
          FWrite( ::hFile, Chr( 10 ) + Chr( 00 ), 2 )
          FWrite( ::hFile, Chr( 200 ) + Chr( 00 ), 2 )
          FWrite( ::hFile, Chr( 00 ) + Chr( 00 ), 2 )
          FWrite( ::hFile, Chr( 05 ), 1 )
          FWrite( ::hFile, "Arial", 5 )
       else
          nByte := 0; nLen := len( aFonts[ n, XLSFONT_NAME ] )    // FONT n
          FWrite( ::hFile, Chr( 49 ) + Chr( 00 ), 2 )
          FWrite( ::hFile, I2Bin( 05 + nLen ), 2 )
          FWrite( ::hFile, I2Bin( aFonts[ n, XLSFONT_HEIGHT ] ), 2 )
          nByte := nOR( nByte, if( aFonts[ n, XLSFONT_BOLD ], 1, 0 ) )
          nByte := nOR( nByte, if( aFonts[ n, XLSFONT_ITALIC ], 2, 0 ) )
          nByte := nOR( nByte, if( aFonts[ n, XLSFONT_UNDERLINE ], 4, 0 ) )
          nByte := nOR( nByte, if( aFonts[ n, XLSFONT_STRIKEOUT ], 8, 0 ) )
          FWrite( ::hFile, Chr( nByte ), 1 )
          FWrite( ::hFile, Chr( 00 ), 1 )
          FWrite( ::hFile, Chr( nLen ), 1 )
          FWrite( ::hFile, aFonts[ n, XLSFONT_NAME ], nLen )
         endif
   next

   FWrite( ::hFile, Chr( 64 ) + Chr( 00 ), 2 )      // BACKUP
   FWrite( ::hFile, Chr( 02 ) + Chr( 00 ), 2 )      // not back up
   FWrite( ::hFile, Chr( 00 ) + Chr( 00 ), 2 )

   FWrite( ::hFile, Chr( 31 ) + Chr( 00 ), 2 )      // FORMATCOUNT
   FWrite( ::hFile, Chr( 02 ) + Chr( 00 ), 2 )      // 1
   FWrite( ::hFile, Chr( 01 ) + Chr( 00 ), 2 )

   FWrite( ::hFile, Chr( 30 ) + Chr( 00 ), 2 )      // FORMAT 0
   FWrite( ::hFile, Chr( 08 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, Chr( 07 ), 1 )
   FWrite( ::hFile, "General", 7 )

   For n := 1 to len( aFormats )
       nLen := len( aFormats[ n ] )
       FWrite( ::hFile, Chr( 30 ) + Chr( 00 ), 2 )  // FORMAT n
       FWrite( ::hFile, I2Bin( nLen + 1 ), 2 )
       FWrite( ::hFile, Chr( nLen ), 1 )
       FWrite( ::hFile, aFormats[ n ], nLen )
   next

return Self

//----------------------------------------------------------------------------//

METHOD End() CLASS TFileXLS

   local n
   local nLen

   local nReturn := 0

   nLen := Len( ::aHBreaks )                        // HORIZONTAL BREAK
   FWrite( ::hFile, Chr( 27 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, I2Bin( 02 + nLen * 2 ), 2 )
   FWrite( ::hFile, I2Bin( nLen ), 2 )
   for n := 1 to nLen
      FWrite( ::hFile, I2Bin( ::aHBreaks[ n ] - 1 ), 2 )
   next

   nLen := Len( ::aVBreaks )                        // VERTICAL BREAK
   FWrite( ::hFile, Chr( 26 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, I2Bin( 02 + nLen * 2 ), 2 )
   FWrite( ::hFile, I2Bin( nLen ), 2 )
   for n := 1 to nLen
      FWrite( ::hFile, I2Bin( ::aVBreaks[ n ] - 1 ), 2 )
   next

   FWrite( ::hFile, Chr( 18 ) + Chr( 00 ), 2 )      // PROTECT
   FWrite( ::hFile, Chr( 02 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, Chr( if( ::lProtect, 1, 0 ) ) + Chr( 00 ), 2 )

   FWrite( ::hFile, Chr( 10 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, Chr( 00 ) + Chr( 00 ), 2 )

   FClose( ::hFile )
   ::hFile := 0

   if ::lAutoexec
      //nReturn := ShellExecute( if( ::oWnd != nil, ::oWnd:hWnd, GetActiveWindow() ), 'Open', ::cName,,, 2 )
  
      Alert("todo run " + ::cName)
   endif

return nReturn

//----------------------------------------------------------------------------//
// Support functions for TFileXLS class

FUNCTION XLSFont( cName, nHeight, ;
                  lBold, lItalic, lUnderline, lStrikeout )
  local nFont

  DEFAULT cName := "Arial"
  DEFAULT nHeight := 10
  DEFAULT lBold := .f.
  DEFAULT lItalic := .f.
  DEFAULT lUnderline := .f.
  DEFAULT lStrikeout := .f.

  nFont := AScan( aFonts, {|a| a[1] == nHeight * 20 .and. ;
                               a[2] == lBold .and. ;
                               a[3] == lItalic .and. ;
                               a[4] == lUnderline .and. ;
                               a[5] == lStrikeout .and. ;
                               a[6] == cName } )

  if nFont == 0
     AAdd( aFonts, { nHeight * 20, lBold, lItalic, lUnderline, lStrikeout, cName } )
     nFont := Len( aFonts )
  endif

return nFont

//

FUNCTION XLSFormat( cPicture )

  local nFormat

  DEFAULT cPicture := "0"

  nFormat := AScan( aFormats, cPicture )

  if nFormat == 0
     AAdd( aFormats, cPicture )
     nFormat := Len( aFormats )
  endif

return nFormat

//

FUNCTION XLSClsFont()
return( aFonts := {} )

//

FUNCTION XLSClsFormat()
return( aFormats := {} )

//----------------------------------------------------------------------------//

METHOD SetDisplay( nTop, nLeft, nBottom, nRight, lHidden, ;
                   lFormulas, lGridLines, lHeaders, lNoZero )

  DEFAULT nTop := 0
  DEFAULT nLeft := 0
  DEFAULT nBottom := 200
  DEFAULT nRight := 300

  FWrite( ::hFile, Chr( 61 ) + Chr( 00 ), 2 )       // WINDOWS1
  FWrite( ::hFile, Chr( 09 ) + Chr( 00 ), 2 )

  FWrite( ::hFile, I2Bin( nLeft * 20 ), 2 )
  FWrite( ::hFile, I2Bin( nTop * 20 ), 2 )
  FWrite( ::hFile, I2Bin( ( nRight - nLeft + 1 ) * 20 ), 2 )
  FWrite( ::hFile, I2Bin( ( nBottom - nTop + 1 ) * 20 ), 2 )
  FWrite( ::hFile, Chr( if( lHidden, 1, 0 ) ), 1 )

  FWrite( ::hFile, Chr( 62 ) + Chr( 00 ), 2 )       // WINDOWS2
  FWrite( ::hFile, Chr( 14 ) + Chr( 00 ), 2 )

  FWrite( ::hFile, Chr( if( lFormulas, 1, 0 ) ), 1 )
  FWrite( ::hFile, Chr( if( lGridLines, 1, 0 ) ), 1 )
  FWrite( ::hFile, Chr( if( lHeaders, 1, 0 ) ), 1 )
  FWrite( ::hFile, Chr( 00 ), 1 )
  FWrite( ::hFile, Chr( if( lNoZero, 0, 1 ) ), 1 )

  FWrite( ::hFile, I2Bin( 00 ), 2 )
  FWrite( ::hFile, I2Bin( 00 ), 2 )
  FWrite( ::hFile, Chr( 01 ), 1 )
  FWrite( ::hFile, L2Bin( 00 ), 4 )

return nil

//----------------------------------------------------------------------------//

METHOD SetPrinter( cHeader, cFooter, nLeft, nRight, nTop, nBottom, ;
                   lHeaders, lGredlines ) CLASS TFileXLS

   local nLen

   DEFAULT cHeader := ""
   DEFAULT cFooter := ""
   DEFAULT nLeft := 0
   DEFAULT nRight := 0
   DEFAULT nTop := 0
   DEFAULT nBottom := 0
   DEFAULT lHeaders := .f.
   DEFAULT lGredlines := .f.

   nLen := Len( cHeader )                           // HEADER
   FWrite( ::hFile, Chr( 20 ) + Chr( 00 ), 2 )
   if nLen == 0
      FWrite( ::hFile, Chr( 00 ) + Chr( 00 ), 2 )
   else
      FWrite( ::hFile, I2Bin( 01 + nLen ), 2 )
      FWrite( ::hFile, Chr( nLen ), 1 )
      FWrite( ::hFile, cHeader, nLen )
   endif

   nLen := Len( cFooter )                           // FOOTER
   FWrite( ::hFile, Chr( 21 ) + Chr( 00 ), 2 )
   if nLen == 0
      FWrite( ::hFile, Chr( 00 ) + Chr( 00 ), 2 )
   else
      FWrite( ::hFile, I2Bin( 01 + nLen ), 2 )
      FWrite( ::hFile, Chr( nLen ), 1 )
      FWrite( ::hFile, cFooter, nLen )
   endif

   FWrite( ::hFile, Chr( 38 ) + Chr( 00 ), 2 )      // LEFT MARGIN
   FWrite( ::hFile, Chr( 08 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, D2Bin( nLeft ), 8 )

   FWrite( ::hFile, Chr( 39 ) + Chr( 00 ), 2 )      // RIGHT MARGIN
   FWrite( ::hFile, Chr( 08 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, D2Bin( nRight ), 8 )

   FWrite( ::hFile, Chr( 40 ) + Chr( 00 ), 2 )      // TOP MARGIN
   FWrite( ::hFile, Chr( 08 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, D2Bin( nTop ), 8 )

   FWrite( ::hFile, Chr( 41 ) + Chr( 00 ), 2 )      // BOTTOM MARGIN
   FWrite( ::hFile, Chr( 08 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, D2Bin( nBottom ), 8 )

   FWrite( ::hFile, Chr( 42 ) + Chr( 00 ), 2 )      // PRINT HEADERS
   FWrite( ::hFile, Chr( 02 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, Chr( if( lHeaders, 1, 0 ) ) + Chr( 00 ), 2 )

   FWrite( ::hFile, Chr( 43 ) + Chr( 00 ), 2 )      // PRINT GRIDLINES
   FWrite( ::hFile, Chr( 02 ) + Chr( 00 ), 2 )
   FWrite( ::hFile, Chr( if( lGredlines, 1, 0 ) ) + Chr( 00 ), 2 )

return nil

//----------------------------------------------------------------------------//

METHOD _Row( nRow, nHeight ) CLASS TFileXLS

  DEFAULT nHeight := 12.75

  FWrite( ::hFile, Chr( 08 ) + Chr( 00 ), 2 )
  FWrite( ::hFile, Chr( 16 ) + Chr( 00 ), 2 )

  FWrite( ::hFile, I2Bin( nRow - 1 ), 2 )

  FWrite( ::hFile, I2Bin( 00 ), 2 )
  FWrite( ::hFile, I2Bin( 00 ), 2 )

  FWrite( ::hFile, I2Bin( nHeight * 20 ), 2 )

  FWrite( ::hFile, Chr( 00 ) + Chr( 00 ), 2 )

  FWrite( ::hFile, Chr( 00 ), 1 )

  FWrite( ::hFile, Chr( 00 ) + Chr( 00 ), 2 )

  FWrite( ::hFile, Chr( 00 ) + Chr( 00 ) + Chr( 00 ), 3 )

return nil

//----------------------------------------------------------------------------//

METHOD _Col( nFirstCol, nLastCol, nWidth, lHide )

  DEFAULT lHide := .f.
  DEFAULT nWidth := 10.71
  DEFAULT nLastCol := nFirstCol

  FWrite( ::hFile, Chr( 36 ) + Chr( 00 ), 2 )
  FWrite( ::hFile, Chr( 04 ) + Chr( 00 ), 2 )

  FWrite( ::hFile, Chr( nFirstCol - 1 ), 1 )
  FWrite( ::hFile, Chr( nLastCol - 1 ), 1 )

  if lHide
     FWrite( ::hFile, I2Bin( 0 ), 2 )
  else
     FWrite( ::hFile, I2Bin( Round( ( nWidth + 0.72 ) * 256, 0) ), 2 )
  endif

return nil

//----------------------------------------------------------------------------//

METHOD Blank( nRow, nCol, ;
              lHidden, lLocked, nFont, nFormat, lShaded, ;
              nBorder, nAlignament ) CLASS TFileXLS

  DEFAULT lHidden := .f.
  DEFAULT lLocked := .f.
  DEFAULT nFont := 0
  DEFAULT nFormat := 0
  DEFAULT lShaded := .f.
  DEFAULT nBorder := BORDER_NONE
  DEFAULT nAlignament := ALIGN_NULL

  FWrite( ::hFile, Chr( 01 ) + Chr( 00 ), 2 )
  FWrite( ::hFile, Chr( 07 ) + Chr( 00 ), 2 )

  ::PutCoors( nRow, nCol )
  ::PutAttributes( lHidden, lLocked, nFont, nFormat, lShaded, ;
                   nBorder, nAlignament )

return nil

//----------------------------------------------------------------------------//

METHOD Number( nRow, nCol, nNumber, ;
               lHidden, lLocked, nFont, nFormat, lShaded, ;
               nBorder, nAlignament ) CLASS TFileXLS

  local lInteger := lInteger( nNumber )

  DEFAULT lHidden := .f.
  DEFAULT lLocked := .f.
  DEFAULT nFont := 0
  DEFAULT nFormat := 0
  DEFAULT lShaded := .f.
  DEFAULT nBorder := BORDER_NONE
  DEFAULT nAlignament := ALIGN_NULL

  if lInteger
     FWrite( ::hFile, Chr( 02 ) + Chr( 00 ), 2 )
     FWrite( ::hFile, Chr( 09 ) + Chr( 00 ), 2 )
  else
     FWrite( ::hFile, Chr( 03 ) + Chr( 00 ), 2 )
     FWrite( ::hFile, Chr( 15 ) + Chr( 00 ), 2 )
  endif

  ::PutCoors( nRow, nCol )
  ::PutAttributes( lHidden, lLocked, nFont, nFormat, lShaded, ;
                   nBorder, nAlignament )

  if lInteger
     FWrite( ::hFile, I2Bin( nNumber ), 2 )
  else
     FWrite( ::hFile, D2Bin( nNumber ), 8 )
  endif

return nil

//----------------------------------------------------------------------------//

METHOD String( nRow, nCol, cString, ;
               lHidden, lLocked, nFont, nFormat, lShaded, ;
               nBorder, nAlignament ) CLASS TFileXLS

  local nLen := Len( cString )

  DEFAULT lHidden := .f.
  DEFAULT lLocked := .f.
  DEFAULT nFont := 0
  DEFAULT nFormat := 0
  DEFAULT lShaded := .f.
  DEFAULT nBorder := BORDER_NONE
  DEFAULT nAlignament := ALIGN_NULL

  FWrite( ::hFile, Chr( 04 ) + Chr( 00 ), 2 )
  FWrite( ::hFile, I2Bin( 08 + nLen ), 2 )

  ::PutCoors( nRow, nCol )
  ::PutAttributes( lHidden, lLocked, nFont, nFormat, lShaded, ;
                   nBorder, nAlignament )

  FWrite( ::hFile, Chr( nLen ), 1 )
  FWrite( ::hFile, cString, nLen )

return nil

//----------------------------------------------------------------------------//

METHOD _Date( nRow, nCol, dDate, ;
              lHidden, lLocked, nFont, nFormat, lShaded, ;
              nBorder, nAlignament ) CLASS TFileXLS

  local nDate

  DEFAULT lHidden := .f.
  DEFAULT lLocked := .f.
  DEFAULT nFont := 0
  DEFAULT nFormat := 0
  DEFAULT lShaded := .f.
  DEFAULT nBorder := BORDER_NONE
  DEFAULT nAlignament := ALIGN_NULL

  FWrite( ::hFile, Chr( 02 ) + Chr( 00 ), 2 )
  FWrite( ::hFile, Chr( 09 ) + Chr( 00 ), 2 )

  ::PutCoors( nRow, nCol )
  ::PutAttributes( lHidden, lLocked, nFont, nFormat, lShaded, ;
                   nBorder, nAlignament, 0 )

  nDate := dDate - CToD( "01/01/1900" ) + 2

  FWrite( ::hFile, I2Bin( nDate ), 2 )

return nil

//----------------------------------------------------------------------------//

METHOD Boolean( nRow, nCol, lBoolean, ;
                lHidden, lLocked, nFont, nFormat, lShaded, ;
                nBorder, nAlignament ) CLASS TFileXLS

  DEFAULT lHidden := .f.
  DEFAULT lLocked := .f.
  DEFAULT nFont := 0
  DEFAULT nFormat := 0
  DEFAULT lShaded := .f.
  DEFAULT nBorder := BORDER_NONE
  DEFAULT nAlignament := ALIGN_NULL

  FWrite( ::hFile, Chr( 05 ) + Chr( 00 ), 2 )
  FWrite( ::hFile, Chr( 09 ) + Chr( 00 ), 2 )

  ::PutCoors( nRow, nCol )
  ::PutAttributes( lHidden, lLocked, nFont, nFormat, lShaded, ;
                   nBorder, nAlignament )

  FWrite( ::hFile, Chr( if( lBoolean, 1, 0 ) ), 1 )
  FWrite( ::hFile, Chr( 00 ), 1 )

return nil

//----------------------------------------------------------------------------//

METHOD Formula( nRow, nCol, nNumber, lRecalc, cFormula, ;
                lHidden, lLocked, nFont, nFormat, lShaded, ;
                nBorder, nAlignament ) CLASS TFileXLS

  local cExpression := GetExpression( cFormula )
  local nLen := Len( cExpression )

  DEFAULT nNumber := 0
  DEFAULT lRecalc := .t.

  DEFAULT lHidden := .f.
  DEFAULT lLocked := .f.
  DEFAULT nFont := 0
  DEFAULT nFormat := 0
  DEFAULT lShaded := .f.
  DEFAULT nBorder := BORDER_NONE
  DEFAULT nAlignament := ALIGN_NULL

  FWrite( ::hFile, Chr( 06 ) + Chr( 00 ), 2 )
  FWrite( ::hFile, I2Bin( 17 + nLen ), 2 )

  ::PutCoors( nRow, nCol )
  ::PutAttributes( lHidden, lLocked, nFont, nFormat, lShaded, ;
                   nBorder, nAlignament )

  FWrite( ::hFile, D2Bin( nNumber ), 8 )

  FWrite( ::hFile, Chr( if( lRecalc, 2, 0 ) ), 1 )

  FWrite( ::hFile, Chr( nLen ), 1 )
  FWrite( ::hFile, cExpression, nLen )

return nil

//----------------------------------------------------------------------------//

METHOD Say( nRow, nCol, uVal, ;
            lHidden, lLocked, nFont, nFormat, lShaded, ;
            nBorder, nAlignament ) CLASS TFileXLS

  local cType := ValType( uVal )

  if cType == "B"
     uVal := Eval( uVal )
     cType := ValType( uVal )
  endif

  do case
     case cType == "N"
          ::Number( nRow, nCol, uVal, ;
                    lHidden, lLocked, nFont, nFormat, lShaded, ;
                    nBorder, nAlignament )

     case cType == "C" .or. cType == "M"
          ::String( nRow, nCol, uVal, ;
                    lHidden, lLocked, nFont, nFormat, lShaded, ;
                    nBorder, nAlignament )

     case cType == "D"
          ::_Date( nRow, nCol, uVal, ;
                   lHidden, lLocked, nFont, nFormat, lShaded, ;
                   nBorder, nAlignament )

     case cType == "L"
          ::Boolean( nRow, nCol, uVal, ;
                     lHidden, lLocked, nFont, nFormat, lShaded, ;
                     nBorder, nAlignament )

     case cType == "U"
          ::Blank( nRow, nCol, ;
                   lHidden, lLocked, nFont, nFormat, lShaded, ;
                   nBorder, nAlignament )

     otherwise
          Eval( ErrorBlock(), _XLSGenError( DATATYPE_NOSUPPORT, ;
                                    CHR(13)+CHR(10) + "Type: " + cType ) )

  endcase

return nil

//----------------------------------------------------------------------------//

METHOD Error( nRow, nCol, nError, ;
              lHidden, lLocked, nFont, nFormat, lShaded, ;
              nBorder, nAlignament ) CLASS TFileXLS

  DEFAULT lHidden := .f.
  DEFAULT lLocked := .f.
  DEFAULT nFont := 0
  DEFAULT nFormat := 0
  DEFAULT lShaded := .f.
  DEFAULT nBorder := BORDER_NONE
  DEFAULT nAlignament := ALIGN_NULL

  FWrite( ::hFile, Chr( 05 ) + Chr( 00 ), 2 )
  FWrite( ::hFile, Chr( 09 ) + Chr( 00 ), 2 )

  ::PutCoors( nRow, nCol )
  ::PutAttributes( lHidden, lLocked, nFont, nFormat, lShaded, ;
                   nBorder, nAlignament )

  FWrite( ::hFile, Chr( nError ), 1 )
  FWrite( ::hFile, Chr( 01 ), 1 )

return nil

//----------------------------------------------------------------------------//

METHOD Note( nRow, nCol, cNote ) CLASS TFileXLS

  local nLen := Len( cNote )

  FWrite( ::hFile, Chr( 28 ) + Chr( 00 ), 2 )
  FWrite( ::hFile, I2Bin( 06 + nLen ), 2 )

  ::PutCoors( nRow, nCol )

  FWrite( ::hFile, I2Bin( nLen ), 2 )
  FWrite( ::hFile, cNote, nLen )

return nil

//----------------------------------------------------------------------------//

METHOD AddBreak( cCourse, aBreaks ) CLASS TFileXLS

  DEFAULT cCourse := "HORIZONTAL"

  do case
     case cCourse == "HORIZONTAL"
          AEval( aBreaks, {|nBreak| if( AScan( ::aHBreaks, nBreak ) == 0, ;
                                        AAdd( ::aHBreaks, nBreak ), ) } )
          ASort( ::aHBreaks )

     case cCourse == "VERTICAL"
          AEval( aBreaks, {|nBreak| if( AScan( ::aVBreaks, nBreak ) == 0, ;
                                        AAdd( ::aVBreaks, nBreak ), ) } )
          ASort( ::aVBreaks )

  endcase

return nil

//----------------------------------------------------------------------------//

METHOD PutCoors( nRow, nCol ) CLASS TFileXLS

  local cWord

  cWord := I2Bin( nRow - 1 )

  ? Bin2I(cWord)
  FWrite( ::hFile, @cWord, 2 ) //  Byte Offset 0-1
  ? Bin2I(cWord)
  cWord := I2Bin( nCol - 1 )
  FWrite( ::hFile, @cWord, 2 ) //  Byte Offset 2-3

return nil

//----------------------------------------------------------------------------//

METHOD PutAttributes( lHidden, lLocked, nFont, nFormat, lShaded, ;
                      nBorder, nAlignament, nReserved ) CLASS TFileXLS

  local nByte, cByte

  DEFAULT nReserved := 0

  nByte := 0
  if lHidden
     nByte := 128
  endif
  if lLocked
     nByte := nOR( nByte, 64 )
  endif
  nByte := nOR( nByte, nReserved )

  cByte := Chr( nByte )
  FWrite( ::hFile, @cByte, 1 )  //  Byte Offset 0

  if nFont == 0
     nByte := 0
  elseif nFont == 1
     nByte := 64
  elseif nFont == 2
     nByte := 128
  else
     nByte := 192
  endif
  nByte := nOR( nByte, nFormat )

  cByte := Chr( nByte )
  FWrite( ::hFile, @cByte, 1 )  //  Byte Offset 1

  nByte := 0
  if lShaded
     nByte := 128
  endif
  nByte := nOR( nByte, nBorder )
  nByte := nOR( nByte, nAlignament )

  cByte := Chr( nByte )
  FWrite( ::hFile, @cByte, 1 )  //  Byte Offset 3

return nil


//  Static functions
//----------------------------------------------------------------------------//

static function GetExpression( cFormula )

  local n, nLen

  local cExpression := ""
  local cLabel:= "", cNumber := "", cFunction := ""

  local cOperator := "", nPart, cChar, cSign := ""

  local lOperator := .f., lFunction := .f., lParenthetically := .f.

  local aBuffer := {}

  cFormula := StrTran( cFormula, " ", "" )
  nLen := Len( cFormula )

  n := 1

  do while n <= nLen

     cChar := Upper( SubStr( cFormula, n, 1 ) )

     do case

        case cChar $ "0123456789."
             if empty( cLabel )
                cNumber += cChar
             else
                cLabel += cChar
             endif

        case Asc( cChar ) >= 65 .and. Asc( cChar ) <= 90 ;
             .or. cChar == "_"
             cLabel += cChar

        case cChar $ "+-*/^"
             if lParenthetically .or. ;
                !empty( cNumber ) .or. !empty( cLabel ) .or. !empty( cfunction )

                if empty( cOperator )
                elseif ( cChar$"*/^" .and. cOperator$"+-" ).or. ;
                       ( cChar$"^" .and. cOperator$"*/" )
                       AAdd( aBuffer, cOperator )
                       cOperator := ""
                       lParenthetically := .f.
                elseif ( cChar$"+-" .and. cOperator$"*/^" ).or. ;
                       ( cChar$"*/" .and. cOperator$"^" )
                       lOperator := .t.
                endif

                if !empty( cNumber )
                   cExpression += GetNumber( Val( cNumber ), cSign, cOperator )
                elseif !empty ( cLabel )
                   cExpression += GetNumber( &cLabel, cSign, cOperator )
                elseif !empty( cfunction )
                   cExpression += GetFunction( cFunction, cSign, cOperator )
                endif
                cNumber := cLabel := cFunction := ""

                if lParenthetically
                   if !empty( cOperator )
                      cExpression += Chr( AScan( aOperators, cOperator ) )
                   endif
                   lParenthetically := .f.
                endif

                if lOperator
                   do while len( aBuffer ) != 0 .and. Atail( aBuffer ) != "P"
                      if !empty( Atail( aBuffer ) )
                         cExpression += Chr( AScan( aOperators, Atail( aBuffer ) ) )
                      endif
                      ASize( aBuffer, len( aBuffer ) - 1 )
                   enddo
                   lOperator := .f.
                endif
                cOperator := cChar

                cSign := ""

             else

                cSign := cChar

             endif

        case cChar == "("
             if empty( cLabel )

                AAdd( aBuffer, cOperator )
                AAdd( aBuffer, "P" )
                cOperator := ""

             else

                #ifdef _MSLINK_
                lFunction := Upper( Left( clabel, 3 ) ) == "XLS"
                #else
                lFunction := Left( clabel, 1 ) == "_"
                #endif

                nPart := 1
                cLabel += "("
                do while nPart != 0
                   n++
                   cChar := SubStr( cFormula, n, 1 )
                   do case
                      case cChar == "("
                           nPart++
                      case cChar == ")"
                           nPart--
                      case lFunction .and. ;
                           cChar == "," .and. nPart = 1
                           cChar := ";"
                   endcase
                   cLabel += cChar
                enddo

                if lFunction
                   cFunction := cLabel
                   cLabel := ""
                else
                   cLabel := AllTrim( cValToChar( &cLabel ) )
                endif

             endif

        case cChar == ")"
             if !empty( cNumber )
                cExpression += GetNumber( Val( cNumber ), cSign, cOperator )
             elseif !empty ( cLabel )
                cExpression += GetNumber( &cLabel, cSign, cOperator )
             elseif !empty( cfunction )
                cExpression += GetFunction( cFunction, cSign, cOperator )
             endif
             cNumber := cLabel := cFunction := ""

             if lParenthetically
                if !empty( cOperator )
                   cExpression += Chr( AScan( aOperators, cOperator ) )
                endif
                lParenthetically := .f.
             endif

             do while Atail( aBuffer ) != "P"
                if !empty( Atail( aBuffer ) )
                   cExpression += Chr( AScan( aOperators, Atail( aBuffer ) ) )
                endif
                ASize( aBuffer, len( aBuffer ) - 1 )
             enddo
             cExpression += Chr( 21 )
             ASize( aBuffer, len( aBuffer ) - 1 )
             cOperator := Atail( aBuffer )
             ASize( aBuffer, len( aBuffer ) - 1 )
             lParenthetically := .t.

        otherwise
             Eval( ErrorBlock(), _XLSGenError( SYNTATIC_ERROR, ;
                                      CHR(13)+CHR(10) + cChar ) )
      endcase

      n++

  enddo

  if !empty( cNumber )
     cExpression += GetNumber( Val( cNumber ), cSign, cOperator )
  elseif !empty( cLabel )
     cExpression += GetNumber( &cLabel, cSign, cOperator )
  elseif !empty( cfunction )
     cExpression += GetFunction( cFunction, cSign, cOperator )
  endif

  if lParenthetically
     if !empty( cOperator )
        cExpression += Chr( AScan( aOperators, cOperator ) )
     endif
     lParenthetically := .f.
  endif

  do while len( aBuffer ) != 0
     cOperator := Atail( aBuffer )
     if cOperator == "P"
        cExpression += Chr( 21 )
     else
        if !empty( cOperator )
           cExpression += Chr( AScan( aOperators, cOperator ) )
        endif
     endif
     ASize( aBuffer, len( aBuffer ) - 1 )
  enddo

return cExpression

//----------------------------------------------------------------------------//

Static function GetNumber( nNumber, cSign, cOperator )

  local cExpression := ""

  nNumber *= if( cSign == "-", -1, +1 )

  if lInteger( nNumber )
     cExpression += Chr( 30 )
     cExpression += I2Bin( nNumber )
  else
     cExpression += Chr( 31 )
     cExpression += D2Bin( nNumber )
  endif

  if !empty( cOperator )
     cExpression += Chr( AScan( aOperators, cOperator ) )
  endif

return cExpression

//----------------------------------------------------------------------------//

Static function GetFunction( cFunction, cSign, cOperator )

  local cExpression := ""
  local n, nType, cVal, nVal, nPar := 1, aPar := {}, aVal := {}, uVal

  local cName := Left( cFunction, At( "(", cFunction ) - 1 )
  local cParameters := SubStr( cFunction, At( "(", cFunction ) )

  cParameters := SubStr( cParameters, 2, len( cParameters ) - 2 )
  do while ( n := At( ";", SubStr( cParameters, nPar ) ) ) != 0
     cVal := SubStr( cParameters, nPar, n - 1 )
     AAdd( aPar, cVal )
     uVal := &cVal
     AAdd( aVal, uVal )
     nPar += n
  enddo
  if !empty( cParameters )
     cVal := SubStr( cParameters, nPar )
     AAdd( aPar, cVal )
     uVal := &cVal
     AAdd( aVal, uVal )
  endif

  do case

     //  Funct. Cell.

     #ifdef _MSLINK_
     case cName == "XLSCELL"
     #else
     case cName == "_CELL"
     #endif
          cExpression += Chr( 68 )
          nType := 192
          if len( aVal ) > 3 .and. aVal[ 4 ]
             nType -= 64
          endif
          if len( aVal ) > 2 .and. aVal[ 3 ]
             nType -= 128
          endif
          nVal := aVal[ 1 ] - 1
          cExpression += Chr( nLoByte( nVal ) ) + Chr( nHiByte( nVal ) + nType )
          nVal := aVal[ 2 ] - 1
          cExpression += Chr( nVal )

     #ifdef _MSLINK_
     case cName == "XLSSUM"
     #else
     case cName == "_SUM"
     #endif
          cExpression += Chr( 37 )
          nType := 192
          if len( aVal ) > 5 .and. aVal[ 6 ]
             nType -= 64
          endif
          if len( aVal ) > 4 .and. aVal[ 5 ]
             nType -= 128
          endif
          nVal := aVal[ 1 ] - 1
          cExpression += Chr( nLoByte( nVal ) ) + Chr( nHiByte( nVal ) + nType )
          nType := 192
          if len( aVal ) > 7 .and. aVal[ 8 ]
             nType -= 64
          endif
          if len( aVal ) > 6 .and. aVal[ 7 ]
             nType -= 128
          endif
          nVal := aVal[ 3 ] - 1
          cExpression += Chr( nLoByte( nVal ) ) + Chr( nHiByte( nVal ) + nType )
          nVal := aVal[ 2 ] - 1
          cExpression += Chr( nVal )
          nVal := aVal[ 4 ] - 1
          cExpression += Chr( nVal )
          cExpression += Chr( 25 ) + Chr( 16 ) + Chr( 00 )

     #ifdef _MSLINK_
     case cName == "XLSMULT"
     #else
     case cName == "_MULT"
     #endif
          cExpression += Chr( 37 )
          nType := 192
          if len( aVal ) > 5 .and. aVal[ 6 ]
             nType -= 64
          endif
          if len( aVal ) > 4 .and. aVal[ 5 ]
             nType -= 128
          endif
          nVal := aVal[ 1 ] - 1
          cExpression += Chr( nLoByte( nVal ) ) + Chr( nHiByte( nVal ) + nType )
          nType := 192
          if len( aVal ) > 7 .and. aVal[ 8 ]
             nType -= 64
          endif
          if len( aVal ) > 6 .and. aVal[ 7 ]
             nType -= 128
          endif
          nVal := aVal[ 3 ] - 1
          cExpression += Chr( nLoByte( nVal ) ) + Chr( nHiByte( nVal ) + nType )
          nVal := aVal[ 2 ] - 1
          cExpression += Chr( nVal )
          nVal := aVal[ 4 ] - 1
          cExpression += Chr( nVal )
          cExpression += Chr( 66 ) + Chr( 01 ) + Chr( 183 )

     // Funct. Math

     #ifdef _MSLINK_
     case cName == "XLSABS"
     #else
     case cName == "_ABS"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += Chr( 65 ) + Chr( 24 )

     #ifdef _MSLINK_
     case cName == "XLSINTE"
     #else
     case cName == "_INTE"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += Chr( 65 ) + Chr( 25 )

     #ifdef _MSLINK_
     case cName == "XLSMOD"
     #else
     case cName == "_MOD"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += GetExpression( aPar[ 2 ] )
          cExpression += Chr( 65 ) + Chr( 39 )

     #ifdef _MSLINK_
     case cName == "XLSROUND"
     #else
     case cName == "_ROUND"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += GetExpression( aPar[ 2 ] )
          cExpression += Chr( 65 ) + Chr( 27 )

     #ifdef _MSLINK_
     case cName == "XLSSIGN"
     #else
     case cName == "_SIGN"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += Chr( 65 ) + Chr( 26 )

     #ifdef _MSLINK_
     case cName == "XLSSQRT"
     #else
     case cName == "_SQRT"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += Chr( 65 ) + Chr( 20 )

     #ifdef _MSLINK_
     case cName == "XLSEXP"
     #else
     case cName == "_EXP"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += Chr( 65 ) + Chr( 21 )

     #ifdef _MSLINK_
     case cName == "XLSLN"
     #else
     case cName == "_LN"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += Chr( 65 ) + Chr( 22 )

     #ifdef _MSLINK_
     case cName == "XLSLOG"
     #else
     case cName == "_LOG"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += Chr( 65 ) + Chr( 23 )

     #ifdef _MSLINK_
     case cName == "XLSPI"
     #else
     case cName == "_PI"
     #endif
          cExpression += Chr( 65 ) + Chr( 19 )

     #ifdef _MSLINK_
     case cName == "XLSRANDOM"
     #else
     case cName == "_RANDOM"
     #endif
          cExpression += Chr( 65 ) + Chr( 63 )

     #ifdef _MSLINK_
     case cName == "XLSSIN"
     #else
     case cName == "_SIN"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += Chr( 65 ) + Chr( 15 )

     #ifdef _MSLINK_
     case cName == "XLSCOS"
     #else
     case cName == "_COS"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += Chr( 65 ) + Chr( 16 )

     #ifdef _MSLINK_
     case cName == "XLSTAN"
     #else
     case cName == "_TAN"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += Chr( 65 ) + Chr( 17 )

     #ifdef _MSLINK_
     case cName == "XLSASIN"
     #else
     case cName == "_ASIN"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += Chr( 65 ) + Chr( 98 )

     #ifdef _MSLINK_
     case cName == "XLSACOS"
     #else
     case cName == "_ACOS"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += Chr( 65 ) + Chr( 99 )

     #ifdef _MSLINK_
     case cName == "XLSATAN"
     #else
     case cName == "_ATAN"
     #endif
          cExpression += GetExpression( aPar[ 1 ] )
          cExpression += Chr( 65 ) + Chr( 18 )

     otherwise
         Eval( ErrorBlock(), _XLSGenError( NODEFINED_FUNCTION, ;
                         CHR(13)+CHR(10) + "Function: " + cName ) )
  endcase

  if !empty( cSign )
     cExpression += Chr( AScan( aOperators, cSign ) + 15 )
  endif

  if !empty( cOperator )
     cExpression += Chr( AScan( aOperators, cOperator ) )
  endif

return cExpression

//----------------------------------------------------------------------------//

Static function lInteger( nNumber )
return nNumber <= 65535 .and. nNumber >= 0 .and. ;
     ( nNumber - INT( nNumber ) ) == 0








