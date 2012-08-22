#!/usr/bin/qmake -Wall
#
# $Id: qtHarbour.pro 115 2011-04-07 02:45:19Z tfonrouge $
#
#-------------------------------------------------
# (C) Teo Fonrouge. WindTelSoft 2010
#-------------------------------------------------
# *
# * (C) 2011. qtHarbour     http://sourceforge.net/projects/qth/
# * (C) 2011. Teo Fonrouge  <tfonrouge/at/gmail/dot/com>
# *
#

include(qtHarbour.qmk)

QT       += network webkit xml xmlpatterns

TARGET = qtHarbour
TEMPLATE = lib

CONFIG += staticlib

DEFINES += QTHARBOUR_LIBRARY

HBSOURCES = src/base/*.prg

WIPSOURCES += wip/*.wip

SOURCES = src/base/*.cpp

HEADERS += include/*.h \
	   include/*.ch