%{
#include <stdio.h>
#include <string.h>
void yyerror (char const *);
extern int yylex();
extern int yylineno;
char *errmsg = "Error";
%}
%union{
	char * valString;
}
//sin start te envian cabeceras 
//cabecera sin final tiene que saltar error 
//start en mitad de una sentencia 
//cabcera start y </algo> que de error

%error-verbose
%token <valString> START STARTHEADER ENDHEADER ENDFILE
%type <valString> body content root
%start S
%%
S :	START root ENDFILE{printf("Corerect XML Document\n");return 0;}
	| START root root {printf("There cannot be more than one root\n");return 0;}
	| START {printf("Corerect XML Document\n");return 0;}  
	| START ENDHEADER {printf("Error there cannot endheader\n");return 0;} 
	;
	
root : STARTHEADER body ENDHEADER {if(strcmp($1, $3) == 0){ $$ = $2;} else { printf("Error: init header label doesn't match final header, on line %d, expected %s, but there was %s\n", yylineno-1, $1, $3);return 0;}}
	|STARTHEADER ENDHEADER {if (strcmp($1, $2) == 0){ $$ = $2;} else { printf("Error: init header label doesn't match final header, on line %d, expected %s, but there was %s\n", yylineno-1, $1, $2);return 0;}}
	|STARTHEADER body {printf("Error: end header missing in line %d.", yylineno-1);return 0;}
    |STARTHEADER {printf("Error: end header missing in line %d.", yylineno-1);return 0;}
	|START {printf("Error in line %d. There is already an initial header",yylineno-1);return 0;}
	;

body : content body {$$ = $2;}
	|content {$$ = $1;}
	;

content : STARTHEADER ENDHEADER {if (strcmp($1, $2) == 0){ $$ = $2;} else { printf("Error: init header label doesn't match final header, on line %d, expected %s, but there was %s\n", yylineno-1, $1, $2);return 0;}}
	 |STARTHEADER body ENDHEADER {if(strcmp($1, $3) == 0){ $$ = $2;} else { printf("Error: init header label doesn't match final header, on line %d, expected %s, but there was %s\n", yylineno-1, $1, $3);return 0;}}
     |START {printf("Error in line %d. There is already an initial header",yylineno-1);return 0;}
	 |STARTHEADER root ENDHEADER {if(strcmp($1, $3) == 0){ $$ = $2;} else { printf("Error: init header label doesn't match final header, on line %d, expected %s, but there was %s\n", yylineno-1, $1, $3);return 0;}}   
	 |error {yyerror(errmsg); yyclearin;}
	 ;

%%
int main(int argc, char *argv[]) {
extern FILE *yyin;

	switch (argc) {
		case 1:	yyin=stdin;
			yyparse();
			break;
		case 2: yyin = fopen(argv[1], "r");
			if (yyin == NULL) {
				printf("ERROR: File cannot be opened.\n");
			}
			else {
				yyparse();
				fclose(yyin);
			}
			break;
		default: printf("ERROR: Too many arguments.\nSintaxis: %s [fichero_entrada]\n\n", argv[0]);
	}
	return 0;
}
void yyerror (char const *message) { fprintf (stderr, "\n %s: %d in line %d\n", message,yylineno-1);}