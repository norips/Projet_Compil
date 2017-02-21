CC=gcc
CFLAGS:= -std=gnu99
LDFLAGS:= -lfl
PROGS = interIMP compIMP compC3A
OBJS = imp.tab.o imp.yy.o environ.o AST.o bilquad.o
TEST = $(wildcard test/*.ip)


.PHONY: clean test


all: $(PROGS)

%.o : %.c %.h 
	$(CC) $(CFLAGS) -c -o $@ $<
	



imp.tab.c imp.tab.h: imp.y
	bison -t -v --file-prefix=imp -d imp.y

imp.yy.c: imp.l imp.tab.h
	flex -o $@ $< 

interIMP: $(OBJS) interIMP.c
	$(CC) $(CFLAGS) -o $@ $^

compIMP: $(OBJS) compIMP.c
	$(CC) $(CFLAGS) -o $@ $^

c3a.yy.c: c3a.l
	flex -o $@ $< 
	
compC3A: c3a.yy.c bilquad.o environ.o
	$(CC) $(CFLAGS) -o $@ $^
	
test: interIMP
	for test in $(TEST); do \
		cat $$test; \
		./interIMP < $$test;\
		echo "#################################"; \
	done

clean :
	rm -f *.tab.*
	rm -f *.o
	rm -f *.yy.c
	rm -f $(PROGS)
	rm -f *.output
