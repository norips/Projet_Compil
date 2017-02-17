CC=gcc
CFLAGS:= -std=gnu99
LDFLAGS:= -lfl
PROGS = interIMP

all: $(PROGS)

AST.o : AST.c AST.h 
	$(CC) $(CFLAGS) -c -o $@ $<

imp.tab.c imp.tab.h: imp.y
	bison -t -v --file-prefix=imp -d imp.y

imp.yy.c: imp.l imp.tab.h
	flex -o $@ $< 

interIMP: imp.yy.c imp.tab.c imp.tab.h AST.o
	$(CC) $(CFLAGS) -o $@ imp.yy.c imp.tab.c AST.o


clean :
	rm -f *.tab.*
	rm -f *.o
	rm -f *.yy.c
	rm -f $(PROGS)
	rm -f *.output
