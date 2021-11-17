%{
unsigned charCount = 0, wordCount = 0, lineCount = 0, phraseCount = 0, capitalWordsCount = 0,minusWordsCount = 0, numberCount = 0;
%}
dot "."
numbers [0-9]+
capitalWord [A-Z"Ñ""´"]+
minusWord [a-z"ñ""´"]+
word [^ \t\n"."]+
%%
{capitalWord}  {capitalWordsCount++;wordCount++;charCount += yyleng;}
{minusWord} {minusWordsCount++;wordCount++;charCount += yyleng;}
{numbers} {numberCount++; wordCount++;charCount+=yyleng;}  
{word} {wordCount++; charCount += yyleng;}
{dot} {charCount++; lineCount++;}
%%
int main(){
    yylex();
	printf("\nphrases: %d words: %d capital words %d: minus words: %d chars: %d ", lineCount, wordCount,capitalWordsCount,minusWordsCount,charCount);
    printf("numbers : %d \n",numberCount);
}

