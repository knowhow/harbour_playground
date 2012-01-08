/*
 * $Id: qtver.prg 14742 2010-06-10 21:02:20Z vszakats $
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2010 Viktor Szakats (harbour.01 syenar.hu)
 * www - http://harbour-project.org
 *
 */

#include "simpleio.ch"

PROCEDURE MAIN()

REQUEST HB_GT_XWC_DEFAULT

REQUEST HB_CODEPAGE_SL852
REQUEST HB_CODEPAGE_SLISO

   ? "QT library used is shared:", QSHAREDBUILD()
   ? "QT library version used:", QVERSION()
   ? "QT library version HBQT was built against:", QT_VERSION_STR()
   ? "QT library version HBQT was built against (numeric):", "0x" + hb_numtohex( QT_VERSION() )

   ?

   Alert("qt verzija je :" + hb_ValToStr(QVERSION()))
RETURN
