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

OSM = Demo
GAME = 2
LGDIR = depends/lg

CPU=i386
APPVER=4.0
!include <win32.mak>

srcdir = .
lgdir = ./depends/lg

DEFINES = -DWINVER=0x0400 -D_WIN32_WINNT=0x0400 -DWIN32_LEAN_AND_MEAN -D_CRT_SECURE_NO_WARNINGS -D_DARKGAME=$(GAME)

LDFLAGS = -nologo $(dllflags)
LIBDIRS =
LIBS = ole32.lib oleaut32.lib uuid.lib $(baselibs)
INCLUDES = -I. -I$(srcdir) -I$(lgdir)
CXXFLAGS = $(cflags) -nologo -W3 -wd4800 -TP -EHsc

CXXDEBUG = -MTd -Od -DDEBUG
LDDEBUG = -DLL -DEBUG
CXXNDEBUG = -MT -Ox -DNDEBUG
LDNDEBUG = -DLL -RELEASE


OSM_HEADERS = ScriptModule.h \
	Script.h \
	scriptvars.h

OSM_SRCS = $(OSM).cpp ScriptModule.cpp Script.cpp
OSM_OBJS = $(OSM).obj ScriptModule.obj Script.obj
OSM_OBJSD = $(OSM)-d.obj ScriptModule-d.obj Script-d.obj
OSM_DLL = $(OSM).osm
OSM_DLLD = $(OSM)d.osm


LG_HEADERS = $(lgdir)/lg/actreact.h \
	$(lgdir)/lg/ai.h \
	$(lgdir)/lg/config.h \
	$(lgdir)/lg/convict.h \
	$(lgdir)/lg/data.h \
	$(lgdir)/lg/defs.h \
	$(lgdir)/lg/dlgs.h \
	$(lgdir)/lg/dynarray.h \
	$(lgdir)/lg/dynarray.hpp \
	$(lgdir)/lg/editor.h \
	$(lgdir)/lg/gen.h \
	$(lgdir)/lg/graphics.h \
	$(lgdir)/lg/iiddef.h \
	$(lgdir)/lg/iids.h \
	$(lgdir)/lg/input.h \
	$(lgdir)/lg/interface.h \
	$(lgdir)/lg/interfaceimp.h \
	$(lgdir)/lg/lg.h \
	$(lgdir)/lg/links.h \
	$(lgdir)/lg/loop.h \
	$(lgdir)/lg/malloc.h \
	$(lgdir)/lg/miss16.h \
	$(lgdir)/lg/net.h \
	$(lgdir)/lg/objects.h \
	$(lgdir)/lg/objstd.h \
	$(lgdir)/lg/propdefs.h \
	$(lgdir)/lg/properties.h \
	$(lgdir)/lg/quest.h \
	$(lgdir)/lg/res.h \
	$(lgdir)/lg/script.h \
	$(lgdir)/lg/scrmanagers.h \
	$(lgdir)/lg/scrmsgs.h \
	$(lgdir)/lg/scrservices.h \
	$(lgdir)/lg/shock.h \
	$(lgdir)/lg/sound.h \
	$(lgdir)/lg/tools.h \
	$(lgdir)/lg/types.h \
	$(lgdir)/lg/win.h

LG_SRCS = $(lgdir)/lg.cpp $(lgdir)/scrmsgs.cpp $(lgdir)/refcnt.cpp $(lgdir)/iids.cpp
LG_OBJS = lg.obj scrmsgs.obj refcnt.obj iids.obj
LG_OBJSD = lg-d.obj scrmsgs-d.obj refcnt-d.obj iids-d.obj

ALL:	$(OSM_DLL) $(OSM_DLLD)

clean:
	del /q $(OSM_OBJS) $(OSM_OBJSD) $(OSM_DLL) $(OSM_DLLD)
	del /q $(LG_OBJS) $(LG_OBJSD) $(LG_LIB) $(LG_LIBD)

$(OSM_DLL): $(OSM_OBJS) $(LG_OBJS)
	$(link) $(LDFLAGS) $(LDNDEBUG) -out:$@ $(OSM_OBJS) $(LG_OBJS)

$(OSM_DLLD): $(OSM_OBJSD) $(LG_OBJSD)
	$(link) $(LDFLAGS) $(LDDEBUG) -out:$@ $(OSM_OBJSD) $(LG_OBJSD)

$(OSM).obj: $(OSM).cpp $(OSM_HEADERS)
	$(cc) $(CXXFLAGS) $(CXXNDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c $(OSM).cpp

Script.obj: Script.cpp Script.h
	$(cc) $(CXXFLAGS) $(CXXNDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c Script.cpp

ScriptModule.obj: ScriptModule.cpp ScriptModule.h
	$(cc) $(CXXFLAGS) $(CXXNDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c ScriptModule.cpp

$(OSM)-d.obj: $(OSM).cpp $(OSM_HEADERS)
	$(cc) $(CXXFLAGS) $(CXXDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c $(OSM).cpp
	
Script-d.obj: Script.cpp Script.h
	$(cc) $(CXXFLAGS) $(CXXDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c Script.cpp

ScriptModule-d.obj: ScriptModule.cpp ScriptModule.h
	$(cc) $(CXXFLAGS) $(CXXDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c ScriptModule.cpp

lg.obj: $(lgdir)/lg.cpp $(LG_HEADERS)
	$(cc) $(CXXFLAGS) $(CXXNDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c $(lgdir)/lg.cpp

scrmsgs.obj: $(lgdir)/scrmsgs.cpp $(lgdir)/lg/scrmsgs.h $(lgdir)/lg/defs.h $(lgdir)/lg/types.h $(lgdir)/lg/interfaceimp.h $(lgdir)/lg/interface.h $(lgdir)/lg/iiddef.h $(lgdir)/lg/objstd.h $(lgdir)/lg/config.h
	$(cc) $(CXXFLAGS) $(CXXNDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c $(lgdir)/scrmsgs.cpp

refcnt.obj: $(lgdir)/refcnt.cpp $(lgdir)/lg/interfaceimp.h $(lgdir)/lg/iiddef.h $(lgdir)/lg/objstd.h $(lgdir)/lg/config.h
	$(cc) $(CXXFLAGS) $(CXXNDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c $(lgdir)/refcnt.cpp

iids.obj: $(lgdir)/lg.cpp $(LG_HEADERS)
	$(cc) $(CXXFLAGS) $(CXXNDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c $(lgdir)/iids.cpp

lg-d.obj: $(lgdir)/lg.cpp $(LG_HEADERS)
	$(cc) $(CXXFLAGS) $(CXXDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c $(lgdir)/lg.cpp

scrmsgs-d.obj: $(lgdir)/scrmsgs.cpp $(lgdir)/lg/scrmsgs.h $(lgdir)/lg/defs.h $(lgdir)/lg/types.h $(lgdir)/lg/interfaceimp.h $(lgdir)/lg/interface.h $(lgdir)/lg/iiddef.h $(lgdir)/lg/objstd.h $(lgdir)/lg/config.h
	$(cc) $(CXXFLAGS) $(CXXDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c $(lgdir)/scrmsgs.cpp

refcnt-d.obj: $(lgdir)/refcnt.cpp $(lgdir)/lg/interfaceimp.h $(lgdir)/lg/iiddef.h $(lgdir)/lg/objstd.h $(lgdir)/lg/config.h
	$(cc) $(CXXFLAGS) $(CXXDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c $(lgdir)/refcnt.cpp

iids-d.obj: $(lgdir)/lg.cpp $(LG_HEADERS)
	$(cc) $(CXXFLAGS) $(CXXDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c $(lgdir)/iids.cpp
