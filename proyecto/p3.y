%{

#define MAX 100000

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern char* yytext;
extern int line;
int yylex();
void yyerror(const char *s);
char* cat_pointer(char* cad1,char* cad2);
char* retireQuotes(char* cad);

FILE* p3;
char * empty = "";

char strKey2[MAX] = "";
char * strKey = "";

char strKeyInRec2[MAX] = "";
char * strKeyInRec = "";

char strData2[MAX] = "<tr>\n";
char * strData = "<tr>\n";

char strRowValues2[MAX] = "";
char * strRowValues = "";

char strRec2[MAX] = "";
char * strRec = "";

char strKeyRec2[MAX] = "";
char * strKeyRec = "";

char list2[MAX] = "<dl>\n";
char * list = "<dl>\n";

int curly = 0;

%}
%union {
  char *string;
  double decimal;
}

%token LEFTCURLY RIGHTCURLY LEFTBRAC RIGHTBRAC COMMA COLON 
%token <string> VALUETRUE VALUEFALSE VALUENULL
%token <string> IMAGE;
%token <string> STRING;
%token <string> DECIMAL;

%type <string> object;
%type <string> value;
%type <string> values;
%type <string> members;
%type <string> member;
%type <int> leftcurly;

%start json

%%

json: array {}
    | error {
      yyerror("JSON should start with -> []");
      return 0;
    }
    ;

value: object 
     | IMAGE {
       char image[MAX] = "<img src=";
       strcat(image,strdup($1));
       strcat(image,">");
       $$ = strdup(image);
     }
     | STRING {
		  char * cad = strdup($1);
		  cad = retireQuotes(cad);
		  $$=cad;}
     | DECIMAL {$$=strdup($1);}
     | array {}
     | VALUETRUE {$$=strdup($1);}
     | VALUEFALSE {$$=strdup($1);}
     | VALUENULL {$$=strdup($1);}
     ;
    
leftcurly: LEFTCURLY {
  curly++;
};


object: LEFTCURLY RIGHTCURLY {}
      | leftcurly members RIGHTCURLY {
              if(curly<=1){
		if(strcmp(strKey,strKeyInRec) != 0){
			yyerror("Key should have same keys and in same order");
			return 0;
	      	}
		strcpy(strKeyInRec,"");
                char * lineRow = "<tr>\n";
                
                lineRow = cat_pointer(lineRow,strRowValues);
                lineRow = cat_pointer(lineRow,"</tr>\n");
                strData = cat_pointer(strData,lineRow);
                strcpy(strRowValues,"");
              }else{
                char * lineRow = "<td>\n";
                char * keyLineRow = "<tr>\n";
                
                lineRow = cat_pointer(lineRow,"<table border>\n");
                keyLineRow = cat_pointer(keyLineRow,strKeyRec);
                keyLineRow = cat_pointer(keyLineRow,"</tr>\n");
                lineRow = cat_pointer(lineRow,keyLineRow);
                lineRow = cat_pointer(lineRow,"<tr>\n");
                lineRow = cat_pointer(lineRow,strRec);
                lineRow = cat_pointer(lineRow,"</tr>\n");
                lineRow = cat_pointer(lineRow,"</table>\n");
                lineRow = cat_pointer(lineRow,"</td>\n");
                strRowValues = cat_pointer(strRowValues,lineRow);
                strcpy(strRec,"");
                strcpy(strKeyRec,"");
              }
              curly--;
            }
          | error {
              yyerror("Should be {value} or {values , value}");
              return 0;
          }
      ;


members: member {}
       | members COMMA member {}
       ;

member: STRING COLON value {
	      char * keyStr;
	      keyStr = $1;
	      retireQuotes(keyStr);
              if(curly<=1){
                if(strstr(strKey,$1)==NULL){
                  char * key = "<th>";
                  key = cat_pointer(key,$1);
                  key = cat_pointer(key,"</th>\n");
		  strKeyInRec = cat_pointer(strKeyInRec,key);
		  strKey = cat_pointer(strKey,key);
                } else {
		  char * key = "<th>";
                  key = cat_pointer(key,$1);
                  key = cat_pointer(key,"</th>\n");
                  strKeyInRec = cat_pointer(strKeyInRec,key);
		}
              }else{
                  char * key = "<th>";
                  key = cat_pointer(key,$1);
                  key = cat_pointer(key,"</th>\n");
                  strKeyRec = cat_pointer(strKeyRec,key);
              }
            if((strstr(strdup($3),"roi")==NULL)
              &&(strstr(strdup($3),"top_3_coins")==NULL)){
              if(curly<=1){
                char * row = "<td>";
                row = cat_pointer(row,strdup($3));
                row = cat_pointer(row,"</td>\n");
                strRowValues = cat_pointer(strRowValues,row);
              }else{
                char * row = "<td>";
                row = cat_pointer(row,strdup($3));
                row = cat_pointer(row,"</td>\n");
                strRec = cat_pointer(strRec,row);
              }
            }
        }
        | error {
              yyerror("Should be string : value");
              return 0;
          }

      ;

array: LEFTBRAC RIGHTBRAC
     | LEFTBRAC values RIGHTBRAC {  
              if(curly==0){
                char * init = "<!DOCTYPE html>\n<html lang=\"en\">\n";
                char * end = "\n</html>";
                char * head = "<head>\n<title>Info crypto</title>\n</head>\n";
                char * title = "<h1>Info crypto</h1>\n";
                char * table  = "<table border>\n";
                char * rowHead = "<tr>\n";
                
                init = cat_pointer(init,head);
                init = cat_pointer(init,title);
                init = cat_pointer(init,"<link rel=\"stylesheet\" href=\"p3.css\">\n");
                table = cat_pointer(table,rowHead);
		            table = cat_pointer(table,strKey);
                table = cat_pointer(table,"</tr>\n");
                table = cat_pointer(table,strData);
                table = cat_pointer(table,"</tr>\n");
                table = cat_pointer(table,"</table>\n");
                init = cat_pointer(init,table);
                init = cat_pointer(init,end);

                p3 = fopen ("p3.html", "w");
                fprintf(p3, "%s\n",init);
                fclose(p3);
              }else{
                  char * array = "<td>\n";
                  array = cat_pointer(array,list);
                  array = cat_pointer(array,"</dl>\n</td>\n");
                  strRowValues = cat_pointer(strRowValues,array);
                  strcpy(list,"<dl>\n");

              }

            }
     ;

values: value {
                if(curly!=0){
                  char * img = "<li>";
		  char * im = $1;
		  if(im!=NULL){
                    img = cat_pointer(img,strdup($1));
                    img = cat_pointer(img,"</li>\n");
                    list = cat_pointer(list,img);
		  }
                }
              }
      | values COMMA value {
        if(curly!=0){
          char * img = "<li>";
          img = cat_pointer(img,strdup($3));
          img = cat_pointer(img,"</li>\n");
          list = cat_pointer(list,img);
        }
      }
      ;

%%

char* cat_pointer(char* cad1,char* cad2){ 
  int n1,n2;
  char * aux;

  n1 = strlen(cad1);
  n2 = strlen(cad2);
  
  aux = (char*)malloc(sizeof(char)*(n1+n2+100));
  strcat(aux,cad1);
  
  strcat(aux,cad2);
  
  return aux;
}

char* retireQuotes(char* cad){
  int ini,fin;

  ini = 0;
  fin = strlen(cad);
  if((*cad=='\"')&&(cad[fin-1]=='\"')){
    strcpy(cad,cad + 1);
    cad[fin-2] = '\0';
  }
  return cad;
}

void yyerror(const char *s){
  fprintf(stderr,"Error: %s on line %d\n", s, line);
}
extern FILE* yyin;

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
		default: printf("ERROR: Too many arguments.\nSintaxis: %s [enter_file]\n\n", argv[0]);
	}
	return 0;
}
