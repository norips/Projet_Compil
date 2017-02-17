%{
#include <stdio.h>
#include "imp.tab.h"
#include <string.h>
%}

%%


-?[0-9]+  	{yylval.i = atoi(yytext); return I;}
:=		{return Af;}
Skip 		{return Sk;}
; 		{return Se;}
if 		{return If;}
then 		{return Th;}
else 		{return El;}
while 		{return Wh;}
do 		{return Do;}
"+" 		{return Pl;}
"-" 		{return Mo;}
"*" 		{return Mu;}
[A-Za-z]+	{yylval.id = strdup(yytext);return V;}

.       {return yytext[0];}

%%
