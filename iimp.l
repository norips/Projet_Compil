%{
#include <stdio.h>
#include <string.h>
#include "utils/AST.h"
#include "imp.tab.h"
%}
%option nounput noinput
%%


[0-9]+  	{yylval.i = atoi(yytext); return I;}
:=		{return Af;}
skip 		{return Sk;}
; 		{return Se;}
if 		{return If;}
then 		{return Th;}
else 		{return El;}
while 		{return Wh;}
do 		{return Do;}
"+" 		{return Pl;}
"-" 		{return Mo;}
"*" 		{return Mu;}
[A-Za-z0-9]+	{yylval.id = strdup(yytext);return V;}
[ \t\n]		{;} //Ignore

.       {return yytext[0];}

%%
