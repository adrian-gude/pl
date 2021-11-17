%{
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "p2.tab.h"	


void subString(char *cont, int min){
	char *contenido = malloc(strlen(cont));
	int i = 0;
	for(i = min; i < ((strlen(cont))) && cont[i] != '>'; i++){
		contenido[i-min] = cont[i];
	}
	contenido[i] = '\0';
	strcpy(cont, contenido);
	free(contenido);
}

%}
%option yylineno
word [^<>]+
comment "<!-- "{word}" -->"[\n \t]*
start	"<?xml version="\"1\.0\"" encoding="\"UTF-8\""?>"[\n \t]*
finalHeader "</"{word}">"[\n \t]*
startHeader "<"{word}">"[\n \t]*
text {word}
   

%%
{start} {return START;}
{comment}	{;}
{finalHeader} {subString(yytext, 2); yylval.valString = yytext;return ENDHEADER;}
{startHeader} {subString(yytext, 1); yylval.valString = yytext;return STARTHEADER;}
{text} {;}
<<EOF>> return ENDFILE;
%%