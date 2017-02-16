%{
#include <stdio.h>
#include "imp.tab.h"

%}

%%


[0-9]+  {yylval.i = atoi(yytext); return I;}
.       {return yytext[0];}

%%
