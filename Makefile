CC=gcc
CFLAGS:= -std=gnu99
LDFLAGS:= -lfl
PROGS = interIMP
OBJS = imp.tab.o imp.yy.o environ.o AST.o 
all: $(PROGS)

%.o : %.c %.h 
	$(CC) $(CFLAGS) -c -o $@ $<
	



imp.tab.c imp.tab.h: imp.y
	bison -t -v --file-prefix=imp -d imp.y

imp.yy.c: imp.l imp.tab.h
	flex -o $@ $< 

interIMP: $(OBJS) interIMP.c
	$(CC) $(CFLAGS) -o $@ $^


clean :
	rm -f *.tab.*
	rm -f *.o
	rm -f *.yy.c
	rm -f $(PROGS)
	rm -f *.output
