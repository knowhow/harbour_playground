#!/bin/bash
#
# $Id: run_App.sh 388 2009-08-10 21:58:46Z tfonrouge $
#

App_MacPath="./${1}.app/Contents"

if [ `uname` == "Darwin" ] ; then
    mkdir -p ${App_MacPath}/MacOS
    ln -f ${1} ${App_MacPath}/MacOS/${1}
    if [ ! -e ${App_MacPath}/Info.plist ] ; then
	cp ../../config/Info.plist ${App_MacPath}
	SEDCMD=s/__APPNAME__/${1}/
	sed -i "" ${SEDCMD} ${App_MacPath}/Info.plist
    fi
    if [ ! -d ${App_MacPath}/Resources ] ; then
	mkdir -p ${App_MacPath}/Resources/
	cp ../../config/*.icns ${App_MacPath}/Resources/
    fi
    cp ../../config/PkgInfo ${App_MacPath}
    ${App_MacPath}/MacOS/${1}
else
    ./${1}
fi
