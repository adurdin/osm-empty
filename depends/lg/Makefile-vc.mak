# Makefile for lg library
# MSVC++

CPU=i386
APPVER=4.0
!include <win32.mak>

srcdir = .

DEFINES = -DWINVER=0x0400 -D_WIN32_WINNT=0x0400 -DWIN32_LEAN_AND_MEAN -D_CRT_SECURE_NO_WARNINGS

LDFLAGS = -nologo $(dlllflags)
LIBDIRS =
LIBS = ole32.lib oleaut32.lib uuid.lib $(baselibs)
INCLUDES = -I. -I$(srcdir)
CXXFLAGS = $(cflags) -nologo -W3 -wd4800 -TP -EHsc
LIBFLAGS = -nologo

CXXDEBUG = -MTd -Od -DDEBUG
LDDEBUG = -DEBUG
CXXNDEBUG = -MT -Ox -DNDEBUG
LDNDEBUG = -RELEASE

LG_HEADERS = lg/actreact.h \
	lg/ai.h \
	lg/config.h \
	lg/convict.h \
	lg/data.h \
	lg/defs.h \
	lg/dlgs.h \
	lg/dynarray.h \
	lg/dynarray.hpp \
	lg/editor.h \
	lg/gen.h \
	lg/graphics.h \
	lg/iiddef.h \
	lg/iids.h \
	lg/input.h \
	lg/interface.h \
	lg/interfaceimp.h \
	lg/lg.h \
	lg/links.h \
	lg/loop.h \
	lg/malloc.h \
	lg/miss16.h \
	lg/net.h \
	lg/objects.h \
	lg/objstd.h \
	lg/propdefs.h \
	lg/properties.h \
	lg/quest.h \
	lg/res.h \
	lg/script.h \
	lg/scrmanagers.h \
	lg/scrmsgs.h \
	lg/scrservices.h \
	lg/shock.h \
	lg/sound.h \
	lg/tools.h \
	lg/types.h \
	lg/win.h

LG_SRCS = lg.cpp scrmsgs.cpp refcnt.cpp iids.cpp
LG_OBJS = lg.obj scrmsgs.obj refcnt.obj iids.obj
LG_OBJSD = lg-d.obj scrmsgs-d.obj refcnt-d.obj iids.obj
LG_LIB = lg.lib
LG_LIBD = lgd.lib

ALL:	$(LG_LIB) $(LG_LIBD)

clean:
	del /q $(LG_OBJS) $(LG_OBJSD) $(LG_LIB) $(LG_LIBD)

.cpp.obj:
	$(cc) $(CXXFLAGS) $(CXXNDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c $<

$(LG_LIB): $(LG_OBJS)
	$(implib) $(libflags) -out:$@ $(LG_OBJS)

$(LG_LIBD): $(LG_OBJSD)
	$(implib) $(libflags) -out:$@ $(LG_OBJSD)

lg.obj: lg.cpp $(LG_HEADERS)
	$(cc) $(CXXFLAGS) $(CXXNDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c lg.cpp

scrmsgs.obj: scrmsgs.cpp lg/scrmsgs.h lg/defs.h lg/types.h lg/interfaceimp.h lg/interface.h lg/iiddef.h lg/objstd.h lg/config.h
	$(cc) $(CXXFLAGS) $(CXXNDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c scrmsgs.cpp

refcnt.obj: refcnt.cpp lg/interfaceimp.h lg/iiddef.h lg/objstd.h lg/config.h
	$(cc) $(CXXFLAGS) $(CXXNDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c refcnt.cpp

lg-d.obj: lg.cpp $(LG_HEADERS)
	$(cc) $(CXXFLAGS) $(CXXDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c lg.cpp

scrmsgs-d.obj: scrmsgs.cpp lg/scrmsgs.h lg/defs.h lg/types.h lg/interfaceimp.h lg/interface.h lg/iiddef.h lg/objstd.h lg/config.h
	$(cc) $(CXXFLAGS) $(CXXDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c scrmsgs.cpp

refcnt-d.obj: refcnt.cpp lg/interfaceimp.h lg/iiddef.h lg/objstd.h lg/config.h
	$(cc) $(CXXFLAGS) $(CXXDEBUG) $(DEFINES) $(INCLUDES) -Fo$@ -c refcnt.cpp
