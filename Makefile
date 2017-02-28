CC=gcc
CFLAGS:= -std=gnu99 -Wall
LDFLAGS:= -lfl
PROGS = interIMP compIMP compC3A iimp
OBJS = imp.tab.o imp.yy.o utils/environ.o utils/AST.o utils/bilquad.o
TEST = $(wildcard test/*.ip)


.PHONY: clean test


all: $(PROGS)

%.o : %.c %.h 
	$(CC) $(CFLAGS) -c -o $@ $<
	



imp.tab.c imp.tab.h: iimp.y
	bison -t -v --file-prefix=imp -d iimp.y

imp.yy.c: iimp.l imp.tab.h
	flex -o $@ $< 

interIMP: $(OBJS) interIMP.c
	$(CC) $(CFLAGS) -o $@ $^

compIMP: $(OBJS) compIMP.c
	$(CC) $(CFLAGS) -o $@ $^

compC3A.yy.c: compC3A.l
	flex -o $@ $< 
	
compC3A: compC3A.yy.c utils/bilquad.o utils/environ.o
	$(CC) $(CFLAGS) -o $@ $^
	
iimp: compC3A compIMP iimp.c
	gcc $(CFLAGS) -o $@ iimp.c

test: compIMP compC3A
	for test in $(TEST); do \
		./compIMP < $$test > $$test.c3a;\
		./compC3A < $$test.c3a > $$test.y86;\
	done

clean :
	rm -f *.tab.*
	rm -f *.o
	rm -f *.yy.c
	rm -f $(PROGS)
	rm -f *.output
	rm -f utils/*.o
	rm -f test/*.c3a
	rm -f test/*.y86
