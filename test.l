%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>  // Needed for strdup
#include "test.tab.h"
%}

%option noyywrap

digit   [0-9]+
letter  [a-zA-Z_]+
id      ({letter}|_)({letter}|{digit}|_)* 
integer {digit}+
floatn  {digit}*"."{digit}+

%%
"int"            { return INT_KW; }
"float"          { return FLOAT_KW; }
"jodi"           { return JODI; }
"notuba"         { return ELSE; }
"jonno"          { return FOR; }
"jokhon"         { return JOKHON; }
"see" { return SEE; }




{floatn}         { yylval.fval = atof(yytext); return FLOAT_LIT; }
{integer}        { yylval.ival = atoi(yytext); return INT_LIT; }

"+"              { return ADD; }
"-"              { return SUB; }
"*"              { return MUL; }
"/"              { return DIV; }
"="              { return ASSIGN; }
";"              { return SEMICOLON; }
"("              { return LPAREN; }
")"              { return RPAREN; }
"{"              { return LBRACE; }
"}"              { return RBRACE; }
"<"              { return LT; }
","              { return COMMA; }
">"              { return GT; }
[ \t\n]+         { /* Skip whitespace */ }
{id}             { yylval.sval = strdup(yytext); return IDENTIFIER; }
.                { printf("Invalid character: %c\n", yytext[0]); }
%%