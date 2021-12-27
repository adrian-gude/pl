%{
#include "p3.tab.h"
#include <string.h>

int line = 0;

%}

%option noyywrap
EXP ([Ee][-+]?[0-9]+)
PATH (([^ \t\n\ñ\!]*"/")*[^ \t\n\ñ\!]*"."[^ \t\n\ñ\!]*)
QUERYSTRING ("?"[0-9]*)
QUOTESTR ([\\]["])

%%

[\n] {line++;}
[ \t\r]+ { /* eat whitespace */ }
"[" { ; return LEFTBRAC; }
"]" { ; return RIGHTBRAC; }
"{" { ; return LEFTCURLY; }
"}" { ; return RIGHTCURLY; }
"," { ; return COMMA; }
":" { ; return COLON; }
"null" {yylval.string = strdup(yytext); return VALUENULL; }
"true" {yylval.string = strdup(yytext); return VALUETRUE; }
"false" {yylval.string = strdup(yytext); return VALUEFALSE; }
"-"?[0-9]+\.?[0-9]*{EXP}? {yylval.string = strdup(yytext); return DECIMAL; }
\""https""://"{PATH}{QUERYSTRING}\" {yylval.string = strdup(yytext);return IMAGE;}
\"([^"]|{QUOTESTR})*\" { yylval.string = strdup(yytext); return STRING; }

%%

