function Main()

xls_1()

return



#pragma BEGINDUMP

/*
#include <xlslib/common/xlconfig.h>

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#ifdef HAVE_STDINT_H
#include <stdint.h>
#endif
#ifdef HAVE_STDBOOL_H
#include <stdbool.h>
#else
typedef enum
{
	false = 0,
	true = 1
} bool;
#endif
#ifdef HAVE_WCHAR_H
#include <wchar.h>
#endif
#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif
*/

#include "hbapi.h"

#define PACKAGE_VERSION "2.3.4"

#include "xlslib.h"

#include "common/timespan.h"

//#include "md5.h"

#include <string>
#include <sstream>
#include <iostream>
#include <stdio.h>
#include <limits.h>

using namespace std;
using namespace xlslib_core;


HB_FUNC( XLS_1 ) {

int ret;
/*
workbook *wb;
worksheet *ws;
format_t *myFormat;
xf_t *x_myFormat;
cell_t *c1;
int i;

wb = xlsNewWorkbook();
ws = xlsWorkbookSheet(wb, "xlslib C");

myFormat = xlsWorkbookFormat(wb, "##.00");

x_myFormat = xlsWorkbookxFormat(wb);

for (i = 0; i < 10; i++) {

   xlsWorksheetRowheight(ws, i, 35, x_myFormat);

   c1 =	 xlsWorksheetLabel(ws, i, 0, "Ernad Husremović", x_myFormat);	
   xlsCellValign(c1, VALIGN_CENTER);
   xlsCellHalign(c1, HALIGN_CENTER);

   c1 =  xlsWorksheetNumberDbl(ws,  i, 1, 1.03414234 + i, x_myFormat);
   xlsCellValign(c1, VALIGN_BOTTOM);
   xlsCellHalign(c1, HALIGN_RIGHT);
   xlsCellFormatP(c1, myFormat);
   printf("cell %d\n", i);
}
*/

//c1 = xlsWorksheetFormula(ws, 10, 1, "=SUM(B1:B9)", x_myFormat);

   
workbook *wb = new workbook();

worksheet* sh2 = wb->sheet("sheet2");

expression_node_factory_t& maker = wb->GetFormulaFactory();


// cell_t *pCell=ws1->FindCell(0,0);
// cell_t *pCell2=ws1->FindCell(10,0);


cell_t *c1 = sh2->number(0, 0, 1.1);

sh2->number(0, 1, 2.2);

cell_t *c2 = sh2->number(0, 2, 3.3);

expression_node_t *pExpFormula = maker.f(FUNC_SUM, maker.area(*c1, *c2, CELL_RELATIVE_A1));
sh2->formula(0, 3, pExpFormula, true);


//xlsWorksheetColwidth(ws, 0, 7000, x_myFormat);
//xlsWorksheetColwidth(ws, 1, 4000, x_myFormat);


// format_number_t fmtnum = FMT_CURRENCY8;

//xlsCellFormat(c1, fmtnum);

/*
xlsWorksheetColwidth(ws, 1, 4000, x_myFormat);

ret = xlsWorkbookDump(wb, "xls_1.xls");
*/

ret = wb->Dump("xls_1.xls");
}

#pragma ENDDUMP

