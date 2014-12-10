include config.mk

SRCS := atosl.c subprograms.c common.c
HDRS := atosl.h subprograms.h common.h
SRCSU := atosu.c subprograms.c common.c

TARGET := atosl
TARGETU := atosu

OBJS := ${SRCS:.c=.o}
DEPS := ${SRCS:.c=.dep}

OBJSU := ${SRCSU:.c=.o}
DEPSU := ${SRCSU:.c=.dep}

DIST := ${TARGET}-${VERSION}

.PHONY: all clean distclean dist install uninstall

all:: ${TARGET} ${TARGETU}

${TARGET}: ${OBJS}
	    ${CC} -o $@ $^ ${LDFLAGS}

${OBJS}: %.o: %.c %.dep ${HDRS} config.mk $(wildcard config.mk.local)
	    ${CC} ${CFLAGS} -o $@ -c $<

${DEPS}: %.dep: %.c Makefile
	    ${CC} ${CFLAGS} -MM $< > $@

${TARGETU}: ${OBJSU}
	    ${CC} -o $@ $^ ${LDFLAGS}



clean:
	    -rm -f *~ *.o *.dep ${TARGET} ${TARGETU} ${DIST}.tar.gz

dist: clean
	mkdir -p ${DIST}
	cp -R LICENSE PATENTS Makefile README.md config.mk ${SRCS} ${HDRS} ${DIST}
	tar -cf ${DIST}.tar ${DIST}
	gzip ${DIST}.tar
	rm -rf ${DIST}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f atosl ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/atosl

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/atosl

distclean:: clean
