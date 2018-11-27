/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_X0_BISON_SNAPSHOT_TAB_H_INCLUDED
# define YY_YY_X0_BISON_SNAPSHOT_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    BOOLSYM = 258,
    BREAKSYM = 259,
    CALLSYM = 260,
    CASESYM = 261,
    CHARSYM = 262,
    COLON = 263,
    CONSTSYM = 264,
    CONTINUESYM = 265,
    DEFAULTSYM = 266,
    DOSYM = 267,
    ELSESYM = 268,
    EXITSYM = 269,
    FORSYM = 270,
    INTSYM = 271,
    IFSYM = 272,
    MAINSYM = 273,
    READSYM = 274,
    REALSYM = 275,
    REPEATSYM = 276,
    RR = 277,
    RL = 278,
    LPAREN = 279,
    RPAREN = 280,
    STRINGSYM = 281,
    SWITCHSYM = 282,
    UNTILSYM = 283,
    WHILESYM = 284,
    WRITESYM = 285,
    LBRACE = 286,
    RBRACE = 287,
    LBRACKET = 288,
    RBRACKET = 289,
    BITAND = 290,
    BITOR = 291,
    BECOMES = 292,
    COMMA = 293,
    LSS = 294,
    LEQ = 295,
    GTR = 296,
    GEQ = 297,
    EQL = 298,
    NEQ = 299,
    PLUS = 300,
    INCPLUS = 301,
    MINUS = 302,
    INCMINUS = 303,
    TIMES = 304,
    DEVIDE = 305,
    MOD = 306,
    SEMICOLON = 307,
    XOR = 308,
    AND = 309,
    OR = 310,
    NOT = 311,
    YAJU = 312,
    YARIMASUNESYM = 313,
    KIBONOHANASYM = 314,
    RETURNSYM = 315,
    IDENT = 316,
    INTEGER = 317,
    STRING = 318,
    CHAR = 319,
    BOOL = 320,
    REAL = 321
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 169 "X0-Bison-Snapshot.y" /* yacc.c:1909  */

	char 	*ident;
	int 	number;
	char 	*text;
	char 	single_char;
	int 	flag;
	double 	realnumber;
	struct 	bp_list *bp;

#line 131 "X0-Bison-Snapshot.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_X0_BISON_SNAPSHOT_TAB_H_INCLUDED  */
