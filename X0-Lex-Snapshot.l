%{
#include "stdio.h"
#include "string.h"
#include "malloc.h"
#include "stdlib.h"
#include "X0-Bison.tab.h"

int 		line = 1;
%}

%%

[/][*].*[*][/]	{;} 
[/][/].*[\n]	{;}
[ \t]			{;}
[\n]			{line++;}

"bool"			{return BOOLSYM;}
"break"			{return BREAKSYM;}
"call"			{return CALLSYM;}
"case"			{return CASESYM;}
"char"			{return CHARSYM;}
"const"			{return CONSTSYM;}
"continue"		{return CONTINUESYM;}
"default"		{return DEFAULTSYM;}
"do"			{return DOSYM;}
"else"			{return ELSESYM;}
"exit"			{return EXITSYM;}
"false"			{yylval.flag = 0; return BOOL;}
"for"			{return FORSYM;}
"integer"		{return INTSYM;}
"if"			{return IFSYM;}
"kibonohana"	{return KIBONOHANASYM;}		
"main"			{return MAINSYM;}
"read"			{return READSYM;}
"real"			{return REALSYM;}
"repeat"		{return REPEATSYM;}
"return"		{return RETURNSYM;}
"string"		{return STRINGSYM;}
"switch"		{return SWITCHSYM;}
"true"			{yylval.flag = 1; return BOOL;}
"until"			{return UNTILSYM;}
"while"			{return WHILESYM;}
"write"			{return WRITESYM;}
"yarimasune"	{return YARIMASUNESYM;}
"114514"		{	printf("heng heng heng a a a a a, a a a a a a a, a a a a a a a a a a a a a a!!!!!\n"); 
					printf("ni shi yi ge, yi ge, yi ge, a a a a a a a a a a a a a a a a!!!!!!!!!!!!!!\n");
					yylval.number = atoi(yytext);
					return INTEGER;
				}

[A-Za-z]([A-Za-z]|[0-9]|_)*	{ 	yylval.ident = (char*) malloc(strlen(yytext) + 1);
								strcpy(yylval.ident, yytext);
								return IDENT; 
							}
[+|-]?[0-9]+				{	yylval.number = atoi(yytext);
								return INTEGER;
							}
[+|-]?([0-9]*\.?[0-9]+|[0-9]+\.[0-9]*) {	yylval.realnumber = atof(yytext);
											return REAL;
									   }
["].*["]					{	yylval.text = (char*) malloc(strlen(yytext) + 1);
								int i = 0, j = 0;
								for (i = 0; i < strlen(yytext); i++) {
									if (yytext[i] != '\"') {
										yylval.text[j++] = yytext[i];
									}
								}
								yylval.text[strlen(yytext) - 1] = '\0';
								return STRING;
							}
['].[']						{	yylval.single_char = yytext[1];
								return CHAR;
							}
							
":="			{return BECOMES;}
"<"				{return LSS;}
"<="			{return LEQ;}
">"				{return GTR;}
">="			{return GEQ;}
"=="			{return EQL;}
"!="			{return NEQ;}
"<<"			{return RL;}
">>"			{return RR;}
"+"				{return PLUS;}
"++"			{return INCPLUS;}
"-"				{return MINUS;}
"--"			{return INCMINUS;}
"*"				{return TIMES;}
"/"				{return DEVIDE;}
"("				{return LPAREN;}
")"				{return RPAREN;}
"{"				{return LBRACE;}
"}"				{return RBRACE;}
"["				{return LBRACKET;}
"]"				{return RBRACKET;}
"%"				{return MOD;}
","				{return COMMA;}
";"				{return SEMICOLON;}
":"				{return COLON;}
"^^"			{return XOR;}
"&&"			{return AND;}
"&"				{return BITAND;}
"||"			{return OR;}
"|"				{return BITOR;}
"!"				{return NOT;}
.				{yyerror("Unknown Character!");}

%%

void redirectInput(FILE *input) {
	yyin = input;
}

int yygetchar(void) {
	int res;
	res = getc(yyin);
	printf("%c", res);
	return res;
}

int yywrap(void) {
	return 1;
}
