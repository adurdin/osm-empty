###############################################################################
##    Makefile-vc.mak
##
##    This file is part of Object Script Module
##    Copyright (C) 2004 Tom N Harris <telliamed@whoopdedo.cjb.net>
##    Copyright (C) 2020 Andrew Durdin <me@andy.durdin.net>
##
##    Permission is hereby granted, free of charge, to any person obtaining
##    a copy of this software and associated documentation files (the 
##    "Software"), to deal in the Software without restriction, including 
##    without limitation the rights to use, copy, modify, merge, publish, 
##    distribute, sublicense, and/or sell copies of the Software, and to 
##    permit persons to whom the Software is furnished to do so.
##    
##    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
##    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
##    OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-
##    INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS 
##    BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN 
##    AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
##    IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
##    THE SOFTWARE.
##
###############################################################################

OSM = empty

GAME = 2

LGDIR = depends/lg

DEFINES = -D_X86_ -DWINVER=0x0400 -D_WIN32_WINNT=0x0400 -DWIN32_LEAN_AND_MEAN -D_DARKGAME=$(GAME)

!ifdef DEBUG
DEFINES = $(DEFINES) -D_DEBUG 
CXXDEBUG = /Zi /Od
LDDEBUG =
LGLIB = lgd.lib
!else
DEFINES = $(DEFINES) -DNDEBUG
CXXDEBUG = /O2
LDDEBUG =
LGLIB = lg.lib
!endif

LDFLAGS =
LIBDIRS =
LIBS = uuid.lib
INCLUDES = /I. /I$(LGDIR)
CXXFLAGS =
CXXFLAGS = /nologo
DLLFLAGS = /LD

.cpp.obj:
	$(CXX) $(CXXFLAGS) $(CXXDEBUG) $(DEFINES) $(INCLUDES) /Fo$@ /c $<

$(OSM).osm: $(OSM).obj ScriptModule.obj Script.obj $(LGDIR)/$(LGLIB)
	$(CXX) $(DLLFLAGS) /Fe$@ $** $(LDFLAGS) $(LDDEBUG) $(LIBDIRS) $(LIBS)

$(LGDIR)/$(LGLIB):
	cd $(LGDIR)
	$(MAKE) /f Makefile-vc.mak
	cd $(MAKEDIR)

all: $(OSM).osm

clean:
	del /q *.exp *.lib *.obj *.osm

cleanall: clean
	cd $(LGDIR)
	$(MAKE) /f Makefile-vc.mak clean
	cd $(MAKEDIR)
