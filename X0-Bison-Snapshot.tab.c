/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 1 "X0-Bison-Snapshot.y" /* yacc.c:339  */

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <memory.h>
#include <string.h>
#include <math.h>

#define bool 			int
#define true 			1
#define false 			0

#define SYM_TABLE 		200				// Max Capicity of symbol table
#define ID_NAME_LEN		20				// Max length of ident
#define ADDRESS_MAX		8000			// Upper bound of the address
#define DEPTH_MAX		10				// Max depth of declaration, Un used
#define CODE_MAX		1000			// Max Virtual Machine code amount
#define STACK_SIZE		8000			// Max Run-Time stack element amount
#define STRING_LEN		201				// Max length of const string
#define ERROR_MAG_NUM	1145141919810	// For error processing
#define MAX_ARR_DIM		10				// Max dimension of the array
#define FLOAT_EPS		0.001			// Using for float opran comparing
#define MAX_CASE_NUM	100				// Max case in switch statement

typedef unsigned char byte;
int cnt = 0;
enum object {
	constant_int,
	constant_real,
	constant_bool,
	constant_string,
	constant_char,
	variable_int,
	variable_real,
	variable_bool,
	variable_string,
	variable_char,
	constant_int_array,
	variable_int_array,
	constant_real_array,
	variable_real_array,
	constant_char_array,
	variable_char_array,
	constant_bool_array,
	variable_bool_array,
	constant_string_array,
	variable_string_array,
	function,
};

struct symbol_table {
	char 	name[ID_NAME_LEN];
	enum 	object kind;
	int 	addr;
	byte 	val[STRING_LEN];			// Use byte to store all kind of data, use pointer to specify them
	int		init_or_not;
	int		array_size;
	int 	array_const_or_not;
	int 	array_dim[MAX_ARR_DIM];
//	void*	val;						// Using pointer to specify unlimitted length constant string @todo: in the future.
};

struct symbol_table table[SYM_TABLE];	// Store all symbol

enum data_type {
	integer,		real,
	single_char,	boolean,
	str,
};

struct data_stack {
	enum 	data_type t;				// current un-used
	byte 	val[STRING_LEN];
};

enum fct {
	lit,	opr,	lod,
	sto,	cal,	ini,
	jmp,	jpc,	off,
};

struct instruction {
	enum 	fct f;
	int 	lev;						// Used for type identifying
										// For all ato lod opr, this should be use to specify type
										// 2 for integer
										// 3 for real
										// 4 for string
										// 5 for bool
										// 6 for char
	byte	opr[STRING_LEN];
};

struct instruction code[CODE_MAX];		// Store V-Machine code

int			sym_tab_tail;							// tail of sym table
int			vm_code_pointer = 0;					// pc during parsing stage
char		id_name[ID_NAME_LEN];					// current parsing ident name
int			outter_int;								// used for temp result
float		outter_real;							// Un-used
bool		outter_bool;							// Un-used
char		outter_char;							// Un-used
char		outter_string[STRING_LEN];				// Un-used
int			err_num;								// Un-used
int			constant_decl_or_not = 0;
int 		var_decl_with_init_or_not = 0;
int			cur_decl_type = -1;
char		curr_read_write_ident[ID_NAME_LEN];
int 		curr_address = 3;						// RA,SL,DL for future function module
int 		inbuf_int;								// for read() [opr $% 20]
float		inbuf_real;								// for read() [opr $% 20]
char		inbuf_char;								// for read() [opr $% 20]
char		inbuf_string[STRING_LEN];				// for read() [opr $% 20]
char		inbuf_bool[6];							// for read() [opr $% 20]
int			bool_flag;
int			arr_size = 0;
int			tmp_arr_list[MAX_ARR_DIM];
int			tmp_arr_dim_idx = 0;
struct 		data_stack s[STACK_SIZE];
int 		stack_top = 2;
int 		array_offset;
int 		tmp_arr_cur_dim;
int 		glob_var_addr;
int			back_patch_list[STRING_LEN];
int			back_patch_idx = 0;
int 		curr_ident_array_or_not = 0;
int			else_compound;
int			do_start_idx;
int			break_return_address_by_level[DEPTH_MAX];			// Using to recording return address of for, while, do, switch per level to back patch the break statement
int			continue_return_address_by_level[DEPTH_MAX];
int			cur_break_level = 0;
int			cur_continue_level = 0;
int			break_statement_address[DEPTH_MAX][STRING_LEN];
int			continue_statement_address[DEPTH_MAX][STRING_LEN];	// Allowed up to 200 continue and break.
int			cur_level = 0;
int			inc_flag;											// inc++ inc-- act differently when pop stack top

struct expression_result {
	enum	data_type	t;
	int		res_int;
	float	res_real;
	bool	res_bool;
	char	res_char;
	char	res_string[STRING_LEN];
};

struct expression_result e_res;

struct bp_list {
	int 	case_start;
	int 	case_end;
};

FILE*		fin;
FILE*		ftable;
FILE*		fcode;
FILE*		foutput;
FILE*		fresult;
char		fname;
int 		err;
extern int	line;

void 		init();
void		enter(enum object k);
void 		gen(enum fct x, int y, byte* z);


#line 234 "X0-Bison-Snapshot.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "X0-Bison-Snapshot.tab.h".  */
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
#line 169 "X0-Bison-Snapshot.y" /* yacc.c:355  */

	char 	*ident;
	int 	number;
	char 	*text;
	char 	single_char;
	int 	flag;
	double 	realnumber;
	struct 	bp_list *bp;

#line 351 "X0-Bison-Snapshot.tab.c" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_X0_BISON_SNAPSHOT_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 368 "X0-Bison-Snapshot.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  9
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   325

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  67
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  49
/* YYNRULES -- Number of rules.  */
#define YYNRULES  119
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  199

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   321

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   202,   202,   205,   206,   207,   210,   211,   212,   213,
     216,   217,   220,   221,   224,   225,   226,   227,   228,   231,
     232,   235,   238,   239,   242,   245,   246,   247,   250,   251,
     252,   253,   254,   255,   256,   257,   258,   259,   260,   261,
     262,   263,   264,   267,   270,   271,   272,   275,   276,   279,
     282,   285,   288,   291,   292,   295,   298,   301,   304,   307,
     310,   313,   316,   319,   322,   323,   326,   327,   330,   331,
     334,   336,   337,   340,   341,   342,   343,   346,   347,   348,
     351,   352,   353,   354,   355,   356,   357,   358,   359,   360,
     361,   362,   363,   366,   367,   370,   371,   374,   375,   378,
     379,   380,   383,   384,   385,   386,   387,   388,   389,   390,
     393,   396,   399,   405,   406,   409,   410,   413,   414,   417
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "BOOLSYM", "BREAKSYM", "CALLSYM",
  "CASESYM", "CHARSYM", "COLON", "CONSTSYM", "CONTINUESYM", "DEFAULTSYM",
  "DOSYM", "ELSESYM", "EXITSYM", "FORSYM", "INTSYM", "IFSYM", "MAINSYM",
  "READSYM", "REALSYM", "REPEATSYM", "RR", "RL", "LPAREN", "RPAREN",
  "STRINGSYM", "SWITCHSYM", "UNTILSYM", "WHILESYM", "WRITESYM", "LBRACE",
  "RBRACE", "LBRACKET", "RBRACKET", "BITAND", "BITOR", "BECOMES", "COMMA",
  "LSS", "LEQ", "GTR", "GEQ", "EQL", "NEQ", "PLUS", "INCPLUS", "MINUS",
  "INCMINUS", "TIMES", "DEVIDE", "MOD", "SEMICOLON", "XOR", "AND", "OR",
  "NOT", "YAJU", "YARIMASUNESYM", "KIBONOHANASYM", "RETURNSYM", "IDENT",
  "INTEGER", "STRING", "CHAR", "BOOL", "REAL", "$accept", "program",
  "declaration_list", "declaration_stat", "identlist", "identdef",
  "typeenum", "identarraylist", "identarraydef", "dimensionlist",
  "dimension", "statement_list", "statement", "switch_statement",
  "case_list", "case_stat", "default_statement", "continue_stat",
  "break_stat", "if_statement", "else_list", "ELSESYMSTAT",
  "while_statement", "WHILESYMSTAT", "write_statement", "read_statement",
  "compound_statement", "for_statement", "INC_OR_NOT", "do_statement",
  "var", "expression_list", "expression_statement", "expression",
  "simple_expr", "SINGLEOPR", "OPR", "additive_expr", "PLUSMINUS", "term",
  "TIMESDEVIDE", "factor", "SEMICOLONSTAT", "LPARENSTAT", "RPARENSTAT",
  "function_decl", "para_list", "para_item", "yarimasu_stat", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321
};
# endif

#define YYPACT_NINF -116

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-116)))

#define YYTABLE_NINF -1

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     191,  -116,  -116,  -116,  -116,  -116,    27,   -33,    17,  -116,
      14,    22,   191,    30,    10,    -6,  -116,     3,    61,   191,
       3,    42,    57,    57,    57,  -116,    57,  -116,    57,    30,
    -116,  -116,  -116,  -116,  -116,    31,    51,  -116,  -116,  -116,
    -116,  -116,   206,  -116,    29,   173,  -116,  -116,    91,  -116,
    -116,  -116,  -116,  -116,    57,  -116,  -116,  -116,  -116,  -116,
      69,  -116,     3,  -116,    89,   269,    79,  -116,  -116,    61,
    -116,  -116,    42,   191,  -116,   102,    29,  -116,    82,    61,
      61,    53,    61,    61,   237,  -116,    61,  -116,   -16,   -30,
    -116,   -26,  -116,  -116,  -116,  -116,    61,    61,  -116,  -116,
     -27,  -116,  -116,  -116,  -116,  -116,  -116,  -116,  -116,  -116,
    -116,  -116,  -116,  -116,  -116,  -116,  -116,    89,    89,  -116,
    -116,  -116,    89,    90,  -116,  -116,    42,    -9,    -8,    95,
       3,    90,    90,    90,    90,  -116,    36,  -116,    58,    89,
      60,  -116,    71,  -116,    90,  -116,   -27,    79,  -116,  -116,
    -116,  -116,  -116,  -116,    61,    61,    42,     3,   100,     3,
    -116,    61,  -116,    70,  -116,  -116,    96,  -116,   101,  -116,
      42,    90,     3,   123,  -116,    91,  -116,  -116,  -116,    58,
    -116,     3,    61,  -116,  -116,    42,    92,  -116,  -116,    90,
    -116,   133,   110,  -116,    42,  -116,    42,  -116,  -116
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
     114,    16,    18,    14,    17,    15,     0,     0,     0,     1,
       0,     0,   118,     5,     0,     0,   116,     0,    72,     0,
       0,     0,     0,     0,     0,   111,     0,    57,     0,     5,
      77,    78,   110,    79,   109,     0,    64,   104,   106,   108,
     107,   105,    36,     4,     0,     0,    26,    39,    40,    45,
      37,    38,    29,    30,     0,    32,    31,    33,    34,    35,
     103,    28,     0,    71,     0,    73,    93,    97,    69,    72,
      41,   117,     0,   118,    51,     0,     0,    50,     0,    72,
      72,     0,    72,    72,     0,   119,    72,     3,    12,     0,
      10,     0,    19,     2,    25,    44,    72,    72,    68,   103,
      76,    91,    92,    89,    90,    82,    83,    84,    85,    80,
      81,    95,    96,    88,    86,    87,    75,     0,     0,    99,
     100,   101,     0,     0,   113,   115,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    60,     0,    66,     0,     0,
       0,     6,     0,     7,     0,    70,    74,    94,    98,   112,
     102,    47,     8,     9,    72,    72,     0,     0,     0,     0,
      65,    72,    24,     0,    22,    13,    12,    11,     0,    20,
       0,     0,     0,    54,    59,    46,    58,    67,    21,     0,
      56,     0,    72,    55,    52,     0,     0,    23,    63,     0,
      53,     0,     0,    62,     0,    43,     0,    49,    61
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -116,  -116,  -116,   105,    72,    16,     4,    83,    18,  -116,
     -18,   134,   -20,  -116,    -7,   -46,  -116,  -116,  -116,  -116,
    -116,  -116,  -116,  -116,  -116,  -116,   -21,  -116,  -116,  -116,
     -50,  -116,  -116,   -17,  -116,    97,  -116,   -59,  -116,    48,
    -116,  -115,   -14,   -13,   -32,  -116,  -116,    98,  -116
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     6,    42,    43,    89,    90,    44,    91,    92,   163,
     164,    45,    46,    47,    48,    49,   192,    50,    51,    52,
     184,   185,    53,    54,    55,    56,    57,    58,   196,    59,
      60,   136,    61,    62,    63,    64,   117,    65,   118,    66,
     122,    67,    68,    69,   150,     8,    15,    16,    70
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      78,    75,    95,    74,     7,   100,    77,   148,   140,    79,
      80,    81,   142,    82,    99,    83,    14,   138,   111,    72,
     112,   139,    32,    76,   165,    94,   143,     9,    10,   140,
     142,   132,    73,     1,    17,    11,    18,     2,    12,    19,
      20,    96,    21,   152,   153,    22,     3,    23,    98,    24,
       4,   124,   123,    13,    25,    32,     5,    26,   146,    27,
      28,    29,   130,   131,    94,   133,   134,    99,    99,   137,
     160,    71,    99,    29,   161,   141,    30,    14,    31,   144,
     145,    25,    32,    85,    86,    25,    33,    34,    35,    99,
      88,    36,    37,    38,    39,    40,    41,    18,    18,   156,
     157,   158,   159,   191,   178,   151,    97,    30,   179,    31,
     126,   129,   170,    25,    36,   149,   155,    33,    34,   154,
     162,   166,    36,    37,    38,    39,    40,    41,   119,   120,
     121,   175,   168,   139,   138,   173,   183,   171,   172,   181,
      95,   194,   195,   174,   177,   176,    34,    87,   127,   180,
      36,    37,    38,    39,    40,    41,   167,   193,   182,   128,
     169,   187,   116,    84,   190,   189,   147,   188,   186,     0,
       0,   125,     0,   197,     0,   198,     1,    17,     0,    18,
       2,     0,    19,    20,     0,    21,     0,     0,    22,     3,
      23,     0,    24,     4,     1,     0,     0,    25,     2,     5,
      26,     0,    27,    28,    29,    93,     0,     3,     0,     1,
       0,     4,     0,     2,     0,    19,     0,     5,     0,    30,
       0,    31,     3,     0,     0,    32,     4,     0,     0,    33,
      34,    35,     5,     0,    36,    37,    38,    39,    40,    41,
       1,    17,     0,    18,     2,     0,    19,    20,     0,    21,
       0,     0,    22,     3,    23,     0,    24,     4,     0,     0,
       0,    25,     0,     5,    26,     0,    27,    28,    29,   135,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    30,     0,    31,     0,     0,     0,    32,
       0,   101,   102,    33,    34,    35,     0,     0,    36,    37,
      38,    39,    40,    41,   103,   104,     0,     0,   105,   106,
     107,   108,   109,   110,   111,    30,   112,    31,     0,     0,
       0,     0,   113,   114,   115,    33
};

static const yytype_int16 yycheck[] =
{
      21,    18,    48,    17,     0,    64,    20,   122,    38,    22,
      23,    24,    38,    26,    64,    28,    12,    33,    45,    25,
      47,    37,    52,    19,   139,    45,    52,     0,    61,    38,
      38,    81,    38,     3,     4,    18,     6,     7,    24,     9,
      10,    54,    12,    52,    52,    15,    16,    17,    62,    19,
      20,    72,    69,    31,    24,    52,    26,    27,   117,    29,
      30,    31,    79,    80,    84,    82,    83,   117,   118,    86,
      34,    61,   122,    31,    38,    89,    46,    73,    48,    96,
      97,    24,    52,    52,    33,    24,    56,    57,    58,   139,
      61,    61,    62,    63,    64,    65,    66,     6,     6,   131,
     132,   133,   134,    11,    34,   126,    37,    46,    38,    48,
       8,    29,   144,    24,    61,    25,   130,    56,    57,    24,
      62,    61,    61,    62,    63,    64,    65,    66,    49,    50,
      51,    31,    61,    37,    33,   156,    13,   154,   155,   171,
     186,     8,    32,   157,   161,   159,    57,    42,    76,   170,
      61,    62,    63,    64,    65,    66,   140,   189,   172,    76,
     142,   179,    65,    29,   185,   182,   118,   181,   175,    -1,
      -1,    73,    -1,   194,    -1,   196,     3,     4,    -1,     6,
       7,    -1,     9,    10,    -1,    12,    -1,    -1,    15,    16,
      17,    -1,    19,    20,     3,    -1,    -1,    24,     7,    26,
      27,    -1,    29,    30,    31,    32,    -1,    16,    -1,     3,
      -1,    20,    -1,     7,    -1,     9,    -1,    26,    -1,    46,
      -1,    48,    16,    -1,    -1,    52,    20,    -1,    -1,    56,
      57,    58,    26,    -1,    61,    62,    63,    64,    65,    66,
       3,     4,    -1,     6,     7,    -1,     9,    10,    -1,    12,
      -1,    -1,    15,    16,    17,    -1,    19,    20,    -1,    -1,
      -1,    24,    -1,    26,    27,    -1,    29,    30,    31,    32,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    46,    -1,    48,    -1,    -1,    -1,    52,
      -1,    22,    23,    56,    57,    58,    -1,    -1,    61,    62,
      63,    64,    65,    66,    35,    36,    -1,    -1,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    -1,    -1,
      -1,    -1,    53,    54,    55,    56
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     7,    16,    20,    26,    68,    73,   112,     0,
      61,    18,    24,    31,    73,   113,   114,     4,     6,     9,
      10,    12,    15,    17,    19,    24,    27,    29,    30,    31,
      46,    48,    52,    56,    57,    58,    61,    62,    63,    64,
      65,    66,    69,    70,    73,    78,    79,    80,    81,    82,
      84,    85,    86,    89,    90,    91,    92,    93,    94,    96,
      97,    99,   100,   101,   102,   104,   106,   108,   109,   110,
     115,    61,    25,    38,   109,   100,    73,   109,    93,   110,
     110,   110,   110,   110,    78,    52,    33,    70,    61,    71,
      72,    74,    75,    32,    79,    82,   110,    37,   109,    97,
     104,    22,    23,    35,    36,    39,    40,    41,    42,    43,
      44,    45,    47,    53,    54,    55,   102,   103,   105,    49,
      50,    51,   107,   100,    93,   114,     8,    71,    74,    29,
     100,   100,    97,   100,   100,    32,    98,   100,    33,    37,
      38,   109,    38,    52,   100,   100,   104,   106,   108,    25,
     111,    93,    52,    52,    24,   109,   111,   111,   111,   111,
      34,    38,    62,    76,    77,   108,    61,    72,    61,    75,
     111,   100,   100,    93,   109,    31,   109,   100,    34,    38,
      93,   111,   109,    13,    87,    88,    81,    77,   109,   100,
      93,    11,    83,   111,     8,    32,    95,    93,    93
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    67,    68,    69,    69,    69,    70,    70,    70,    70,
      71,    71,    72,    72,    73,    73,    73,    73,    73,    74,
      74,    75,    76,    76,    77,    78,    78,    78,    79,    79,
      79,    79,    79,    79,    79,    79,    79,    79,    79,    79,
      79,    79,    79,    80,    81,    81,    81,    82,    82,    83,
      84,    85,    86,    87,    87,    88,    89,    90,    91,    92,
      93,    94,    95,    96,    97,    97,    98,    98,    99,    99,
     100,   100,   100,   101,   101,   101,   101,   102,   102,   102,
     103,   103,   103,   103,   103,   103,   103,   103,   103,   103,
     103,   103,   103,   104,   104,   105,   105,   106,   106,   107,
     107,   107,   108,   108,   108,   108,   108,   108,   108,   108,
     109,   110,   111,   112,   112,   113,   113,   114,   114,   115
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     5,     2,     1,     0,     3,     3,     4,     4,
       1,     3,     1,     3,     1,     1,     1,     1,     1,     1,
       3,     4,     1,     3,     1,     2,     1,     0,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     0,     8,     2,     1,     0,     4,     0,     3,
       2,     2,     6,     2,     0,     1,     5,     1,     5,     5,
       3,    10,     0,     7,     1,     4,     1,     3,     2,     1,
       3,     1,     0,     1,     3,     2,     2,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     3,     1,     1,     1,     3,     1,
       1,     1,     3,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     6,     0,     3,     1,     2,     0,     2
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
      
#line 1625 "X0-Bison-Snapshot.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 419 "X0-Bison-Snapshot.y" /* yacc.c:1906  */


void init() {
	
}

int yyerror(char *s) {
	err_num++;
	printf("%s in line %d.\n", s, line);
	fprintf(foutput, "%s in line %d.\n", s, line);
	return 0;
}

void gen(enum fct x, int y, byte z[STRING_LEN]) {
	
}

void enter(enum object k) {
	sym_tab_tail++;
	strcpy(table[sym_tab_tail].name, id_name);
	table[sym_tab_tail].kind = k;
	table[sym_tab_tail].init_or_not = 0;
	switch (k) {
		case constant_int:
			break;
		case constant_real:
			break;
		case constant_string:
			break;
		case constant_char:
			break;
		case constant_bool:
			break;
		case variable_int:
			break;
		case variable_real:
			break;
		case variable_string:
			break;
		case variable_char:
			break;
		case variable_bool:
			break;
		case constant_int_array:
		case constant_real_array:
		case constant_bool_array:
		case constant_char_array:
		case constant_string_array:
		case variable_int_array:
		case variable_real_array:
		case variable_bool_array:
		case variable_char_array:
		case variable_string_array: 
			break;
	}
}

void display_sym_tab() {			// @todo: Finish sym-table displaying
	int i, j;
	for (i = 1; i <= sym_tab_tail; i++) {
		switch (table[i].kind) {
			case constant_int:
				break;
			case constant_real:
				break;
			case constant_char:
				break;
			case constant_string:
				break;
			case constant_bool:
				break;
			case variable_int:
				break;
			case variable_real:
				break;
			case variable_char:
				break;
			case variable_string:
				break;
			case variable_bool:
				break;
			case constant_int_array:
			case constant_real_array:
			case constant_bool_array:
			case constant_char_array:
			case constant_string_array:
				break;
			case variable_int_array:
			case variable_real_array:
			case variable_bool_array:
			case variable_char_array:
			case variable_string_array:
				break;
		}
	}
}

int find_addr_of_ident(char *s) {
}

void interpret() {
	// Unknown error of unexpected output!
	int 		pc = 0;
	int 		base = 1;
	struct 		instruction i;
	int			addr;
	int			iter;
	int			jter;
	int			res;
	int 		addr_to_find_array_in_table;
	int			bool_opr1, bool_opr2;
	int			array_input = 0;
	int			input_flag = 0;
	memset(inbuf_string, 0, sizeof inbuf_string);
	printf("Start X0\n");
	fprintf(fresult, "Start X0\n");
	do {
		i = code[pc];
		pc = pc + 1;
		switch (i.f) {
			case lit:
				break;
			case opr:
				switch (*(int*)&(i.opr)) {
					case 0:								// return
                        break;
					case 1:								// Negative
						break;
					case 2:								// 2 opr +
						break;
					case 3:								// 2 opr -
						break;
					case 4:								// 2 opr *
						break;
					case 5:								// 2 opr /
						break;
					case 6:								// 2 opr %
						break;
					case 7:								// 2 opr ==
						break;
					case 8:								// 2 opr !=
						break;
					case 9:								// 2 opr <
						break;
					case 10:							// 2 opr <=
						break;
					case 11:							// 2 opr >
						break;
					case 12:							// 2 opr >=
						break;
					case 13:							// 2 opr &&
						break;
					case 14:							// 2 opr ||
						break;
					case 15:							// 2 opr ^^
						break;
					case 16:							// 1 opr !
						break;
					case 17:							// 1 opr ++
						break;
					case 18:							// 1 opr --
						break;
					case 19:                            // output
						break;
					case 20:							// input
						break;
					case 21: 						    // >>
						break;
					case 22:						    // <<
                        break;
					case 23:						    // pop from the stack
						break;
					case 24:							// This == is especially for case, which will not pop the stack top after comparing
						break;
				}
				break;
			case lod:
				break;
			case sto:
				break;
			case cal:
				break;
			case ini:
				break;
			case jmp:
				break;
			case jpc:
				break;
			case off:
				break;
		}
	} while (pc != vm_code_pointer);
}

int type_max(int a, int b) {
}

void back_patch(int ins_idx, byte op[STRING_LEN]) {
}

void listall() {
	int i;
	char name[][5] = {
		{"lit"}, {"opr"}, {"lod"}, {"sto"},
		{"cal"}, {"ini"}, {"jmp"}, {"jpc"}, {"off"}
	};
	for (i = 0; i < vm_code_pointer; i++) {
		if (code[i].f == lit) {
			switch (code[i].lev) {
				case 2:
					break;
				case 3:
					break;
				case 4:
					break;
				case 5:
					break;
				case 6:
					break;
			}
		}
		else {
		}
	}
}

void print_data_stack() {
	int i = 3;
	for (; i <= stack_top; i++) {
		switch (s[i].t) {
			case integer:
				break;
			case real:
				break;
			case str:
				break;
			case boolean:
				break;
			case single_char:
				break;
		}
	}
}

int main(int argc, int **argv) {
	int tok;
	fcode = fopen("fcode", "w+");
	ftable = fopen("ftable", "w+");
	fresult = fopen("fresult", "w+");
	if (argc != 2) {
		printf("Please specific ONE source code file!\n");
		return 0;
	}
	FILE *f = fopen(argv[1], "r");
	if (!f) {
		perror(argv[1]);
		return 1;
	}
	redirectInput(f);
	init();
	int opran = 0;
	//while (tok = yylex()) printf("%d\n", tok);
	yyparse();
	//display_sym_tab();
	//listall();
	//interpret();
	//listall();
	//print_data_stack();
}
