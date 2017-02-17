%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "AST.h"

#define YYDEBUG 1
extern int yyerror(char*);
extern int yylex();

%}
%union {
    int i;
    char* id;
    nodeType *nPtr;
}
%token<id> V
%token<i> I
%token Af Sk Se If Th Wh Do Pl Mo Mu
%nonassoc Th
%nonassoc El
%left '('
%start prog 

%type<nPtr> C0 C E T F

%%
/* Un programme est une suite de déclaration (C) composé de déclaration atomique (C0)  */
prog: C		{printf("Head -> %d\n",((nodeType *)$1)->opr.oper);}
    ;

E: E Pl T		{$$ = opr(Pl,2,$1, $3);}
 | E Mo T		{$$ = opr(Mo,2,$1, $3);}
 | T			{$$ = $1;}
 ;

T: T Mu F		{$$ = opr(Mu,2,$1, $3);}
 | F			{$$ = $1;}
 ;

F: '(' E ')'		{$$ = $2;}
 | I			{$$ = con($1);}
 | V			{$$ = id($1);}
 ;

C0: V Af E		{$$ = opr(Af,2,id($1), $3);}
 | Sk			{$$ = opr(Sk,2,NULL,NULL);}
 | Se			{$$ = opr(Se,2,NULL,NULL);}
 | '(' C0 ')'		{$$ = $2;}
 | If E Th C El C0	{$$ = opr(If,3,$2,$4,$6);}
 | Wh E Do C0		{$$ = opr(Wh,2,$2,$4);}
 ;

C: C Se C0		{$$ = opr(Se,2,$1,$3);}
 | C0			{$$ = $1;}
 | '(' C ')'		{$$ = $2;}
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
