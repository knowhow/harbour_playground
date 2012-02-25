#ifndef _XLS_CH
	#define _XLS_CH
#endif
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

// XLS error code
#define XLSERROR_NULL      0
#define XLSERROR_DIV0      7
#define XLSERROR_VALUE    15
#define XLSERROR_REF      23
#define XLSERROR_NAME     29
#define XLSERROR_NUM      36
#define XLSERROR_N_A      42

#include "XLSForm.ch"

/*----------------------------------------------------------------------------//
!short: DEFINEXLS  */

#xcommand DEFINE XLS FONT <nFont> ;
             [ NAME <cName> ] ;
             [ HEIGHT <nHeight> ] ;
             [ <bold: BOLD> ] ;
             [ <italic: ITALIC> ] ;
             [ <underline: UNDERLINE> ] ;
             [ <strikeout: STRIKEOUT> ] ;
       => ;
             <nFont> := XLSFont( <cName>, <nHeight>, ; 
                  [<.bold.>], [<.italic.>], [<.underline.>], [<.strikeout.>] )

#xcommand RELEASE XLS FONT => XLSClsFont()


#xcommand DEFINE XLS FORMAT <nFormat> ;
             [ PICTURE <cPicture> ] ;
       => ;
            <nFormat> := XLSFormat( <cPicture> )

#xcommand RELEASE XLS FORMAT => XLSClsFormat()

/*----------------------------------------------------------------------------//
!short: FILEXLS  */

#xcommand XLS <oXLS> [ FILE  <cFile> ] ;
               [ <noautomatic: NOAUTOMATIC, NO AUTOMATIC> ] ;       
               [ ITERATIONS <nIterations> ] ;
               [ <lProtect: PROTECT> ] ;
               [ <lAutoexec: AUTOEXEC> ] ;  
               [ OF <oParent> ] ;
        => ;
              <oXLS> := TFileXLS():New( <(cFile)>, !<.noautomatic.>, ;
                  <nIterations>, <.lProtect.>, <.lAutoexec.>, <oParent> ) 


#xcommand XLS ROW <nRow> [ HEIGHT <nHeight> ] [ OF <oXLS> ] ; 
        => ;
              <oXLS>:_Row( <nRow>, <nHeight> ) 

#xcommand XLS COL <nFirstCol> [ TO <nLastCol> ] [ WIDTH <nWidth> ] [ OF <oXLS> ] ;
               [ <hide: HIDE> ] ;
        => ;
              <oXLS>:_Col( <nFirstCol>, <nLastCol>, <nWidth>, <.hide.> ) 


#xcommand @ <nRow>, <nCol> XLS [ SAY <uVal> ] [ OF <oXLS> ] ; 
               [ FONT <nFont> ] ;
               [ FORMAT <nFormat> ] ;
               [ <hidden: HIDDEN> ] ;
               [ <locked: LOCKED> ] ;
               [ <shaded: SHADED> ] ;
               [ <border: BORDER> ] [ <nBorder> ] ;
               [ ALIGNAMENT <nAlignament> ] ;
       => ;
             <oXLS>:Say( <nRow>, <nCol>, <uVal>, ;
                      <.hidden.>, <.locked.>, <nFont>, <nFormat>, <.shaded.>, ;
                      if( <.border.> .and. !<.nBorder.>, BORDER_ALL, <nBorder> ), ;
                      <nAlignament> )

#xcommand @ <nRow>, <nCol> XLS FORMULA <formula> [ OF <oXLS> ] ; 
               [ VAL <nVal> ] ;
               [ <norecalc: NORECALCULATE, NO RECALCULATE> ] ;
               [ FONT <nFont> ] ;
               [ FORMAT <nFormat> ] ;
               [ <hidden: HIDDEN> ] ;
               [ <locked: LOCKED> ] ;
               [ <shaded: SHADED> ] ;
               [ <border: BORDER> ] [ <nBorder> ] ;
               [ ALIGNAMENT <nAlignament> ] ;
       => ;
             <oXLS>:Formula( <nRow>, <nCol>, <nVal>, ;
                      !<.norecalc.>, <(formula)>, ;
                      <.hidden.>, <.locked.>, <nFont>, <nFormat>, <.shaded.>, ;
                      if( <.border.> .and. !<.nBorder.>, BORDER_ALL, <nBorder> ), ;
                      <nAlignament> )                                 

/*
   So that you formulate them they can process variable clipper in time of creation
   of the XLS file, these variables must be declared as you publics.

   Para que las formulas puedan procesar variables clipper en tiempo de creación 
   de la hoja XLS, estas variables han de estar declaradas como publicas.

*/

/*
   For not confusing to the preprocessor you formulate them they cannot begin
   with parenthesis, recommending you to begin the you formulate with the sign '+'.  

   Para no confundir al preprocesador las formulas no pueden comenzar con parentesis,
   recomendandose comenzar las formulas con el signo '+'.

   Example: / Ejemplo: 

        FORMULA ( xlsCELL(3,4) + xlsCELL(3,5) ) * 2 

     To substitute for: / Sustituir por:

        FORMULA +( xlsCELL(3,4) + xlsCELL(3,5) ) * 2 

*/

#xcommand @ <nRow>, <nCol> XLS ERROR <nError> [ OF <oXLS> ] ; 
               [ FONT <nFont> ] ;
               [ FORMAT <nFormat> ] ;
               [ <hidden: HIDDEN> ] ;
               [ <locked: LOCKED> ] ;
               [ <shaded: SHADED> ] ;
               [ <border: BORDER> ] [ <nBorder> ] ;
               [ ALIGNAMENT <nAlignament> ] ;
       => ;
             <oXLS>:Error( <nRow>, <nCol>, <nError>, ;
                      <.hidden.>, <.locked.>, <nFont>, <nFormat>, <.shaded.>, ;
                      if( <.border.> .and. !<.nBorder.>, BORDER_ALL, <nBorder> ), ;
                      <nAlignament> )

#xcommand @ <nRow>, <nCol> XLS NOTE <cNote> [ OF <oXLS> ] ; 
       => ;
             <oXLS>:Note( <nRow>, <nCol>, <(cNote)> )

#xcommand XLS PAGE [ BREAK ] [ <course: HORIZONTAL, VERTICAL> ] AT <aBreaks,...> ;
              [ OF <oXLS> ] ; 
       => ;
             <oXLS>:AddBreak( [ Upper(<(course)>) ], \{<aBreaks>\} )

#xcommand ENDXLS <oXLS> => <oXLS>:End()

//----------------------------------------------------------------------------//

#xcommand SET XLS TO DISPLAY ;
               [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;  
               [ <lHidden: HIDDEN> ] ;
               [ <lFormulas: FORMULAS> ] ;
               [ <lNoGredlines: NOGRIDLINES, NO GRIDLINES> ] ;   
               [ <lNoHeaders: NOHEAGDERS, NO HEADERS> ] ;
               [ <lNoZero: NOZERO, NO ZERO> ] ;
               [ OF <oXLS> ] ;
        => ;   
              <oXLS>:SetDisplay( <nTop>, <nLeft>, <nBottom>, <nRight>, <.lHidden.>, ;
                       <.lFormulas.>, !<.lNoGredlines.>, !<.lNoHeaders.>, <.lNoZero.> )

#xcommand SET XLS TO PRINTER ;
               [ HEADER <cHeader> ] ;
               [ FOOTER <cFooter> ] ;
               [ LEFT MARGIN <nLeft> ] ;       // inches    
               [ RIGHT MARGIN <nRight> ] ;     // inches        
               [ TOP MARGIN <nTop> ] ;         // inches      
               [ BOTTOM MARGIN <nBottom> ] ;   // inches         
               [ <lHeaders: HEADERS > ] ;
               [ <lGredlines: GRIDLINES> ] ;         
               [ OF <oXLS> ] ;
        => ;   
              <oXLS>:SetPrinter( <cHeader>, <cFooter>, ;
                       <nLeft>, <nRight>, <nTop>, <nBottom>, ;
                       <.lHeaders.>, <.lGredlines.> ) 

//----------------------------------------------------------------------------//
// FileXLS Library (c) Ramón Avendaño
              
#xcommand DEFAULT <e1>, <e2>, <e3> => XDEFAULT <e1> ; XDEFAULT <e2>; XDEFAULT <e3>
#xcommand DEFAULT <e,...> => XDEFAULT <e>

#command  XDEFAULT <xVar> := <expr> =>   if <xVar> == NIL ; <xVar> :=  <expr> ; end

//#command  DEFAULT <xVar> := <expr> => if <xVar> == NIL ; <xVar> :=  <expr> ; end

