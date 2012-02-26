function Main()

xls_1()

return



#pragma BEGINDUMP

#include <xlslib/common/xlconfig.h>

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#ifdef _X_DEBUG_
#include <unistd.h>
#endif

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


#include <xlslib/xlslib.h>
//#include <xlslib/common/systype.h>



#include "hbapi.h"

HB_FUNC( XLS_1 ) {

int ret;
workbook *wb;
worksheet *ws;
format_t *myFormat;
xf_t *x_myFormat;
cell_t *c1;

wb = xlsNewWorkbook();
ws = xlsWorkbookSheet(wb, "xlslib C");

myFormat = xlsWorkbookFormat(wb, "##.000");

x_myFormat = xlsWorkbookxFormat(wb);

c1 =  xlsWorksheetNumberDbl(ws, 1, 5, 1.03414234, x_myFormat);

// format_number_t fmtnum = FMT_CURRENCY8;

//xlsCellFormat(c1, fmtnum);

ret = xlsWorkbookDump(wb, "xls_1.xls");

}

#pragma ENDDUMP

