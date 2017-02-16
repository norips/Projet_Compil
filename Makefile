CC=gcc
CFLAGS:= -std=gnu99
LDFLAGS:= -lfl
PROGS = interIMP

all: $(PROGS)


imp.tab.c imp.tab.h: imp.y
	bison --file-prefix=imp -d imp.y

imp.yy.c: imp.l imp.tab.h
	flex -o $@ $< 

interIMP: imp.yy.c imp.tab.c imp.tab.h
	gcc -o $@ imp.yy.c imp.tab.c


clean :
	rm -f *.tab.*
	rm -f *.o
	rm -f *.yy.c
	rm -f $(PROGS)
