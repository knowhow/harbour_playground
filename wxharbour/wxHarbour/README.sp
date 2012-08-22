
wxHarbour: Is xHarbour bindings for wxWidgets
           a portable GUI for xHarbour


1-sep-2006 This pre-alpha is build on Linux FC5, so the makefiles aren't (yet)
           ready to make Windows binaries.

9-sep-2006 Continuing

16-nov-2006 Para compilar bajo windows con MinGw:
			Se necesita ademas de wxwidgets y xHarbour, los siguientes Prerequisitos:
			Bajar e instalar MinGW 5.0.3 gcc 3.4.5 (candidate) installer:
				http://prdownloads.sourceforge.net/mingw/MinGW-5.0.3.exe?download
			Bajar e instalar GDB v6.3-2 debugger:
				http://prdownloads.sourceforge.net/mingw/gdb-6.3-2.exe?download
			Bajar e instalar 7-Zip:
				http://www.7-zip.org/es/
			Bajar e instalar los ports de GNU tools:
				http://gnuwin32.sourceforge.net/
			También necesita el port de wxconfig para windows,lo puedes bajar de:
				http://wxconfig.googlepages.com/
			Modificar los archivos Makefile.inc del directorio trunk/config y setear las variables correspondientes,
			entrar al directorio trunk/src y ejecutar mingw32-make, luego entrar en cada directorio de los ejemplos
			que estan el directorio trunk/samples y ejecutar mingw32-make. Es todo.

			suerte!.
