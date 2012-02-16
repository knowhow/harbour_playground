/*
 * $Id: myzip.prg 16899 2011-06-21 10:16:59Z vszakats $
 */

/*
 * Harbour Project source code:
 *  MyZip utility
 *
 * Copyright 2008 Mindaugas Kavaliauskas <dbtopas.at.dbtopas.lt>
 * www - http://harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

PROCEDURE Main( ... )
   LOCAL hZip, aDir, aFile, aWild, ;
         cZipName, cPath, cFileName, cExt, cWild, cPassword, cComment,;
         tmp

   aWild := { ... }
   IF LEN(aWild) < 2
      ? "Usage: myzip <ZipName> [ --pass <password> ] [ --comment <comment> ] <FilePattern1> [ <FilePattern2> ... ]"
      RETURN
   ENDIF

   HB_FNameSplit( aWild[ 1 ], @cPath, @cFileName, @cExt )
   IF EMPTY( cExt )
      cExt := ".zip"
   ENDIF
   cZipName := HB_FNameMerge( cPath, cFileName, cExt )

   HB_ADEL( aWild, 1, .T. )

   FOR tmp := LEN( aWild ) - 1 TO 1 STEP -1
      IF LOWER( aWild[ tmp ] ) == "--pass"
         IF EMPTY( cPassword )
            cPassword := aWild[ tmp + 1 ]
         ENDIF
         aWild[ tmp ] := ""
         aWild[ tmp + 1 ] := ""
      ELSEIF LOWER( aWild[ tmp ] ) == "--comment"
         IF EMPTY( cComment )
            cComment := aWild[ tmp + 1 ]
         ENDIF
         aWild[ tmp ] := ""
         aWild[ tmp + 1 ] := ""
      ENDIF
   NEXT

   hZip := HB_ZIPOPEN( cZipName )
   IF ! EMPTY( hZip )
      ? "Archive file:", cZipName
      FOR EACH cWild IN aWild
         IF !EMPTY( cWild )
            HB_FNameSplit( cWild, @cPath, @cFileName, @cExt )
            aDir := HB_DirScan( cPath, cFileName + cExt )
            FOR EACH aFile IN aDir
               IF ! cPath + aFile[ 1 ] == cZipName
                  ? "Adding", cPath + aFile[ 1 ]
                  HB_ZipStoreFile( hZip, cPath + aFile[ 1 ], cPath + aFile[ 1 ], cPassword )
               ENDIF
            NEXT
         ENDIF
      NEXT
      HB_ZIPCLOSE( hZip, cComment )
   ENDIF

   RETURN
