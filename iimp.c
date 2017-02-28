#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


int main(int argc, char *argv[]) {
	int p[2];
	pipe(p);
	if(fork() != 0) {
		close(p[1]);
		dup2(p[0],0);
		execlp("./compC3A","./compC3A",NULL);
		perror("compC3A");
		exit(0);
	} else {
		dup2(p[1],1);
		close(p[0]);
		execlp("./compIMP","./compIMP",NULL);
		perror("compIMP");
		exit(0);
	}
	return EXIT_SUCCESS;

}
