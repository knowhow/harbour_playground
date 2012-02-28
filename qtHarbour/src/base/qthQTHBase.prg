/*
 * $Id: qthQObject.prg 63 2011-02-01 05:10:29Z tfonrouge $
 *
 * (C) 2011. qtHarbour     http://sourceforge.net/projects/qth/
 * (C) 2011. Teo Fonrouge  <tfonrouge/at/gmail/dot/com>
 *
 */

#include "qtHarbour.ch"

REQUEST QOUT
REQUEST QQOUT

CLASS QTHBASE /* base for all qth classes */

    DESTRUCTOR OnDestruct()

ENDCLASS


METHOD PROCEDURE OnDestruct() CLASS QTHBASE
    qth_BaseDestruct( Self )
RETURN
