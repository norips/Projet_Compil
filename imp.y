%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYDEBUG 1
extern int yylex();
extern int yyerror(char*);


%}
%union {
    int i;
    char* id;
}
%left I V Af Sk Se If Th El Wh Do Pl Mo Mu
%type<id> V
%type<i> I
%start prog


%%
/* Un programme est une suite de déclaration (C) composé de déclaration atomique (C0)  */
prog: C
    ;

E: E Pl T
 | E Mo T
 | T
 ;

T: T Mu F
 | F
 ;

F: '(' E ')'
 | I
 | V			{printf("V=%s\n",$1);}
 ;

C0: V Af E
 | Sk
 | '(' C0 ')'
 | If E Th C El C0
 | Wh E Do C0
 ;

C: C Se C0
 | C0
 ;


%%


int yyerror(char *s) {
    fprintf(stderr, "*** ERRROR: %s\n",s);
    return 0;
}

int yywrap() {
    return -1;
}

int main(int argn, char **argv) {
    yydebug = 1;
    return yyparse();
}
